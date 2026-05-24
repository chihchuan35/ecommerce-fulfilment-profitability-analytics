# Silver Business Rule Mapping

## Purpose

This document links the project’s business problem to the Silver layer rules required for downstream analysis.

The Silver layer is not only a technical cleaning layer. It prepares the fields and flags needed to analyse delivery reliability, customer satisfaction, freight pressure, seller performance, and regional fulfilment patterns.

## Business Problem Mapping

| Business Area           | Analytical Question                                                   | Silver Layer Preparation                                                  | Future Gold Metric                                   |
| ----------------------- | --------------------------------------------------------------------- | ------------------------------------------------------------------------- | ---------------------------------------------------- |
| Delivery reliability    | Which orders were delivered late?                                     | Standardise delivery dates and create late delivery flags                 | Late delivery rate, average delay days               |
| Fulfilment process      | Are there missing or invalid fulfilment dates?                        | Check purchase, approval, carrier, delivery, and estimated delivery dates | Fulfilment exception count and rate                  |
| Customer satisfaction   | Do late deliveries lead to lower review scores?                       | Link review scores to order and delivery outcomes                         | Average review score by delivery status              |
| Freight pressure        | Which items, sellers, or categories have high freight burden?         | Preserve item price and freight value                                     | Freight-to-price ratio                               |
| Seller performance      | Which sellers are linked to delays, freight pressure, or low reviews? | Connect sellers to order items, orders, and reviews                       | Seller performance scorecard                         |
| Regional performance    | Which customer regions experience worse fulfilment outcomes?          | Preserve customer city and state                                          | Late delivery rate by state or city                  |
| Product category impact | Which categories drive operational or margin issues?                  | Preserve product category and English category labels                     | Category-level fulfilment and profitability analysis |

## Core Silver Flags

| Flag                            | Purpose                                                                    |
| ------------------------------- | -------------------------------------------------------------------------- |
| `is_delivered`                  | Identifies delivered orders                                                |
| `is_late_delivery`              | Identifies delivered orders that arrived after the estimated delivery date |
| `has_missing_delivery_date`     | Identifies delivered orders without a customer delivery timestamp          |
| `has_invalid_delivery_sequence` | Identifies records with illogical fulfilment date sequences                |

## Design Boundary

The Silver layer prepares clean and traceable data.

Final aggregations, KPI calculations, business segmentation, ranking logic, and recommendations will be handled in the Gold layer and Power BI reporting layer.
