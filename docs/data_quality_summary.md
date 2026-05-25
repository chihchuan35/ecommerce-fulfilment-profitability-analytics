# Data Quality Summary

## Purpose

This document summarises the raw data quality checks completed after loading the Olist CSV files into Microsoft Fabric.

The purpose of these checks is to confirm whether the raw loaded tables are reliable enough for Silver transformation and downstream Power BI analysis.

## Data Quality Scope

The checks focus on:

- Raw table row counts
- Missing values in key fields
- Date completeness and fulfilment sequence logic
- Numeric value validity
- Review score validity
- Duplicate business keys
- Relationship integrity between source tables
- Product category translation mapping

## Completed Checks

| Check                         | SQL Script                                                   | Purpose                                          |
| ----------------------------- | ------------------------------------------------------------ | ------------------------------------------------ |
| Raw table row counts          | `sql/data_quality/01_check_raw_table_row_counts.sql`         | Confirm raw tables were loaded successfully      |
| Orders missing dates          | `sql/data_quality/02_check_orders_missing_dates.sql`         | Check missing fulfilment date fields             |
| Orders status distribution    | `sql/data_quality/03_check_orders_status_distribution.sql`   | Understand order status coverage                 |
| Orders invalid date sequence  | `sql/data_quality/04_check_orders_invalid_date_sequence.sql` | Identify illogical fulfilment timelines          |
| Order items price and freight | `sql/data_quality/05_check_order_items_price_freight.sql`    | Validate price and freight fields                |
| Payments value                | `sql/data_quality/06_check_payments_value.sql`               | Validate payment value and instalment fields     |
| Reviews score range           | `sql/data_quality/07_check_reviews_score_range.sql`          | Validate review score quality                    |
| Duplicate business keys       | `sql/data_quality/08_check_duplicate_business_keys.sql`      | Check whether source tables match expected grain |
| Duplicate review details      | `sql/data_quality/09_check_review_duplicate_details.sql`     | Investigate duplicate review IDs                 |
| Relationship integrity        | `sql/data_quality/10_check_relationship_integrity.sql`       | Confirm key relationships can be joined          |
| Category translation mapping  | `sql/data_quality/11_check_category_translation_mapping.sql` | Check product category translation coverage      |

## Key Findings

| Area                     | Finding                                                                                                          | Treatment                                                                                 |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| Raw table loading        | Main raw tables were loaded into Fabric and row counts were checked                                              | Proceed to raw-to-Silver transformation                                                   |
| Orders date completeness | Some fulfilment date fields are missing, especially carrier and customer delivery dates                          | Preserve records and create Silver-level exception flags                                  |
| Orders date sequence     | Some records have carrier dates before approval dates and customer delivery dates before carrier dates           | Flag as invalid fulfilment sequence in Silver                                             |
| Order items              | Price and freight fields are valid overall; 383 records have zero freight value                                  | Preserve records and flag zero freight where needed                                       |
| Payments                 | Payment fields are valid overall; small number of records have zero instalments or zero payment value            | Preserve records and flag payment exceptions where needed                                 |
| Reviews loading          | The original review table loaded through the Fabric UI had parsing issues due to free-text comment fields        | Use Fabric Notebook output table `olist_order_reviews_metadata` for review score analysis |
| Reviews quality          | Review metadata table has valid review IDs, order IDs, scores, and date fields                                   | Use this table for customer satisfaction analysis                                         |
| Review duplicates        | `review_id` is not unique; 789 review IDs appear across multiple orders without conflicting score or date values | Do not assume `review_id` alone is the table grain                                        |
| Relationships            | Main table relationships returned zero missing references                                                        | Proceed with joins for Silver and Gold modelling                                          |
| Product categories       | 610 products have missing category values; 73 distinct product categories exist                                  | Preserve missing categories and handle reporting labels in Silver/Gold                    |
| Category translation     | Product category translation mapping should be checked before reporting                                          | Use English category labels where available                                               |

## Silver Layer Implications

The Silver layer should:

1. Standardise date and numeric data types.
2. Preserve raw records instead of deleting exceptions too early.
3. Add fulfilment flags such as `is_delivered`, `is_late_delivery`, `has_missing_delivery_date`, and `has_invalid_delivery_sequence`.
4. Add exception flags for zero freight, zero payment value, and missing product category.
5. Use `olist_order_reviews_metadata` instead of the original UI-loaded review table.
6. Avoid treating `review_id` as a unique key by itself.
7. Keep business rules transparent for downstream Gold modelling and Power BI reporting.

## Design Decision

The data quality stage is intentionally lightweight.

The goal is not to build an enterprise data quality framework. The goal is to validate the raw data issues that directly affect fulfilment analysis, freight pressure analysis, customer satisfaction analysis, and reporting model reliability.
