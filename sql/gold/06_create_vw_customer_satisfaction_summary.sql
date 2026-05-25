-- Create customer satisfaction summary view.
-- Grain: delivery performance segment.
-- Purpose: compare review outcomes between late and on-time delivery groups.

IF OBJECT_ID('dbo.vw_customer_satisfaction_summary', 'V') IS NOT NULL
    DROP VIEW dbo.vw_customer_satisfaction_summary;
GO

CREATE VIEW dbo.vw_customer_satisfaction_summary
AS
    SELECT
        CASE
        WHEN is_late_delivery = 1 THEN 'Late delivery'
        WHEN is_delivered = 1 AND is_late_delivery = 0 THEN 'On-time or early delivery'
        ELSE 'Not delivered or other status'
    END AS delivery_performance_group,

        COUNT(*) AS total_orders,
        SUM(is_delivered) AS delivered_orders,
        SUM(is_late_delivery) AS late_deliveries,

        CAST(AVG(average_review_score) AS DECIMAL(18, 2)) AS average_review_score,

        SUM(has_low_customer_satisfaction) AS low_satisfaction_orders,
        CAST(SUM(has_low_customer_satisfaction) * 100.0 / NULLIF(COUNT(*), 0) AS DECIMAL(10, 2)) AS low_satisfaction_rate_pct,

        SUM(late_and_low_review_flag) AS late_and_low_review_orders,

        CAST(AVG(CASE WHEN is_late_delivery = 1 THEN late_delivery_delay_days END) AS DECIMAL(18, 2)) AS average_late_delay_days

    FROM dbo.gold_order_fulfilment
    GROUP BY
    CASE
        WHEN is_late_delivery = 1 THEN 'Late delivery'
        WHEN is_delivered = 1 AND is_late_delivery = 0 THEN 'On-time or early delivery'
        ELSE 'Not delivered or other status'
    END;
GO