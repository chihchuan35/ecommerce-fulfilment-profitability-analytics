# E-commerce Fulfilment & Profitability Analytics

## Project Status

In progress.

Current stage:
- Repository structure created
- Extract layer design in progress

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