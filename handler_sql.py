#handler_sql.py

#handler_sql.py

import logging
from   datetime import datetime
from   time import strftime, gmtime
from   threading import Lock
from   langchain_community.utilities import SQLDatabase
from   sqlalchemy.pool import QueuePool
import re
import json
import time
from   pydantic import BaseModel
import asyncio
from   utils_sql import generate_sql_query, handle_pandas_response, table_citation, identify_generic_columns
from   select_table import find_matching_tables
from   sqlalchemy import create_engine, text
import pandas as pd
import ast
from   utils_common import openai_call
from   langchain_openai import ChatOpenAI
from   langchain.prompts import ChatPromptTemplate
from   dotenv import load_dotenv
import os
import numpy as np
from   forecast import run_forecast_core
from   logging_utils import setup_logging, get_logger, get_query_id, query_id_manager, SubQueryIDContext
from   query_relationships import RelationshipQuery

load_dotenv("prod.env")
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

def reload_env_keys():
    """Force reload environment variables from prod.env with override."""
    load_dotenv("prod.env", override=True)
    global OPENAI_API_KEY
    OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
    # Also reload keys from utils_common if imported
    try:
        from utils_common import reload_env_keys as reload_utils_keys
        reload_utils_keys()
    except ImportError:
        pass

current_date  = datetime.now().strftime('%Y-%m-%d')
QUERY_TIMEOUT = 60  # seconds

# Setup logging with query ID support
setup_logging("sql", logging.INFO)
logger = get_logger(__name__)

DATABASE_URI = "postgresql://postgres:admin@localhost:5432/final"
#DATABASE_URI = "postgresql://postgres:admin@136.112.177.68:5432/final"
#DATABASE_URI = os.getenv("DATABASE_URI")

engine = create_engine(
    DATABASE_URI,
    poolclass=QueuePool,
    pool_size=10,
    max_overflow=5,
    pool_recycle=3600,
    pool_timeout=30,
    future=True
)
db = SQLDatabase.from_uri(
    DATABASE_URI,
    engine_args={
        "poolclass": QueuePool,
        "pool_size": 10,
        "max_overflow": 5,
        "pool_recycle": 3600,
        "pool_timeout": 30
    }
)

def split_conditions(where_clause):
    # Split on 'AND' or 'OR' that is not within quotes
    pattern = r'\b(?:AND|OR)\b(?=(?:[^\'"]*[\'"][^\'"]*[\'"])*[^\'"]*$)'
    conditions = re.split(pattern, where_clause, flags=re.IGNORECASE)
    return [cond.strip() for cond in conditions if cond.strip()]

def extract_conditions(where_clause):
    # Handle BETWEEN ... AND ... expressions
    between_pattern = r"BETWEEN\s+('[^']*'|\d+(\.\d+)?|\w+)\s+AND\s+('[^']*'|\d+(\.\d+)?|\w+)"
    between_matches = re.findall(between_pattern, where_clause)
    placeholders = {}
    for i, match in enumerate(between_matches):
        full_match = f"BETWEEN {match[0]} AND {match[2]}"
        placeholder = f"__BETWEEN_{i}__"
        placeholders[placeholder] = full_match
        where_clause = where_clause.replace(full_match, placeholder)

    # Split by AND/OR only if not inside quotes or parentheses
    conditions = []
    current = ''
    stack = []
    in_single_quote = False
    in_double_quote = False
    i = 0
    while i < len(where_clause):
        c = where_clause[i]
        if c == "'" and not in_double_quote:
            in_single_quote = not in_single_quote
            current += c
        elif c == '"' and not in_single_quote:
            in_double_quote = not in_double_quote
            current += c
        elif c == '(' and not in_single_quote and not in_double_quote:
            stack.append('(')
            current += c
        elif c == ')' and not in_single_quote and not in_double_quote:
            if stack:
                stack.pop()
            current += c
        elif (where_clause[i:i+4].upper() == ' AND' and not stack and not in_single_quote and not in_double_quote):
            conditions.append(current.strip())
            current = ''
            i += 3
        elif (where_clause[i:i+3].upper() == ' OR' and not stack and not in_single_quote and not in_double_quote):
            conditions.append(current.strip())
            current = ''
            i += 2
        else:
            current += c
        i += 1
    if current.strip():
        conditions.append(current.strip())

    # Restore BETWEEN ... AND ... expressions
    for i, part in enumerate(conditions):
        for placeholder, expr in placeholders.items():
            if placeholder in part:
                conditions[i] = part.replace(placeholder, expr)
    return conditions

