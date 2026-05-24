# Silver Table Design

## Purpose

This document defines the planned Silver tables for the E-commerce Fulfilment & Profitability Analytics project.

The Silver layer is designed to convert raw Olist CSV files into standardised, reusable analytical tables. These tables will preserve source-level business keys while applying basic cleaning, type conversion, naming standardisation, and business rule flags needed for downstream Gold modelling and Power BI reporting.

The goal of the Silver layer is not to calculate all final business KPIs. Instead, it prepares clean and reliable entities that can be used to analyse fulfilment performance, freight pressure, seller performance, customer satisfaction, and profitability leakage.

---

## Silver Table Overview

| Silver Table                          | Grain                        | Main Business Key                | Source File                             |
| ------------------------------------- | ---------------------------- | -------------------------------- | --------------------------------------- |
| `silver_orders`                       | One row per order            | `order_id`                       | `olist_orders_dataset.csv`              |
| `silver_order_items`                  | One row per order item       | `order_id`, `order_item_id`      | `olist_order_items_dataset.csv`         |
| `silver_customers`                    | One row per customer record  | `customer_id`                    | `olist_customers_dataset.csv`           |
| `silver_sellers`                      | One row per seller           | `seller_id`                      | `olist_sellers_dataset.csv`             |
| `silver_products`                     | One row per product          | `product_id`                     | `olist_products_dataset.csv`            |
| `silver_order_payments`               | One row per payment record   | `order_id`, `payment_sequential` | `olist_order_payments_dataset.csv`      |
| `silver_order_reviews`                | One row per review record    | `review_id`                      | `olist_order_reviews_dataset.csv`       |
| `silver_product_category_translation` | One row per product category | `product_category_name`          | `product_category_name_translation.csv` |

---

## 1. `silver_orders`

### Source

`olist_orders_dataset.csv`

### Grain

One row per order.

### Business Purpose

This table supports order-level fulfilment analysis, including delivery status, delivery delays, missing delivery dates, and fulfilment timeline checks.

### Key Fields

| Field                           | Purpose                                      |
| ------------------------------- | -------------------------------------------- |
| `order_id`                      | Unique order identifier                      |
| `customer_id`                   | Links the order to the customer table        |
| `order_status`                  | Current order status                         |
| `order_purchase_timestamp`      | Customer order placement time                |
| `order_approved_at`             | Order approval time                          |
| `order_delivered_carrier_date`  | Date the order was handed to the carrier     |
| `order_delivered_customer_date` | Date the order was delivered to the customer |
| `order_estimated_delivery_date` | Expected delivery date                       |

### Planned Business Rules

| Rule                           | Description                                                                                                          |
| ------------------------------ | -------------------------------------------------------------------------------------------------------------------- |
| Delivered order flag           | `is_delivered` should identify orders with delivered status                                                          |
| Late delivery flag             | `is_late_delivery` should identify delivered orders where actual delivery happened after the estimated delivery date |
| Missing delivery date flag     | `has_missing_delivery_date` should identify delivered orders without a customer delivery timestamp                   |
| Invalid delivery sequence flag | `has_invalid_delivery_sequence` should identify records where the fulfilment timeline is logically inconsistent      |
| Date standardisation           | Timestamp fields should be converted into proper datetime types                                                      |

---

## 2. `silver_order_items`

### Source

`olist_order_items_dataset.csv`

### Grain

One row per order item.

### Business Purpose

This table supports product, seller, price, and freight analysis at item level. It is the main table for analysing freight-related margin pressure.

### Key Fields

| Field                 | Purpose                                  |
| --------------------- | ---------------------------------------- |
| `order_id`            | Links order items to orders              |
| `order_item_id`       | Identifies item sequence within an order |
| `product_id`          | Links the item to the product table      |
| `seller_id`           | Links the item to the seller table       |
| `shipping_limit_date` | Seller shipping deadline                 |
| `price`               | Product item price                       |
| `freight_value`       | Freight cost charged for the item        |

### Planned Business Rules

| Rule                              | Description                                                                           |
| --------------------------------- | ------------------------------------------------------------------------------------- |
| Numeric validation                | `price` and `freight_value` should be converted into numeric types                    |
| Freight pressure preparation      | `freight_value` should be retained for downstream freight-to-revenue analysis         |
| Shipping deadline standardisation | `shipping_limit_date` should be converted into a proper datetime type                 |
| Item grain validation             | The combination of `order_id` and `order_item_id` should define item-level uniqueness |

---

## 3. `silver_customers`

### Source

`olist_customers_dataset.csv`

### Grain

One row per customer record.

### Business Purpose

This table supports regional fulfilment and customer location analysis.

### Key Fields

| Field                      | Purpose                                         |
| -------------------------- | ----------------------------------------------- |
| `customer_id`              | Customer identifier used in the orders table    |
| `customer_unique_id`       | Unique customer identity across multiple orders |
| `customer_zip_code_prefix` | Customer postcode prefix                        |
| `customer_city`            | Customer city                                   |
| `customer_state`           | Customer state                                  |

### Planned Business Rules

| Rule                          | Description                                                                            |
| ----------------------------- | -------------------------------------------------------------------------------------- |
| Location standardisation      | City and state fields should be standardised for reporting                             |
| Customer key retention        | Both `customer_id` and `customer_unique_id` should be retained                         |
| Regional analysis preparation | State and city fields should be available for downstream delivery performance analysis |

---

