"""
match_files.py

Runs through every table with non-zero rows, sampling rows and generating 
metadata in 150 words for each table.
"""

import time
from sqlalchemy import create_engine, text
from sqlalchemy.pool import QueuePool
from dotenv import load_dotenv
import os
import pandas as pd
from utils_common import openai_call

# Load environment variables
load_dotenv("prod.env")

# Database connection (same as handler_sql.py)
DATABASE_URI = "postgresql://postgres:admin@localhost:5432/final"
# DATABASE_URI = "postgresql://postgres:admin@136.112.177.68:5432/final"
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


def get_all_tables():
    """
    Get all table names from tables.csv.
    
    Returns:
        List of table names
    """
    try:
        csv_file = "tables.csv"
        if not os.path.exists(csv_file):
            print(f"Error: {csv_file} not found")
            return []
        
        df = pd.read_csv(csv_file)
        if 'table_name' not in df.columns:
            print(f"Error: {csv_file} does not contain 'table_name' column")
            return []
        
        tables = df['table_name'].tolist()
        return tables
    except Exception as e:
        print(f"Error reading tables from {csv_file}: {e}")
        return []


def get_table_row_count(table_name):
    """
    Get row count for a table.
    
    Args:
        table_name: Name of the table
        
    Returns:
        Row count (0 if error or table doesn't exist)
    """
    try:
        count_query = f"SELECT COUNT(*) FROM {table_name};"
        with engine.connect() as connection:
            result = connection.execute(text(count_query))
            return result.fetchone()[0]
    except Exception as e:
        print(f"Warning: Error getting row count for {table_name}: {e}")
        return 0


def get_table_schema(table_name):
    """
    Get schema information for a table.
    
    Args:
        table_name: Name of the table
        
    Returns:
        List of tuples (column_name, data_type)
    """
    try:
        schema_query = f"""
        SELECT column_name, data_type
        FROM information_schema.columns
        WHERE table_name = '{table_name}'
        ORDER BY ordinal_position;
        """
        with engine.connect() as connection:
            result = connection.execute(text(schema_query))
            return result.fetchall()
    except Exception as e:
        print(f"Warning: Error getting schema for {table_name}: {e}")
        return []


def sample_table_rows(table_name, sample_size=10):
    """
    Sample random rows from a table.
    
    Args:
        table_name: Name of the table
        sample_size: Number of rows to sample (default: 10)
        
    Returns:
        List of sampled rows as dictionaries
    """
    try:
        sample_query = f"SELECT * FROM {table_name} ORDER BY RANDOM() LIMIT :n"
        with engine.connect() as connection:
            result = connection.execute(text(sample_query), {"n": sample_size})
            rows = result.fetchall()
            # Convert to list of dictionaries
            columns = result.keys()
            return [dict(zip(columns, row)) for row in rows]
    except Exception as e:
        print(f"Warning: Error sampling rows from {table_name}: {e}")
        return []


def detect_time_granularity(schema, sample_rows):
    """
    Detect time granularity from schema and sample data.
    
    Args:
        schema: List of (column_name, data_type) tuples
        sample_rows: List of sampled row dictionaries
        
    Returns:
        String describing time granularity (e.g., "monthly", "quarterly", "yearly", "daily", "none")
    """
    time_columns = []
    for col_name, _ in schema:
        col_lower = col_name.lower()
        if any(keyword in col_lower for keyword in ['year', 'month', 'quarter', 'date', 'fiscal', 'period']):
            time_columns.append(col_name)
    
    if not time_columns:
        return "none"
    
    # Check sample data to determine granularity
    if sample_rows:
        first_row = sample_rows[0]
        for col in time_columns:
            if col in first_row:
                value = str(first_row[col])
                col_lower = col.lower()
                if 'month' in col_lower or 'month_numeric' in col_lower:
                    return "monthly"
                elif 'quarter' in col_lower:
                    return "quarterly"
                elif 'year' in col_lower or 'fiscal_year' in col_lower:
                    # Check if month column exists
                    has_month = any('month' in c.lower() for c, _ in schema)
                    if has_month:
                        return "monthly"
                    else:
                        return "yearly"
                elif 'date' in col_lower:
                    return "daily"
    
    # Default based on column names
    if any('month' in c.lower() for c, _ in schema):
        return "monthly"
    elif any('quarter' in c.lower() for c, _ in schema):
        return "quarterly"
    elif any('year' in c.lower() for c, _ in schema):
        return "yearly"
    
    return "unknown"


def detect_geographical_granularity(schema, sample_rows):
    """
    Detect geographical granularity from schema and sample data.
    
    Args:
        schema: List of (column_name, data_type) tuples
        sample_rows: List of sampled row dictionaries
        
    Returns:
        String describing geographical granularity (e.g., "city", "district", "state", "national", "none")
    """
    geo_columns = []
    for col_name, _ in schema:
        col_lower = col_name.lower()
        if any(keyword in col_lower for keyword in ['state', 'city', 'district', 'country', 'region', 'location']):
            geo_columns.append(col_name)
    
    if not geo_columns:
        return "national"
    
    # Determine granularity based on column names
    col_names_lower = [c.lower() for c, _ in schema]
    if any('city' in c for c in col_names_lower):
        return "city"
    elif any('district' in c for c in col_names_lower):
        return "district"
    elif any('state' in c for c in col_names_lower):
        return "state"
    elif any('country' in c for c in col_names_lower):
        return "country"
    
    return "state"  # Default assumption for Indian economic data


