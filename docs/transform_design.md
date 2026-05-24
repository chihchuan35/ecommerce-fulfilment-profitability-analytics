# Transform Layer Design

## Purpose

This project follows an ELT-oriented analytics workflow. The raw Olist CSV files are first extracted, validated, versioned, and preserved in a raw landing zone. Transformation is then planned for the analytical platform, where raw data will be cleaned, standardised, modelled, and prepared for business reporting.

The transform layer is not designed only to clean data. Its purpose is to convert raw marketplace transaction data into reliable analytical tables that can support fulfilment, customer satisfaction, and profitability analysis.

## Transformation Scope

The first version of the transform layer focuses on preparing Silver tables from the raw Olist dataset.

The Silver layer will standardise source data so it can be used consistently for downstream Gold modelling and Power BI reporting.

The main transformation objectives are:

1. Standardise column names and data types.
2. Convert date and timestamp fields into usable analytical formats.
3. Preserve business keys from the source dataset.
4. Add basic operational flags needed for fulfilment analysis.
5. Prepare category, seller, customer, order, payment, review, and order item data for downstream modelling.
6. Keep raw data unchanged and perform transformation in a separate analytical layer.

## Planned Silver Tables

The first version of the Silver layer will focus on the following tables:

| Silver Table                          | Source File                             | Purpose                                                      |
| ------------------------------------- | --------------------------------------- | ------------------------------------------------------------ |
| `silver_orders`                       | `olist_orders_dataset.csv`              | Standardised order-level fulfilment and delivery status data |
| `silver_order_items`                  | `olist_order_items_dataset.csv`         | Item-level product, seller, price, and freight data          |
| `silver_customers`                    | `olist_customers_dataset.csv`           | Customer location and customer identifier data               |
| `silver_sellers`                      | `olist_sellers_dataset.csv`             | Seller location and seller identifier data                   |
| `silver_products`                     | `olist_products_dataset.csv`            | Product attributes and category information                  |
| `silver_order_payments`               | `olist_order_payments_dataset.csv`      | Payment type, instalment, and payment value data             |
| `silver_order_reviews`                | `olist_order_reviews_dataset.csv`       | Customer review scores and review timing data                |
| `silver_product_category_translation` | `product_category_name_translation.csv` | English product category names for reporting                 |

The geolocation file is not included in the first Silver scope. Customer and seller city/state fields are sufficient for the first version of regional fulfilment analysis. Geolocation enrichment may be considered later only if it adds clear analytical value.

## Raw-to-Silver Design Principles

The Silver layer will follow these principles:

1. Do not overwrite or modify raw data.
2. Keep transformation logic simple and transparent.
3. Use business-friendly table and column names where appropriate.
4. Retain source identifiers to support traceability.
5. Create reusable cleaned tables instead of embedding all logic directly into Power BI.
6. Separate data cleaning from final business metric calculation.
7. Avoid over-engineering beyond what is required for a junior Data Analyst / Business Analyst portfolio.

## Planned Silver-Level Data Quality Rules

The Silver layer will include basic checks and standardisation for:

| Area              | Planned Rule                                                                               |
| ----------------- | ------------------------------------------------------------------------------------------ |
| File completeness | Confirm required source tables are available before transformation                         |
| Primary keys      | Check key fields such as `order_id`, `customer_id`, `seller_id`, and `product_id`          |
| Duplicate records | Identify unexpected duplicates based on expected table grain                               |
| Date fields       | Convert order, delivery, review, and shipping date fields into proper timestamp/date types |
| Missing values    | Flag important missing fields instead of silently removing records                         |
| Delivery sequence | Check whether delivery and shipping dates follow a valid chronological order               |
| Numeric fields    | Ensure price, freight, payment, and instalment fields are usable for analysis              |
| Category names    | Join product category translation to support English reporting labels                      |

## Planned Fulfilment Fields

The Silver order table is expected to support fulfilment analysis through standardised date fields and basic operational flags, such as:

| Field                           | Purpose                                                            |
| ------------------------------- | ------------------------------------------------------------------ |
| `order_purchase_timestamp`      | When the customer placed the order                                 |
| `order_approved_at`             | When the order was approved                                        |
| `order_delivered_carrier_date`  | When the order was handed to the carrier                           |
| `order_delivered_customer_date` | When the order was delivered to the customer                       |
| `order_estimated_delivery_date` | Expected delivery date                                             |
| `is_delivered`                  | Whether the order has a delivered status                           |
| `is_late_delivery`              | Whether the order was delivered after the estimated delivery date  |
| `has_missing_delivery_date`     | Whether a delivered order is missing a customer delivery timestamp |
| `has_invalid_delivery_sequence` | Whether delivery dates appear in an illogical sequence             |

Detailed business metrics such as delivery delay days, freight-to-revenue ratio, average review score, and margin pressure indicators will be finalised in the Gold layer.

## Planned Analytical Direction

The Silver layer will prepare the data needed to answer the main business problem:

> Which product categories, sellers, regions, and fulfilment patterns are driving operational inefficiency and profitability leakage?

The Silver layer will support downstream analysis across:

1. Delivery reliability by order, seller, customer region, and product category.
2. Freight cost pressure by product category, seller, and order item.
3. Customer satisfaction patterns based on review scores.
4. Operational exceptions such as late deliveries, missing delivery timestamps, and invalid date sequences.
5. Seller and regional fulfilment performance.

## Out of Scope for the First Version

The first version of the transform layer will not include:

1. Advanced machine learning.
2. Predictive delivery modelling.
3. Complex geospatial modelling.
4. External enrichment datasets.
5. Overly complex orchestration.
6. Full enterprise data warehouse governance.

These may be considered later only if they clearly improve the business analysis.