## 4. `silver_sellers`

### Source

`olist_sellers_dataset.csv`

### Grain

One row per seller.

### Business Purpose

This table supports seller-level fulfilment, freight pressure, and operational performance analysis.

### Key Fields

| Field                    | Purpose                |
| ------------------------ | ---------------------- |
| `seller_id`              | Seller identifier      |
| `seller_zip_code_prefix` | Seller postcode prefix |
| `seller_city`            | Seller city            |
| `seller_state`           | Seller state           |

### Planned Business Rules

| Rule                      | Description                                                                      |
| ------------------------- | -------------------------------------------------------------------------------- |
| Seller key validation     | `seller_id` should be checked for uniqueness                                     |
| Location standardisation  | Seller city and state fields should be standardised for reporting                |
| Seller region preparation | Seller location should support downstream seller fulfilment performance analysis |

---

## 5. `silver_products`

### Source

`olist_products_dataset.csv`

### Grain

One row per product.

### Business Purpose

This table supports product category, product size, and product attribute analysis.

### Key Fields

| Field                        | Purpose                                |
| ---------------------------- | -------------------------------------- |
| `product_id`                 | Product identifier                     |
| `product_category_name`      | Original Portuguese product category   |
| `product_name_lenght`        | Product name length from source        |
| `product_description_lenght` | Product description length from source |
| `product_photos_qty`         | Number of product photos               |
| `product_weight_g`           | Product weight in grams                |
| `product_length_cm`          | Product length in centimetres          |
| `product_height_cm`          | Product height in centimetres          |
| `product_width_cm`           | Product width in centimetres           |

### Planned Business Rules

| Rule                    | Description                                                                     |
| ----------------------- | ------------------------------------------------------------------------------- |
| Product key validation  | `product_id` should be checked for uniqueness                                   |
| Category preparation    | Product category should be retained for translation mapping                     |
| Numeric standardisation | Weight and dimension fields should be converted into numeric types              |
| Missing category flag   | Products with missing category values should be flagged for downstream analysis |

---

## 6. `silver_order_payments`

### Source

`olist_order_payments_dataset.csv`

### Grain

One row per payment record.

### Business Purpose

This table supports payment value and payment method analysis. It may also be used to compare order revenue against freight cost in downstream Gold tables.

### Key Fields

| Field                  | Purpose                          |
| ---------------------- | -------------------------------- |
| `order_id`             | Links payment records to orders  |
| `payment_sequential`   | Payment sequence within an order |
| `payment_type`         | Payment method                   |
| `payment_installments` | Number of instalments            |
| `payment_value`        | Payment value                    |

### Planned Business Rules

| Rule                     | Description                                                                                   |
| ------------------------ | --------------------------------------------------------------------------------------------- |
| Payment value validation | `payment_value` should be converted into a numeric type                                       |
| Instalment validation    | `payment_installments` should be converted into an integer type                               |
| Payment grain validation | The combination of `order_id` and `payment_sequential` should define payment-level uniqueness |

---

## 7. `silver_order_reviews`

### Source

`olist_order_reviews_dataset.csv`

### Grain

One row per review record.

### Business Purpose

This table supports customer satisfaction analysis and can be connected to fulfilment performance to identify whether late delivery patterns are associated with lower review scores.

### Key Fields

| Field                     | Purpose                        |
| ------------------------- | ------------------------------ |
| `review_id`               | Review identifier              |
| `order_id`                | Links review records to orders |
| `review_score`            | Customer satisfaction score    |
| `review_comment_title`    | Review title                   |
| `review_comment_message`  | Review text                    |
| `review_creation_date`    | Review creation date           |
| `review_answer_timestamp` | Review answer timestamp        |

### Planned Business Rules

| Rule                    | Description                                                                       |
| ----------------------- | --------------------------------------------------------------------------------- |
| Review score validation | `review_score` should be checked for valid score range                            |
| Date standardisation    | Review date fields should be converted into proper datetime types                 |
| Review-to-order link    | `order_id` should be retained for downstream fulfilment and satisfaction analysis |

---

## 8. `silver_product_category_translation`

### Source

`product_category_name_translation.csv`

### Grain

One row per product category.

### Business Purpose

This table provides English product category names for reporting and Power BI visualisation.

### Key Fields

| Field                           | Purpose                              |
| ------------------------------- | ------------------------------------ |
| `product_category_name`         | Original Portuguese product category |
| `product_category_name_english` | English category name                |

### Planned Business Rules

| Rule                        | Description                                                              |
| --------------------------- | ------------------------------------------------------------------------ |
| Category key validation     | `product_category_name` should be checked for uniqueness                 |
| Reporting label preparation | English category names should be available for downstream reporting      |
| Missing translation check   | Missing category translations should be identified before Gold modelling |

---

## Excluded from First Silver Version

The following source file is excluded from the first Silver version:

| Source File                     | Reason                                                                                                                                                                                           |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `olist_geolocation_dataset.csv` | City and state fields in the customer and seller tables are sufficient for the first version of regional analysis. Geolocation enrichment may be added later if it creates clear business value. |

---

## Silver Layer Design Boundary

The Silver layer should prepare clean, reusable data entities. It should not contain final dashboard-specific calculations unless they are basic operational flags required across multiple Gold tables.

Final business metrics such as delivery delay days, freight-to-revenue ratio, average review score by seller, category-level fulfilment performance, and profitability leakage indicators will be defined in the Gold layer.
