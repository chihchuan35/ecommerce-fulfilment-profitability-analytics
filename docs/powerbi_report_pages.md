# Power BI Report Pages

## Purpose

This document defines the first version of the Power BI report page structure.

The report is designed to turn the Gold layer into business insights and recommendations, focusing on fulfilment reliability, freight pressure, seller performance, regional delivery issues, customer satisfaction, and product category risks.

## Page 1: Executive Summary

### Business Question

What are the key fulfilment and profitability pressure issues?

### Main Visuals

| Visual           | Purpose                                                                          |
| ---------------- | -------------------------------------------------------------------------------- |
| KPI cards        | Total orders, late delivery rate, average review score, freight-to-revenue ratio |
| Trend chart      | Orders and late delivery rate over time                                          |
| Bar chart        | Top product categories by freight pressure                                       |
| Bar chart        | Top sellers by late delivery rate                                                |
| Summary text box | Key findings and recommended focus areas                                         |

### Main Data Source

- `gold_order_fulfilment`
- `gold_order_item_profitability`
- `vw_category_performance`
- `vw_seller_performance`

---

## Page 2: Fulfilment Performance

### Business Question

Where are late deliveries happening, and how severe are they?

### Main Visuals

| Visual          | Purpose                                                                        |
| --------------- | ------------------------------------------------------------------------------ |
| KPI cards       | Delivered orders, late deliveries, late delivery rate, average late delay days |
| Line chart      | Late delivery rate by month                                                    |
| Bar chart       | Late deliveries by customer state                                              |
| Table or matrix | Orders with missing or invalid fulfilment sequence flags                       |

### Main Data Source

- `gold_order_fulfilment`
- `vw_regional_fulfilment`

---

## Page 3: Freight Pressure

### Business Question

Which items, categories, or sellers create freight-related margin pressure?

### Main Visuals

| Visual       | Purpose                                                           |
| ------------ | ----------------------------------------------------------------- |
| KPI cards    | Total item revenue, total freight value, freight-to-revenue ratio |
| Bar chart    | Product categories by freight-to-revenue ratio                    |
| Bar chart    | Sellers by freight-to-revenue ratio                               |
| Scatter plot | Item price vs freight value                                       |
| Table        | High freight pressure items or categories                         |

### Main Data Source

- `gold_order_item_profitability`
- `vw_category_performance`
- `vw_seller_performance`

---

## Page 4: Seller Performance

### Business Question

Which sellers are linked to delays, high freight pressure, or poor customer satisfaction?

### Main Visuals

| Visual               | Purpose                                                                     |
| -------------------- | --------------------------------------------------------------------------- |
| Seller ranking table | Compare seller revenue, freight ratio, late delivery rate, and review score |
| Bar chart            | Top sellers by late delivery rate                                           |
| Bar chart            | Top sellers by freight-to-revenue ratio                                     |
| Scatter plot         | Late delivery rate vs average review score                                  |

### Main Data Source

- `vw_seller_performance`

---

## Page 5: Product Category Analysis

### Business Question

Which product categories drive fulfilment or freight pressure?

### Main Visuals

| Visual                 | Purpose                                                              |
| ---------------------- | -------------------------------------------------------------------- |
| Category ranking table | Compare revenue, freight ratio, late delivery rate, and review score |
| Bar chart              | Categories by freight-to-revenue ratio                               |
| Bar chart              | Categories by late delivery rate                                     |
| Bar chart              | Categories by high freight pressure item count                       |

### Main Data Source

- `vw_category_performance`
- `gold_order_item_profitability`

---

## Page 6: Regional Fulfilment

### Business Question

Which customer regions experience worse fulfilment outcomes?

### Main Visuals

| Visual            | Purpose                                                         |
| ----------------- | --------------------------------------------------------------- |
| Map or filled map | Late delivery rate by customer state                            |
| Bar chart         | Customer states by late delivery rate                           |
| Table             | City-level fulfilment performance                               |
| KPI cards         | Regional order volume, late delivery rate, average review score |

### Main Data Source

- `vw_regional_fulfilment`

---

## Page 7: Customer Satisfaction

### Business Question

Do late deliveries appear to affect customer satisfaction?

### Main Visuals

| Visual       | Purpose                                                                   |
| ------------ | ------------------------------------------------------------------------- |
| Bar chart    | Average review score by delivery performance group                        |
| KPI cards    | Average review score, low satisfaction orders, late and low review orders |
| Column chart | Low satisfaction rate by delivery group                                   |
| Table        | Late delivery and low review examples                                     |

### Main Data Source

- `vw_customer_satisfaction_summary`
- `gold_order_fulfilment`

---

## Page 8: Recommendations

### Business Question

What should the business prioritise?

### Main Content

| Section          | Purpose                                       |
| ---------------- | --------------------------------------------- |
| Key finding 1    | Summarise fulfilment reliability issue        |
| Key finding 2    | Summarise freight pressure issue              |
| Key finding 3    | Summarise seller or category risk             |
| Recommendation 1 | Operational improvement action                |
| Recommendation 2 | Freight or pricing review action              |
| Recommendation 3 | Seller management or category strategy action |

### Main Data Source

- Final insights from previous report pages

## Design Principle

Each page should answer one business question.

The report should avoid showing too many technical fields. The focus should be on operational performance, commercial impact, and clear recommendations.
