# Gold Layer Design

## Purpose

The Gold layer converts cleaned Silver tables into business-ready analytical models for Power BI reporting.

The goal is to support fulfilment, freight pressure, seller performance, regional performance, customer satisfaction, and profitability leakage analysis.

## Gold Layer Role

| Layer  | Role                                                                  |
| ------ | --------------------------------------------------------------------- |
| Silver | Cleaned row-level tables with standardised fields and exception flags |
| Gold   | Business-focused models, metrics, and reporting-ready tables          |

Gold tables should be designed around business questions, not source files.

## Planned Gold Tables

| Gold Table                      | Grain                              | Business Purpose                                                                      |
| ------------------------------- | ---------------------------------- | ------------------------------------------------------------------------------------- |
| `gold_order_fulfilment`         | One row per order                  | Analyse delivery reliability, delay patterns, and customer satisfaction impact        |
| `gold_order_item_profitability` | One row per order item             | Analyse item price, freight pressure, product category, and seller contribution       |
| `gold_seller_performance`       | One row per seller                 | Compare sellers by order volume, late delivery rate, freight burden, and review score |
| `gold_category_performance`     | One row per product category       | Identify categories linked to delivery issues, freight pressure, and low satisfaction |
| `gold_regional_fulfilment`      | One row per customer state or city | Analyse regional delivery bottlenecks and fulfilment risk                             |

## Planned Business Metrics

| Metric                        | Purpose                                           |
| ----------------------------- | ------------------------------------------------- |
| `total_orders`                | Measure business volume                           |
| `delivered_orders`            | Measure completed fulfilment volume               |
| `late_delivery_rate`          | Identify delivery reliability issues              |
| `average_delivery_delay_days` | Measure severity of delivery delays               |
| `average_review_score`        | Measure customer satisfaction                     |
| `low_review_rate`             | Identify poor customer experience patterns        |
| `total_item_revenue`          | Measure item-level revenue before freight         |
| `total_freight_value`         | Measure freight cost exposure                     |
| `freight_to_price_ratio`      | Identify freight-related margin pressure          |
| `order_item_count`            | Measure product and seller activity               |
| `exception_count`             | Track records with data or operational exceptions |

## Business Questions Supported

The Gold layer should help answer:

1. Which sellers are associated with higher late delivery rates?
2. Which product categories create higher freight pressure?
3. Do late deliveries correlate with lower review scores?
4. Which customer regions experience worse fulfilment outcomes?
5. Which categories or sellers should be prioritised for operational improvement?
6. Where is profitability leakage most likely caused by freight burden?

## Design Boundary

Gold tables should contain business-level metrics and reporting-ready fields.

They should not repeat raw cleaning logic that already belongs in the Silver layer.  
They should also avoid final presentation-specific formatting, which will be handled in Power BI.
