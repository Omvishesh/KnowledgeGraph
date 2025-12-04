#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri May 30 18:06:45 2025

@author: harshad

FastAPI application for data retrieval and orchestration

Note: For interactive use, run streamlit_app.py instead.
You can also use the orchestrate() function programmatically.
"""
import asyncio
from   pydantic import BaseModel
from   time import strftime, gmtime
import os
import re
import json
from   utils_common import clarify_query, generate_sql_queries, query_certify_valid
import time
import logging
from   handler_sql import batch_sql_queries, reload_env_keys
from   utils_common import openai_call
import pandas as pd
from collections import defaultdict
from   dotenv import load_dotenv
from   logging_utils import setup_logging, get_logger, query_id_manager, QueryIDContext
from   fastapi import FastAPI, Depends, HTTPException
from   fastapi.security.api_key import APIKeyHeader
#from   async_handler_sql import batch_sql_queries

# Load environment variables
load_dotenv("prod.env")

# Setup logging with query ID support
setup_logging("sql", logging.INFO)
logger = get_logger(__name__)

# FastAPI app instance
app = FastAPI(title="Knowledge Graph Query API", version="1.0.0")

# API Key configuration
API_KEY = os.getenv("ACQ_API_KEY")
if API_KEY is None:
    raise ValueError("ACQ_API_KEY environment variable is not set")
API_KEY_NAME = "access_token"
api_key_header = APIKeyHeader(name=API_KEY_NAME, auto_error=True)

# API Key verification
async def verify_api_key(api_key: str = Depends(api_key_header)):
    """Verify the API key"""
    print(f"Received API Key: {api_key}")
    print("Verify key: Current time: " + strftime("%Y-%m-%d %H-%M-%S", gmtime()))
    
    if api_key != API_KEY:
        raise HTTPException(status_code=403, detail="Invalid API Key")
    
    return api_key

# ============================================================================
# QUESTION VARIABLE (DEPRECATED - Use streamlit_app.py for interactive queries)
# ============================================================================
# QUESTION = "What is the GDP growth rate in India for the last 5 years?"
# ============================================================================

def has_long_run(s, min_run_length=200):
    """Detects long single-character runs (e.g., 'aaaaa...')"""
    if len(s) < min_run_length:
        return False
    count = 1
    for i in range(1, len(s)):
        count = count + 1 if s[i] == s[i-1] else 1
        if count >= min_run_length:
            return True
    return False

def build_suggested_answer_from_table_dicts(table_dicts):
    """
    Build a markdown string from table_dicts in the backup format.
    Includes table markdowns with captions, confidence, and missing_data.
    """
    if not table_dicts:
        return "<insufficient_data>"
    
    markdown_parts = []
    
    for table_dict in table_dicts:
        # Extract fields
        table_metadata = table_dict.get("table_metadata", "N/A")
        explanation = table_dict.get("explanation", "")
        table_markdown = table_dict.get("table_markdown", "")
        confidence = table_dict.get("confidence", "N/A")
        missing_data = table_dict.get("missing_data", "")
        table_name = table_dict.get("table_name", "N/A")
        query = table_dict.get("query", "N/A")
        
        # Build caption
        caption_parts = []
        if table_metadata and table_metadata != "N/A":
            caption_parts.append(f"Table Metadata: {table_metadata}")
        if explanation and explanation != "N/A" and explanation != "answer to original query":
            caption_parts.append(f"\n\nExplanation: {explanation}")
        
        caption = "\n".join(caption_parts) if caption_parts else "Table information"
        
        # Build markdown part
        part_markdown = f"\n\n**Caption:** {caption}\n\n{table_markdown}\n"
        
        # Add confidence and missing_data if available
        if confidence and confidence != "N/A":
            part_markdown += f"\n**Confidence:** {confidence}\n"
        if missing_data:
            part_markdown += f"\n**Missing Data:** {missing_data}\n"
        
        markdown_parts.append(part_markdown)
    
    return "\n".join(markdown_parts)

def markdown_answer(user_query, responses, counter, input_tokens_counter, output_tokens_counter, consolidated_results=None):
    # data_description !- ""
    if consolidated_results is None:
        consolidated_results = []
    
    try:
        table_dicts = []
        
        # Helper function to extract markdown table from result
        def extract_table_markdown(result):
            table_markdown = ""
            if isinstance(result, list) and len(result) > 0:
                if isinstance(result[0], dict):
                    # Check for summarized_info (normal case)
                    if "summarized_info" in result[0]:
                        table_markdown = str(result[0]["summarized_info"]).strip()
                    # Check for df_with_forecast (forecast case)
                    elif "df_with_forecast" in result[0]:
                        table_markdown = str(result[0]["df_with_forecast"]).strip()
                    else:
                        # Fallback: convert dict to markdown table
                        table_markdown = pd.DataFrame([result[0]]).to_markdown(index=False)
                else:
                    # If result[0] is not a dict, convert to DataFrame
                    table_markdown = pd.DataFrame(result).to_markdown(index=False)
            elif isinstance(result, dict):
                # If result is directly a dict
                if "summarized_info" in result:
                    table_markdown = str(result["summarized_info"]).strip()
                elif "df_with_forecast" in result:
                    table_markdown = str(result["df_with_forecast"]).strip()
                else:
                    table_markdown = pd.DataFrame([result]).to_markdown(index=False)
            else:
                # Fallback: try to convert to DataFrame
                try:
                    df = pd.DataFrame(result)
                    table_markdown = df.to_markdown(index=False)
                except:
                    table_markdown = str(result)
            return table_markdown
        
        # Helper function to check and deduplicate tables before adding
        def add_table_with_deduplication(new_table_dict, existing_table_dicts):
            """
            Add a new table_dict to existing_table_dicts after checking for duplicates.
            If the new table_markdown is a substring of an existing one, skip adding.
            If an existing table_markdown is a substring of the new one, overwrite the existing one.
            """
            new_markdown = new_table_dict.get("table_markdown", "")
            new_markdown_len = len(new_markdown)
            
            # Check against all existing entries (at most one match expected)
            for idx, existing_dict in enumerate(existing_table_dicts):
                existing_markdown = existing_dict.get("table_markdown", "")
                existing_markdown_len = len(existing_markdown)
                
                # Determine which is shorter
                if new_markdown_len < existing_markdown_len:
                    # New is shorter - check if it's a substring of existing
                    if new_markdown in existing_markdown:
                        # New is a substring of existing, don't add it
                        logger.info(f"Skipping duplicate table (new is substring of existing): {new_table_dict.get('table_name', 'N/A')}")
                        return
                elif existing_markdown_len < new_markdown_len:
                    # Existing is shorter - check if it's a substring of new
                    if existing_markdown in new_markdown:
                        # Existing is a substring of new, overwrite it
                        logger.info(f"Overwriting duplicate table (existing is substring of new): {existing_dict.get('table_name', 'N/A')}")
                        existing_table_dicts[idx] = new_table_dict
                        return
                else:
                    # Lengths are equal - check if they're identical
                    if new_markdown == existing_markdown:
                        # Identical strings, skip adding duplicate
                        logger.info(f"Skipping duplicate table (identical markdown): {new_table_dict.get('table_name', 'N/A')}")
                        return
            
            # No match found, add the new entry
            existing_table_dicts.append(new_table_dict)
        
        # Process main responses first
        for i in range(len(responses)):
            if responses[i]["success"]:
                logger.info("<part> " + str(i+1) + " has data")
                
                # Extract all required fields
                query = responses[i].get("unit_query", responses[i].get("query", user_query))
                table_name = responses[i].get("table_name", "N/A")
                table_metadata = str(responses[i].get("table_metadata", "N/A")).strip()
                explanation = "answer to original query"
                url = responses[i].get("url", "N/A")
                reference = responses[i].get("reference", "N/A")
                success = responses[i].get("success", False)
                table_type = "main"
                
                # Extract markdown table from result
                result = responses[i]["result"]
                table_markdown = extract_table_markdown(result)
                
                # Create table dictionary (confidence and missing_data will be computed later)
                table_dict = {
                    "query": query,
                    "table_name": table_name,
                    "table_metadata": table_metadata,
                    "explanation": explanation,
                    "url": url,
                    "reference": reference,
                    "success": success,
                    "table_type": table_type,
                    "confidence": None,  # Will be computed later
                    "missing_data": None,  # Will be computed later
                    "table_markdown": table_markdown  # Store markdown for confidence computation
                }
                # Use deduplication helper before adding
                add_table_with_deduplication(table_dict, table_dicts)
        
        # Process consolidated results (skip main query at index 0, only process parent and child queries)
        for idx, cr in enumerate(consolidated_results):
            # Skip the first entry (index 0) as it's the main query already processed above
            if idx == 0:
                continue
            
            # Process if this entry has data (success=True and has results)
            if cr.get("success", False) and cr.get("result"):
                logger.info(f"Processing consolidated result {idx+1}: table='{cr.get('table_name', 'N/A')}'")
                
                # Extract all required fields
                query = cr.get("query", cr.get("unit_query", "N/A"))
                table_name = cr.get("table_name", "N/A")
                table_metadata = str(cr.get("table_metadata", "N/A")).strip()
                explanation = str(cr.get("explanation", "N/A")).strip()
                url = cr.get("url", "N/A")
                reference = cr.get("reference", "N/A")
                success = cr.get("success", False)
                table_type = "additional_result"
                
                # Extract markdown table from result
                result = cr.get("result", [])
                table_markdown = extract_table_markdown(result)
                
                # Create table dictionary (confidence and missing_data will be computed later)
                table_dict = {
                    "query": query,
                    "table_name": table_name,
                    "table_metadata": table_metadata,
                    "explanation": explanation,
                    "url": url,
                    "reference": reference,
                    "success": success,
                    "table_type": table_type,
                    "confidence": None,  # Will be computed later
                    "missing_data": None,  # Will be computed later
                    "table_markdown": table_markdown  # Store markdown for confidence computation
                }
                # Use deduplication helper before adding
                add_table_with_deduplication(table_dict, table_dicts)
        
        if table_dicts:
            return table_dicts
        else:
            return []
    except Exception as e:
        logger.error(f"Error in markdown_answer: {str(e)}")
        try:
            # Handle forecast case in exception
            if isinstance(responses, dict) and "result" in responses:
                result = responses["result"]
                if isinstance(result, list) and len(result) > 0:
                    if isinstance(result[0], dict) and "df_with_forecast" in result[0]:
                        table_markdown = str(result[0]["df_with_forecast"]).strip()
                        query = responses.get("unit_query", responses.get("query", user_query))
                        table_dict = {
                            "query": query,
                            "table_name": "N/A",
                            "table_metadata": responses.get("description", "Forecast data"),
                            "explanation": "answer to original query",
                            "url": responses.get("url", "N/A"),
                            "reference": responses.get("reference", "N/A"),
                            "success": True,
                            "table_type": "main",
                            "confidence": None,
                            "missing_data": None,
                            "table_markdown": table_markdown
                        }
                        return [table_dict]
        except:
            pass
        return []

# MODIFIED: Added token_counters as arguments, now works on individual table queries
def confidence_checker(user_query, table_query, table_markdown, input_tokens_counter, output_tokens_counter):
    """
    Compute confidence for an individual table query.
    
    Args:
        user_query: The original user query
        table_query: The specific query that generated this table
        table_markdown: The markdown table content
        input_tokens_counter: Dictionary to track input tokens
        output_tokens_counter: Dictionary to track output tokens
    
    Returns:
        tuple: (confidence: str, missing_data: str) where:
            - confidence: Confidence score ("0", "1", or "2")
            - missing_data: Detailed explanation of what data is missing (empty string if nothing missing)
    """
    system_instruction = f"""
    Consider the following table result: {table_markdown}. This table was generated to answer the query: "{table_query}". The original user query is: "{user_query}".

    Task: You must return TWO things:
    1. A unique integer value from 0, 1, 2 based on the following criteria.
    2. A detailed explanation of what data is missing (if any), comparing the query requirements to what's in the table.

    CONFIDENCE CRITERIA:
    
    0: If the table result has no relation to neither the user query nor the table query. For example, if the data is at national level when state level was queried, or if the data is completely irrelevant to both queries.
    
    1: If the table result is partially relevant. This includes:
       - The data partially answers either the user query or the table query (but not fully)
       - The data is relevant but incomplete in terms of timeline (e.g., missing some requested years)
       - The data answers part of what was asked but not everything
    
    2: If the table result fully answers either the user query OR the table query. This means:
       - The data completely satisfies the user query, OR
       - The data completely satisfies the table query
       - The time range requested is covered (if applicable)
       - IMPORTANT: If the table contains sufficient underlying information to answer the query (even if computation or analysis is required), it should be confidence 2. For example, if the query asks for correlation between GDP and IIP, both GDP and IIP tables individually should receive confidence 2 because they contain the underlying data needed to compute the correlation, even though the correlation itself cannot be directly retrieved from a single table.

    MISSING DATA ANALYSIS:
    Provide a detailed explanation of what data is missing by comparing:
    - Timeline: Compare the time range requested in the query (years, months, date ranges) with the time range covered in the table_markdown. Note any missing years, months, or date ranges.
    - Categories/States/Entities: Compare the categories, states, sectors, or other entities requested in the query with what's present in the table_markdown. List any missing categories, states, or entities.
    - Other requirements: Note any other specific requirements from the query that are not present in the table.
    
    If the table fully satisfies the query (confidence 2) and nothing is missing, return an empty string for missing_data.
    If confidence is 0 (completely irrelevant), you can still note what would be needed, but focus on why it's irrelevant.

    RESPONSE FORMAT:
    You MUST return a valid JSON object with the following structure:
    {{
        "confidence": 0 or 1 or 2,
        "missing_data": "detailed explanation of missing data, or empty string if nothing is missing"
    }}
    
    The confidence field must be an integer (0, 1, or 2).
    The missing_data field must be a string.
    """
    # MODIFIED: Capture token usage from openai_call and update counters
    # The default model in openai_call is 'gpt-4.1'
    model_name = "gpt-4.1"
    # Use the table_query as the context for confidence checking (not user_query)
    # Request JSON format for structured output
    response, i_tokens, o_tokens = openai_call(
        system_instruction, 
        table_query, 
        model=model_name,
        response_format={"type": "json_object"}
    )
    input_tokens_counter[model_name] += i_tokens
    output_tokens_counter[model_name] += o_tokens

    # Parse the JSON response and validate with Pydantic model
    confidence = "0"
    missing_data = ""
    
    try:
        # Parse JSON response
        response_json = json.loads(response.strip())
        
        # Validate with Pydantic model
        confidence_response = ConfidenceResponse(**response_json)
        confidence = str(confidence_response.confidence)
        missing_data = confidence_response.missing_data
        
    except json.JSONDecodeError as e:
        logger.warning(f"Could not parse JSON response: {str(e)}")
        logger.warning(f"Response content: {response[:200]}")
        # Fallback to old parsing logic
        try:
            response_text = response.strip()
            # Try to extract confidence
            confidence_match = None
            if "CONFIDENCE:" in response_text:
                conf_part = response_text.split("CONFIDENCE:")[1].split("MISSING_DATA:")[0].strip()
                confidence_match = re.search(r'\b([012])\b', conf_part)
            elif re.search(r'\b([012])\b', response_text):
                confidence_match = re.search(r'\b([012])\b', response_text)
            
            if confidence_match:
                confidence = str(int(confidence_match.group(1)))
            
            # Try to extract missing_data
            if "MISSING_DATA:" in response_text:
                missing_data = response_text.split("MISSING_DATA:")[1].strip()
        except Exception as fallback_error:
            logger.warning(f"Fallback parsing also failed: {str(fallback_error)}")
            confidence = "0"
            missing_data = "Error parsing response"
    
    except Exception as e:
        logger.warning(f"Could not parse confidence response: {str(e)}")
        logger.warning(f"Response content: {response[:200]}")
        confidence = "0"
        missing_data = "Error parsing response"
    
    return confidence, missing_data

# Input model
class Question(BaseModel):
    question: str

class BatchRequest(BaseModel):
    queries: list[str]

class ConfidenceResponse(BaseModel):
    """Structured response model for confidence checking."""
    confidence: int  # 0, 1, or 2
    missing_data: str  # Detailed explanation of missing data, or empty string if nothing is missing

@app.post("/integrated_query", dependencies=[Depends(verify_api_key)])
async def orchestrate(question: Question):
    # Force reload environment keys from prod.env (including cached keys in imported modules)
    # This reloads keys from handler_sql (OPENAI_API_KEY) and utils_common (GOOGLE_API_KEY)
    reload_env_keys()
    
    # Generate unique main query ID for this request
    main_query_id = query_id_manager.get_next_main_id()

    # Set main query ID context for this entire request
    with QueryIDContext(main_query_id):
        # Initialize token counters for this request
        total_input_tokens = defaultdict(int)
        total_output_tokens = defaultdict(int)

        # Initialize variables for error cases
        rephrased_query = "N/A"
        clarified_response = None
        sql_queries = []

        try:
            start_time = time.time()
            user_query = str(question.question).strip()
            

            # Extract first line and remaining lines separately
            if '\n' in user_query:
                lines = user_query.split('\n')
                first_line = lines[0].strip()
                remaining_lines = lines[1:]
                
                # Apply replacements only to first line
                # Replace "vs." or "versus" with "and" (case-insensitive)
                first_line = re.sub(r'\b(vs\.?|versus)\b', 'and', first_line, flags=re.IGNORECASE)
                # Replace "top" with "rank" (whole word match, case-insensitive)
                first_line = re.sub(r'\btop\b', 'rank', first_line, flags=re.IGNORECASE)
                
                # Recombine: processed first line + unchanged remaining lines
                user_query = first_line + '\n' + '\n'.join(remaining_lines) if remaining_lines else first_line
            else:
                # No newlines, apply replacements to entire query
                user_query = re.sub(r'\b(vs\.?|versus)\b', 'and', user_query, flags=re.IGNORECASE)
                user_query = re.sub(r'\btop\b', 'rank', user_query, flags=re.IGNORECASE)

            logger.info("Original received query: " + str(user_query))

            # MODIFIED: Capture tokens from query_certify_valid (uses gpt-4.1)
            validity, i_tokens, o_tokens = query_certify_valid(user_query)
            total_input_tokens["gpt-4.1"] += i_tokens
            total_output_tokens["gpt-4.1"] += o_tokens

            if "NO" in validity:
                total_time = time.time() - start_time
                logger.info(f"Total processing time: {total_time}")
                logger.info("Query is out of bounds")
                data_payload = {
                    "query": user_query,
                    "suggested_answer": "Out of bounds",
                    "context": "N/A",
                    "urls": [],
                    "references": [],
                    "total_time": total_time,
                    "confidence": "0"
                }
                return {
                    "success": False, "data": data_payload,
                    "total_input_tokens": dict(total_input_tokens),
                    "total_output_tokens": dict(total_output_tokens)
                }

            # Forecast condition deactivated - all queries now go through regular flow
            # if ("India IIP forecast" in user_query or "India GDP forecast" in user_query) and ("years" in user_query):
            #     sql_responses = await handle_forecast(user_query)
            #     sql_queries   = "Combined GDP and IIP history for India"
            #     rephrased_query = user_query
            # else:
            if True:  # Always use regular query flow
                # MODIFIED: Capture tokens from clarify_query (uses gpt-4.1)
                clarified_response, i_tokens, o_tokens = clarify_query(user_query)
                total_input_tokens["gpt-4.1"] += i_tokens
                total_output_tokens["gpt-4.1"] += o_tokens
                
                # Create a string representation for logging and compatibility
                unitary_queries_str = ", ".join(clarified_response.unitary_queries)
                date_range_str = f"{clarified_response.date_range.min} to {clarified_response.date_range.max}"
                rephrased_query = f"{unitary_queries_str} ({date_range_str})"
                logger.info(f"Unitary queries: {clarified_response.unitary_queries}")
                logger.info(f"Date range: {date_range_str}")

                if True:
                    # MODIFIED: generate_sql_queries now combines unitary queries with date range programmatically
                    # No LLM call is made, so no tokens are consumed
                    sql_queries, i_tokens, o_tokens = generate_sql_queries(clarified_response)
                    # Tokens are 0 since no LLM call is made, but keeping for consistency
                    total_input_tokens["gpt-4.1"] += i_tokens
                    total_output_tokens["gpt-4.1"] += o_tokens
                else:
                    sql_queries = clarified_response.unitary_queries

                batch = BatchRequest(queries=sql_queries)
                sql_responses = await batch_sql_queries(batch, user_query, total_input_tokens, total_output_tokens, main_query_id)
                logger.info("SQL responses obtained")
                logger.info(sql_responses["responses"])

            # Extract consolidated_results from all responses (works for both forecast and regular queries)
            all_consolidated_results = []
            for resp in sql_responses["responses"]:
                if isinstance(resp, dict) and "consolidated_results" in resp:
                    consolidated_results = resp.get("consolidated_results", [])
                    if consolidated_results:
                        all_consolidated_results.extend(consolidated_results)
            
            # Log consolidated results for debugging
            if all_consolidated_results:
                logger.info(f"Found {len(all_consolidated_results)} consolidated query results")
                for idx, cr in enumerate(all_consolidated_results):
                    logger.info(f"  Consolidated result {idx+1}: query='{cr.get('query', 'N/A')}', table='{cr.get('table_name', 'N/A')}', success={cr.get('success', False)}")
            
            # Get table dictionaries from markdown_answer
            has_garbage = True
            counter = 0
            table_dicts = []
            while has_garbage and (counter < 2):
                table_dicts = markdown_answer(user_query, sql_responses["responses"], counter, total_input_tokens, total_output_tokens, all_consolidated_results)
                # Check for garbage in each table's markdown
                has_garbage = False
                for table_dict in table_dicts:
                    if has_long_run(str(table_dict.get("table_markdown", ""))):
                        has_garbage = True
                        break
                if has_garbage:
                    logger.warning("Output contained garbage, retrying")
                counter += 1

            # --- BACKUP STRUCTURE FOR GARBAGE ERROR ---
            if has_garbage:
                total_time = time.time() - start_time
                data_payload = {
                    "query": user_query,
                    "suggested_answer": "Model throwing garbage tokens",
                    "context": "N/A",
                    "urls": [],
                    "references": [],
                    "total_time": total_time,
                    "confidence": "0"
                }
                return {
                    "success": False,
                    "data": data_payload,
                    "total_input_tokens": dict(total_input_tokens),
                    "total_output_tokens": dict(total_output_tokens)
                }

            # Check for insufficient data
            if not table_dicts:
                total_time = time.time() - start_time
                data_payload = {
                    "query": user_query,
                    "suggested_answer": "<insufficient_data>",
                    "context": "N/A",
                    "urls": [],
                    "references": [],
                    "total_time": total_time,
                    "confidence": "0"
                }
                return {
                    "success": False,
                    "data": data_payload,
                    "total_input_tokens": dict(total_input_tokens),
                    "total_output_tokens": dict(total_output_tokens)
                }

            # Compute confidence for each table
            logger.info(f"Computing confidence for {len(table_dicts)} tables")
            confidence_values = []
            for table_dict in table_dicts:
                table_query = table_dict.get("query", user_query)
                table_markdown = table_dict.get("table_markdown", "")
                
                # Compute confidence and missing_data for this table
                confidence, missing_data = confidence_checker(user_query, table_query, table_markdown, total_input_tokens, total_output_tokens)
                table_dict["confidence"] = confidence
                table_dict["missing_data"] = missing_data
                
                # Collect confidence values to find maximum
                try:
                    confidence_int = int(confidence)
                    confidence_values.append(confidence_int)
                except (ValueError, TypeError):
                    pass
                
                logger.info(f"Table '{table_dict.get('table_name', 'N/A')}' confidence: {confidence}, missing_data: {missing_data[:100] if missing_data else 'None'}")

            # Build suggested_answer markdown string
            suggested_answer = build_suggested_answer_from_table_dicts(table_dicts)
            
            # Find maximum confidence value
            overall_confidence = str(max(confidence_values)) if confidence_values else "0"
            
            # Extract urls and references
            urls, refs, meta = [], [], []
            try:
                # Extract from main responses (filter out "N/A" values)
                urls = [resp.get("url") for resp in sql_responses["responses"] if resp.get("success") is True and "url" in resp and resp.get("url") != "N/A"]
                refs = [resp.get("reference") for resp in sql_responses["responses"] if resp.get("success") is True and "reference" in resp and resp.get("reference") != "N/A"]
                meta = [resp.get("table_metadata") for resp in sql_responses["responses"] if resp.get("success") is True and "table_metadata" in resp]
                
                # Also extract from consolidated_results (filter out "N/A" values and duplicates)
                for cr in all_consolidated_results:
                    if cr.get("success") is True:
                        url = cr.get("url")
                        if url and url != "N/A" and url not in urls:
                            urls.append(url)
                        ref = cr.get("reference")
                        if ref and ref != "N/A" and ref not in refs:
                            refs.append(ref)
                        if "table_metadata" in cr:
                            meta.append(cr.get("table_metadata"))
            except:
                logger.info("Could not trace back urls or references")
            
            # Build context/commentary
            commentary = "Table information:\n"
            try:
                commentary += str(meta)
            except:
                pass
            
            # Summarize commentary using GPT-4o-mini
            if commentary and commentary.strip() != "Table information:\n":
                try:
                    summary_instruction = "Summarize the following table information and metadata in approximately 100 words. Focus on the key data sources, tables, and their relevance to the query."
                    summary_response, i_tokens, o_tokens = openai_call(
                        summary_instruction,
                        commentary,
                        model="gpt-4o-mini"
                    )
                    total_input_tokens["gpt-4o-mini"] += i_tokens
                    total_output_tokens["gpt-4o-mini"] += o_tokens
                    commentary = summary_response.strip()
                    logger.info("Commentary summarized successfully")
                except Exception as e:
                    logger.warning(f"Failed to summarize commentary: {str(e)}")
                    # Keep original commentary if summarization fails
            
            logger.info("Suggested answer: ")
            logger.info(suggested_answer)
            logger.info("Commentary:")
            logger.info(commentary)
            logger.info(f"Overall confidence: {overall_confidence}")

            total_time = time.time() - start_time
            logger.info(f"Total processing time: {total_time}")

            # --- BACKUP STRUCTURE FOR SUCCESS RESPONSE ---
            data_payload = {
                "query": user_query,
                "rephrased_query": rephrased_query,
                "suggested_answer": suggested_answer,
                "context": commentary,
                "urls": urls,
                "references": refs,
                "confidence": overall_confidence,
                "sql_queries": sql_queries,
                "total_time": total_time,
                # "raw_sql_responses": sql_responses
            }

            return {
                "success": True,
                "data": data_payload,
                "total_input_tokens": dict(total_input_tokens),
                "total_output_tokens": dict(total_output_tokens)
            }

        except Exception as error:
            logger.error(f"Error: {error}")
            total_time = time.time() - start_time

            # --- BACKUP STRUCTURE FOR EXCEPTION RESPONSE ---
            data_payload = {
                "query": question.question,
                "rephrased_query": rephrased_query,
                "suggested_answer": "Answer compilation failed",
                "context": str(error),  # Include the actual error in the context
                "urls": [],
                "references": [],
                "confidence": "0",
                "sql_queries": sql_queries,
                "total_time": total_time
            }
            return {
                "success": False,
                "data": data_payload,
                "total_input_tokens": dict(total_input_tokens),
                "total_output_tokens": dict(total_output_tokens)
            }
