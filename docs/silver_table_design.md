# Silver Table Design

## Purpose

The Silver layer converts raw Olist CSV files into clean and reusable analytical tables.

These tables prepare the data needed for downstream Gold modelling and Power BI reporting. The focus is on fulfilment performance, freight pressure, customer satisfaction, seller performance, and regional analysis.

## Planned Silver Tables

| Silver Table                          | Source File                             | Grain                        | Business Purpose                                                                |
| ------------------------------------- | --------------------------------------- | ---------------------------- | ------------------------------------------------------------------------------- |
| `silver_orders`                       | `olist_orders_dataset.csv`              | One row per order            | Order status, delivery dates, late delivery flags, fulfilment timeline analysis |
| `silver_order_items`                  | `olist_order_items_dataset.csv`         | One row per order item       | Product, seller, price, freight value, and item-level profitability analysis    |
| `silver_customers`                    | `olist_customers_dataset.csv`           | One row per customer record  | Customer city/state for regional fulfilment analysis                            |
| `silver_sellers`                      | `olist_sellers_dataset.csv`             | One row per seller           | Seller location and seller-level operational analysis                           |
| `silver_products`                     | `olist_products_dataset.csv`            | One row per product          | Product attributes and product category analysis                                |
| `silver_order_payments`               | `olist_order_payments_dataset.csv`      | One row per payment record   | Payment type, instalments, and payment value analysis                           |
| `silver_order_reviews`                | `olist_order_reviews_dataset.csv`       | One row per review record    | Review score and customer satisfaction analysis                                 |
| `silver_product_category_translation` | `product_category_name_translation.csv` | One row per product category | English product category labels for reporting                                   |

## Key Silver Rules

| Area        | Planned Rule                                                   |
| ----------- | -------------------------------------------------------------- |
| Orders      | Standardise order timestamps and create delivery-related flags |
| Order items | Convert price and freight fields into numeric values           |
| Customers   | Standardise customer city and state fields                     |
| Sellers     | Standardise seller city and state fields                       |
| Products    | Preserve product category and product attributes               |
| Payments    | Standardise payment value and instalment fields                |
| Reviews     | Validate review scores and standardise review timestamps       |
| Categories  | Join Portuguese category names to English reporting labels     |

## Excluded from First Silver Version

| Source File                     | Reason                                                                                                                                                                         |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `olist_geolocation_dataset.csv` | Customer and seller city/state fields are sufficient for the first version of regional analysis. Geolocation enrichment may be added later if it creates clear business value. |
