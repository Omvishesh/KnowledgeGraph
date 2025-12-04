"""
Query First-Degree Relationships for Database Tables

This script loads the knowledge graph from JSON and queries first-degree
relationships (direct parents and children) for a given table name.
"""

import json
import sys
from typing import List, Dict, Optional

class RelationshipQuery:
    def __init__(self, json_path: str = "knowledge_graph.json", silent: bool = False):
        """
        Initialize the relationship query with the knowledge graph JSON file.
        
        Args:
            json_path: Path to the knowledge graph JSON file
            silent: If True, suppress print statements (useful when used as a library)
        """
        self.json_path = json_path
        self.silent = silent
        self.nodes = []
        self.relationships = []
        self.load_graph()
    
    def load_graph(self):
        """Load the knowledge graph from JSON file."""
        try:
            with open(self.json_path, 'r', encoding='utf-8') as f:
                data = json.load(f)
                self.nodes = data.get("nodes", [])
                self.relationships = data.get("relationships", [])
            if not self.silent:
                print(f"Loaded knowledge graph: {len(self.nodes)} nodes, {len(self.relationships)} relationships")
        except FileNotFoundError:
            if not self.silent:
                print(f"Error: {self.json_path} not found!")
            raise
        except json.JSONDecodeError as e:
            if not self.silent:
                print(f"Error: Invalid JSON file - {e}")
            raise
    
    def find_table_node(self, table_name: str) -> Optional[Dict]:
        """Find a table node by name (case-insensitive)."""
        for node in self.nodes:
            if node.get("name", "").lower() == table_name.lower():
                return node
        return None
    
    def get_first_degree_relationships(self, table_name: str) -> Dict:
        """
        Get first-degree relationships (direct parents and children) for a table.
        
        Returns:
            Dict with:
            - 'table': table node information
            - 'parents': list of relationships where this table is the target
            - 'children': list of relationships where this table is the source
        """
        table_node = self.find_table_node(table_name)
        if not table_node:
            return None
        
        parents = []
        children = []
        
        for rel in self.relationships:
            source = rel.get("source_table", "")
            target = rel.get("target_table", "")
            
            # Parents: tables that this table depends on or derives from
            if target.lower() == table_name.lower():
                parent_table = self.find_table_node(source)
                if parent_table:
                    parents.append({
                        "table": parent_table,
                        "relationship": rel
                    })
            
            # Children: tables that depend on or derive from this table
            if source.lower() == table_name.lower():
                child_table = self.find_table_node(target)
                if child_table:
                    children.append({
                        "table": child_table,
                        "relationship": rel
                    })
        
        # Sort by strength (highest first)
        parents.sort(key=lambda x: x["relationship"].get("strength", 0), reverse=True)
        children.sort(key=lambda x: x["relationship"].get("strength", 0), reverse=True)
        
        return {
            "table": table_node,
            "parents": parents,
            "children": children
        }
    
    def print_relationships(self, table_name: str):
        """Print first-degree relationships for a table in a formatted way."""
        result = self.get_first_degree_relationships(table_name)
        
        if not result:
            print(f"\n❌ Table '{table_name}' not found in knowledge graph.")
            print("\nAvailable tables (showing first 20):")
            for i, node in enumerate(self.nodes[:20]):
                print(f"  - {node.get('name')}")
            if len(self.nodes) > 20:
                print(f"  ... and {len(self.nodes) - 20} more")
            return
        
        table = result["table"]
        parents = result["parents"]
        children = result["children"]
        
        # Print table information
        print("\n" + "="*80)
        print(f"TABLE: {table.get('name')}")
        print("="*80)
        print(f"Domain: {table.get('data_domain', 'N/A')}")
        print(f"Description: {table.get('business_metadata', 'N/A')}")
        print(f"Source: {table.get('source', 'N/A')}")
        print(f"Rows: {table.get('rows_count', 'N/A')}")
        
        # Print parents (direct dependencies)
        print("\n" + "-"*80)
        print(f"DIRECT PARENTS (Tables this table depends on): {len(parents)}")
        print("-"*80)
        if parents:
            for i, parent_info in enumerate(parents, 1):
                parent_table = parent_info["table"]
                rel = parent_info["relationship"]
                rel_type = rel.get("relationship_type", "UNKNOWN")
                description = rel.get("description", "No description")
                strength = rel.get("strength", 0.0)
                
                print(f"\n{i}. {parent_table.get('name')} [{parent_table.get('data_domain', 'N/A')}]")
                print(f"   Relationship Type: {rel_type}")
                print(f"   Strength: {strength:.2f}")
                print(f"   Explanation: {description}")
        else:
            print("   No direct parents found.")
        
        # Print children (tables that depend on this table)
        print("\n" + "-"*80)
        print(f"DIRECT CHILDREN (Tables that depend on this table): {len(children)}")
        print("-"*80)
        if children:
            for i, child_info in enumerate(children, 1):
                child_table = child_info["table"]
                rel = child_info["relationship"]
                rel_type = rel.get("relationship_type", "UNKNOWN")
                description = rel.get("description", "No description")
                strength = rel.get("strength", 0.0)
                
                print(f"\n{i}. {child_table.get('name')} [{child_table.get('data_domain', 'N/A')}]")
                print(f"   Relationship Type: {rel_type}")
                print(f"   Strength: {strength:.2f}")
                print(f"   Explanation: {description}")
        else:
            print("   No direct children found.")
        
        print("\n" + "="*80)
        print(f"Summary: {len(parents)} parent(s), {len(children)} child(ren)")
        print("="*80 + "\n")


def main():
    """Main function to query relationships."""
    # Allow optional JSON file path as first argument
    json_path = "knowledge_graph.json"
    if len(sys.argv) > 1 and sys.argv[1].endswith('.json'):
        json_path = sys.argv[1]
        table_name = sys.argv[2] if len(sys.argv) > 2 else None
    else:
        table_name = sys.argv[1] if len(sys.argv) > 1 else None
    
    query = RelationshipQuery(json_path)
    
    if not table_name:
        print("Usage: python query_relationships.py <table_name> [json_file]")
        print("\nExample:")
        print("  python query_relationships.py iip_monthly")
        print("  python query_relationships.py gdp_actuals_summary")
        print("  python query_relationships.py knowledge_graph.json iip_monthly")
        print("\nEntering interactive mode...")
        print("(Type 'exit' or 'quit' to stop, 'list' to see all tables)\n")
        
        # Interactive mode
        while True:
            try:
                table_name = input("Enter table name: ").strip()
                if not table_name:
                    continue
                if table_name.lower() in ['exit', 'quit', 'q']:
                    print("Goodbye!")
                    break
                if table_name.lower() == 'list':
                    print("\nAvailable tables:")
                    for i, node in enumerate(query.nodes, 1):
                        print(f"  {i}. {node.get('name')} [{node.get('data_domain', 'N/A')}]")
                    print()
                    continue
                
                query.print_relationships(table_name)
            except KeyboardInterrupt:
                print("\n\nGoodbye!")
                break
            except Exception as e:
                print(f"Error: {e}\n")
    else:
        query.print_relationships(table_name)


if __name__ == "__main__":
    main()