async def execute_query_with_table(
    selected_file: str,
    unit_query: str,
    orig_query: str,
    nq: int,
    total_input_tokens: dict,
    total_output_tokens: dict,
    curdate: str,
    start_time: float
):
    """
    Execute a query against a specific database table.
    
    Args:
        selected_file: Name of the table to query
        unit_query: The unit query string
        orig_query: The original query string
        nq: Number of queries
        total_input_tokens: Dictionary to track input tokens
        total_output_tokens: Dictionary to track output tokens
        curdate: Current date string
        start_time: Start time for timing calculations
        
    Returns:
        Dictionary with query results, success status, and metadata
    """
    table_info = "N/A"
    ref_name = "N/A"
    ref_url = "N/A"
    
    try:
        ref_name = table_citation(selected_file)
        #engine = create_engine(DATABASE_URI)
        # Query the information schema to get the table schema
        schema_query = f"""
        SELECT column_name, data_type, is_nullable, column_default
        FROM information_schema.columns
        WHERE table_name = '{selected_file}'
        ORDER BY ordinal_position;
        """
        logger.info("Generated schema query:")
        logger.info(schema_query)

        max_retries = 3
        attempt     = 1
        success     = False
        error       = "N/A"
        max_rows    = 60 # int(125.0/nq)

        while (not success) and (attempt <= max_retries):
            result=None
            error = "N/A"
            response = None  # Initialize response to avoid NameError if exception occurs early
            try:
                logger.info(f"Attempt {attempt}: to process query")
                # Connect to the database
                with engine.connect() as connection:
                    context = ""
                    # Execute the query
                    schema_result = connection.execute(text(schema_query))
                    # Fetch all the results
                    schema = schema_result.fetchall()
                    
                    # Validate that schema was retrieved successfully
                    if not schema or len(schema) == 0:
                        error = f"No schema found for table '{selected_file}'. The table may not exist or may have no columns."
                        logger.error(error)
                        raise ValueError(error)
                    
                    context += "Schema:\n"
                    for column in schema:
                        if """'id'""" not in str(column):
                            context += str(column) + "\n"
                    schema = str(schema)
                    contains_year = ""
                    if "'date_stamp'" in schema:
                        contains_year = 'date_stamp'
                    elif "'year'" in schema:
                        contains_year = 'year'
                    elif "'years'" in schema:
                        contains_year = 'years'
                    elif "'fiscal_year'" in schema:
                        contains_year = 'fiscal_year'
                    contains_month = ""
                    if "'month_numeric'" in schema:
                        contains_month = 'month_numeric'
                    elif "'quarter'" in schema:
                        contains_quarter = 'quarter'

                    set_vals = ""  # Initialize set_vals in case the try block fails
                    try:
                        gen_cols = identify_generic_columns(schema)
                        if gen_cols:
                            gen_col_string = ""
                            for g in range(len(gen_cols)):
                                gen_col_string += str(gen_cols[g])
                                if g < len(gen_cols) - 1:
                                    gen_col_string += ", "
                            pull_sample_query = "SELECT " + gen_col_string + " FROM " + selected_file + " ORDER BY RANDOM() LIMIT 40;"
                            logger.info("Trying to run: " + pull_sample_query)

                            sample_result = connection.execute(text(pull_sample_query))
                            sample_cat = ""
                            for row in sample_result:
                                sample_cat += str(row) + "\n"

                            value_list = "\n\nDistinct value lists:"
                            for col in gen_cols:
                                distinct_vals = []
                                #set_vals = ""
                                sample_result = connection.execute(
                                    text(f"SELECT DISTINCT {col} FROM {selected_file}")
                                    )
                                for row in sample_result:
                                    distinct_vals.append(str(row))
                                distinct_vals = [ast.literal_eval(t)[0] for t in distinct_vals]
                                value_list += f"\nValues for {col}: {distinct_vals}"

                            set_vals = openai_call(f""""
                Consider the following sample rows for columns: {gen_col_string}.
                Your task is to return a set of assignments for each columns which can help minimize the number of rows pulled by an SQL agent.
                {sample_cat}
                Return the set values based on the following user query.
                ## Rule:
                - Look for values such as General, Combined, * where the query below does not specify anything.
                - Do not include any other text in your response, apart from suggested assignments.
                - REMOVE any conditions based on release_date or updated_date.
                - Do not use any settings apart from the unique lists given below.
                - Do not use any state, group, category names not mentioned in the query below.

                - IMPORTANT NEVER choose more than 5 values for any single filter
                - IMPORTANT If the query mentions "top states", "Indian states", "GDP", DO NOT filter on the state column!
                - IMPORTANT If the query mentions an entity such as "states", "inflation", "category", "various categories", "all categories", "group" WITHOUT specifying a value for this entity, then DO NOT include a filter based on this entity.
                - IMPORTANT If the query is comparative (which country, which state, which category) then do suggest any settings for this field

                Lists of unique values are as follows:\n{value_list}.\nThe query to be handled is:""", unit_query)

                            logger.info("Suggested value sets: " + str(set_vals))
                            context += "\n\nSuggested value settings:\n" + str(set_vals)
                    except:
                        logger.warning("Failed to process suggested value settings")
                # Close the connection
                # connection.close()
                n = 40 #50 + 25*(attempt-1)  # Replace with your desired number of rows
                context += "\n\nSample rows:\n"
                # Run the query
                with engine.connect() as connection:
                    sample_result = connection.execute(
                        text(f"SELECT * FROM {selected_file} ORDER BY RANDOM() LIMIT :n"),
                        {"n": n}
                    )
                    # Fetch and print the rows
                    for row in sample_result:
                        context += str(row) + "\n" #print(row)
                logger.info(context)
                if error == "N/A":
                    response, query_for_table, i_tokens, o_tokens = generate_sql_query(unit_query, schema, context, selected_file)
                    logger.info(f"query for table: {query_for_table}")
                    logger.info(f"response: {response}")


                    total_input_tokens['gpt-4.1'] += i_tokens
                    total_output_tokens['gpt-4.1'] += o_tokens
                else:
                    #unit_query = retry_query(unit_query, error)
                    #logger.info(f"Changed user query to: {unit_query}")
                    response, query_for_table, i_tokens, o_tokens = generate_sql_query(unit_query, schema, context, selected_file, error)
                    logger.info(f"query for table: {query_for_table}")
                    logger.info(f"response: {response}")
                    total_input_tokens['gpt-4.1'] += i_tokens
                    total_output_tokens['gpt-4.1'] += o_tokens
                logger.info(f"Used query for specific table: {query_for_table}")
                logger.info("SQL query:")
                try:
                    response = response.split("```")[1]
                    response = response.split("sql")[1]
                    response = response.split(";")[0]
                except:
                    logger.warning("Could not remove decorator from original query")
                if "\n" in response:
                    response = response.replace("\n"," ")
                logger.info("Originally: " + response)
                try:
                    #REMEMBER THAT YOU SHOULD ONLY EDIT THE DATE/YEAR BASED CONDITIONS USING THE SCHEMA {schema}""", response)
                    response,i_tokens, o_tokens = openai_call(f"""Consider the following query: {orig_query}.

                    The following SQL query is intended to retrieve relevant data pertaining to it.

                    REMEMBER THAT YOU SHOULD ONLY EDIT THE DATE/YEAR BASED CONDITIONS USING THE SCHEMA {schema}

                    Here are some column setting conditions: {set_vals}. Remember that financial year involves previous and current year (e.g. FY25 = 2024 and 2025).

                    Based ONLY on a consideration of the date range (keep in mind current date is {curdate}), provide a revised SQL query.

                    ** VALIDATION RULES **:
                    1. Fix any conflicting timeline conditions (e.g., if you see "month <= 11 AND month >= 11", this is redundant - use "month = 11" or remove if not needed).
                    2. If the date range spans a full year or more (e.g., Nov 2024 to Nov 2025, or any range >= 12 months), REMOVE all month constraints (e.g., remove "month_numeric = 11" or "month = 11" conditions). Only keep year-based conditions for long ranges.
                    3. Month constraints should only be used for date ranges shorter than 12 months.
                    4. **CRITICAL**: Time filters must be SIMPLE using only =, <=, or >= operators. DO NOT use complex filters like IN clauses (e.g., "month_numeric IN (6, 9, 11)") or OR conditions with multiple year/month combinations (e.g., "(year = 2025 AND month_numeric IN (6, 9, 11)) OR (year = 2024 AND month_numeric = 12)"). Instead, use simple range filters like "year >= 2024 AND year <= 2025" or "year = 2025 AND month_numeric >= 6 AND month_numeric <= 11".

                    Make edits only if needed, and change only the date range.

                    ** IMPORTANT RULE ** Return your response ONLY as a valid SQL query, with NO DECORATIVE TEXT.

                    ** IMPORTANT RULE ** Do not use any category settings longer than 5 entries.""", response)

                    total_input_tokens['gpt-4.1'] += i_tokens
                    total_output_tokens['gpt-4.1'] += o_tokens
                except:
                    #REMEMBER THAT YOU SHOULD ONLY EDIT THE DATE/YEAR BASED CONDITIONS USING THE SCHEMA {schema}""", response)
                    response,i_tokens, o_tokens = openai_call(f"""Consider the following query: {orig_query}.

                    The following SQL query is intended to retrieve relevant data pertaining to it.

                    REMEMBER THAT YOU SHOULD ONLY EDIT THE DATE/YEAR BASED CONDITIONS USING THE SCHEMA {schema}

                    Based ONLY on a consideration of the date range (keep in mind current date is {curdate}), provide a revised SQL query.

                    ** VALIDATION RULES **:
                    1. Fix any conflicting timeline conditions (e.g., if you see "month <= 11 AND month >= 11", this is redundant - use "month = 11" or remove if not needed).
                    2. If the date range spans a full year or more (e.g., Nov 2024 to Nov 2025, or any range >= 12 months), REMOVE all month constraints (e.g., remove "month_numeric = 11" or "month = 11" conditions). Only keep year-based conditions for long ranges.
                    3. Month constraints should only be used for date ranges shorter than 12 months.
                    4. **CRITICAL**: Time filters must be SIMPLE using only =, <=, or >= operators. DO NOT use complex filters like IN clauses (e.g., "month_numeric IN (6, 9, 11)") or OR conditions with multiple year/month combinations (e.g., "(year = 2025 AND month_numeric IN (6, 9, 11)) OR (year = 2024 AND month_numeric = 12)"). Instead, use simple range filters like "year >= 2024 AND year <= 2025" or "year = 2025 AND month_numeric >= 6 AND month_numeric <= 11".

                    Make edits only if needed, and change only the date range.

                    ** IMPORTANT RULE ** Return your response ONLY as a valid SQL query, with NO DECORATIVE TEXT.""", response)

                    total_input_tokens['gpt-4.1'] += i_tokens
                    total_output_tokens['gpt-4.1'] += o_tokens
                try:
                    response = response.split("```")[1]
                    response = response.split("sql")[1]
                    response = response.split(";")[0]
                except:
                    logger.warning("Could not remove decorator from validated query")
                if "\n" in response:
                    response = response.replace("\n"," ")
                #if "```" in response:
                #    response = response.split("```")[1]
                logger.info("After validation: " + str(response))
                try:
                    response = clean_sql_query(response, selected_file, engine, logger, error, contains_year, contains_month)
                    logger.info("Cleaned SQL: " + response)
                except Exception as e:
                    logger.warning(f"Query cleaning failed. Continuing with original SQL. Error: {e}")
                if "ORDER" not in str(response):
                    if contains_year != "":
                        if contains_month != "":
                            response = str(response) + f"\nORDER BY {contains_year} DESC, {contains_month} DESC"
                        else:
                            response = str(response) + f"\nORDER BY {contains_year} DESC"
                if "LIMIT" not in str(response):
                    response = str(response) + f"\nLIMIT {max_rows};"
                else:
                    response = str(response)
                    response = re.sub(r'\blimit\s+\d+\b', 'LIMIT 100', response, flags=re.IGNORECASE)
                response = "SELECT * \nFROM" + response.split("FROM",1)[1]
                if "`" in response:
                    response = response.replace("`", "'")
                #partq = response.split("FROM")[0]
                #if " AS " in partq:
                #    error = "Trying to set AS in SELECT condition is not allowed"
                #    raise Exception(error)
                logger.info(response)
                logger.info("SQL response:")

                try:
                    if "WHERE  ORDER BY" in str(response):
                        raise Exception("No filters in query")
                    with engine.connect() as connection:
                        df = pd.read_sql(text(response), connection)
                        nrows = len(df)
                        logger.info("Number of rows pulled: " + str(nrows))
                except Exception as e:
                    logger.error("Exception while pulling SQL query: " + str(e))
                    df = {}
                    nrows = 0

                if nrows == 0:
                    error = "SQL query resulted in no data. Try changing categories or broadening time scope, or REDUCING the number of filters: " + str(response)
                    logger.info(error)
                else:
                    error = "N/A"
                    # Convert numeric columns to object dtype before filling with empty strings to avoid dtype incompatibility
                    for col in df.columns:
                        if df[col].dtype in ['float64', 'int64', 'float32', 'int32']:
                            df[col] = df[col].astype('object')
                    df.fillna('', inplace=True)
                if error == "N/A":
                    try:
                        reference_query = f"""
                                SELECT source, source_url, business_metadata FROM tables_metadata WHERE table_name = '{selected_file}';
                                """
                        #reference_query = f"""
                        #    SELECT source, source_url, business_metadata FROM get_metadata_for('{selected_file}');
                        #"""
                        with engine.connect() as connection:
                            ref_result = connection.execute(text(reference_query))
                            references = ref_result.fetchall()
                            ref_name, ref_url, table_info = references[0]
                            table_info = str(table_info)
                            logger.info("Got metadata: " + ref_name + ", " + ref_url + ", " + table_info)
                    except Exception as e:
                        logger.warning("Could not fetch table metadata")
                        logger.warning(str(e))
                    if 'data_source' in df.columns:
                        ref_name = df.loc[0, 'data_source']
                        logger.info("Found a data source column: " + ref_name)
                        df = df.drop(columns=['data_source'])
                    result, headers, i_tokens, o_tokens = handle_pandas_response(df, unit_query, orig_query, max_rows, nq)
                    total_input_tokens['gpt-4o-mini'] += i_tokens
                    total_output_tokens['gpt-4o-mini'] += o_tokens
                    table_info += headers
                    success = True
                else:
                    attempt += 1
            except Exception as error:
                logger.info("Something went wrong in SQL retrieval")
                error_msg = str(error)
                if response is not None:
                    error_msg += " " + str(response)
                else:
                    error_msg += " (response not yet generated)"
                error = error_msg
                logger.info(error)
                result = []
                attempt += 1
        logger.info("Got result: Current time: " + strftime("%Y-%m-%d %H-%M-%S", gmtime()))

        if not result: # or not isinstance(result, str):
            raise Exception("No output found from agents.")

        #logger.info(str(result))
        #logger.info(str(headers))
        #parsed_data = handle_json_response(str(result))
        parsed_data = result

        if not parsed_data:
            raise Exception("Parsed data is None or empty.")

        # Successful execution
        #logger.info(parsed_data)
        #logger.info(headers)
        total_time = time.time() - start_time

        logger.info(f"Response: {parsed_data}")
        logger.info(f"Total processing time: {total_time:.2f} seconds")

        if isinstance(parsed_data, list) and parsed_data and isinstance(parsed_data[0], dict):
            if any(key in parsed_data[0] for key in ["message", "status", "error"]):
                total_time = time.time() - start_time
                return {
                        "unit_query": unit_query,
                        "result": [],
                        "description": "No data",
                        "success": False,
                        "message": "Query resulted in error",
                        "unitary_time": total_time,
                        "reference": "N/A",
                        "url": "N/A",
                        "table_metadata": table_info,
                    }

        return {
                "unit_query": unit_query,
                "result": [parsed_data],
                "description": headers,
                "success": True,
                "message": "Successful completion",
                "unitary_time": total_time,
                "reference": ref_name,
                "url": ref_url,
                "table_metadata": table_info,
            }

    except Exception as e:
        error_message = str(e)
        logger.error(f"Error: {error_message}")
        total_time = time.time() - start_time
        return {
                "unit_query": unit_query,
                "result": [],
                "description": "No data",
                "success": False,
                "message": error_message,
                "unitary_time": total_time,
                "reference": "N/A",
                "url": "N/A",
                "table_metadata": table_info,
            }

