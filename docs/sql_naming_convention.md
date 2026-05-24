# SQL Naming Convention

## Purpose

This document defines simple naming rules for SQL scripts and database objects used in the Fabric Warehouse transformation layer.

The goal is to keep the project easy to read, review, and maintain.

## Layer Naming

| Layer        | SQL Schema / Prefix | Purpose                                         |
| ------------ | ------------------- | ----------------------------------------------- |
| Staging      | `stg`               | Source-aligned tables loaded from raw CSV files |
| Silver       | `silver`            | Cleaned and standardised analytical tables      |
| Gold         | `gold`              | Business-ready reporting tables and KPI models  |
| Data Quality | `dq`                | Validation and reconciliation checks            |

## Table Naming

| Layer        | Example                       |
| ------------ | ----------------------------- |
| Staging      | `stg_orders`                  |
| Silver       | `silver_orders`               |
| Gold         | `gold_fulfilment_performance` |
| Data Quality | `dq_order_validation_checks`  |

## SQL Script Naming

SQL scripts should use a numbered prefix so they can be executed in order.

| Folder              | Example                                     |
| ------------------- | ------------------------------------------- |
| `sql/staging/`      | `01_create_stg_orders.sql`                  |
| `sql/silver/`       | `01_create_silver_orders.sql`               |
| `sql/gold/`         | `01_create_gold_fulfilment_performance.sql` |
| `sql/data_quality/` | `01_check_staging_row_counts.sql`           |

## Design Principle

Naming should make the data layer and business purpose clear.

The project avoids overly complex naming standards because the goal is to demonstrate a clear analytics workflow, not an enterprise data platform.
