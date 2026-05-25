# Gold Layer Summary

## Purpose

The Gold layer converts cleaned Silver tables into reporting-ready business models for Power BI.

The first version focuses on fulfilment reliability, freight pressure, seller performance, customer satisfaction, regional fulfilment, and product category analysis.

## Completed Gold Objects

| Object                             | Type  | Grain                                  | Purpose                                                                        |
| ---------------------------------- | ----- | -------------------------------------- | ------------------------------------------------------------------------------ |
| `gold_order_fulfilment`            | Table | One row per order                      | Order-level fulfilment, review, payment, revenue, and freight analysis         |
| `gold_order_item_profitability`    | Table | One row per order item                 | Item-level freight pressure, seller, product category, and fulfilment analysis |
| `vw_seller_performance`            | View  | One row per seller                     | Seller-level delivery, freight, revenue, and review performance                |
| `vw_category_performance`          | View  | One row per product category           | Category-level freight pressure, delivery, and satisfaction analysis           |
| `vw_regional_fulfilment`           | View  | One row per customer state and city    | Regional delivery reliability and fulfilment risk analysis                     |
| `vw_customer_satisfaction_summary` | View  | One row per delivery performance group | Review score comparison by delivery outcome                                    |

## Design Decision

The Gold layer uses two physical tables as the core Power BI fact models:

- `gold_order_fulfilment`
- `gold_order_item_profitability`

Additional seller, category, regional, and satisfaction summaries are created as views to avoid unnecessary table duplication.

## Key Business Metrics

The Gold layer supports:

- Total orders
- Delivered orders
- Late delivery rate
- Average late delay days
- Average review score
- Low satisfaction orders
- Total item revenue
- Total freight value
- Freight-to-revenue ratio
- High freight pressure items
- Seller-level fulfilment performance
- Category-level freight pressure
- Regional delivery bottlenecks

## Business Interpretation Boundary

The project does not calculate actual profit margin because product cost data is not available in the Olist dataset.

Instead, the project uses freight-to-price ratio and freight-to-revenue ratio as indicators of freight-related margin pressure.