def clean_sql_query(raw_sql: str, table_name: str, engine, logger, error="N/A",  contains_year="", contains_month="") -> str:
    if ";" in raw_sql:
        raw_sql = raw_sql.replace(";","")

    if "where" not in raw_sql.lower():
        return raw_sql

    idx = raw_sql.upper().find('LIMIT')
    if idx != -1:
        raw_sql = raw_sql[:idx].rstrip()  # Remove LIMIT and anything after

    # Split at WHERE
    pre_where, where_and_after = re.split(r'\bwhere\b', raw_sql, flags=re.IGNORECASE, maxsplit=1)

    # Split at ORDER BY if present
    where_clause, *order_by_clause = re.split(r'\border by\b', where_and_after, flags=re.IGNORECASE, maxsplit=1)

    # Now split conditions in where_clause
    conditions = extract_conditions(where_clause)

    valid_conditions = []
    with engine.connect() as conn:
        for condition in conditions:
            #if (("month" in condition) or ("quarter" in condition)):
            if ("quarter" in condition):
                logger.info("Dropping quarter-based or month-based condition: " + condition)
                continue
            if ("status" in condition):
                logger.info("Dropping status-based condition: " + condition)
                continue
            if (('data_updated_date' in condition) or ('data_release_date' in condition) or ('data_source' in condition)):
                logger.info("Dropping metadata based condition: " + condition)
                continue
            if (error != "N/A") and ("year" not in condition):
                logger.info("Dropping non time-based condition since running after error")
                continue
            try:
                validation_query = text(f"SELECT 1 FROM {table_name} WHERE " + condition + " LIMIT 1")
                result = conn.execute(validation_query)
                if result.fetchone():
                    valid_conditions.append(condition)
                else:
                    logger.info(f"Dropping invalid condition: {condition}")
            except Exception as e:
                logger.warning(f"Error validating condition '{condition}': {e}")
                #valid_conditions.append(condition)

    # Reconstruct the query
    result_query = f"{pre_where.strip()} WHERE {' AND '.join(valid_conditions)}"
    if order_by_clause:
        result_query += f" ORDER BY {order_by_clause[0].strip()}"
        if (contains_year != "") and (contains_year not in order_by_clause):
            result_query += f", {contains_year} DESC"
        if (contains_month != "") and (contains_month not in order_by_clause):
            result_query += f", {contains_month} DESC"
    return result_query

