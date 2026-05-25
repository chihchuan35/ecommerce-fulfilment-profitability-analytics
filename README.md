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

- Preparing Fabric-based raw-to-Silver transformation using Lakehouse tables, SQL analytics endpoint checks, and notebook-based table preparation

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

The transformation layer uses Fabric Lakehouse as the raw landing area and Fabric Warehouse as the SQL transformation layer.

| Layer             | Purpose                                                      |
| ----------------- | ------------------------------------------------------------ |
| Lakehouse raw     | Stores uploaded raw CSV files and raw loaded tables          |
| Warehouse staging | Source-aligned tables materialised from Lakehouse raw tables |
| Silver            | Cleaned and standardised analytical tables                   |
| Gold              | Business-ready reporting models and KPIs                     |

More details:

- `docs/transform_design.md`
- `docs/fabric_staging_load_plan.md`
- `docs/silver_table_design.md`
- `docs/silver_business_rule_mapping.md`
- `sql/README.md`

## Data Quality Checks

Raw data quality checks are stored in:

## Silver Layer

The first version of the Silver layer has been completed in Fabric Warehouse SQL.

Silver tables standardise data types, clean key fields, add row-level exception flags, and prepare the dataset for Gold modelling and Power BI reporting.

More details:

- `docs/silver_layer_summary.md`

- `sql/data_quality/`

Summary:

- `docs/data_quality_summary.md`

## Gold Layer

The first version of the Gold layer has been completed.

It includes two physical reporting tables and several analytical views for Power BI:

- `gold_order_fulfilment`
- `gold_order_item_profitability`
- `vw_seller_performance`
- `vw_category_performance`
- `vw_regional_fulfilment`
- `vw_customer_satisfaction_summary`

More details:

- `docs/gold_layer_summary.md`

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
sql/         Data quality, Silver, and Gold SQL scripts
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
