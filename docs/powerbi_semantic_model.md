# Power BI Semantic Model Design

## Purpose

This document defines the first version of the Power BI semantic model for the E-commerce Fulfilment & Profitability Analytics project.

The model is designed to focus on business analysis rather than raw data exploration. Power BI should mainly use the Gold layer outputs from Fabric Warehouse.

## Recommended Power BI Tables

The first report version should use the following Gold objects:

| Object                             | Type  | Purpose                                                        |
| ---------------------------------- | ----- | -------------------------------------------------------------- |
| `gold_order_fulfilment`            | Table | Main order-level fulfilment and customer satisfaction analysis |
| `gold_order_item_profitability`    | Table | Main item-level freight pressure and product category analysis |
| `vw_seller_performance`            | View  | Seller-level performance summary                               |
| `vw_category_performance`          | View  | Category-level performance summary                             |
| `vw_regional_fulfilment`           | View  | Customer region fulfilment summary                             |
| `vw_customer_satisfaction_summary` | View  | Review score comparison by delivery outcome                    |

Staging and Silver tables should not be included in the Power BI model unless they are needed for troubleshooting.

## Model Design Principle

Power BI should use the Gold layer as the reporting source.

The staging and Silver layers remain in Fabric Warehouse for traceability, validation, and transformation logic, but the report should focus on business-ready tables and views.

## Primary Fact Tables

| Table                           | Grain                  | Main Use                                                                       |
| ------------------------------- | ---------------------- | ------------------------------------------------------------------------------ |
| `gold_order_fulfilment`         | One row per order      | Delivery reliability, review score, payment, order-level freight and revenue   |
| `gold_order_item_profitability` | One row per order item | Freight pressure, seller, product category, and item-level commercial analysis |

## Relationship Guidance

The first version should keep the Power BI model simple.

Recommended approach:

| From                              | To                                        | Relationship                  |
| --------------------------------- | ----------------------------------------- | ----------------------------- |
| `gold_order_fulfilment[order_id]` | `gold_order_item_profitability[order_id]` | One-to-many, single direction |

The analytical summary views can be used as standalone reporting tables. They do not need to be connected to every other table in the first version.

## Core Measures

The report should include measures for:

| Measure Area           | Example Measures                                                           |
| ---------------------- | -------------------------------------------------------------------------- |
| Order volume           | Total Orders, Delivered Orders                                             |
| Delivery reliability   | Late Deliveries, Late Delivery Rate, Average Late Delay Days               |
| Customer satisfaction  | Average Review Score, Low Satisfaction Orders, Low Satisfaction Rate       |
| Freight pressure       | Total Freight Value, Freight-to-Revenue Ratio, High Freight Pressure Items |
| Commercial value       | Total Item Revenue                                                         |
| Operational exceptions | Invalid Delivery Sequence Count, Payment Exception Count                   |

## Design Boundary

The Power BI model should avoid unnecessary complexity.

The first report version does not require a full star schema with separate dimension tables. The Gold layer already provides reporting-ready tables and views for the required business questions.

Additional dimension tables may be added later only if they improve report usability or reduce model ambiguity.

## Current Semantic Model Status

A Fabric semantic model has been created from the Fabric Warehouse Gold layer.

Included reporting objects:

- `gold_order_fulfilment`
- `gold_order_item_profitability`
- `vw_seller_performance`
- `vw_category_performance`
- `vw_regional_fulfilment`
- `vw_customer_satisfaction_summary`

DAX measures are organised in a dedicated measure table named `Measure`.

The primary relationship is:

| From                              | To                                        | Cardinality | Direction |
| --------------------------------- | ----------------------------------------- | ----------- | --------- |
| `gold_order_fulfilment[order_id]` | `gold_order_item_profitability[order_id]` | One-to-many | Single    |

Staging and Silver tables are excluded from the semantic model to keep the report focused on business-ready Gold outputs.