def handle_json_response(raw_data):
    try:
        if not isinstance(raw_data, str):
            raise Exception("Raw data must be a string.")
        if "summarized_info" in raw_data:
            py_dict = ast.literal_eval(raw_data)
            return json.loads(json.dumps(py_dict,default=str))
        logger.info("Handle JSON: Current time: " + strftime("%Y-%m-%d %H-%M-%S", gmtime()))
        # Remove code fences if present
        raw_data = raw_data.replace("```json", "").replace("```", "").strip()

        # Fix common formatting issues
        raw_data = re.sub(r"'", '"', raw_data)  # Single to double quotes
        raw_data = re.sub(r",\s*([}\]])", r"\1", raw_data)  # Remove trailing commas

        # Try to extract multiple JSON objects (best-effort)
        object_matches = re.findall(r'\{[^{}]*\}', raw_data, re.DOTALL)

        valid_objects = []
        for obj_str in object_matches:
            try:
                obj = json.loads(obj_str)
                valid_objects.append(obj)
            except json.JSONDecodeError:
                continue  # skip broken ones

        if not valid_objects:
            raise Exception("No valid JSON objects found.")

        return valid_objects

    except Exception as e:
        try:
            return json.loads(json.dumps(raw_data,default=str))
        except:
            raise Exception(f"Error processing JSON: {str(e)}")

def return_table_list():
    try:
        #engine = create_engine(DATABASE_URI)
        with engine.connect() as connection:
            table_list_query = """
                SELECT table_name
                FROM information_schema.tables
                WHERE table_schema='public'
                  AND (table_type='BASE TABLE' OR table_type='VIEW');
            """
            table_list_return = connection.execute(text(table_list_query))
            table_list = table_list_return.fetchall()
            table_list_return = str([table[0] for table in table_list])
            return table_list_return
    except Exception as e:
        logger.info("Could not fetch tables: %s", e)
        return ""

