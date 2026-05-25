# Transformation Layers

## Purpose

The transformation layer converts raw marketplace data into cleaned analytical tables and business-ready reporting models.

## Layer Boundary

| Layer   | Role                                                                             |
| ------- | -------------------------------------------------------------------------------- |
| Staging | Source-aligned Warehouse tables copied from Lakehouse raw tables                 |
| Silver  | Cleaned row-level analytical tables with standardised fields and exception flags |
| Gold    | Business-ready tables and views for Power BI reporting                           |

## Silver Layer

Completed Silver tables:

| Silver Table                          | Purpose                                                                            |
| ------------------------------------- | ---------------------------------------------------------------------------------- |
| `silver_orders`                       | Fulfilment dates, late delivery flags, delivery delay, and invalid sequence checks |
| `silver_order_items`                  | Price, freight, freight-to-price ratio, and freight exception flags                |
| `silver_products`                     | Product attributes, category labels, volume, and product exception flags           |
| `silver_customers`                    | Standardised customer location fields                                              |
| `silver_sellers`                      | Standardised seller location fields                                                |
| `silver_order_payments`               | Payment values, instalments, and payment exception flags                           |
| `silver_order_reviews`                | Review scores and customer satisfaction flags                                      |
| `silver_product_category_translation` | English category labels for reporting                                              |

Silver validation row counts matched staging expectations.

## Gold Layer

Completed Gold objects:

| Object                             | Type  | Purpose                                                                |
| ---------------------------------- | ----- | ---------------------------------------------------------------------- |
| `gold_order_fulfilment`            | Table | Order-level fulfilment, review, payment, revenue, and freight analysis |
| `gold_order_item_profitability`    | Table | Item-level freight pressure, seller, product, and category analysis    |
| `vw_seller_performance`            | View  | Seller-level performance summary                                       |
| `vw_category_performance`          | View  | Product category performance summary                                   |
| `vw_regional_fulfilment`           | View  | Regional fulfilment summary                                            |
| `vw_customer_satisfaction_summary` | View  | Satisfaction comparison by delivery outcome                            |

## Design Decision

The Gold layer uses two physical reporting tables as core fact models:

- `gold_order_fulfilment`
- `gold_order_item_profitability`

Additional seller, category, regional, and satisfaction summaries are created as views to avoid unnecessary table duplication.

## Business Interpretation Boundary

The dataset does not include product cost or actual profit margin.

This project uses freight-to-price ratio and freight-to-revenue ratio as indicators of freight-related margin pressure.
