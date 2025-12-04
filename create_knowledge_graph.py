"""
Knowledge Graph Builder for Database Tables

This script loads table metadata from a CSV file and uses OpenAI to infer
relationships between tables, then creates export files for Neo4j knowledge graph.
Neo4j connection is optional - if credentials are provided, it will write directly.
Otherwise, it generates Cypher scripts and JSON files for later import.
"""

import os
import pandas as pd
from dotenv import load_dotenv
from openai import OpenAI
import json
from typing import List, Dict, Optional
import time

# Load environment variables
load_dotenv("prod.env")

class KnowledgeGraphBuilder:
    def __init__(self, connect_to_neo4j: bool = False):
        """
        Initialize the knowledge graph builder with API credentials.
        
        Args:
            connect_to_neo4j: If True, will attempt to connect to Neo4j.
                             If False, will only generate export files.
        """
        self.openai_client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
        self.driver = None
        
        if connect_to_neo4j:
            try:
                from neo4j import GraphDatabase
                self.neo4j_uri = os.getenv("NEO4J_URI", "bolt://localhost:7687")
                self.neo4j_user = os.getenv("NEO4J_USER", "neo4j")
                self.neo4j_password = os.getenv("NEO4J_PASSWORD", "password")
                
                # Initialize Neo4j driver
                self.driver = GraphDatabase.driver(
                    self.neo4j_uri,
                    auth=(self.neo4j_user, self.neo4j_password)
                )
                print("Connected to Neo4j successfully")
            except Exception as e:
                print(f"Warning: Could not connect to Neo4j: {e}")
                print("Will generate export files only.")
                self.driver = None
        
    def load_tables(self, csv_path: str) -> pd.DataFrame:
        """Load table metadata from CSV file."""
        print(f"Loading tables from {csv_path}...")
        df = pd.read_csv(csv_path)
        print(f"Loaded {len(df)} tables")
        return df
    
    def infer_relationships(self, tables_df: pd.DataFrame, batch_size: int = 10) -> List[Dict]:
        """
        Use OpenAI to infer relationships between tables based on their metadata.
        Processes tables in batches to handle rate limits.
        """
        print("Inferring relationships using OpenAI...")
        relationships = []
        
        # Create a list of table information
        tables_info = []
        for _, row in tables_df.iterrows():
            tables_info.append({
                "table_name": row["table_name"],
                "data_domain": row.get("data_domain", ""),
                "business_metadata": row.get("business_metadata", ""),
                "columns": row.get("columns", "")
            })
        
        # Process in batches to avoid overwhelming the API
        total_batches = (len(tables_info) + batch_size - 1) // batch_size
        
        for batch_idx in range(0, len(tables_info), batch_size):
            batch = tables_info[batch_idx:batch_idx + batch_size]
            current_batch = (batch_idx // batch_size) + 1
            
            print(f"Processing batch {current_batch}/{total_batches}...")
            
            # Create prompt for OpenAI
            prompt = self._create_relationship_prompt(batch)
            
            try:
                response = self.openai_client.chat.completions.create(
                    model="gpt-4.1",
                    messages=[
                        {
                            "role": "system",
                            "content": "You are an expert economist and data analyst specializing in the Indian economy. Your task is to identify causal economic relationships between database tables containing official Indian government economic data. Focus on understanding how economic indicators causally influence each other, while being cognizant of time frequencies (annual, quarterly, monthly, daily) indicated in table names."
                        },
                        {
                            "role": "user",
                            "content": prompt
                        }
                    ],
                    temperature=0.3,
                    response_format={"type": "json_object"}
                )
                
                result = json.loads(response.choices[0].message.content)
                
                if "relationships" in result:
                    relationships.extend(result["relationships"])
                
                # Add a small delay to respect rate limits
                time.sleep(0.5)
                
            except Exception as e:
                print(f"Error processing batch {current_batch}: {e}")
                continue
        
        # Now process all tables together to find cross-batch relationships
        print("Analyzing cross-table relationships...")
        all_relationships = self._infer_all_relationships(tables_info)
        relationships.extend(all_relationships)
        
        # Remove duplicates
        unique_relationships = []
        seen = set()
        for rel in relationships:
            key = (rel.get("source_table"), rel.get("target_table"), rel.get("relationship_type"))
            if key not in seen:
                seen.add(key)
                unique_relationships.append(rel)
        
        print(f"Found {len(unique_relationships)} unique relationships")
        return unique_relationships
    
    def _create_relationship_prompt(self, tables: List[Dict]) -> str:
        """Create a prompt for OpenAI to analyze relationships in a batch of tables."""
        tables_json = json.dumps(tables, indent=2)
        
        prompt = f"""Analyze the following database tables from the Indian economy and identify CAUSAL ECONOMIC RELATIONSHIPS between them. These tables contain official government economic data for India.

IMPORTANT CONSIDERATIONS:
1. CAUSAL ECONOMIC RELATIONSHIPS: Focus on identifying causal relationships where one economic indicator influences, drives, or causes changes in another. For example, GDP growth may cause changes in industrial production (IIP), or inflation (CPI) may affect consumer spending patterns.

2. TIME FREQUENCY AWARENESS: Pay close attention to the table names which indicate time frequency:
   - Annual/yearly tables: Contain yearly aggregated data
   - Quarterly tables: Contain quarterly aggregated data  
   - Monthly tables: Contain monthly data points
   - Daily tables: Contain daily data points
   
   Consider how different frequencies relate - for example, monthly data may aggregate to quarterly or annual data, and higher frequency data may be used to forecast or derive lower frequency aggregates.

3. GEOGRAPHY AWARENESS: CRITICAL - Pay close attention to geographic scope in table names and metadata:
   - State-specific tables (e.g., containing "maharashtra", "kerala", "gujarat" in name or metadata) represent data for that specific state
   - India/All-India tables (e.g., "india", "all_india", "national" in name) represent aggregate national data
   - DO NOT create relationships between different states (e.g., Maharashtra cannot causally impact Kerala, Tamil Nadu cannot derive from West Bengal)
   - DO create relationships from states to India (e.g., Maharashtra GDP contributes to India GDP, state-level data aggregates to national data)
   - DO create relationships from India to states (e.g., national policies affect states, India-level indicators influence state-level indicators)
   - DO create relationships between tables at the same geographic level if they represent the same geography (e.g., Maharashtra GDP and Maharashtra IIP can be related)
   - When in doubt about geography, check table names, metadata, and column names for geographic indicators

4. DEPENDENCIES: If one table's data is used to calculate or derive another table's data (e.g., GDP components contributing to overall GDP)

5. HIERARCHICAL RELATIONSHIPS: If one table is a summary or aggregation of another (respecting time frequency - e.g., monthly aggregated to quarterly)

6. ECONOMIC CAUSALITY: Focus on real economic cause-and-effect relationships in the Indian economy context (e.g., how GDP affects employment, how inflation affects consumption, how industrial production affects GDP)

Return a JSON object with a "relationships" array. Each relationship should have:
- source_table: name of the source table
- target_table: name of the target table
- relationship_type: one of "DEPENDS_ON", "AGGREGATES", "DERIVES_FROM", "RELATED_TO", "SUPERSET_OF"
- description: brief explanation of the relationship
- strength: a number between 0 and 1 indicating relationship strength

Tables to analyze:
{tables_json}

Return only valid JSON with this structure:
{{
  "relationships": [
    {{
      "source_table": "table1",
      "target_table": "table2",
      "relationship_type": "DEPENDS_ON",
      "description": "Table1 depends on data from table2",
      "strength": 0.8
    }}
  ]
}}
"""
        return prompt
    
    def _infer_all_relationships(self, all_tables: List[Dict]) -> List[Dict]:
        """Analyze relationships across all tables at once."""
        # Create a summary of all tables
        tables_summary = []
        for table in all_tables:
            tables_summary.append({
                "table_name": table["table_name"],
                "data_domain": table["data_domain"],
                "description": table["business_metadata"][:200]  # Truncate for token efficiency
            })
        
        prompt = f"""Analyze CAUSAL ECONOMIC RELATIONSHIPS between these database tables from the Indian economy. These tables contain official government economic data for India.

IMPORTANT CONSIDERATIONS:
1. CAUSAL ECONOMIC RELATIONSHIPS: Focus on identifying causal relationships where one economic indicator influences, drives, or causes changes in another in the Indian economic context. For example:
   - GDP growth may cause changes in industrial production (IIP)
   - Inflation (CPI) may affect consumer spending and GDP
   - Employment data may depend on GDP and industrial production
   - Monetary policy indicators may influence inflation and GDP

2. TIME FREQUENCY AWARENESS: Pay close attention to table names which indicate time frequency:
   - Annual/yearly tables: Contain yearly aggregated data
   - Quarterly tables: Contain quarterly aggregated data  
   - Monthly tables: Contain monthly data points
   - Daily tables: Contain daily data points
   
   Consider how different frequencies relate - monthly data may aggregate to quarterly/annual, and higher frequency data may be used to forecast or derive lower frequency aggregates. Relationships should respect temporal causality (e.g., monthly indicators may influence quarterly outcomes).

3. GEOGRAPHY AWARENESS: CRITICAL - Pay close attention to geographic scope in table names and metadata:
   - State-specific tables (e.g., containing "maharashtra", "kerala", "gujarat" in name or metadata) represent data for that specific state
   - India/All-India tables (e.g., "india", "all_india", "national" in name) represent aggregate national data
   - DO NOT create relationships between different states (e.g., Maharashtra cannot causally impact Kerala, Tamil Nadu cannot derive from West Bengal)
   - DO create relationships from states to India (e.g., Maharashtra GDP contributes to India GDP, state-level data aggregates to national data)
   - DO create relationships from India to states (e.g., national policies affect states, India-level indicators influence state-level indicators)
   - DO create relationships between tables at the same geographic level if they represent the same geography (e.g., Maharashtra GDP and Maharashtra IIP can be related)
   - When in doubt about geography, check table names, metadata, and column names for geographic indicators

4. DEPENDENCIES: Which tables depend on others (e.g., IIP might depend on GDP data, quarterly GDP may depend on monthly indicators)

5. AGGREGATIONS: Which tables aggregate or summarize others (respecting time frequency hierarchies)

6. ECONOMIC CAUSALITY: Identify real economic cause-and-effect relationships in the Indian economy context

Return a JSON object with a "relationships" array. Each relationship should have:
- source_table: name of the source table
- target_table: name of the target table
- relationship_type: one of "DEPENDS_ON", "AGGREGATES", "DERIVES_FROM", "RELATED_TO", "SUPERSET_OF"
- description: brief explanation of the relationship
- strength: a number between 0 and 1

Tables:
{json.dumps(tables_summary, indent=2)}

Return only valid JSON with this structure:
{{
  "relationships": [
    {{
      "source_table": "table1",
      "target_table": "table2",
      "relationship_type": "DEPENDS_ON",
      "description": "Brief description",
      "strength": 0.8
    }}
  ]
}}
"""
        
        try:
            response = self.openai_client.chat.completions.create(
                model="gpt-4",
                messages=[
                    {
                        "role": "system",
                        "content": "You are an expert economist and data analyst specializing in the Indian economy. Your task is to identify causal economic relationships between database tables containing official Indian government economic data. Focus on understanding how economic indicators causally influence each other, while being cognizant of time frequencies (annual, quarterly, monthly, daily) indicated in table names."
                    },
                    {
                        "role": "user",
                        "content": prompt
                    }
                ],
                temperature=0.3,
                response_format={"type": "json_object"}
            )
            
            result = json.loads(response.choices[0].message.content)
            return result.get("relationships", [])
            
        except Exception as e:
            print(f"Error in cross-table analysis: {e}")
            return []
    
    def _escape_cypher_string(self, value: str) -> str:
        """Escape a string for use in Cypher queries."""
        if pd.isna(value):
            return ""
        # Replace newlines with spaces, then escape quotes and backslashes
        value = str(value).replace('\n', ' ').replace('\r', ' ')
        value = value.replace('\\', '\\\\').replace("'", "\\'")
        return value
    
    def export_to_cypher(self, tables_df: pd.DataFrame, relationships: List[Dict], output_file: str = "knowledge_graph.cypher"):
        """Export the knowledge graph to a Cypher script file."""
        print(f"Generating Cypher script: {output_file}...")
        
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write("// Knowledge Graph Cypher Script\n")
            f.write("// Generated from table metadata analysis\n\n")
            
            # Clear existing data
            f.write("// Clear existing graph data\n")
            f.write("MATCH (n) DETACH DELETE n;\n\n")
            
            # Create table nodes
            f.write("// Create table nodes\n")
            for _, row in tables_df.iterrows():
                name = self._escape_cypher_string(row["table_name"])
                domain = self._escape_cypher_string(row.get("data_domain", ""))
                metadata = self._escape_cypher_string(row.get("business_metadata", ""))
                columns = self._escape_cypher_string(row.get("columns", ""))
                source = self._escape_cypher_string(row.get("source", ""))
                rows_count = row.get("rows_count", 0)
                
                f.write(f"CREATE (t:Table {{\n")
                f.write(f"  name: '{name}',\n")
                f.write(f"  data_domain: '{domain}',\n")
                f.write(f"  business_metadata: '{metadata}',\n")
                f.write(f"  columns: '{columns}',\n")
                f.write(f"  source: '{source}',\n")
                f.write(f"  rows_count: {rows_count}\n")
                f.write(f"}});\n\n")
            
            # Create relationships
            f.write("// Create relationships\n")
            for rel in relationships:
                source = self._escape_cypher_string(rel.get("source_table", ""))
                target = self._escape_cypher_string(rel.get("target_table", ""))
                rel_type = rel.get("relationship_type", "RELATED_TO")
                description = self._escape_cypher_string(rel.get("description", ""))
                strength = rel.get("strength", 0.5)
                
                # Map relationship type to Neo4j relationship
                neo4j_rel_type = rel_type.upper().replace("_", "_")
                
                f.write(f"MATCH (source:Table {{name: '{source}'}})\n")
                f.write(f"MATCH (target:Table {{name: '{target}'}})\n")
                f.write(f"MERGE (source)-[r:{neo4j_rel_type} {{\n")
                f.write(f"  description: '{description}',\n")
                f.write(f"  strength: {strength}\n")
                f.write(f"}}]->(target);\n\n")
        
        print(f"Cypher script saved to {output_file}")
        print(f"  - {len(tables_df)} nodes")
        print(f"  - {len(relationships)} relationships")
    
    def export_to_json(self, tables_df: pd.DataFrame, relationships: List[Dict], output_file: str = "knowledge_graph.json"):
        """Export the knowledge graph to a JSON file."""
        print(f"Generating JSON export: {output_file}...")
        
        graph_data = {
            "nodes": [],
            "relationships": []
        }
        
        # Export nodes
        for _, row in tables_df.iterrows():
            graph_data["nodes"].append({
                "name": row["table_name"],
                "data_domain": row.get("data_domain", ""),
                "business_metadata": row.get("business_metadata", ""),
                "columns": row.get("columns", ""),
                "source": row.get("source", ""),
                "rows_count": row.get("rows_count", 0)
            })
        
        # Export relationships
        graph_data["relationships"] = relationships
        
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(graph_data, f, indent=2, ensure_ascii=False)
        
        print(f"JSON export saved to {output_file}")
    
    def create_neo4j_graph(self, tables_df: pd.DataFrame, relationships: List[Dict]):
        """Create nodes and relationships in Neo4j (if connected)."""
        if not self.driver:
            print("Skipping direct Neo4j write (no connection). Use export files instead.")
            return
        
        print("Creating Neo4j knowledge graph...")
        
        try:
            with self.driver.session() as session:
                # Clear existing data (optional - comment out if you want to keep existing data)
                print("Clearing existing graph data...")
                session.run("MATCH (n) DETACH DELETE n")
                
                # Create table nodes
                print("Creating table nodes...")
                for _, row in tables_df.iterrows():
                    session.run("""
                        CREATE (t:Table {
                            name: $name,
                            data_domain: $domain,
                            business_metadata: $metadata,
                            columns: $columns,
                            source: $source,
                            rows_count: $rows_count
                        })
                    """, 
                        name=row["table_name"],
                        domain=row.get("data_domain", ""),
                        metadata=row.get("business_metadata", ""),
                        columns=row.get("columns", ""),
                        source=row.get("source", ""),
                        rows_count=row.get("rows_count", 0)
                    )
                
                # Create relationships
                print("Creating relationships...")
                for rel in relationships:
                    source = rel.get("source_table")
                    target = rel.get("target_table")
                    rel_type = rel.get("relationship_type", "RELATED_TO")
                    description = rel.get("description", "")
                    strength = rel.get("strength", 0.5)
                    
                    # Map relationship type to Neo4j relationship
                    neo4j_rel_type = rel_type.upper().replace("_", "_")
                    
                    session.run(f"""
                        MATCH (source:Table {{name: $source}})
                        MATCH (target:Table {{name: $target}})
                        MERGE (source)-[r:{neo4j_rel_type} {{
                            description: $description,
                            strength: $strength
                        }}]->(target)
                    """,
                        source=source,
                        target=target,
                        description=description,
                        strength=strength
                    )
                
                print(f"Created {len(tables_df)} nodes and {len(relationships)} relationships")
        except Exception as e:
            print(f"Error writing to Neo4j: {e}")
            print("Continuing with export files only...")
    
    def close(self):
        """Close the Neo4j driver connection."""
        if self.driver:
            self.driver.close()
    
    def print_statistics(self, tables_df: pd.DataFrame, relationships: List[Dict]):
        """Print statistics about the knowledge graph."""
        if self.driver:
            try:
                with self.driver.session() as session:
                    result = session.run("""
                        MATCH (t:Table)
                        RETURN count(t) as node_count
                    """)
                    node_count = result.single()["node_count"]
                    
                    result = session.run("""
                        MATCH ()-[r]->()
                        RETURN count(r) as rel_count
                    """)
                    rel_count = result.single()["rel_count"]
                    
                    print(f"\nNeo4j Knowledge Graph Statistics:")
                    print(f"  Nodes (Tables): {node_count}")
                    print(f"  Relationships: {rel_count}")
            except Exception as e:
                print(f"Could not retrieve Neo4j statistics: {e}")
        
        print(f"\nExport File Statistics:")
        print(f"  Nodes (Tables): {len(tables_df)}")
        print(f"  Relationships: {len(relationships)}")


def main():
    """Main function to build the knowledge graph."""
    csv_path = "tables.csv"
    
    if not os.path.exists(csv_path):
        print(f"Error: {csv_path} not found!")
        return
    
    # Check for OpenAI API key
    if not os.getenv("OPENAI_API_KEY"):
        print("Error: OPENAI_API_KEY not found in environment variables!")
        print("Please set it in your .env file.")
        return
    
    # Check if user wants to connect to Neo4j (optional)
    connect_to_neo4j = os.getenv("NEO4J_PASSWORD") and os.getenv("NEO4J_PASSWORD") != "your_neo4j_password_here"
    
    builder = KnowledgeGraphBuilder(connect_to_neo4j=connect_to_neo4j)
    
    try:
        # Load tables
        tables_df = builder.load_tables(csv_path)
        
        # Infer relationships
        relationships = builder.infer_relationships(tables_df)
        
        # Export to files (always done)
        builder.export_to_cypher(tables_df, relationships)
        builder.export_to_json(tables_df, relationships)
        
        # Optionally create Neo4j graph directly (if connected)
        builder.create_neo4j_graph(tables_df, relationships)
        
        # Print statistics
        builder.print_statistics(tables_df, relationships)
        
        print("\n" + "="*60)
        print("Knowledge graph created successfully!")
        print("="*60)
        print("\nExport files generated:")
        print("  - knowledge_graph.cypher (import into Neo4j)")
        print("  - knowledge_graph.json (for reference)")
        print("\nTo import into Neo4j:")
        print("  1. Open Neo4j Browser or use cypher-shell")
        print("  2. Run: CALL apoc.cypher.runFile('file:///path/to/knowledge_graph.cypher')")
        print("     OR copy-paste the contents of knowledge_graph.cypher")
        if connect_to_neo4j:
            print("\n✓ Graph also written directly to Neo4j")
        else:
            print("\nℹ No Neo4j connection configured - use export files to import manually")
        
    except Exception as e:
        print(f"Error: {e}")
        import traceback
        traceback.print_exc()
    finally:
        builder.close()


if __name__ == "__main__":
    main()

