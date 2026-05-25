# Fabric Staging Load Plan

## Purpose

This document defines how raw Olist CSV files will be loaded into Microsoft Fabric before Silver transformation.

The goal is to keep the loading process simple, transparent, and suitable for a Data Analyst / Business Analyst portfolio.

## Loading Flow

| Step | Layer             | Purpose                                             |
| ---- | ----------------- | --------------------------------------------------- |
| 1    | Local raw landing | Store validated and versioned raw CSV files         |
| 2    | Fabric upload     | Upload selected raw CSV files into Microsoft Fabric |
| 3    | Staging tables    | Create source-aligned tables for SQL transformation |
| 4    | Silver tables     | Clean and standardise data for analysis             |
| 5    | Gold tables       | Build business-ready models and KPIs for Power BI   |

## Planned Staging Tables

| Staging Table                      | Source File                             |
| ---------------------------------- | --------------------------------------- |
| `stg_orders`                       | `olist_orders_dataset.csv`              |
| `stg_order_items`                  | `olist_order_items_dataset.csv`         |
| `stg_customers`                    | `olist_customers_dataset.csv`           |
| `stg_sellers`                      | `olist_sellers_dataset.csv`             |
| `stg_products`                     | `olist_products_dataset.csv`            |
| `stg_order_payments`               | `olist_order_payments_dataset.csv`      |
| `stg_order_reviews`                | `olist_order_reviews_dataset.csv`       |
| `stg_product_category_translation` | `product_category_name_translation.csv` |

## Design Decision

The staging layer stays close to the original source files.

Business rules are not applied in staging. They are handled in the Silver and Gold layers so the workflow remains traceable:

```text
Raw files → Staging tables → Silver tables → Gold models → Power BI
```

## Current Manual Upload Step

For the first version, raw CSV files are manually uploaded to the Lakehouse `Files` area before being loaded into Fabric Warehouse staging tables.

Current manual upload target:

```text
Lakehouse: lh_olist_raw
Folder: Files/olist_raw/
```

## Current Fabric Raw File Upload

For the first version, the selected raw CSV files have been manually uploaded to the Fabric Lakehouse Files area.

```text
Lakehouse: lh_olist_raw
Folder: Files/olist_raw/
```

Uploaded files:

- `olist_orders_dataset.csv`
- `olist_order_items_dataset.csv`
- `olist_customers_dataset.csv`
- `olist_sellers_dataset.csv`
- `olist_products_dataset.csv`
- `olist_order_payments_dataset.csv`
- `olist_order_reviews_dataset.csv`
- `product_category_name_translation.csv`

The geolocation file is excluded from the first version because city and state fields are sufficient for the initial regional fulfilment analysis.

At this stage, the files are uploaded only. They have not yet been loaded into tables.

## Current Fabric Loading Decision

For the current version, raw CSV files are uploaded into Fabric Lakehouse Files and loaded into Lakehouse tables.

These Fabric-loaded source tables are used as the raw starting point for SQL analytics endpoint data quality checks.

A separate Warehouse staging layer is not used in the first version. If needed later, it can be added after the Lakehouse-based workflow is complete.
