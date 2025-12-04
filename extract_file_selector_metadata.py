#!/usr/bin/env python3
"""
Script to extract all table names from file selector functions in utils_sql.py,
query metadata for each table using the database, and output a CSV file similar to tables.csv.
"""

import re
import pandas as pd
from sqlalchemy import create_engine, text
from sqlalchemy.pool import QueuePool
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv("prod.env")

# Database connection
DATABASE_URI = "postgresql://postgres:admin@localhost:5432/final"
# DATABASE_URI = os.getenv("DATABASE_URI")

engine = create_engine(
    DATABASE_URI,
    poolclass=QueuePool,
    pool_size=10,
    max_overflow=5,
    pool_recycle=3600,
    pool_timeout=30,
    future=True
)

def extract_table_names_from_file_selectors():
    """
    Extract all table names from file selector functions in utils_sql.py.
    Returns a set of unique table names.
    """
    table_names = set()
    
    # Read utils_sql.py
    with open('utils_sql.py', 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Pattern to find table lists in file selector functions
    # Look for patterns like: [table1, table2, table3, ...]
    # These appear after phrases like "Consider the list above" or "respond ONLY with one of the file names"
    
    # Find all file selector function definitions
    selector_functions = re.findall(
        r'def file_selector_\w+\([^)]*\):.*?(?=def |\Z)',
        content,
        re.DOTALL
    )
    
    for func_content in selector_functions:
        # Look for list patterns that come after "Consider the list" or similar phrases
        # Pattern: find [ ... ] that appears after "Consider" or "respond ONLY"
        list_pattern = r'(?:Consider the list|respond ONLY with one of the file names).*?\[([^\]]+)\]'
        matches = re.findall(list_pattern, func_content, re.DOTALL | re.IGNORECASE)
        
        for match in matches:
            # Split by comma and clean up table names
            tables = [t.strip().strip("'\"") for t in match.split(',')]
            for table in tables:
                # Remove any extra whitespace or quotes
                table = table.strip().strip("'\"")
                # Filter out 'none_of_these' and other non-table entries
                if table and table != 'none_of_these' and len(table) > 2:
                    # Basic validation: table names typically have underscores or are lowercase
                    if '_' in table or table.islower() or any(c.islower() for c in table):
                        table_names.add(table)
    
    # Also look for standalone list patterns that might be table lists
    # This is a fallback for any lists we might have missed
    standalone_lists = re.findall(r'\[([a-z_][a-z0-9_]+(?:,\s*[a-z_][a-z0-9_]+)+)\]', content, re.IGNORECASE)
    for match in standalone_lists:
        tables = [t.strip().strip("'\"") for t in match.split(',')]
        for table in tables:
            table = table.strip().strip("'\"")
            if table and table != 'none_of_these' and '_' in table:
                table_names.add(table)
    
    return sorted(table_names)

def get_table_metadata(table_name):
    """
    Query database for metadata about a table.
    Returns a dict with metadata fields.
    """
    try:
        # Query metadata using the get_metadata_for function
        metadata_query = f"SELECT source, source_url, business_metadata FROM get_metadata_for('{table_name}');"
        
        with engine.connect() as connection:
            result = connection.execute(text(metadata_query))
            row = result.fetchone()
            
            if row:
                source, source_url, business_metadata = row
                return {
                    'source': source or '',
                    'source_url': source_url or '',
                    'business_metadata': str(business_metadata) if business_metadata else ''
                }
            else:
                return {
                    'source': '',
                    'source_url': '',
                    'business_metadata': ''
                }
    except Exception as e:
        print(f"Error getting metadata for {table_name}: {e}")
        return {
            'source': '',
            'source_url': '',
            'business_metadata': ''
        }

def table_exists(table_name):
    """
    Check if a table exists in the database.
    """
    try:
        check_query = f"""
        SELECT EXISTS (
            SELECT FROM information_schema.tables 
            WHERE table_name = '{table_name}'
        );
        """
        with engine.connect() as connection:
            result = connection.execute(text(check_query))
            return result.fetchone()[0]
    except:
        return False

def get_table_columns(table_name):
    """
    Get column names for a table.
    """
    if not table_exists(table_name):
        return ''
    
    try:
        # Query to get column information
        columns_query = f"""
        SELECT column_name 
        FROM information_schema.columns 
        WHERE table_name = '{table_name}' 
        ORDER BY ordinal_position;
        """
        
        with engine.connect() as connection:
            result = connection.execute(text(columns_query))
            columns = [row[0] for row in result.fetchall()]
            return ', '.join(columns) if columns else ''
    except Exception as e:
        print(f"Error getting columns for {table_name}: {e}")
        return ''

def get_table_row_count(table_name):
    """
    Get row count for a table.
    """
    if not table_exists(table_name):
        return 0
    
    try:
        count_query = f"SELECT COUNT(*) FROM {table_name};"
        with engine.connect() as connection:
            result = connection.execute(text(count_query))
            return result.fetchone()[0]
    except Exception as e:
        print(f"Error getting row count for {table_name}: {e}")
        return 0

def get_table_dates(table_name):
    """
    Get released_on and updated_on dates if available in metadata or table.
    """
    if not table_exists(table_name):
        return None, None
    
    # Try to get from table if it has these columns
    try:
        # Check if table has released_on and updated_on columns
        check_query = f"""
        SELECT column_name 
        FROM information_schema.columns 
        WHERE table_name = '{table_name}' 
        AND column_name IN ('released_on', 'updated_on');
        """
        with engine.connect() as connection:
            result = connection.execute(text(check_query))
            available_cols = [row[0] for row in result.fetchall()]
            
            if 'released_on' in available_cols or 'updated_on' in available_cols:
                # Get the latest dates from the table
                date_query = f"""
                SELECT 
                    MAX(released_on) as released_on,
                    MAX(updated_on) as updated_on
                FROM {table_name};
                """
                result = connection.execute(text(date_query))
                row = result.fetchone()
                if row:
                    return row[0], row[1]
    except Exception as e:
        # Table might not exist or columns might not be available
        pass
    
    return None, None

def determine_data_domain(table_name):
    """
    Determine data domain based on table name patterns.
    """
    table_lower = table_name.lower()
    
    # CPI and inflation related
    if 'cpi' in table_lower or 'inflation' in table_lower or 'wpi' in table_lower or 'wholesale_price' in table_lower or 'housing_price' in table_lower:
        return 'CPI'
    
    # GDP and national accounts
    elif ('gdp' in table_lower or 'nsdp' in table_lower or 'gsdp' in table_lower or 'gsva' in table_lower or 
          'nsva' in table_lower or 'national_income' in table_lower or 'key_aggregates' in table_lower or
          'per_capita_income' in table_lower or 'niryat' in table_lower or 'imf_dm' in table_lower):
        return 'GDP'
    
    # State Economic Survey (check before IIP since construct_state_cement is more specific)
    elif 'construct_state_cement' in table_lower:
        return 'State Economic Survey'
    
    # IIP and industrial production
    elif ('iip' in table_lower or 'chemical_production' in table_lower):
        return 'IIP'
    
    # MSME
    elif 'msme' in table_lower or 'udyam' in table_lower or 'nifty_sme' in table_lower:
        return 'MSME'
    
    # GST
    elif 'gst' in table_lower or 'gstr' in table_lower or 'ewb' in table_lower or 'gross_and_net_tax' in table_lower:
        return 'GST'
    
    # Agriculture and rural
    elif ('sa_' in table_lower or 'agriculture' in table_lower or 'crop' in table_lower or 
          'fish_production' in table_lower or 'production_of_major_crops' in table_lower):
        return 'agriculture_and_rural'
    
    # E-Governance (check before social_migration since aadhaar is more specific)
    elif 'aadhaar_' in table_lower:
        return 'E-Governance'
    
    # Social migration and households
    elif ('mis_' in table_lower or 'migration' in table_lower or 'household' in table_lower or 
          'hces_' in table_lower):
        return 'social_migration_and_households'
    
    # Enterprise and establishment surveys
    elif ('asuse' in table_lower or 'annual_survey_of_industries' in table_lower or 'enterprise' in table_lower):
        return 'enterprise_establishment_surveys'
    
    # Labour and worker surveys
    elif ('labour' in table_lower or 'worker' in table_lower or 'plfs' in table_lower or 'epfo' in table_lower or
          'lpfr' in table_lower or 'wpr' in table_lower or 'ur_state' in table_lower or 
          'cws_industry' in table_lower or 'wages_' in table_lower):
        return 'enterprise_establishment_surveys'
    
    # Finance and Industry
    elif ('finance' in table_lower or 'fdi' in table_lower or 'insurance' in table_lower or 'trade_' in table_lower or
          'fpi_' in table_lower or 'mf_' in table_lower or 'mutual_fund' in table_lower or
          'stock_' in table_lower or 'marketcap' in table_lower or 'eshram' in table_lower or
          'revenue_maharashtra' in table_lower or 'ki_assam' in table_lower or 'company_india' in table_lower or
          'mca_nat' in table_lower or 'ins_nat' in table_lower or 'irdai' in table_lower or
          'port_dwell' in table_lower or 'vehicle_registrations' in table_lower or 'ev_state' in table_lower):
        return 'Finance_and_Industry'
    
    # Energy, Power and Renewable Resources
    elif ('energy_' in table_lower or 'crude_oil' in table_lower or 'petroleum' in table_lower or
          'ppac_' in table_lower or 'cumulative_capacity' in table_lower or 'renewable' in table_lower or
          'co2_emissions' in table_lower or 'ores_minerals' in table_lower):
        return 'Energy, Power and Renewable Resources'
    
    # Demography
    elif 'demography_' in table_lower:
        return 'Demography'
    
    # Rainfall and Environment
    elif ('rainfall' in table_lower or 'watersheds' in table_lower or 'river_basin' in table_lower or
          'coastline' in table_lower or 'faunal_diversity' in table_lower or 'annual_mean_temperature' in table_lower or
          'env_state' in table_lower):
        return 'Rainfall'
    
    # Healthcare
    elif 'cghs_' in table_lower or 'sp_india_daily' in table_lower:
        return 'Healthcare, Wellness and Family Welfare'
    
    # Transportation, Logistics and Mobility
    elif ('airport_sewa' in table_lower or 'traffic_india' in table_lower or 'tlm_state' in table_lower or
          'toll_state' in table_lower or 'netc_india' in table_lower):
        return 'Transportation, Logistics and Mobility'
    
    # Digital payments
    elif 'upi_' in table_lower or 'rbi_india_mth_payment' in table_lower or 'rbi_india_mth_bank' in table_lower:
        return 'Digital payments'
    
    # District level
    elif 'youth' in table_lower or ('district' in table_lower and 'rainfall' not in table_lower):
        return 'district_level'
    
    # Industry Survey
    elif 'asi_' in table_lower and 'annual_survey_of_industries' not in table_lower:
        return 'Industry Survey'
    
    # Macro-economic aggregates
    elif ('other_macro_economic' in table_lower or 'top_fifty_macro' in table_lower):
        return 'Macro-economic aggregates'
    
    # Ministry of Corporate Affairs
    elif 'mca_' in table_lower:
        return 'Ministry of Corporate Affairs'
    
    # Commerce, Finance, Banking and Insurance
    elif ('port_dwell' in table_lower or ('insurance' in table_lower and 'irdai' not in table_lower)):
        return 'Commerce, Finance, Banking and Insurance'
    
    else:
        return 'Other'

def main():
    """
    Main function to extract table names, query metadata, and output CSV.
    """
    print("Extracting table names from file selector functions...")
    
    # Extract table names
    table_names = extract_table_names_from_file_selectors()
    print(f"Found {len(table_names)} unique table names")
    
    # Prepare data for CSV
    results = []
    
    for i, table_name in enumerate(table_names, 1):
        print(f"Processing {i}/{len(table_names)}: {table_name}")
        
        # Get metadata
        metadata = get_table_metadata(table_name)
        
        # Get columns
        columns = get_table_columns(table_name)
        
        # Get row count
        row_count = get_table_row_count(table_name)
        
        # Get dates
        released_on, updated_on = get_table_dates(table_name)
        
        # Determine data domain
        data_domain = determine_data_domain(table_name)
        
        # Build result row
        result_row = {
            'data_domain': data_domain,
            'table_name': table_name,
            'columns': columns,
            'comments': '',  # Would need to extract from file selector descriptions
            'source': metadata['source'],
            'source_url': metadata['source_url'],
            'released_on': released_on if released_on else '',
            'updated_on': updated_on if updated_on else '',
            'rows_count': row_count,
            'business_metadata': metadata['business_metadata']
        }
        
        results.append(result_row)
    
    # Create DataFrame and save to CSV
    df = pd.DataFrame(results)
    output_file = 'file_selector_tables_metadata.csv'
    df.to_csv(output_file, index=False)
    
    print(f"\nSuccessfully created {output_file} with {len(results)} rows")
    print(f"Columns: {', '.join(df.columns)}")
    
    # Print summary
    print("\nSummary by data domain:")
    print(df['data_domain'].value_counts())

if __name__ == "__main__":
    main()

