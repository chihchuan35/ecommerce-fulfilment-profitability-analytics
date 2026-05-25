# E-commerce Fulfilment & Profitability Analytics

## Project Overview

This portfolio project analyses e-commerce fulfilment reliability, customer satisfaction, seller performance, regional delivery issues, product category risk, and freight-related profitability pressure.

The project uses the Olist Brazilian E-Commerce Public Dataset and follows a lightweight ELT-oriented analytics workflow.

```text
Business Problem
→ Extract
→ Raw Validation
→ Fabric Lakehouse Raw Area
→ Fabric Warehouse Staging
→ Silver Transformation
→ Gold Reporting Models
→ Power BI Semantic Model
→ Insights and Recommendations
```

## Business Problem

An e-commerce marketplace is experiencing delivery delays, declining customer satisfaction, and freight-related margin pressure.

The goal is to identify which product categories, sellers, regions, and fulfilment patterns are driving operational inefficiency and profitability leakage, then provide data-driven recommendations to improve delivery reliability and margin performance.

## Project Status

In progress.

Completed:

- Repository structure
- Local extract workflow
- Raw source validation
- Versioned raw landing workflow
- Ingestion metadata logging
- Fabric Lakehouse raw upload
- Fabric Warehouse staging tables
- Raw data quality checks
- Silver transformation layer
- Gold reporting tables and views
- Fabric semantic model
- Core Power BI measures

Current stage:

- Building Power BI report pages and documenting business insights

## Data Source

- Dataset: Olist Brazilian E-Commerce Public Dataset
- Dataset handle: `olistbr/brazilian-ecommerce`

Raw CSV files are excluded from GitHub.

## Architecture

| Layer       | Tool                             | Purpose                                                          |
| ----------- | -------------------------------- | ---------------------------------------------------------------- |
| Extract     | Python + KaggleHub               | Download, validate, version, and log raw CSV files               |
| Raw storage | Fabric Lakehouse                 | Store uploaded raw files and raw loaded tables                   |
| Staging     | Fabric Warehouse SQL             | Create source-aligned Warehouse staging tables                   |
| Silver      | Fabric Warehouse SQL             | Clean, standardise, type-cast, and add row-level exception flags |
| Gold        | Fabric Warehouse SQL             | Build reporting-ready business models and analytical views       |
| Reporting   | Fabric Semantic Model + Power BI | Create measures, report pages, insights, and recommendations     |

## Key Outputs

### Silver Layer

Silver tables standardise data types, clean key fields, and add row-level analytical flags.

Examples:

- `silver_orders`
- `silver_order_items`
- `silver_products`
- `silver_customers`
- `silver_sellers`
- `silver_order_payments`
- `silver_order_reviews`

### Gold Layer

The Gold layer includes two physical reporting tables and several analytical views.

| Object                             | Type  | Purpose                                                                       |
| ---------------------------------- | ----- | ----------------------------------------------------------------------------- |
| `gold_order_fulfilment`            | Table | Order-level fulfilment, review, payment, revenue, and freight analysis        |
| `gold_order_item_profitability`    | Table | Item-level freight pressure, product, seller, category, and delivery analysis |
| `vw_seller_performance`            | View  | Seller-level performance summary                                              |
| `vw_category_performance`          | View  | Product category performance summary                                          |
| `vw_regional_fulfilment`           | View  | Regional fulfilment summary                                                   |
| `vw_customer_satisfaction_summary` | View  | Satisfaction comparison by delivery outcome                                   |
| `vw_monthly_fulfilment_trend`      | View  | Monthly order and late delivery trend                                         |
| `vw_state_fulfilment`              | View  | State-level fulfilment performance                                            |

## Power BI Reporting

A Fabric semantic model has been created from the Warehouse Gold layer.

Semantic model:

```text
sm_ecommerce_fulfilment_profitability
```

Core DAX measures are stored in:

```text
powerbi/core_measures.dax
```

The Power BI report focuses on:

- Executive summary
- Fulfilment performance
- Freight pressure
- Seller performance
- Product category analysis
- Regional fulfilment
- Customer satisfaction
- Business recommendations

## Documentation

Project documentation is consolidated into core files:

- `docs/01_project_overview.md`
- `docs/02_extract_and_fabric_architecture.md`
- `docs/03_data_quality_summary.md`
- `docs/04_transformation_layers.md`
- `docs/05_powerbi_reporting_plan.md`
- `docs/06_report_insights.md`

## How to Run the Extract Workflow

Install dependencies:

```powershell
pip install -r requirements.txt
```

Download the dataset:

```powershell
python -m src.extract.download_kaggle_dataset
```

Validate raw source files:

```powershell
python -m src.extract.validate_raw_files
```

Run the full extract workflow:

```powershell
python -m src.extract.run_extract
```

## Repository Structure

```text
config/      Dataset, required column, and path configuration
data/        Local raw data and metadata outputs, excluded from GitHub
src/         Python extract and utility scripts
sql/         Staging, data quality, Silver, and Gold SQL scripts
docs/        Project documentation
notebooks/   Fabric notebook logic used for review metadata preparation
powerbi/     Power BI measures, screenshots, and report documentation
```

## Tech Stack

- Python
- SQL
- Microsoft Fabric Lakehouse
- Microsoft Fabric Warehouse
- Fabric Semantic Model
- Power BI
- GitHub

## Data and Credential Handling

The following are excluded from GitHub:

- Raw CSV files
- Local metadata outputs
- `.env`
- `kaggle.json`
- Credentials and secrets

The repository stores code, SQL scripts, documentation, and reporting assets only.
