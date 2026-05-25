# Transform Layer Design

## Purpose

This project follows a lightweight ELT-oriented analytics workflow.

Raw Olist CSV files are first extracted, validated, versioned, and preserved in a raw landing zone. Transformation is then performed in the analytical layer to prepare clean, business-ready tables for fulfilment, customer satisfaction, freight cost, seller performance, and profitability analysis.

The transform layer is designed to support the project’s core business problem:

> Which product categories, sellers, regions, and fulfilment patterns are driving operational inefficiency and profitability leakage?

## Transformation Approach

The transformation layer is split into two stages:

| Layer  | Purpose                                                          |
| ------ | ---------------------------------------------------------------- |
| Silver | Clean, standardise, and prepare reusable analytical tables       |
| Gold   | Build business-focused models and metrics for Power BI reporting |

## Silver Layer Scope

The Silver layer prepares standardised tables from the raw Olist dataset. It focuses on:

1. Standardising data types.
2. Preserving business keys.
3. Preparing date fields for fulfilment analysis.
4. Creating basic operational flags.
5. Preparing seller, customer, product, order, payment, and review data for Gold modelling.

## Fabric Implementation Approach

The project uses Microsoft Fabric Lakehouse as the raw analytical storage layer.

Raw CSV files are uploaded into Lakehouse Files and loaded into Lakehouse tables. The SQL analytics endpoint is used for data inspection and raw data quality checks.

Because the Lakehouse SQL analytics endpoint is read-only for table data modification, materialised Silver tables will be created through Fabric Notebook logic when write operations are required.
