#!/usr/bin/env python3
"""
Script to compare tables.csv and file_selector_tables_metadata.csv,
identify which entries from tables.csv are missing in file_selector_tables_metadata.csv,
and create tables_common.csv containing only rows from tables.csv that are also present in file_selector_tables_metadata.csv
"""

import pandas as pd
import sys

def compare_tables():
    """
    Compare tables.csv and file_selector_tables_metadata.csv to find missing entries,
    and create tables_common.csv with only the common rows from tables.csv.
    """
    print("Loading tables.csv...")
    try:
        tables_df = pd.read_csv('tables.csv')
        print(f"Loaded {len(tables_df)} rows from tables.csv")
    except FileNotFoundError:
        print("Error: tables.csv not found")
        sys.exit(1)
    except Exception as e:
        print(f"Error reading tables.csv: {e}")
        sys.exit(1)
    
    print("Loading file_selector_tables_metadata.csv...")
    try:
        metadata_df = pd.read_csv('file_selector_tables_metadata.csv')
        print(f"Loaded {len(metadata_df)} rows from file_selector_tables_metadata.csv")
    except FileNotFoundError:
        print("Error: file_selector_tables_metadata.csv not found")
        sys.exit(1)
    except Exception as e:
        print(f"Error reading file_selector_tables_metadata.csv: {e}")
        sys.exit(1)
    
    # Get table names from both dataframes (case-insensitive comparison)
    tables_names = set(tables_df['table_name'].str.strip().str.lower())
    metadata_names = set(metadata_df['table_name'].str.strip().str.lower())
    
    print(f"\nUnique table names in tables.csv: {len(tables_names)}")
    print(f"Unique table names in file_selector_tables_metadata.csv: {len(metadata_names)}")
    
    # Find tables in tables.csv that are NOT in file_selector_tables_metadata.csv
    missing_in_metadata = tables_names - metadata_names
    
    # Find tables in file_selector_tables_metadata.csv that are NOT in tables.csv
    missing_in_tables = metadata_names - tables_names
    
    # Find common tables
    common_tables = tables_names & metadata_names
    
    print(f"\nCommon table names: {len(common_tables)}")
    print(f"Tables in tables.csv but NOT in file_selector_tables_metadata.csv: {len(missing_in_metadata)}")
    print(f"Tables in file_selector_tables_metadata.csv but NOT in tables.csv: {len(missing_in_tables)}")
    
    # Filter tables.csv to retain only rows present in file_selector_tables_metadata.csv
    print("\nFiltering tables.csv to retain only common tables...")
    common_rows = []
    for idx, row in tables_df.iterrows():
        table_name_lower = str(row['table_name']).strip().lower()
        if table_name_lower in common_tables:
            common_rows.append(row)
    
    common_df = pd.DataFrame(common_rows)
    print(f"Filtered to {len(common_df)} rows (from {len(tables_df)} original rows)")
    
    # Write common rows to tables_common.csv
    output_file = 'tables_common.csv'
    common_df.to_csv(output_file, index=False)
    print(f"✓ Common tables saved to {output_file}")
    
    # Report missing tables with their original case
    if missing_in_metadata:
        print("\n" + "="*80)
        print("TABLES IN tables.csv BUT MISSING IN file_selector_tables_metadata.csv:")
        print("="*80)
        
        # Get original case table names and full row data
        missing_rows = []
        for idx, row in tables_df.iterrows():
            table_name_lower = str(row['table_name']).strip().lower()
            if table_name_lower in missing_in_metadata:
                missing_rows.append(row)
        
        missing_df = pd.DataFrame(missing_rows)
        
        # Display summary information
        print(f"\nTotal missing: {len(missing_df)}")
        print("\nMissing tables by data domain:")
        print(missing_df['data_domain'].value_counts())
        
        print("\nDetailed list of missing tables:")
        print("-" * 80)
        for idx, row in missing_df.iterrows():
            print(f"\n{idx + 1}. Table: {row['table_name']}")
            print(f"   Domain: {row['data_domain']}")
            print(f"   Source: {row.get('source', 'N/A')}")
            print(f"   Rows: {row.get('rows_count', 'N/A')}")
            if pd.notna(row.get('business_metadata')):
                metadata_preview = str(row['business_metadata'])[:100]
                print(f"   Description: {metadata_preview}...")
        
        # Save missing tables to a CSV file
        output_file = 'missing_tables_in_metadata.csv'
        missing_df.to_csv(output_file, index=False)
        print(f"\n✓ Missing tables saved to {output_file}")
    else:
        print("\n✓ All tables from tables.csv are present in file_selector_tables_metadata.csv!")
    
    # Report extra tables in metadata (optional)
    if missing_in_tables:
        print("\n" + "="*80)
        print("TABLES IN file_selector_tables_metadata.csv BUT NOT IN tables.csv:")
        print("="*80)
        print(f"Total extra tables: {len(missing_in_tables)}")
        print("\nThese tables are in file_selector_tables_metadata.csv but not in tables.csv:")
        print("(This is expected - file_selector_tables_metadata.csv contains tables from file selectors)")
        
        # Get original case table names
        extra_rows = []
        for idx, row in metadata_df.iterrows():
            table_name_lower = str(row['table_name']).strip().lower()
            if table_name_lower in missing_in_tables:
                extra_rows.append(row)
        
        extra_df = pd.DataFrame(extra_rows)
        print(f"\nExtra tables by data domain:")
        print(extra_df['data_domain'].value_counts())

        print("\nDetailed list of extra tables:")
        print("-" * 80)
        for idx, row in extra_df.iterrows():
            print(f"\n{idx + 1}. Table: {row['table_name']}")
            print(f"   Domain: {row['data_domain']}")
            print(f"   Source: {row.get('source', 'N/A')}")
            print(f"   Rows: {row.get('rows_count', 'N/A')}")
            if pd.notna(row.get('business_metadata')):
                metadata_preview = str(row['business_metadata'])[:100]
                print(f"   Description: {metadata_preview}...")
    
    # Summary
    print("\n" + "="*80)
    print("SUMMARY")
    print("="*80)
    print(f"Tables in tables.csv: {len(tables_names)}")
    print(f"Tables in file_selector_tables_metadata.csv: {len(metadata_names)}")
    print(f"Common tables: {len(common_tables)}")
    print(f"Missing in metadata: {len(missing_in_metadata)}")
    print(f"Extra in metadata: {len(missing_in_tables)}")
    print(f"\n✓ Common tables written to: tables_common.csv ({len(common_df)} rows)")
    
    if missing_in_metadata:
        print(f"\n⚠ WARNING: {len(missing_in_metadata)} table(s) from tables.csv are missing in file_selector_tables_metadata.csv")
        return 1
    else:
        print("\n✓ SUCCESS: All tables from tables.csv are present in file_selector_tables_metadata.csv")
        return 0

if __name__ == "__main__":
    exit_code = compare_tables()
    sys.exit(exit_code)

