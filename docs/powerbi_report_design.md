# Power BI Report Design

## Purpose

This Power BI report is designed to translate the Gold layer outputs into business insights and recommendations.

The report focuses on fulfilment reliability, freight pressure, seller performance, regional bottlenecks, customer satisfaction, and product category risks.

## Reporting Dataset

The first report version will use the following Fabric Warehouse objects:

| Object                             | Purpose                                                             |
| ---------------------------------- | ------------------------------------------------------------------- |
| `gold_order_fulfilment`            | Order-level fulfilment, review, payment, and freight analysis       |
| `gold_order_item_profitability`    | Item-level freight pressure, seller, product, and category analysis |
| `vw_seller_performance`            | Seller-level operational performance                                |
| `vw_category_performance`          | Category-level freight and fulfilment performance                   |
| `vw_regional_fulfilment`           | Customer region-level fulfilment analysis                           |
| `vw_customer_satisfaction_summary` | Review score comparison by delivery performance                     |

## Planned Report Pages

| Page                      | Purpose                                                     | Main Business Question                                                                |
| ------------------------- | ----------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| Executive Summary         | Provide a high-level view of fulfilment and margin pressure | What are the key operational and commercial issues?                                   |
| Fulfilment Performance    | Analyse delivery reliability and delay patterns             | Where are late deliveries happening and how severe are they?                          |
| Freight Pressure          | Analyse freight burden by item, seller, and category        | Which areas are creating freight-related margin pressure?                             |
| Seller Performance        | Compare seller-level operational performance                | Which sellers are associated with delays, high freight pressure, or low satisfaction? |
| Product Category Analysis | Identify category-level operational and commercial risks    | Which categories drive delivery issues or freight pressure?                           |
| Regional Fulfilment       | Analyse customer region delivery outcomes                   | Which customer regions experience worse fulfilment performance?                       |
| Customer Satisfaction     | Link delivery outcomes to review scores                     | Do late deliveries appear to affect customer satisfaction?                            |
| Recommendations           | Summarise findings and business actions                     | What should the business prioritise to improve fulfilment and margin performance?     |

## Core KPIs

| KPI                         | Purpose                                 |
| --------------------------- | --------------------------------------- |
| Total Orders                | Measure marketplace activity            |
| Delivered Orders            | Measure completed fulfilment volume     |
| Late Delivery Rate          | Measure delivery reliability            |
| Average Late Delay Days     | Measure delay severity                  |
| Average Review Score        | Measure customer satisfaction           |
| Low Satisfaction Orders     | Identify poor customer experience       |
| Total Item Revenue          | Measure item-level commercial volume    |
| Total Freight Value         | Measure freight exposure                |
| Freight-to-Revenue Ratio    | Measure freight-related margin pressure |
| High Freight Pressure Items | Identify items with high freight burden |

## Design Principle

The report should focus on business interpretation rather than technical pipeline details.

Visuals should help explain:

1. What is the issue?
2. Where is it happening?
3. Which sellers, categories, or regions are driving it?
4. What business action should be recommended?
