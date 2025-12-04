# Database Tables Knowledge Graph

This project creates a Neo4j knowledge graph that represents relationships and dependencies between database tables based on their metadata.

## Features

- Loads table metadata from CSV file
- Uses OpenAI GPT-4 to infer relationships between tables
- Creates a Neo4j knowledge graph with nodes (tables) and relationships
- Identifies dependencies, aggregations, and related tables

## Setup

1. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

2. **Configure environment variables:**
   ```bash
   cp env_template.txt .env
   ```
   
   Then edit `.env` and add your credentials:
   - `OPENAI_API_KEY`: Your OpenAI API key (required)
   - `NEO4J_URI`: Your Neo4j connection URI (optional, default: `bolt://localhost:7687`)
   - `NEO4J_USER`: Neo4j username (optional, default: `neo4j`)
   - `NEO4J_PASSWORD`: Your Neo4j password (optional - leave as placeholder to skip direct connection)

   **Note:** Neo4j credentials are optional. If not provided, the script will generate export files that you can import into Neo4j later.

## Usage

Run the script:
```bash
python create_knowledge_graph.py
```

The script will:
1. Load tables from `tables.csv`
2. Use OpenAI to analyze relationships between tables
3. Generate export files:
   - `knowledge_graph.cypher` - Cypher script to import into Neo4j
   - `knowledge_graph.json` - JSON format for reference
4. (Optional) If Neo4j credentials are provided, directly write to Neo4j

### Importing into Neo4j

**Option 1: Using Neo4j Browser**
1. Open Neo4j Browser (usually at `http://localhost:7474`)
2. Copy the contents of `knowledge_graph.cypher`
3. Paste and execute in the browser

**Option 2: Using cypher-shell**
```bash
cypher-shell -u neo4j -p your_password < knowledge_graph.cypher
```

**Option 3: Direct Connection**
If you provide Neo4j credentials in `.env`, the script will write directly to Neo4j automatically.

## Querying Relationships

After generating the knowledge graph, you can query first-degree relationships for any table using the query script:

```bash
python query_relationships.py <table_name>
```

**Examples:**
```bash
python query_relationships.py iip_monthly
python query_relationships.py gdp_actuals_summary
```

**Interactive Mode:**
Run without arguments to enter interactive mode:
```bash
python query_relationships.py
```

The script will display:
- Table information (domain, description, source, row count)
- **Direct Parents**: Tables that this table depends on or derives from
- **Direct Children**: Tables that depend on or derive from this table
- Relationship types, confidence scores, and explanations for each relationship

## Knowledge Graph Structure

### Nodes
- **Label**: `Table`
- **Properties**:
  - `name`: Table name
  - `data_domain`: Data domain (e.g., IIP, GDP, CPI)
  - `business_metadata`: Business description
  - `columns`: Column names
  - `source`: Data source
  - `rows_count`: Number of rows

### Relationships
- **Types**:
  - `DEPENDS_ON`: Source table depends on target table's data
  - `AGGREGATES`: Source table aggregates target table's data
  - `DERIVES_FROM`: Source table derives data from target table
  - `RELATED_TO`: Tables are related by business domain
  - `SUPERSET_OF`: Source table is a superset of target table
- **Properties**:
  - `description`: Explanation of the relationship
  - `confidence`: Confidence score (0-1)

## Example Neo4j Queries

Find all tables that depend on GDP:
```cypher
MATCH (t:Table)-[r:DEPENDS_ON]->(gdp:Table {name: 'gdp_actuals_summary'})
RETURN t.name, r.description, r.confidence
```

Find all relationships for a specific table:
```cypher
MATCH (t:Table {name: 'iip_monthly'})-[r]->(related:Table)
RETURN t.name, type(r) as relationship, related.name, r.description
```

Find highly confident relationships:
```cypher
MATCH (t1:Table)-[r]->(t2:Table)
WHERE r.confidence > 0.8
RETURN t1.name, type(r), t2.name, r.description, r.confidence
ORDER BY r.confidence DESC
```

## Notes

- The script processes tables in batches to handle rate limits
- Existing graph data is cleared before creating new nodes (you can modify this behavior)
- Relationship inference is based on metadata analysis by OpenAI
- Confidence scores help filter meaningful relationships

