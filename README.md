# E-commerce Fulfilment & Profitability Analytics

## Project Overview

This portfolio project analyses e-commerce fulfilment reliability, customer satisfaction, seller performance, regional delivery issues, and freight-related profitability pressure.

The project uses the Olist Brazilian E-Commerce Public Dataset and follows a lightweight ELT-oriented analytics workflow.

```text
Business Problem
→ Extract
→ Raw Validation
→ Fabric Staging
→ Silver Transformation
→ Gold Model
→ Power BI
→ Insights and Recommendations
```

## Business Problem

An e-commerce marketplace is experiencing delivery delays, declining customer satisfaction, and freight-related margin pressure.

The goal is to identify which product categories, sellers, regions, and fulfilment patterns are driving operational inefficiency and profitability leakage, then provide data-driven recommendations to improve delivery reliability and margin performance.

## Project Status

In progress.

Completed:

- Repository structure
- Extract configuration
- KaggleHub dataset download
- Raw source file validation
- Versioned raw landing workflow
- Ingestion metadata logging
- Initial transform and Silver layer planning

Current stage:

- Planning SQL-based raw-to-Silver transformation in Microsoft Fabric Warehouse

## Data Source

- Dataset: Olist Brazilian E-Commerce Public Dataset
- Dataset handle: `olistbr/brazilian-ecommerce`

Raw data files are excluded from GitHub.

## Extract Layer

The extract layer downloads, validates, versions, and logs raw CSV files.

Run the extract workflow:

```powershell
pip install -r requirements.txt
python -m src.extract.download_kaggle_dataset
python -m src.extract.validate_raw_files
python -m src.extract.run_extract
```

More details:

- `docs/extract_design.md`

## Transform Plan

The transformation layer will use Microsoft Fabric Warehouse SQL.

| Layer   | Purpose                                         |
| ------- | ----------------------------------------------- |
| Staging | Source-aligned tables loaded from raw CSV files |
| Silver  | Cleaned and standardised analytical tables      |
| Gold    | Business-ready reporting models and KPIs        |

More details:

- `docs/transform_design.md`
- `docs/fabric_staging_load_plan.md`
- `docs/silver_table_design.md`
- `docs/silver_business_rule_mapping.md`
- `sql/README.md`

## Tech Stack

- Python
- SQL
- Microsoft Fabric Warehouse
- Power BI
- GitHub

## Repository Structure

```text
config/      Configuration files
data/        Local raw data and metadata, excluded from GitHub
src/         Python extract and utility scripts
sql/         Staging, Silver, Gold, and data quality SQL scripts
docs/        Project documentation
powerbi/     Power BI screenshots and report documentation
```

## Data and Credential Handling

The following are excluded from GitHub:

- Raw CSV files
- Local metadata outputs
- `.env`
- `kaggle.json`
- Credentials and secrets
