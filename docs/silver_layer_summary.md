# Silver Layer Summary

## Purpose

The Silver layer converts Warehouse staging tables into cleaned and standardised analytical tables.

The goal is to prepare reliable row-level data for downstream Gold modelling and Power BI reporting.

## Completed Silver Tables

| Silver Table                          | Purpose                                                                                   |
| ------------------------------------- | ----------------------------------------------------------------------------------------- |
| `silver_orders`                       | Fulfilment status, delivery dates, late delivery flags, and delivery sequence checks      |
| `silver_order_items`                  | Item-level price, freight value, freight ratio, and freight exception flags               |
| `silver_product_category_translation` | Standardised product category translation labels                                          |
| `silver_products`                     | Product attributes, category labels, product volume, and product exception flags          |
| `silver_customers`                    | Standardised customer identifiers and location fields                                     |
| `silver_sellers`                      | Standardised seller identifiers and location fields                                       |
| `silver_order_payments`               | Payment values, instalments, payment types, and payment exception flags                   |
| `silver_order_reviews`                | Review scores and customer satisfaction flags using the Fabric-safe review metadata table |

## Silver Validation Results

| Silver Table                          | Row Count | Exception Count |
| ------------------------------------- | --------: | --------------: |
| `silver_orders`                       |    99,441 |           1,382 |
| `silver_order_items`                  |   112,650 |             383 |
| `silver_product_category_translation` |        71 |             N/A |
| `silver_products`                     |    32,951 |             631 |
| `silver_customers`                    |    99,441 |               0 |
| `silver_sellers`                      |     3,095 |               0 |
| `silver_order_payments`               |   103,886 |              11 |
| `silver_order_reviews`                |    99,224 |               0 |

## Key Silver Decisions

- Staging tables remain source-aligned.
- Silver tables apply type conversion, text standardisation, row-level data quality flags, and analytical preparation logic.
- Raw records are preserved instead of being removed too early.
- Review analysis uses `stg_order_reviews`, which is based on the Fabric-safe `olist_order_reviews_metadata` table.
- `review_id` is not treated as a unique key by itself because duplicate review IDs can appear across multiple orders.
- Final KPI calculations and business-level aggregations will be handled in the Gold layer.

## Next Step

The next stage is to build Gold tables for Power BI reporting, including fulfilment performance, freight pressure, seller performance, regional analysis, and customer satisfaction metrics.
