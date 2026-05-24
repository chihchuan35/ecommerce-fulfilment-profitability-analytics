# E-commerce Fulfilment & Profitability Analytics

## Project Status

In progress.

Current stage:

- Repository structure completed
- Extract configuration completed
- KaggleHub dataset download script completed
- Raw source file validation completed
- Versioned raw landing workflow completed
- Ingestion metadata logging completed

Next stage:

- SQL-based raw-to-silver transformation design

## Project Overview

This project is a business analytics portfolio project analysing e-commerce fulfilment reliability, customer satisfaction, seller performance, regional fulfilment bottlenecks, and freight-related profitability pressure.

The project uses the Olist Brazilian E-Commerce Public Dataset and is designed to demonstrate an end-to-end analytics workflow:

Business Problem → Data Source → Extract → Transform → Data Quality → Gold Model → Power BI → Insights → Recommendations

## Business Problem

An e-commerce marketplace is experiencing delivery delays, declining customer satisfaction, and freight-related margin pressure.

The business needs to identify which product categories, sellers, regions, and fulfilment patterns are driving operational inefficiency and profitability leakage, then provide data-driven recommendations to improve delivery reliability and margin performance.

## Planned Workflow

1. Define the business problem
2. Ingest raw source data
3. Capture ingestion metadata and schema snapshots
4. Apply lightweight raw data validation
5. Transform data into silver and gold layers
6. Build dimensional models for Power BI
7. Analyse fulfilment, customer satisfaction, and freight pressure
8. Present insights and management recommendations

## Extract Layer

The extract layer is designed to provide a repeatable and traceable raw data ingestion process.

It currently performs the following steps:

1. Downloads the Olist dataset using KaggleHub
2. Copies source CSV files into a local source download folder
3. Validates expected raw files
4. Creates a versioned raw landing folder using extract date and batch ID
5. Copies validated source files into the raw landing zone
6. Writes a file-level ingestion metadata log

The extract stage does not clean, join, transform, or model the data. Its purpose is to preserve the raw source files, validate that the required files and columns are available, and record metadata for traceability.

Key extract outputs:

- Versioned raw landing files
- File existence validation
- Empty file validation
- Required column validation
- File size
- Row count
- Column count
- SHA256 file hash
- Ingestion metadata log

Detailed design documentation is available in:

`docs/extract_design.md`

## How to Run the Extract Workflow

Install dependencies:

````powershell
pip install -r requirements.txt

## Tech Stack

- Python
- SQL
- Microsoft Fabric Lakehouse or MySQL
- Power BI
- GitHub

## Repository Structure

```text
config/      Dataset, required column, and path configuration
data/        Local raw landing zone and metadata outputs
src/         Python extract and utility scripts
pipelines/   Pipeline entry-point scripts
sql/         Raw, silver, data quality, and gold SQL scripts
docs/        Business and technical documentation
diagrams/    Architecture, lineage, and dimensional model diagrams
powerbi/     Power BI screenshots and report documentation
````
