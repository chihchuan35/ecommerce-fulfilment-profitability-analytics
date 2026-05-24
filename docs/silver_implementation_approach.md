# Silver Implementation Approach

## Decision

This project will use **Microsoft Fabric Warehouse SQL** as the main transformation layer for Silver and Gold modelling.

The local Python extract workflow is responsible for downloading, validating, versioning, and preserving the raw Olist CSV files. After the raw files are available, they will be loaded into Microsoft Fabric for SQL-based transformation.

## Selected Approach

| Layer         | Tool                       | Purpose                                                                             |
| ------------- | -------------------------- | ----------------------------------------------------------------------------------- |
| Extract       | Python + KaggleHub         | Download, validate, version, and log raw CSV files                                  |
| Raw / Staging | Microsoft Fabric Warehouse | Store source-aligned raw or staging tables                                          |
| Silver        | Fabric Warehouse SQL       | Clean, standardise, and prepare reusable analytical tables                          |
| Gold          | Fabric Warehouse SQL       | Build business-ready reporting models and KPIs                                      |
| Reporting     | Power BI                   | Analyse fulfilment, freight pressure, customer satisfaction, and seller performance |

## Why Fabric Warehouse SQL

Fabric Warehouse SQL is selected because it fits the project goal:

1. It keeps the transformation logic clear and easy to review.
2. It demonstrates SQL modelling and business rule implementation.
3. It supports a clean Silver-to-Gold workflow.
4. It aligns well with Power BI reporting.
5. It avoids unnecessary engineering complexity for an entry-level Data Analyst / Business Analyst portfolio.

## Tools Not Used in the First Version

| Tool                             | Reason                                                                                        |
| -------------------------------- | --------------------------------------------------------------------------------------------- |
| Lakehouse SQL analytics endpoint | Useful for querying Lakehouse tables, but not selected as the main write/transformation layer |
| PySpark notebook                 | More powerful than needed for the current dataset and portfolio scope                         |
| Dataflow Gen2                    | Useful for low-code transformation, but SQL provides clearer version-controlled logic         |
| Complex orchestration            | Not required for the first version of this portfolio                                          |

## Repository SQL Plan

SQL scripts will be stored in the repository so the transformation logic is transparent and reusable.

Planned folder structure:

| Folder              | Purpose                                             |
| ------------------- | --------------------------------------------------- |
| `sql/staging/`      | Load or prepare source-aligned tables               |
| `sql/silver/`       | Create cleaned and standardised Silver tables       |
| `sql/gold/`         | Create business-ready analytical models and metrics |
| `sql/data_quality/` | Store validation and reconciliation checks          |

## Design Boundary

The first implementation will stay simple.

The goal is not to build a production-grade enterprise data platform. The goal is to demonstrate how raw marketplace data can be transformed into reliable analytical tables that support business problem solving, Power BI reporting, and commercial recommendations.
