# Extract and Fabric Architecture

## Extract Layer

The extract layer downloads, validates, versions, and logs the raw Olist CSV files.

Completed extract workflow:

1. Download dataset using KaggleHub.
2. Copy source CSV files into a local source download folder.
3. Validate expected files and required columns.
4. Create a versioned raw landing folder.
5. Copy validated files into the raw landing zone.
6. Write file-level ingestion metadata.

The extract layer does not clean, join, or model the data.

## Fabric Architecture

Current Fabric workflow:

```text
Local raw extract
→ Fabric Lakehouse Files
→ Lakehouse raw tables
→ Fabric Warehouse staging tables
→ Silver tables
→ Gold tables and views
→ Power BI semantic model
```

## Fabric Objects

| Fabric Object                           | Role                                                       |
| --------------------------------------- | ---------------------------------------------------------- |
| `lh_olist_raw`                          | Raw file and raw table landing area                        |
| Lakehouse SQL analytics endpoint        | Raw inspection and data quality checks                     |
| `wh_olist_analytics`                    | SQL-based staging, Silver, Gold, and reporting model layer |
| `sm_ecommerce_fulfilment_profitability` | Semantic model for Power BI reporting                      |

## Warehouse Staging Tables

| Staging Table                      | Source                              |
| ---------------------------------- | ----------------------------------- |
| `stg_orders`                       | `olist_orders_dataset`              |
| `stg_customers`                    | `olist_customers_dataset`           |
| `stg_order_items`                  | `olist_order_items_dataset`         |
| `stg_sellers`                      | `olist_sellers_dataset`             |
| `stg_products`                     | `olist_products_dataset`            |
| `stg_order_payments`               | `olist_order_payments_dataset`      |
| `stg_order_reviews`                | `olist_order_reviews_metadata`      |
| `stg_product_category_translation` | `product_category_name_translation` |

The review staging table uses a metadata-only review table because the original review CSV contained free-text fields that caused parsing issues during automatic loading.
