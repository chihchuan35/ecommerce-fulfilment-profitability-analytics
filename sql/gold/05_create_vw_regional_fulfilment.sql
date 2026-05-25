-- Create regional fulfilment view.
-- Grain: one row per customer state and city.
-- Purpose: analyse regional delivery reliability, satisfaction, and freight exposure.

IF OBJECT_ID('dbo.vw_regional_fulfilment', 'V') IS NOT NULL
    DROP VIEW dbo.vw_regional_fulfilment;
GO

CREATE VIEW dbo.vw_regional_fulfilment
AS
    SELECT
        customer_state,
        customer_city,

        COUNT(*) AS total_orders,
        SUM(is_delivered) AS delivered_orders,
        SUM(is_late_delivery) AS late_deliveries,

        CAST(SUM(is_late_delivery) * 100.0 / NULLIF(SUM(is_delivered), 0) AS DECIMAL(10, 2)) AS late_delivery_rate_pct,

        CAST(AVG(CASE WHEN is_late_delivery = 1 THEN late_delivery_delay_days END) AS DECIMAL(18, 2)) AS average_late_delay_days,

        CAST(AVG(average_review_score) AS DECIMAL(18, 2)) AS average_review_score,
        SUM(has_low_customer_satisfaction) AS low_satisfaction_orders,
        SUM(late_and_low_review_flag) AS late_and_low_review_orders,

        CAST(SUM(total_item_revenue) AS DECIMAL(18, 2)) AS total_item_revenue,
        CAST(SUM(total_freight_value) AS DECIMAL(18, 2)) AS total_freight_value,
        CAST(SUM(total_freight_value) / NULLIF(SUM(total_item_revenue), 0) AS DECIMAL(18, 4)) AS freight_to_revenue_ratio,

        SUM(has_invalid_delivery_sequence) AS invalid_delivery_sequence_orders

    FROM dbo.gold_order_fulfilment
    GROUP BY
    customer_state,
    customer_city;
GO