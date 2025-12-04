#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri May 30 18:08:22 2025

@author: harshad

Common utils for SQL and VEC data
"""
from dotenv import load_dotenv
import os
import time
from time import strftime, gmtime
from textwrap import dedent
from openai import OpenAI
import logging
import json
from pydantic import BaseModel
from typing import List
from   logging_utils import get_logger

load_dotenv("prod.env", override=True)
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
open_ai_client = OpenAI()
#print(os.getenv("OPENAI_API_KEY"))

# Setup logger
logger = get_logger(__name__)

class DateRange(BaseModel):
    """Date range model with minimum and maximum dates"""
    min: str  # Format: "Month Year" such as "April 2024"
    max: str  # Format: "Month Year" such as "December 2024"

class ClarifiedQueryResponse(BaseModel):
    """Structured response model for query clarification"""
    unitary_queries: List[str]  # List of unitary queries like ["GDP India", "IIP Maharashtra"]
    date_range: DateRange  # Date range with min and max

def openai_call(system_instruct, user_content, model="gpt-4.1", response_format=None):
    """
    Calls the OpenAI API and returns the content and token usage.
    
    Args:
        system_instruct: System instruction message
        user_content: User content message
        model: Model name (default: "gpt-4.1")
        response_format: Optional response format dict (e.g., {"type": "json_object"})
    """
    kwargs = {
        "model": model,
        "messages": [
            {"role": "system", "content": [{"type": "text", "text": str(system_instruct)}]},
            {"role": "user", "content": [{"type": "text", "text": str(user_content)}]}
        ],
        "temperature": 0
    }
    if response_format is not None:
        kwargs["response_format"] = response_format
    
    response = open_ai_client.chat.completions.create(**kwargs)

    # Extract content and token usage from the response object
    content = response.choices[0].message.content
    input_tokens = response.usage.prompt_tokens
    output_tokens = response.usage.completion_tokens

    return content, input_tokens, output_tokens

def query_certify_valid(user_query):
    #if "\n" in user_query:
    #    user_query = user_query.split("\n")[0]
    system_instruction = dedent(f"""
                                Given the query below, determine if it relates in some way to the Indian, Asian, or World economy.

A query is VALID if it concerns any aspect of the Indian economy, including but not limited to:

macroeconomic indicators (GDP, inflation, IIP, WPI, GSDP, NSDP, exports, imports, trade, fiscal or monetary policy, GST, UPI)

sectoral data (agriculture, industry, manufacturing, MSMEs, services, housing, construction, transport, banking, credit, finance, insurance, energy, renewables, electric vehicles, companies, business registrations)

market and labour data (employment, PLFS, rural or urban labour, workforce, demographic groups, education and skill metrics, wage/compensation, population breakdowns, youth empowerment, schools data)

state or district level economic statistics (taxes, GST, value added, government schemes, per capita indicators, outstanding loans)

agriculture and rural indicators (farmer advisory, land use, input/output, household classifications, loans, procurement channels, asset investments, insurance, watershed/rainfall/fishery/rural infrastructure)

public and private investment, government schemes, Aadhaar coverage, settlement/payment systems (UPI, payment transactions, e-way bills, digital platforms), social and living standards (sanitation, water, housing, income/consumption surveys)

Some key words which may appear in VALID queries:
    GDP, gross domestic product, GVA, value added, inflation, CPI, WPI, price index, consumer price, wholesale price, real growth, nominal growth, fiscal deficit, current account, foreign exchange, reserves, trade balance, imports, exports, exchange rate, purchasing power parity, IMF, World Bank, economic survey, taxes, GST, value added tax, excise, customs duty, tax collection, IGST, state taxes, net receipts, direct tax, indirect tax, composition taxpayer, gross tax, net tax, tax refund, settlement, industrial production, IIP, manufacturing output, cement, steel, MSME, medium and small enterprises, enterprise registration, Udyam, sector share, factory data, Annual Survey of Industries, stock and inventory, capital investment, industrial employment, production index, capacity utilization, crop, harvest, sowing, yield, seed quality, fertilizer, procurement, mandi, FPO, rural labour, irrigation, rainfall, watershed, rural credit, NABARD, minimum support price, MSP, agri input, livestock, fisheries, faunal diversity, farmer income, asset holding, non-farm investment, loan waiver, agricultural household, land ownership, social group, OBC, SC, ST, employment, unemployment, PLFS, worker participation, labour force, wages, earnings, compensation, job, skill development, population, migration, youth power, education score, literacy, child labour, sector-wise workers, female workforce, employment rate, NEET, banks, lending, loan, credit, NPA, interest rate, RBI, financial inclusion, payment systems, UPI, transaction, e-way bill, digital payment, mobile banking, ATM, net banking, NBFC, deposit, insurance, premium, coverage, credit guarantee, microfinance, scheme, Ayushman, subsidy, DBT, PDS, social security, pension, provident fund, CGHS, government initiative, welfare, national mission, Swachh Bharat, housing for all, skill India, MNREGA, electricity, power, renewable, solar power, wind energy, grid, water quality, sanitation, road, rail, airport, air passenger, transport, urban infrastructure, construction, company, compliance, registration, startup, FDI, export, import duty, export incentive, e-commerce, trading, business closure, entrepreneur, compliance status, household, expenditure, consumption, receipts, asset, insurance coverage, net worth, procurement agency, cooperative, dealer, wealth index, standard of living, pucca house, affordable housing, land lease, productivity, social indicator, data survey, statistical office, NSO, district-wise, state-wise, per capita, gross collection, net collection, UPI LITE, UPI Credit, banking, card usage