async def process_single_query(unit_query: str, orig_query: str, nq: int, total_input_tokens, total_output_tokens):

    """Convert user query to SQL and execute it using an agent with table context."""
    # Get query ID from context (set by SubQueryIDContext)
    query_id = get_query_id()
    curdate = strftime("%Y-%m", gmtime())

    table_info  = "N/A"
    start_time = time.time()
    # Initialize consolidated queries list (will be populated with main query and related queries)
    consolidated_queries = []
    logger.info(f"START: Processing query: {unit_query}")
    logger.info("Start processing: Current time: " + strftime("%Y-%m-%d %H-%M-%S", gmtime()))
    unit_query = unit_query.strip()
    logger.info(f"Received unitary query: {unit_query}")

    # Use embedding-based table selection
    logger.info("Finding matching tables using embeddings...")
    try:
        matches = find_matching_tables(unit_query, top_k=6)
        
        if matches and len(matches) > 0:
            # Get samples from each of the top 3 tables
            logger.info(f"Getting samples from top 6 tables: {[m['table_name'] for m in matches]}")
            table_samples = {}
            table_metadata = {}
            
            for match in matches:
                table_name = match['table_name']
                try:
                    with engine.connect() as connection:
                        sample_result = connection.execute(
                            text(f"SELECT * FROM {table_name} ORDER BY RANDOM() LIMIT :n"),
                            {"n": 10}
                        )
                        samples = []
                        for row in sample_result:
                            samples.append(str(row))
                        table_samples[table_name] = "\n".join(samples)
                        logger.info(f"Retrieved {len(samples)} sample rows from {table_name}")
                        
                        # Fetch business_metadata for the table
                        try:
                            metadata_query = text("""
                                SELECT business_metadata FROM tables_metadata WHERE table_name = :table_name;
                            """)
                            metadata_result = connection.execute(metadata_query, {"table_name": table_name})
                            metadata_row = metadata_result.fetchone()
                            if metadata_row and metadata_row[0]:
                                table_metadata[table_name] = str(metadata_row[0])
                                logger.info(f"Retrieved metadata for {table_name}")
                            else:
                                table_metadata[table_name] = "No metadata available"
                                logger.warning(f"No metadata found for {table_name}")
                        except Exception as e:
                            logger.warning(f"Error fetching metadata for {table_name}: {e}")
                            table_metadata[table_name] = "No metadata available"
                except Exception as e:
                    logger.warning(f"Error sampling rows from {table_name}: {e}")
                    table_samples[table_name] = "Error retrieving samples"
                    table_metadata[table_name] = "No metadata available"
            
            # Create prompt for OpenAI to choose the best table
            system_prompt = """You are a data analyst. Given a user query and sample data from multiple database tables, 
choose the most appropriate table that can answer the user's query. Consider the data content, structure, 
and relevance to the query. 

CRITICAL: BE LENIENT WITH SEMANTIC MISMATCHES
- IGNORE minor semantic differences between query terms and table content. For example:
  * "revenue" vs "counts" or "numbers" - if a table has counts/numbers for the same entity, it's relevant
  * "sales" vs "transactions" - treat as equivalent
  * "value" vs "amount" vs "total" - treat as equivalent
  * "growth" vs "change" vs "increase" - treat as equivalent
- Choose the CLOSEST matching table even if there are minor terminology differences
- Focus on the CORE ENTITY and DOMAIN rather than exact wording (e.g., "vehicle registrations" matches "vehicle registration counts")

IMPORTANT: Return "none_of_these" ONLY when:
- The data is TOTALLY IRRELEVANT to the query (e.g., query asks for vehicle data but table contains rainfall data)
- The query asks for a completely different domain/entity (e.g., query asks for financial data but table contains agricultural data)
- The query asks for MORE SPECIFIC CATEGORIES than available AND the categories are fundamentally different (e.g., query asks for "GST sector-wise" but table only has "GST overall" - but ONLY if sector-wise breakdown is essential to answer the query)

DO NOT return "none_of_these" for:
- Minor semantic mismatches (revenue vs counts, sales vs transactions, etc.)
- Time granularity differences (monthly vs quarterly vs annual - always choose the most granular available)
- Terminology differences (different words for the same concept)
- Missing specific categories in samples (the data may exist in the full table)
- Less specific categories than requested (more granular data can be aggregated)
- International trade/investment queries where India is implied but not explicitly mentioned

CRITICAL: TIME FREQUENCY HANDLING
- If the query mentions a time frequency (monthly, quarterly, annual, yearly, weekly, daily, etc.), FIRST try to choose a table with the matching frequency.
- If NO table with the exact matching frequency is available, you MUST choose the table with the most granular time available (e.g., if query asks for monthly but only quarterly/annual available, choose quarterly; if query asks for quarterly but only annual available, choose annual).
- NEVER return "none_of_these" solely because of a time granularity mismatch - always select the most granular option available.
- If the query only mentions a date range without specifying frequency, choose the table with the most granular time available.

When in doubt, choose the CLOSEST matching table rather than returning "none_of_these". Return ONLY the table name, nothing else."""
            
            # Build user prompt with table samples
            user_prompt_parts = [f"User Query: {unit_query}\n\nSample data from six candidate tables:\n"]
            
            for i, match in enumerate(matches, 1):
                table_name = match['table_name']
                samples = table_samples.get(table_name, 'No samples available')
                metadata = table_metadata.get(table_name, 'No metadata available')
                user_prompt_parts.append(f"Table {i}: {table_name}\nMetadata: {metadata}\nSample rows:\n{samples}\n")
            
            user_prompt_parts.append(f"\nBased on the user query and the sample data above, which table is most appropriate? ")
            user_prompt_parts.append(f"\nCRITICAL: BE LENIENT WITH SEMANTIC MISMATCHES - ")
            user_prompt_parts.append(f"Ignore minor semantic differences. For example: \"revenue\" vs \"counts\" or \"numbers\" are equivalent if they refer to the same entity. ")
            user_prompt_parts.append(f"\"sales\" vs \"transactions\", \"value\" vs \"amount\", \"growth\" vs \"change\" - treat these as equivalent. ")
            user_prompt_parts.append(f"Focus on the CORE ENTITY and DOMAIN (e.g., vehicle registrations) rather than exact wording. ")
            user_prompt_parts.append(f"Choose the CLOSEST matching table even with minor terminology differences. ")
            user_prompt_parts.append(f"\nReturn \"none_of_these\" ONLY when the data is TOTALLY IRRELEVANT (e.g., vehicle query but table has rainfall data). ")
            user_prompt_parts.append(f"DO NOT return \"none_of_these\" for minor semantic mismatches, time granularity differences, or terminology variations. ")
            user_prompt_parts.append(f"\nTIME FREQUENCY HANDLING: ")
            user_prompt_parts.append(f"If the query mentions a time frequency (monthly, quarterly, annual, yearly, weekly, daily, etc.), ")
            user_prompt_parts.append(f"FIRST try to choose a table with the matching frequency. ")
            user_prompt_parts.append(f"If NO table with the exact matching frequency is available, you MUST choose the table with the most granular time available ")
            user_prompt_parts.append(f"(e.g., if query asks for monthly but only quarterly/annual available, choose quarterly; if query asks for quarterly but only annual available, choose annual). ")
            user_prompt_parts.append(f"NEVER return \"none_of_these\" solely because of a time granularity mismatch - always select the most granular option available. ")
            user_prompt_parts.append(f"If the query only mentions a date range (e.g., \"May 2025 to October 2025\") without specifying frequency, ")
            user_prompt_parts.append(f"then choose the table with the most granular time available (e.g., prefer monthly over quarterly, quarterly over annual). ")
            user_prompt_parts.append(f"\nWhen in doubt, choose the CLOSEST matching table rather than returning \"none_of_these\". ")
            user_prompt_parts.append(f"Return ONLY the table name (e.g., \"{matches[0]['table_name']}\"), with no additional text or explanation.")
            
            user_prompt = "".join(user_prompt_parts)
            
            # Call OpenAI to select the best table
            try:
                selected_table_response, i_tokens, o_tokens = openai_call(system_prompt, user_prompt, model="gpt-4.1")
                total_input_tokens['gpt-4.1'] += i_tokens
                total_output_tokens['gpt-4.1'] += o_tokens
                
                # Extract table name from response (clean up any extra text)
                selected_table_name = selected_table_response.strip()
                # Remove any markdown formatting or quotes
                selected_table_name = selected_table_name.replace("`", "").replace('"', "").replace("'", "").strip()
                
                # Check if LLM determined that none of the tables can answer the query
                if selected_table_name.lower() == "none_of_these":
                    selected_file = "none_of_these"
                    similarity_score = 0.0
                    logger.info(f"OpenAI determined that none of the candidate tables can answer the query: {unit_query}")
                else:
                    # Verify the selected table is one of the candidates
                    candidate_names = [m['table_name'] for m in matches]
                    if selected_table_name in candidate_names:
                        selected_file = selected_table_name
                        similarity_score = next((m['similarity_score'] for m in matches if m['table_name'] == selected_file), 0.0)
                        logger.info(f"OpenAI selected table: {selected_file} from candidates: {candidate_names}")
                    else:
                        # Fallback to first match if OpenAI response doesn't match
                        selected_file = matches[0]['table_name']
                        similarity_score = matches[0]['similarity_score']
                        logger.warning(f"OpenAI returned '{selected_table_name}' which is not in candidates. Using first match: {selected_file}")
                
                if selected_file != "none_of_these":
                    candidate_names = [m['table_name'] for m in matches]
                    logger.info(f"Selected table: {selected_file} (similarity score: {similarity_score:.4f})")
                    logger.info(f"Top 3 matches: {candidate_names}")
                ref_url = "N/A"  # URL not available from embedding-based selection
            except Exception as e:
                logger.error(f"Error in OpenAI table selection: {e}")
                # Fallback to first match
                selected_file = matches[0]['table_name']
                similarity_score = matches[0]['similarity_score']
                logger.info(f"Fell back to first match: {selected_file} (similarity score: {similarity_score:.4f})")
                ref_url = "N/A"
        else:
            selected_file = "none_of_these"
            ref_url = "N/A"
            logger.info("No matching tables found, setting selected_file to 'none_of_these'")
    except Exception as e:
        logger.error(f"Error in embedding-based table selection: {e}")
        selected_file = "none_of_these"
        ref_url = "N/A"

    # After the loop, check if we still have 'none_of_these'
    if selected_file and selected_file.strip() == "none_of_these":
        total_time = time.time() - start_time
        ref_name = "N/A"
        # Create consolidated list with just the main query
        consolidated_queries = [
            {
                "query": unit_query,
                "unit_query": unit_query,
                "table_name": "none_of_these",
                "result": [],
                "description": "No data",
                "success": False,
                "message": "We do not have structured data related to this query",
                "unitary_time": total_time,
                "reference": "N/A",
                "url": "N/A",
                "table_metadata": table_info,
            }
        ]
        logger.info(f"Consolidated Queries List (no table selected):")
        logger.info(f"    Main query: '{unit_query}' -> table: 'none_of_these'")
        return {
                "unit_query": unit_query,
                "result": [],
                "description": "No data",
                "success": False,
                "message": "We do not have structured data related to this query",
                "unitary_time": total_time,
                "reference": "N/A",
                "url": "N/A",
                "table_metadata": table_info,
                "consolidated_results": consolidated_queries
            }
    else:
        # Query knowledge graph relationships for the selected table
        # Initialize lists to track generated queries
        parent_queries_list = []
        child_queries_list = []
        
        try:
            json_path = "knowledge_graph.json"
            if os.path.exists(json_path):
                query = RelationshipQuery(json_path, silent=True)
                relationships = query.get_first_degree_relationships(selected_file)
                
                if relationships:
                    logger.info(f"Knowledge Graph Relationships for table '{selected_file}':")
                    logger.info(f"  Domain: {relationships['table'].get('data_domain', 'N/A')}")
                    logger.info(f"  Description: {relationships['table'].get('business_metadata', 'N/A')}")
                    
                    # Log parent relationships and generate queries
                    parents = relationships.get('parents', [])
                    # Sort parents by strength (highest first) and take top 2
                    original_parents_count = len(parents) if parents else 0
                    if False: #parents:
                        parents = sorted(parents, key=lambda x: x.get('relationship', {}).get('strength', 0), reverse=True)[:2]
                        logger.info(f"  Direct Parents (top {len(parents)} of {original_parents_count}):")
                        for i, parent_info in enumerate(parents, 1):
                            parent_table = parent_info["table"]
                            rel = parent_info["relationship"]
                            parent_table_name = parent_table.get('name')
                            logger.info(f"    {i}. {parent_table_name} [{parent_table.get('data_domain', 'N/A')}]")
                            logger.info(f"       Type: {rel.get('relationship_type', 'N/A')}, Strength: {rel.get('strength', 0):.2f}")
                            logger.info(f"       Explanation: {rel.get('description', 'N/A')}")
                            
                            # Generate natural language query for parent table
                            try:
                                parent_query_prompt = f"""Given the following user query: "{unit_query}"

And the relationship context: {rel.get('description', 'N/A')}

The table '{parent_table_name}' is a parent/dependency of the current table. This table contains: {parent_table.get('business_metadata', 'N/A')}

Generate a natural language query that is relevant to querying the parent table '{parent_table_name}' based on the original user query and the relationship context. The query should be adapted to be appropriate for the parent table's data domain ({parent_table.get('data_domain', 'N/A')}).

Return ONLY the natural language query, without any explanations or additional text."""
                                
                                parent_query, i_tokens, o_tokens = openai_call(parent_query_prompt, unit_query)
                                total_input_tokens['gpt-4.1'] += i_tokens
                                total_output_tokens['gpt-4.1'] += o_tokens
                                parent_query = parent_query.strip()
                                logger.info(f"       Generated query for parent table: {parent_query}")
                                
                                # Store parent query with table name and explanation
                                parent_queries_list.append({
                                    "query": parent_query,
                                    "table_name": parent_table_name,
                                    "explanation": rel.get('description', 'N/A')
                                })
                            except Exception as e:
                                logger.warning(f"       Failed to generate query for parent table: {e}")
                    else:
                        logger.info("  Direct Parents: None")
                    
                    # Log child relationships and generate queries
                    children = relationships.get('children', [])
                    # Sort children by strength (highest first) and take top 2
                    original_children_count = len(children) if children else 0
                    if False: #children:
                        children = sorted(children, key=lambda x: x.get('relationship', {}).get('strength', 0), reverse=True)[:2]
                        logger.info(f"  Direct Children (top {len(children)} of {original_children_count}):")
                        for i, child_info in enumerate(children, 1):
                            child_table = child_info["table"]
                            rel = child_info["relationship"]
                            child_table_name = child_table.get('name')
                            logger.info(f"    {i}. {child_table_name} [{child_table.get('data_domain', 'N/A')}]")
                            logger.info(f"       Type: {rel.get('relationship_type', 'N/A')}, Strength: {rel.get('strength', 0):.2f}")
                            logger.info(f"       Explanation: {rel.get('description', 'N/A')}")
                            
                            # Generate natural language query for child table
                            try:
                                child_query_prompt = f"""Given the following user query: "{unit_query}"

And the relationship context: {rel.get('description', 'N/A')}

The table '{child_table_name}' is a child/dependent of the current table. This table contains: {child_table.get('business_metadata', 'N/A')}

Generate a natural language query that is relevant to querying the child table '{child_table_name}' based on the original user query and the relationship context. The query should be adapted to be appropriate for the child table's data domain ({child_table.get('data_domain', 'N/A')}).

Return ONLY the natural language query, without any explanations or additional text."""
                                
                                child_query, i_tokens, o_tokens = openai_call(child_query_prompt, unit_query)
                                total_input_tokens['gpt-4.1'] += i_tokens
                                total_output_tokens['gpt-4.1'] += o_tokens
                                child_query = child_query.strip()
                                logger.info(f"       Generated query for child table: {child_query}")
                                
                                # Store child query with table name and explanation
                                child_queries_list.append({
                                    "query": child_query,
                                    "table_name": child_table_name,
                                    "explanation": rel.get('description', 'N/A')
                                })
                            except Exception as e:
                                logger.warning(f"       Failed to generate query for child table: {e}")
                    else:
                        logger.info("  Direct Children: None")
                    
                    # Summary: show how many were processed (top 2) vs total available
                    logger.info(f"  Summary: {len(parents)} parent(s) processed (from {original_parents_count} total), {len(children)} child(ren) processed (from {original_children_count} total)")
                    
                    # Create consolidated list with all queries
                    consolidated_queries = [
                        {
                            "query": unit_query,
                            "table_name": selected_file
                        }
                    ]
                    consolidated_queries.extend(parent_queries_list)
                    consolidated_queries.extend(child_queries_list)
                    
                    # Filter out duplicate table names, keeping only the first occurrence
                    seen_tables = set()
                    unique_queries = []
                    for query_entry in consolidated_queries:
                        table_name = query_entry.get("table_name")
                        if table_name not in seen_tables:
                            seen_tables.add(table_name)
                            unique_queries.append(query_entry)
                    consolidated_queries = unique_queries
                    
                    logger.info(f"\n  Consolidated Queries List:")
                    logger.info(f"    Main query: '{unit_query}' -> table: '{selected_file}'")
                    for pq in parent_queries_list:
                        logger.info(f"    Parent query: '{pq['query']}' -> table: '{pq['table_name']}'")
                    for cq in child_queries_list:
                        logger.info(f"    Child query: '{cq['query']}' -> table: '{cq['table_name']}'")
                    logger.info(f"  Total queries in consolidated list: {len(consolidated_queries)}")
                else:
                    logger.info(f"Table '{selected_file}' not found in knowledge graph")
                    # Create consolidated list with just the main query if no relationships found
                    consolidated_queries = [
                        {
                            "query": unit_query,
                            "table_name": selected_file
                        }
                    ]
            else:
                logger.info(f"Knowledge graph file '{json_path}' not found, skipping relationship query")
                # Create consolidated list with just the main query if knowledge graph not found
                consolidated_queries = [
                    {
                        "query": unit_query,
                        "table_name": selected_file
                    }
                ]
        except Exception as e:
            logger.warning(f"Error querying knowledge graph relationships: {e}")
            # Create consolidated list with just the main query if error occurs
            consolidated_queries = [
                {
                    "query": unit_query,
                    "table_name": selected_file
                }
            ]
        
        # Store consolidated_queries for potential use (e.g., in return value or logging)
        # The list is available in the consolidated_queries variable

    # Execute queries against each table in consolidated_queries in parallel
    # Helper function to process a single query entry
    async def process_single_query_entry(query_entry: dict, index: int) -> dict:
        """Process a single query entry and return the updated entry with results."""
        query_text = query_entry.get("query", "")
        table_name = query_entry.get("table_name", "")
        
        logger.info(f"\nProcessing query {index+1}/{len(consolidated_queries)} (parallel):")
        logger.info(f"  Query: '{query_text}'")
        logger.info(f"  Table: '{table_name}'")
        
        try:
            # Execute query for this entry
            # Note: execute_query_with_table is marked async but performs blocking I/O
            # Run it in a thread pool with its own event loop to enable true parallelization
            def run_in_thread():
                """Run the async function in a new event loop in a separate thread."""
                new_loop = asyncio.new_event_loop()
                asyncio.set_event_loop(new_loop)
                try:
                    return new_loop.run_until_complete(execute_query_with_table(
                        selected_file=table_name,
                        unit_query=query_text,
                        orig_query=orig_query,
                        nq=nq,
                        total_input_tokens=total_input_tokens,
                        total_output_tokens=total_output_tokens,
                        curdate=curdate,
                        start_time=start_time
                    ))
                finally:
                    new_loop.close()
            
            loop = asyncio.get_event_loop()
            query_result = await loop.run_in_executor(None, run_in_thread)
            
            # Merge the result fields into the query entry
            query_entry.update({
                "unit_query": query_result.get("unit_query", query_text),  # Keep unit_query for consistency
                "result": query_result.get("result", []),
                "description": query_result.get("description", "No data"),
                "success": query_result.get("success", False),
                "message": query_result.get("message", "N/A"),
                "unitary_time": query_result.get("unitary_time", 0),
                "reference": query_result.get("reference", "N/A"),
                "url": query_result.get("url", "N/A"),
                "table_metadata": query_result.get("table_metadata", "N/A")
            })
            
            logger.info(f"  Success: {query_entry.get('success')} (query {index+1})")
            logger.info(f"  Message: {query_entry.get('message')} (query {index+1})")
            
        except Exception as e:
            error_message = str(e)
            logger.error(f"  Error executing query for table '{table_name}' (query {index+1}): {error_message}")
            
            # Add error fields to the entry
            query_entry.update({
                "unit_query": query_text,  # Keep unit_query for consistency
                "result": [],
                "description": "No data",
                "success": False,
                "message": f"Query execution failed: {error_message}",
                "unitary_time": 0,
                "reference": "N/A",
                "url": "N/A",
                "table_metadata": "N/A"
            })
        
        return query_entry
    
    # Execute all queries in parallel using asyncio.gather
    logger.info(f"\nExecuting {len(consolidated_queries)} queries in parallel...")
    start_parallel_time = time.time()
    
    # Create tasks for all queries
    tasks = [
        process_single_query_entry(query_entry.copy(), i) 
        for i, query_entry in enumerate(consolidated_queries)
    ]
    
    # Execute all queries concurrently
    # return_exceptions=True allows us to handle individual query failures gracefully
    consolidated_results = await asyncio.gather(*tasks, return_exceptions=True)
    
    # Handle any exceptions that occurred during parallel execution
    for i, result in enumerate(consolidated_results):
        if isinstance(result, Exception):
            logger.error(f"Exception in parallel query {i+1}: {str(result)}")
            # Update the query entry with error information
            query_entry = consolidated_queries[i].copy()
            query_entry.update({
                "unit_query": query_entry.get("query", ""),
                "result": [],
                "description": "No data",
                "success": False,
                "message": f"Parallel execution exception: {str(result)}",
                "unitary_time": 0,
                "reference": "N/A",
                "url": "N/A",
                "table_metadata": "N/A"
            })
            consolidated_results[i] = query_entry
    
    parallel_time = time.time() - start_parallel_time
    logger.info(f"All {len(consolidated_queries)} queries completed in {parallel_time:.2f} seconds (parallel execution)")
    
    # Return the first result (main query) as the primary response
    # This maintains backward compatibility with existing code that expects a single result
    if consolidated_results:
        main_result = consolidated_results[0].copy()
        # Ensure unit_query is present for backward compatibility
        if "unit_query" not in main_result:
            main_result["unit_query"] = main_result.get("query", unit_query)
        # Also include all consolidated results in the response
        main_result["consolidated_results"] = consolidated_results
        return main_result
    else:
        # Fallback if somehow consolidated_results is empty
        return {
            "unit_query": unit_query,
            "result": [],
            "description": "No data",
            "success": False,
            "message": "No queries to execute",
            "unitary_time": 0,
            "reference": "N/A",
            "url": "N/A",
            "table_metadata": "N/A",
            "consolidated_results": []
        }

