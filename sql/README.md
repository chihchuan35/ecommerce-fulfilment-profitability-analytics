# SQL Scripts

This folder stores SQL scripts used in Microsoft Fabric.

## Current Structure

| Folder          | Purpose                                                           |
| --------------- | ----------------------------------------------------------------- |
| `staging/`      | Warehouse staging tables created from Fabric Lakehouse raw tables |
| `data_quality/` | Raw data validation and quality checks                            |
| `silver/`       | Silver transformation scripts                                     |
| `gold/`         | Gold reporting model and KPI scripts                              |

## Current Workflow

```text
Fabric Lakehouse raw tables
→ Fabric Warehouse staging tables
→ Silver transformation
→ Gold reporting models
→ Power BI
## Notes

Raw CSV files are loaded into Microsoft Fabric and are not stored in this repository.

Staging scripts will be added only if a separate staging layer is required. At the current stage, the Fabric-loaded source tables are used as the raw starting point for data quality checks and Silver transformation.
```

```markdown
## Current Warehouse Staging Status

The selected Olist source tables have been materialised from Fabric Lakehouse raw tables into Fabric Warehouse staging tables.

Current staging tables:

| Warehouse Staging Table            | Source Lakehouse Table              | Row Count |
| ---------------------------------- | ----------------------------------- | --------: |
| `stg_orders`                       | `olist_orders_dataset`              |    99,441 |
| `stg_customers`                    | `olist_customers_dataset`           |    99,441 |
| `stg_order_items`                  | `olist_order_items_dataset`         |   112,650 |
| `stg_sellers`                      | `olist_sellers_dataset`             |     3,095 |
| `stg_products`                     | `olist_products_dataset`            |    32,951 |
| `stg_order_payments`               | `olist_order_payments_dataset`      |   103,886 |
| `stg_order_reviews`                | `olist_order_reviews_metadata`      |    99,224 |
| `stg_product_category_translation` | `product_category_name_translation` |        71 |

The review staging table uses `olist_order_reviews_metadata` instead of the original UI-loaded reviews table because the original reviews CSV contained free-text fields that caused parsing issues during automatic loading.
```
