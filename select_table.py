"""
select_table.py

Compares a given query with metadata information for each table and finds 
the 3 closest matching tables using semantic similarity.
"""

import os
import pickle
import pandas as pd
import numpy as np
from dotenv import load_dotenv
from openai import OpenAI
from typing import List, Dict, Tuple, Optional

# Load environment variables
load_dotenv("prod.env")

# Initialize OpenAI client
openai_client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))


def get_embedding(text: str, model: str = "text-embedding-3-small") -> List[float]:
    """
    Get embedding vector for a text using OpenAI embeddings.
    
    Args:
        text: Text to embed
        model: Embedding model to use
        
    Returns:
        List of floats representing the embedding vector
    """
    try:
        response = openai_client.embeddings.create(
            model=model,
            input=text
        )
        return response.data[0].embedding
    except Exception as e:
        print(f"Error getting embedding: {e}")
        return None


def cosine_similarity(vec1: List[float], vec2: List[float]) -> float:
    """
    Calculate cosine similarity between two vectors.
    
    Args:
        vec1: First vector
        vec2: Second vector
        
    Returns:
        Cosine similarity score (0 to 1)
    """
    vec1 = np.array(vec1)
    vec2 = np.array(vec2)
    
    dot_product = np.dot(vec1, vec2)
    norm1 = np.linalg.norm(vec1)
    norm2 = np.linalg.norm(vec2)
    
    if norm1 == 0 or norm2 == 0:
        return 0.0
    
    return dot_product / (norm1 * norm2)


def load_table_metadata(csv_file: str = "table_metadata_results.csv") -> pd.DataFrame:
    """
    Load table metadata from CSV file.
    
    Args:
        csv_file: Path to the CSV file containing table metadata
        
    Returns:
        DataFrame with table metadata, or None if file doesn't exist
    """
    if not os.path.exists(csv_file):
        print(f"Error: CSV file '{csv_file}' not found")
        return None
    
    try:
        df = pd.read_csv(csv_file)
        if 'table_name' not in df.columns or 'metadata' not in df.columns:
            print(f"Error: CSV file must contain 'table_name' and 'metadata' columns")
            return None
        return df
    except Exception as e:
        print(f"Error loading CSV file: {e}")
        return None


def generate_table_embeddings(csv_file: str = "table_metadata_results.csv", 
                               embeddings_file: str = "table_embeddings.pkl",
                               force_regenerate: bool = False) -> Dict[str, List[float]]:
    """
    Generate embeddings for all tables and save them to a pickle file.
    
    Args:
        csv_file: Path to CSV file with table metadata
        embeddings_file: Path to pickle file to store embeddings
        force_regenerate: If True, regenerate embeddings even if file exists
        
    Returns:
        Dictionary mapping table_name -> embedding vector
    """
    # Check if embeddings file exists
    if not force_regenerate and os.path.exists(embeddings_file):
        #print(f"Loading pre-computed embeddings from {embeddings_file}...")
        try:
            with open(embeddings_file, 'rb') as f:
                embeddings = pickle.load(f)
            #print(f"Loaded embeddings for {len(embeddings)} tables")
            return embeddings
        except Exception as e:
            print(f"Error loading embeddings file: {e}, regenerating...")
    
    # Load table metadata
    df = load_table_metadata(csv_file)
    if df is None:
        return {}
    
    print(f"Generating embeddings for {len(df)} tables...")
    print("This may take a few minutes...")
    
    embeddings = {}
    for idx, row in df.iterrows():
        table_name = row['table_name']
        metadata = str(row['metadata'])
        
        # Create a combined text for matching (table name + metadata)
        table_text = f"{table_name}. {metadata}"
        
        # Get embedding for table
        print(f"  Generating embedding {idx + 1}/{len(df)}: {table_name}")
        table_embedding = get_embedding(table_text)
        
        if table_embedding is not None:
            embeddings[table_name] = table_embedding
        else:
            print(f"    Warning: Failed to generate embedding for {table_name}")
    
    # Save embeddings to pickle file
    print(f"\nSaving embeddings to {embeddings_file}...")
    try:
        with open(embeddings_file, 'wb') as f:
            pickle.dump(embeddings, f)
        print(f"Saved embeddings for {len(embeddings)} tables")
    except Exception as e:
        print(f"Error saving embeddings: {e}")
    
    return embeddings


def load_table_embeddings(embeddings_file: str = "table_embeddings.pkl") -> Optional[Dict[str, List[float]]]:
    """
    Load pre-computed table embeddings from pickle file.
    
    Args:
        embeddings_file: Path to pickle file containing embeddings
        
    Returns:
        Dictionary mapping table_name -> embedding vector, or None if file doesn't exist
    """
    if not os.path.exists(embeddings_file):
        return None
    
    try:
        with open(embeddings_file, 'rb') as f:
            embeddings = pickle.load(f)
        return embeddings
    except Exception as e:
        print(f"Error loading embeddings file: {e}")
        return None