class BatchRequest(BaseModel):
    queries: list[str]

semaphore = asyncio.Semaphore(6)

async def batch_sql_queries(batch: BatchRequest, orig_query: str, total_input_tokens, total_output_tokens, main_query_id: int):
    if len(batch.queries) > 6:
        logger.warning(f"Received {len(batch.queries)} queries, but maximum of 6 allowed. Retaining only the first 6 queries.")
        batch.queries = batch.queries[:6]
    nq = len(batch.queries)
    # override per-batch semaphore

    async def limited(q, orig_query, sub_query_index):
        async with semaphore:
            try:
                # Generate sub-query ID for this specific sub-query
                sub_query_id = query_id_manager.get_next_sub_id(main_query_id)

                # Set sub-query context for processing
                with SubQueryIDContext(sub_query_id, main_query_id):
                    return await asyncio.wait_for(process_single_query(q, orig_query, nq, total_input_tokens, total_output_tokens), timeout=QUERY_TIMEOUT)
            except asyncio.TimeoutError:
                logger.info("Query timed out: Current time: " + strftime("%Y-%m-%d %H-%M-%S", gmtime()))
                return {
                    "error": "Query timed out.",
                    "unit_query": q,
                    "success": False,
                }

    tasks = [limited(q, orig_query, i) for i, q in enumerate(batch.queries)]
    results = await asyncio.gather(*tasks , return_exceptions=True)

    successes = sum(1 for r in results if isinstance(r, dict) and r.get('success'))
    return {
        "processed": len(results),
        "successful": successes,
        "errors": len(results) - successes,
        "responses": results
    }