def extract_data_diversity(schema, sample_rows):
    """
    Extract examples of data diversity from sample rows.
    
    Args:
        schema: List of (column_name, data_type) tuples
        sample_rows: List of sampled row dictionaries
        
    Returns:
        Dictionary with column names and example values showing diversity
    """
    diversity = {}
    
    if not sample_rows:
        return diversity
    
    # Focus on categorical/text columns (not numeric IDs)
    categorical_cols = []
    for col_name, data_type in schema:
        col_lower = col_name.lower()
        # Skip ID columns and numeric-only columns
        if 'id' not in col_lower and data_type in ['character varying', 'varchar', 'text', 'character']:
            categorical_cols.append(col_name)
    
    # Extract unique values from sample rows for categorical columns
    for col in categorical_cols[:5]:  # Limit to first 5 categorical columns
        unique_values = set()
        for row in sample_rows:
            if col in row and row[col] is not None:
                value = str(row[col]).strip()
                if value and len(value) < 100:  # Skip very long values
                    unique_values.add(value)
                    if len(unique_values) >= 5:  # Get up to 5 examples
                        break
        if unique_values:
            diversity[col] = list(unique_values)[:5]
    
    return diversity


def generate_table_metadata(table_name, schema, sample_rows):
    """
    Generate 400-word metadata description for a table using OpenAI.
    
    Args:
        table_name: Name of the table
        schema: List of (column_name, data_type) tuples
        sample_rows: List of sampled row dictionaries (not used, will pull 50 rows directly)
        
    Returns:
        Metadata string (approximately 400 words)
    """
    try:
        # Pull 50 random rows directly from the table
        print(f"Pulling 50 random rows from {table_name}...")
        samples = []
        try:
            with engine.connect() as connection:
                sample_result = connection.execute(
                    text(f"SELECT * FROM {table_name} ORDER BY RANDOM() LIMIT :n"),
                    {"n": 50}
                )
                for row in sample_result:
                    samples.append(str(row))
                print(f"Retrieved {len(samples)} sample rows from {table_name}")
        except Exception as e:
            print(f"Warning: Error sampling rows from {table_name}: {e}")
            # Fallback to provided sample_rows if available
            if sample_rows:
                samples = [str(row) for row in sample_rows[:50]]
            else:
                samples = []
        
        if not samples:
            print(f"Warning: No sample rows available for {table_name}")
            return f"Error: No sample data available for {table_name}"
        
        # Format schema information, excluding metadata columns
        metadata_columns = ['data_updated_date', 'data_release_date', 'release_date', 'updated_date', 
                           'updated_on', 'released_on', 'source', 'source_url', 'data_source']
        schema_str = "\n".join([f"- {col[0]} ({col[1]})" for col in schema 
                               if col[0].lower() not in [mc.lower() for mc in metadata_columns]])
        
        # Format sample rows as a single string
        sample_str = "\n".join(samples)
        
        # Detect time and geographical granularity (using schema only, not sample_rows)
        time_granularity = detect_time_granularity(schema, [])
        geo_granularity = detect_geographical_granularity(schema, [])
        
        # Create prompt for OpenAI
        system_prompt = """You are a data analyst. Generate a comprehensive, informative metadata description 
for a database table based on its schema and sample data. The description should be approximately 400 words and must include:
1. What the table contains and its purpose
2. Detailed description of items, categories, subcategories, commodities, sectors, industries, or other entities present in the data
3. Time granularity (monthly, quarterly, yearly, daily, or none)
4. Geographical granularity (city, district, state, national, or country level)
5. Two sample queries that this table can answer

IMPORTANT INSTRUCTIONS:
- IGNORE metadata columns such as data_updated_date, data_release_date, release_date, updated_date, updated_on, released_on, source, source_url, data_source
- FOCUS on describing the actual data entities: items, categories, subcategories, commodities, sectors, industries, regions, states, etc.
- Include as many specific entity examples as possible within the 400-word limit
- Show the variety and diversity of entities in the data
- Be specific about what types of items/categories/commodities are present

Include any synonyms for the data included.

Be specific, informative, and use the provided information. Return approximately 400 words."""
        
        user_prompt = f"""Table name: {table_name}

Schema (columns and data types - metadata columns excluded):
{schema_str}

Sample data (50 random rows):
{sample_str}

Detected time granularity: {time_granularity}
Detected geographical granularity: {geo_granularity}

Generate a 400-word metadata description for this table. The description must include:
1. What data the table contains and its purpose
2. Detailed description of items, categories, subcategories, commodities, sectors, industries, or other entities present - include as many specific examples as possible
3. Time granularity: {time_granularity}
4. Geographical granularity: {geo_granularity}
5. Two sample queries that this table can answer

IMPORTANT: Ignore metadata columns (data_updated_date, release_date, etc.) and focus on describing the actual data entities. Include as many entity examples as possible within the 400-word limit.

Be specific and informative. Return approximately 400 words."""
        
        metadata, i_tokens, o_tokens = openai_call(system_prompt, user_prompt, model="gpt-4.1")
        
        # Clean up the response (remove any markdown formatting, extra whitespace)
        metadata = metadata.strip()
        # Remove markdown code blocks if present
        if metadata.startswith("```"):
            metadata = metadata.split("```")[1]
            if metadata.startswith("text") or metadata.startswith("markdown"):
                metadata = metadata.split("\n", 1)[1] if "\n" in metadata else metadata
        metadata = metadata.strip()
        
        print(f"Generated metadata for {table_name}: {len(metadata.split())} words")
        return metadata
        
    except Exception as e:
        print(f"Error generating metadata for {table_name}: {e}")
        return f"Error generating metadata: {str(e)}"