def find_matching_tables(query: str, 
                         csv_file: str = "table_metadata_results.csv",
                         embeddings_file: str = "table_embeddings.pkl",
                         top_k: int = 3,
                         force_regenerate_embeddings: bool = False) -> List[Dict]:
    """
    Find the top K tables that best match the given query.
    
    Args:
        query: User query to match against tables
        csv_file: Path to CSV file with table metadata
        embeddings_file: Path to pickle file with pre-computed embeddings
        top_k: Number of top matches to return (default: 3)
        force_regenerate_embeddings: If True, regenerate embeddings even if file exists
        
    Returns:
        List of dictionaries with table information and similarity scores,
        sorted by similarity (highest first)
    """
    # Load table metadata
    df = load_table_metadata(csv_file)
    if df is None:
        return []
    
    #print(f"Loaded {len(df)} tables from {csv_file}")
    
    # Load or generate table embeddings
    #print("Loading table embeddings...")
    table_embeddings = generate_table_embeddings(csv_file, embeddings_file, force_regenerate_embeddings)
    
    if not table_embeddings:
        print("No table embeddings available")
        return []
    
    #print(f"Comparing query with {len(table_embeddings)} table embeddings...")
    
    # Get embedding for the query
    #print("Generating embedding for query...")
    query_embedding = get_embedding(query)
    if query_embedding is None:
        print("Failed to generate query embedding")
        return []
    
    # Filter dataframe to only include tables with embeddings and reset index
    df_filtered = df[df['table_name'].isin(table_embeddings.keys())].copy().reset_index(drop=True)
    
    if len(df_filtered) == 0:
        print("No tables with embeddings found")
        return []
    
    # Batch compute cosine similarities using vectorized operations
    #print(f"Computing similarities for {len(df_filtered)} tables (vectorized)...")
    
    # Convert query embedding to numpy array
    query_vec = np.array(query_embedding)
    
    # Stack all table embeddings into a matrix (n_tables x embedding_dim)
    # Maintain same order as df_filtered
    table_names_list = df_filtered['table_name'].tolist()
    table_embeddings_matrix = np.array([table_embeddings[name] for name in table_names_list])
    
    # Vectorized cosine similarity calculation
    # Cosine similarity = dot product / (norm1 * norm2)
    # For batch: query_vec @ table_embeddings_matrix.T / (||query_vec|| * ||each_table_vec||)
    query_norm = np.linalg.norm(query_vec)
    table_norms = np.linalg.norm(table_embeddings_matrix, axis=1)
    
    # Compute dot products (query with each table)
    dot_products = np.dot(table_embeddings_matrix, query_vec)
    
    # Compute cosine similarities (avoid division by zero)
    similarity_scores = dot_products / (query_norm * table_norms + 1e-8)
    
    # Create results list with similarities
    # The order of table_names_list matches the order in similarity_scores and df_filtered
    similarities = []
    for idx in range(len(df_filtered)):
        row = df_filtered.iloc[idx]
        similarities.append({
            'table_name': row['table_name'],
            'similarity_score': float(similarity_scores[idx]),
            'metadata': str(row['metadata']),
            'row_count': row.get('row_count', 'N/A'),
            'column_count': row.get('column_count', 'N/A')
        })
    
    # Sort by similarity (highest first) and return top K
    similarities.sort(key=lambda x: x['similarity_score'], reverse=True)
    top_matches = similarities[:top_k]
    
    #print(f"Found top {len(top_matches)} matches")
    
    return top_matches


def print_results(matches: List[Dict]):
    """
    Print the matching results in a formatted way.
    
    Args:
        matches: List of matching table dictionaries
    """
    if not matches:
        print("\nNo matching tables found.")
        return
    
    print(f"\n{'='*80}")
    print(f"TOP {len(matches)} MATCHING TABLES")
    print(f"{'='*80}\n")
    
    for i, match in enumerate(matches, 1):
        print(f"{i}. {match['table_name']}")
        print(f"   Similarity Score: {match['similarity_score']:.4f}")
        print(f"   Row Count: {match['row_count']}")
        print(f"   Column Count: {match['column_count']}")
        print(f"   Metadata Preview: {match['metadata'][:200]}...")
        print()


def main():
    """
    Main function to run table selection.
    
    Usage:
        python select_table.py "your query here"
        python select_table.py --regenerate "your query here"
        python select_table.py --regenerate-only  # Just regenerate embeddings, no query
    """
    import sys
    
    # Check for command-line flags
    force_regenerate = False
    regenerate_only = False
    args = sys.argv[1:]
    
    if '--regenerate-only' in args:
        regenerate_only = True
        args = [a for a in args if a != '--regenerate-only']
    elif '--regenerate' in args:
        force_regenerate = True
        args = [a for a in args if a != '--regenerate']
    
    if regenerate_only:
        print("Regenerating table embeddings...")
        generate_table_embeddings(force_regenerate=True)
        print("Embeddings regeneration complete!")
        return
    
    # Get query from command line argument or prompt
    if args:
        query = " ".join(args)
    else:
        query = input("Enter your query: ").strip()
    
    if not query:
        print("Error: Query cannot be empty")
        return
    
    print(f"\nQuery: {query}\n")
    
    # Find matching tables
    matches = find_matching_tables(query, top_k=3, force_regenerate_embeddings=force_regenerate)
    
    # Print results
    print_results(matches)
    
    # Return results for programmatic use
    return matches


if __name__ == "__main__":
    main()