async def handle_forecast(query: str):
    start_time = time.time()
    # Generate df, target_column, steps_ahead
    prompt = ChatPromptTemplate.from_messages([
        ("system", "You are a data assistant. Given a user question and a CSV schema with samples, extract: target_column (string among provided columns) and steps_ahead (integer 1-50). If steps not specified, default to 3. If target not clear, pick the most likely numeric target column."),
        ("human", "Question: {question}\nColumns: {columns}\nSamples: {samples}\nReturn JSON with keys target_column and steps_ahead only."),
    ])
    logger.info("Entered forecasting module")
    #engine = create_engine(DATABASE_URI)
    # Query the information schema to get the table schema
    data_query = "select * from combined_gdp_iip ;"
    with engine.connect() as connection:
        df = pd.read_sql(text(data_query), connection)
        nrows = len(df)
        logger.info("Number of rows pulled: " + str(nrows))

    cols = df.columns.tolist()
    sample = df.head(3).to_dict(orient="records")
    # Sort the DataFrame by the 'date' columnß
    df = df.sort_values(by="year",ascending=True).reset_index(drop=True)

    llm = ChatOpenAI(model="gpt-4.1", api_key=OPENAI_API_KEY)
    chain = prompt | llm
    resp = await chain.ainvoke({"question": query, "columns": cols, "samples": sample})

    import json as _json
    try:
        parsed = _json.loads(resp.content)
        target_column = parsed.get("target_column")
        steps_ahead = int(parsed.get("steps_ahead", 3))
        if steps_ahead < 1 or steps_ahead > 50:
            steps_ahead = 3
        if not target_column or target_column not in df.columns:
            num_cols = df.select_dtypes(include=[np.number]).columns.tolist()
            target_column = num_cols[0]
    except Exception as exc:
        raise Exception(f"LLM parsing failed: {exc}")

    result = run_forecast_core(df, target_column=target_column, steps_ahead=steps_ahead, model_type="AUTO")
    result["understood"] = {"target_column": target_column, "steps_ahead": steps_ahead}
    parsed_data = handle_json_response(result)
    result = [parsed_data]
    total_time = time.time() - start_time
    results =  {
                "unit_query": query,
                "result": [parsed_data],
                "description": "Historic values and future forecasts of GDP/IIP at India level",
                "success": True,
                "message": "Successful completion",
                "unitary_time": total_time,
                "reference": "GDP and IIP combined view",
                "url": "GDP and IIP combined view",
                "table_metadata": "GDP and IIP combined view",
            }
    logger.info("Result: " + str(results["result"][0]["df_with_forecast"]))
    return {
        "processed": 1,
        "successful": 1,
        "errors": 0,
        "responses": results
    }