def main():
    """
    Main function to process all tables with non-zero rows.
    Loads existing CSV and only processes tables not already in it.
    """
    output_file = 'table_metadata_results.csv'
    
    # Load existing CSV if it exists
    existing_tables = set()
    existing_df = None
    if os.path.exists(output_file):
        try:
            existing_df = pd.read_csv(output_file)
            if 'table_name' in existing_df.columns:
                existing_tables = set(existing_df['table_name'].tolist())
                print(f"Loaded existing CSV with {len(existing_tables)} tables")
            else:
                print(f"Warning: Existing CSV does not have 'table_name' column, starting fresh")
        except Exception as e:
            print(f"Warning: Could not load existing CSV: {e}, starting fresh")
    else:
        print("No existing CSV found, starting fresh")
    
    print("Starting table metadata generation process...")
    
    # Get all tables
    all_tables = get_all_tables()
    print(f"Found {len(all_tables)} tables in database")
    
    # Filter tables with non-zero rows
    tables_with_data = []
    for table_name in all_tables:
        row_count = get_table_row_count(table_name)
        if row_count > 0:
            tables_with_data.append((table_name, row_count))
            print(f"Table {table_name}: {row_count} rows")
        else:
            print(f"Skipping {table_name}: 0 rows")
    
    # Filter out tables that already exist in CSV
    tables_to_process = [(t, c) for t, c in tables_with_data if t not in existing_tables]
    
    if existing_tables:
        print(f"\nSkipping {len(existing_tables)} tables already in CSV")
    print(f"Processing {len(tables_to_process)} new tables with non-zero rows...")
    
    if len(tables_to_process) == 0:
        print("No new tables to process. All tables already have metadata.")
        return
    
    # Process each table
    results = []
    for i, (table_name, row_count) in enumerate(tables_to_process, 1):
        print(f"\n[{i}/{len(tables_to_process)}] Processing table: {table_name} ({row_count} rows)")
        
        try:
            # Get schema
            schema = get_table_schema(table_name)
            if not schema:
                print(f"Warning: No schema found for {table_name}, skipping")
                continue
            
            # Sample rows (sample more rows for larger tables, but cap at 20)
            sample_size = min(20, max(5, row_count // 100))
            sample_rows = sample_table_rows(table_name, sample_size)
            
            if not sample_rows:
                print(f"Warning: No sample rows retrieved for {table_name}, skipping")
                continue
            
            # Generate metadata
            metadata = generate_table_metadata(table_name, schema, sample_rows)
            
            # Rate limiting: wait 2 seconds before next API request
            time.sleep(2)
            
            # Store result
            results.append({
                'table_name': table_name,
                'row_count': row_count,
                'column_count': len(schema),
                'metadata': metadata,
                'word_count': len(metadata.split())
            })
            
            print(f"✓ Generated metadata for {table_name}: {len(metadata.split())} words")
            
        except Exception as e:
            print(f"Error processing {table_name}: {e}")
            results.append({
                'table_name': table_name,
                'row_count': row_count,
                'column_count': 0,
                'metadata': f"Error: {str(e)}",
                'word_count': 0
            })
        
        # Debug: break after 5 tables
        #if i >= 5:
        #    print(f"\n[DEBUG] Stopping after {i} tables for review")
        #    break
    
    # Append new results to existing CSV or create new one
    if results:
        new_df = pd.DataFrame(results)
        
        if existing_df is not None and len(existing_df) > 0:
            # Append to existing CSV
            combined_df = pd.concat([existing_df, new_df], ignore_index=True)
            combined_df.to_csv(output_file, index=False)
            print(f"\n✓ Appended {len(results)} new tables to {output_file}")
            print(f"Total tables in CSV: {len(combined_df)}")
        else:
            # Create new CSV
            new_df.to_csv(output_file, index=False)
            print(f"\n✓ Saved {len(results)} results to {output_file}")
        
        print(f"Total new tables processed: {len(results)}")
        print(f"Average metadata word count: {new_df['word_count'].mean():.1f} words")
    else:
        print("No new results to save")
    
    print("\nTable metadata generation process completed!")


if __name__ == "__main__":
    main()