If a query is vague or ambiguous (e.g., "top 5 states"), treat it as VALID.

A query is INVALID only if it clearly does NOT relate to the Indian or global economy in any way. Exclude queries about foreign or non-economic topics unless they explicitly compare to or affect India’s economic context.
                                
**IMPORTANT**
If in doubt or if it is unclear whether the query is economy-related, answer YES.

Respond with a single word only:
YES (if the query is valid) or NO (if the query is invalid).
If VALID --> answer "YES"
If INVALID --> answer "NO"
No explanations or additional output.
                                """)
    # MODIFIED: Capture token usage from openai_call
    validity, i_tokens, o_tokens = openai_call(system_instruction, user_query, "gpt-4.1")
    validity = validity.strip()

    return validity, i_tokens, o_tokens

def old_query_certify_valid(user_query):
    if "\n" in user_query:
        user_query = user_query.split("\n")[0]
    system_instruction = dedent(f"""
                                Given the attached query below, decide whether the query can be answered with the available data. To decide on validity, remember that you are an agent which can answer questions about the Indian economy.

                                ## Valid topics and questions include:
                                    finance_and_industry
                                    Inflation (CPI),
                                    wholesale prices (WPI),
                                    industrial output (IIP),
                                    manufacturing and other industrial sectors,
                                    cement and construction,
                                    banking, finance,
                                    aadhar,
                                    Hospital data (CGHS),
                                    toll data,
                                    electric vehicles(ev),
                                    Airport Data,
                                    Air passenger traffic,
                                    renewable energy,
                                    RBI, Payment Systems, Transactions,
                                    GDP (gross domestic product),
                                    state value added (GSVA),
                                    state gross domestic product (GSDP),
                                    medium and small enterprises (MSME),
                                    MSME queries around the world -- Asia, Europe, America,
                                    Credit related queries,
                                    agriculture and rural labour,
                                    housing prices,
                                    government schemes like ayushman,
                                    national income,
                                    private income,
                                    exports, imports, IMF data,
                                    international trade,
                                    macro and micro economic questions,
                                    population or strength of labour force in various categories, and
                                    Indian government initiatives regarding the economy.
                                    farmer advisory
                                    crop disposal channels
                                    seed quality and procurement
                                    fertilizer usage
                                    veterinary services
                                    irrigation access
                                    land leasing (leased-in, leased-out)
                                    land ownership patterns
                                    agricultural household classification
                                    social group (SC, ST, OBC, Others) analysis
                                    agricultural credit and loan sources
                                    livestock ownership patterns
                                    productive asset investment (farm and non-farm)
                                    agricultural input usage
                                    agricultural production and yield
                                    operational land holdings
                                    average expenditure and receipts
                                    household insurance coverage
                                    reasons for non-insurance
                                    MSP awareness and crop sale satisfaction
                                    agency of procurement (FPO, mandi, cooperatives, dealers)
                                    rural socio-economic indicators,
                                    Statewise Net State Domestic Product (NSDP),
                                    Net State Value Added (NSVA),
                                    per capita state economic indicators,
                                    sanitation and water access,
                                    living standards (pucca housing, transport),
                                    outstanding loan per worker,
                                    GST , GST Return ,
                                    Gross Net Tax Collection,
                                    State wise Tax Collection ,
                                    Settlement of IGST to State,
                                    Composition taxpayers,
                                    Anything on MSMEs (export ratios, Udyam registrations, MSME shares of GDP, etc.),
                                    Countries by share of GDP, Purchasing Power Parity (PPP),
                                    UPI payments and transactions.
                                    youth power,
                                    District level youth empowerment indicators (youth opportunity, education scores, skill development, employment metrics, etc.)
                                    schools data
                                    rainfall data,
                                    fish production data,
                                    watershed management, river basin catchment, coastline, temperature,
                                    faunal diversity,
                                    e-way bills,
                                    water quality, BOD, ph,
                                    insurance and insurers data,
                                    companies data (opened, closed, compliance status, registered etc.)

                                    Annual Survey of Industries (ASI) (which includes information relating to industries such as capital and investment,stock and inventory,financial metrics of industries,employment and labour,compensation and benefits,production and outputs),

                                    Periodic Labour Force Survey (PLFS) (which has information of participation rate, unemployment rate, job related data, population ratio distributed across state, gender,age, religion,social group,education, employment and unemployment statistics),

                                If the query is very short without details about context (for example, "top 5 states"), then let it pass with a YES.

                                Queries should be marked as invalid only if they are clearly not related to the Indian economy.

                                You MUST answer with a single word: YES (query is valid) or NO (query is invalid or out of bounds). Do NOT include any other thinking traces or text apart from YES or NO.
                                """)
    # MODIFIED: Capture token usage from openai_call
    validity, i_tokens, o_tokens = openai_call(system_instruction, user_query)
    validity = validity.strip()

    return validity, i_tokens, o_tokens


def clarify_query(user_query):
    curdate = strftime("%Y-%m", gmtime())
    system_instruction=dedent(f"""You are tasked with rephrasing the given query to make it easier for an SQL RAG agent to pull the right data.

                    **** Rules to extract unitary queries and date range ****
                        1. Extract date range from the query, or augment with a date range if none is present.
                            a. Remember that the current date is {curdate}.
                            b. If no date range is available from the context or from web search, use six months before {curdate} to {curdate}.
                            c. If the date range is LONGER than two years, note this in the date range.
                            d. If the query asks about vague timelines such as "long term" without specifying dates, use the date two years ago from [{curdate}].
                            e. If the query asks for the impact of a specific event on certain quantities, use a date range of at most two years.
                            f. ALWAYS specify date ranges with both start date and end date.
                            g. NEVER change the dates if they are already mentioned in the query.
                            h. Always use month names and full years (e.g. April 2025, January 2022)
                            i. If the query date range is longer than 2 years (e.g. since 2022, in the last few years, in the last decade), use the full date range.
                            j. If the query talks about quarters (e.g. last two quarters), extract the appropriate date range.
                        2. If the query contains acronyms, include full form in parentheses in the unitary queries.
                            Example: Query -> What is RBI's thought process in May 2025?
                                    Unitary queries -> ["RBI (Reserve Bank of India) thought process"]
                        4. Do not attach extraneous information apart from this, or include your own thinking traces. Keep unitary queries as close to the original query as possible.
                        5. IMPORTANT: Analyze the provided query for the existence of multiple entities, comparisons between quantities. Extract each entity-qualifier combination as a separate unitary query. For example, if the query asks about "contribution of Maharashtra to total GDP", extract ["GDP Maharashtra", "GDP India"]. If the query is about "apparel and leather", extract ["apparel", "leather"] as separate unitary queries or combine them appropriately. You MUST limit the number of unitary queries to a MAXIMUM of 6. If the query would result in more than 6 unitary queries, prioritize the most important ones or combine related queries.
                        6. If the word "India" is not mentioned in the query (and the query does not mention "which country" or specify a country), include India in the relevant unitary queries.
                        7. If a statistic such as "top 5", "highest", "lowest", is mentioned in the query, include it in the unitary queries.
                        8. Some hints for extraction:
                            - Queries related to "top states" should be mapped to GDP values, if no context is provided.
                            - Queries related to "top categories" should be mapped to inflation groups and subgroups, if no context is provided.
                            - Queries related to "top sectors" should be mapped to industrial output, if no context is provided.
                        12. VERY VERY IMPORTANT: Do not change the date range in {user_query} if it is already specified.

                    **** Output format ****
                    You must extract unitary queries from the main query. A unitary query is a simple phrase combining an entity (like GDP, IIP, inflation) with its qualifier (like a state, country, or category).
                    
                    Examples:
                    - "GDP of India and IIP of Maharashtra" should become ["GDP India", "IIP Maharashtra"]
                    - "Inflation in food and mining sectors" should become ["Inflation food", "Inflation mining"]
                    - "CPI for top 5 states" should become ["CPI state1", "CPI state2", "CPI state3", "CPI state4", "CPI state5"] (if states are specified) or ["CPI top 5 states"] (if states are not specified)
                    
                    Output as a strict JSON format with the following structure:
                    {{
                        "unitary_queries": ["query1", "query2", ...],
                        "date_range": {{
                            "min": "Month Year" (e.g., "April 2024"),
                            "max": "Month Year" (e.g., "December 2024")
                        }}
                    }}
                    
                    Rules for unitary queries:
                    - Extract each distinct entity-qualifier combination as a separate unitary query
                    - You MUST limit the number of unitary queries to a MAXIMUM of 6. If more than 6 would be needed, prioritize the most important ones but DO NOT combine queries.
                    - Keep queries concise (but retain examples cited in the query, for example if the query is about "apparel and leather", ensure that both "apparel" and "leather" are retained in the unitary query)
                    - If multiple entities are mentioned with the same qualifier, create separate queries for each (up to the maximum of 6)
                    - If multiple qualifiers are mentioned for the same entity, create separate queries for each (up to the maximum of 6)
                    - Preserve important qualifiers like states, categories, sectors, etc.
                    - If "top N" or similar statistics are mentioned, include them in the unitary query
                    - Retain qualifying words like "top 5", "highest", "lowest", "last 3 years", "last 6 months", "all", "various", "different", etc. in the unitary query.
                    - Note that separate unitary queries might be hidden in long sentences and lists. Separate them into different unitary queries.
                    - ALWAYS retain time frequency words like "weekly", "monthly", "quarterly", "annual", "yearly", "daily", etc. in the unitary queries if mentioned in the original query.
                    
                    Make sure keywords such as "states", "groups", "food", "labour", "agriculture", etc. are retained in the unitary queries.
                    DO NOT miss out on any important words from the original query.
                    YOU MUST include specified categories and/or states, date range, in the output!!!!
                    DO NOT include any thinking traces or text apart from the JSON format above.
            """),
    # MODIFIED: Capture token usage from openai_call with JSON response format
    response, i_tokens, o_tokens = openai_call(
        system_instruction, 
        user_query, 
        model="gpt-4.1",
        response_format={"type": "json_object"}
    )
    response = response.strip()
    
    # Parse JSON response and validate with Pydantic model
    try:
        response_json = json.loads(response)
        clarified_response = ClarifiedQueryResponse(**response_json)
        
        # Return the structured response
        return clarified_response, i_tokens, o_tokens
    except json.JSONDecodeError as e:
        logger.warning(f"Could not parse JSON response from clarify_query: {str(e)}")
        logger.warning(f"Response content: {response[:200]}")
        # Fallback: create a basic response with the original query as a single unitary query
        # and a default date range
        from datetime import datetime, timedelta
        try:
            # Parse curdate (format: "YYYY-MM") and create datetime object for the first day of that month
            year, month = map(int, curdate.split("-"))
            curdate_obj = datetime(year, month, 1)
            # Calculate six months ago
            six_months_ago = curdate_obj - timedelta(days=180)
            # Ensure we're at the start of a month
            six_months_ago = six_months_ago.replace(day=1)
        except:
            # If parsing fails, use current date
            curdate_obj = datetime.now()
            six_months_ago = curdate_obj - timedelta(days=180)
            six_months_ago = six_months_ago.replace(day=1)
        
        fallback_response = ClarifiedQueryResponse(
            unitary_queries=[user_query],
            date_range=DateRange(
                min=six_months_ago.strftime("%B %Y"),
                max=curdate_obj.strftime("%B %Y")
            )
        )
        return fallback_response, i_tokens, o_tokens
    except Exception as e:
        logger.warning(f"Error validating clarify_query response: {str(e)}")
        logger.warning(f"Response content: {response[:200]}")
        # Fallback: create a basic response
        from datetime import datetime, timedelta
        try:
            year, month = map(int, curdate.split("-"))
            curdate_obj = datetime(year, month, 1)
            six_months_ago = curdate_obj - timedelta(days=180)
            six_months_ago = six_months_ago.replace(day=1)
        except:
            curdate_obj = datetime.now()
            six_months_ago = curdate_obj - timedelta(days=180)
            six_months_ago = six_months_ago.replace(day=1)
        
        fallback_response = ClarifiedQueryResponse(
            unitary_queries=[user_query],
            date_range=DateRange(
                min=six_months_ago.strftime("%B %Y"),
                max=curdate_obj.strftime("%B %Y")
            )
        )
        return fallback_response, i_tokens, o_tokens

def generate_sql_queries(clarified_response: ClarifiedQueryResponse):
    """
    Generate SQL queries by combining unitary queries with date ranges programmatically.
    No LLM call is needed since the unitary queries are already extracted.
    
    Args:
        clarified_response: ClarifiedQueryResponse object containing unitary queries and date range
        
    Returns:
        tuple: (list of SQL query strings, input_tokens, output_tokens)
        Since no LLM call is made, tokens are always 0.
    """
    # Combine each unitary query with the date range
    sql_queries = []
    date_range_str = f"from {clarified_response.date_range.min} to {clarified_response.date_range.max}"
    
    for unitary_query in clarified_response.unitary_queries:
        # Combine unitary query with date range
        combined_query = f"{unitary_query} {date_range_str}"
        sql_queries.append(combined_query)
    
    # No LLM call is made, so tokens are 0
    return sql_queries, 0, 0
