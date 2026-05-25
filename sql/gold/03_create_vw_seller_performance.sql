-- Create seller performance view.
-- Grain: one row per seller.
-- Purpose: compare sellers by fulfilment reliability, freight pressure, revenue, and review performance.

IF OBJECT_ID('dbo.vw_seller_performance', 'V') IS NOT NULL
    DROP VIEW dbo.vw_seller_performance;
GO

CREATE VIEW dbo.vw_seller_performance
AS
    SELECT
        seller_id,
        seller_city,
        seller_state,

        COUNT(DISTINCT order_id) AS total_orders,
        COUNT(*) AS total_order_items,

        CAST(SUM(item_price) AS DECIMAL(18, 2)) AS total_item_revenue,
        CAST(SUM(freight_value) AS DECIMAL(18, 2)) AS total_freight_value,
        CAST(SUM(freight_value) / NULLIF(SUM(item_price), 0) AS DECIMAL(18, 4)) AS freight_to_revenue_ratio,

        SUM(is_late_delivery) AS late_delivery_items,
        CAST(SUM(is_late_delivery) * 100.0 / NULLIF(COUNT(*), 0) AS DECIMAL(10, 2)) AS late_delivery_item_rate_pct,

        SUM(is_high_freight_pressure) AS high_freight_pressure_items,
        SUM(high_freight_and_late_delivery_flag) AS high_freight_and_late_delivery_items,

        CAST(AVG(average_review_score) AS DECIMAL(18, 2)) AS average_review_score,
        SUM(has_low_customer_satisfaction) AS low_satisfaction_items,

        SUM(has_invalid_delivery_sequence) AS invalid_delivery_sequence_items

    FROM dbo.gold_order_item_profitability
    GROUP BY
    seller_id,
    seller_city,
    seller_state;
GO