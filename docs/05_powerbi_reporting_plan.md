# Power BI Reporting Plan

## Semantic Model

A Fabric semantic model has been created from the Fabric Warehouse Gold layer.

Semantic model:

```text
sm_ecommerce_fulfilment_profitability
```

Included objects:

- `gold_order_fulfilment`
- `gold_order_item_profitability`
- `vw_seller_performance`
- `vw_category_performance`
- `vw_regional_fulfilment`
- `vw_customer_satisfaction_summary`

DAX measures are organised in a dedicated measure table named `Measure`.

## Primary Relationship

| From                              | To                                        | Cardinality | Direction |
| --------------------------------- | ----------------------------------------- | ----------- | --------- |
| `gold_order_fulfilment[order_id]` | `gold_order_item_profitability[order_id]` | One-to-many | Single    |

## Core Measures

Core DAX measures are stored in:

```text
powerbi/core_measures.dax
```

Measure areas include:

- Order volume
- Delivery reliability
- Customer satisfaction
- Freight pressure
- Commercial value
- Operational exceptions

## Planned Report Pages

| Page                      | Business Question                                                               |
| ------------------------- | ------------------------------------------------------------------------------- |
| Executive Summary         | What are the key fulfilment and profitability pressure issues?                  |
| Fulfilment Performance    | Where are late deliveries happening and how severe are they?                    |
| Freight Pressure          | Which items, categories, or sellers create freight-related margin pressure?     |
| Seller Performance        | Which sellers are linked to delays, high freight pressure, or low satisfaction? |
| Product Category Analysis | Which categories drive fulfilment or freight pressure?                          |
| Regional Fulfilment       | Which customer regions experience worse fulfilment outcomes?                    |
| Customer Satisfaction     | Do late deliveries appear to affect review scores?                              |
| Recommendations           | What should the business prioritise?                                            |

## Reporting Principle

The report should focus on business interpretation.

Each page should explain:

1. What is happening?
2. Where is the issue concentrated?
3. Which sellers, categories, or regions are driving it?
4. What action should the business take?
