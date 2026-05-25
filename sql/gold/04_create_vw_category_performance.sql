-- Create product category performance view.
-- Grain: one row per product category.
-- Purpose: identify product categories linked to freight pressure, late delivery, and review performance.

IF OBJECT_ID('dbo.vw_category_performance', 'V') IS NOT NULL
    DROP VIEW dbo.vw_category_performance;
GO

CREATE VIEW dbo.vw_category_performance
AS
    SELECT
        COALESCE(product_category_name_english_label, 'unknown') AS product_category,

        COUNT(DISTINCT order_id) AS total_orders,
        COUNT(*) AS total_order_items,
        COUNT(DISTINCT seller_id) AS distinct_sellers,

        CAST(SUM(item_price) AS DECIMAL(18, 2)) AS total_item_revenue,
        CAST(SUM(freight_value) AS DECIMAL(18, 2)) AS total_freight_value,
        CAST(SUM(freight_value) / NULLIF(SUM(item_price), 0) AS DECIMAL(18, 4)) AS freight_to_revenue_ratio,

        SUM(is_high_freight_pressure) AS high_freight_pressure_items,
        SUM(is_medium_freight_pressure) AS medium_freight_pressure_items,
        SUM(is_low_freight_pressure) AS low_freight_pressure_items,

        SUM(is_late_delivery) AS late_delivery_items,
        CAST(SUM(is_late_delivery) * 100.0 / NULLIF(COUNT(*), 0) AS DECIMAL(10, 2)) AS late_delivery_item_rate_pct,

        SUM(high_freight_and_late_delivery_flag) AS high_freight_and_late_delivery_items,

        CAST(AVG(average_review_score) AS DECIMAL(18, 2)) AS average_review_score,
        SUM(has_low_customer_satisfaction) AS low_satisfaction_items,

        SUM(has_missing_product_category) AS missing_category_items,
        SUM(has_missing_category_translation) AS missing_category_translation_items

    FROM dbo.gold_order_item_profitability
    GROUP BY
    COALESCE(product_category_name_english_label, 'unknown');
GO