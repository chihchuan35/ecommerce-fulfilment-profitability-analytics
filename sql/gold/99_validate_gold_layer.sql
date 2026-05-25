-- Validate Gold layer outputs.
-- These checks confirm that Gold tables and views are available for Power BI reporting.

    SELECT
        'gold_order_fulfilment' AS object_name,
        COUNT(*) AS row_count
    FROM dbo.gold_order_fulfilment

UNION ALL

    SELECT
        'gold_order_item_profitability',
        COUNT(*)
    FROM dbo.gold_order_item_profitability

UNION ALL

    SELECT
        'vw_seller_performance',
        COUNT(*)
    FROM dbo.vw_seller_performance

UNION ALL

    SELECT
        'vw_category_performance',
        COUNT(*)
    FROM dbo.vw_category_performance

UNION ALL

    SELECT
        'vw_regional_fulfilment',
        COUNT(*)
    FROM dbo.vw_regional_fulfilment

UNION ALL

    SELECT
        'vw_customer_satisfaction_summary',
        COUNT(*)
    FROM dbo.vw_customer_satisfaction_summary;
GO


-- High-level business summary.

SELECT
    COUNT(*) AS total_orders,
    SUM(is_delivered) AS delivered_orders,
    SUM(is_late_delivery) AS late_deliveries,
    CAST(SUM(is_late_delivery) * 100.0 / NULLIF(SUM(is_delivered), 0) AS DECIMAL(10, 2)) AS late_delivery_rate_pct,
    CAST(AVG(CASE WHEN is_late_delivery = 1 THEN late_delivery_delay_days END) AS DECIMAL(18, 2)) AS avg_late_delay_days,
    CAST(AVG(average_review_score) AS DECIMAL(18, 2)) AS avg_review_score,
    SUM(has_low_customer_satisfaction) AS low_satisfaction_orders,
    SUM(late_and_low_review_flag) AS late_and_low_review_orders,
    CAST(SUM(total_item_revenue) AS DECIMAL(18, 2)) AS total_item_revenue,
    CAST(SUM(total_freight_value) AS DECIMAL(18, 2)) AS total_freight_value,
    CAST(SUM(total_freight_value) / NULLIF(SUM(total_item_revenue), 0) AS DECIMAL(18, 4)) AS freight_to_revenue_ratio
FROM dbo.gold_order_fulfilment;
GO


-- Freight pressure summary.

SELECT
    COUNT(*) AS total_order_items,
    CAST(SUM(item_price) AS DECIMAL(18, 2)) AS total_item_revenue,
    CAST(SUM(freight_value) AS DECIMAL(18, 2)) AS total_freight_value,
    CAST(SUM(freight_value) / NULLIF(SUM(item_price), 0) AS DECIMAL(18, 4)) AS overall_freight_to_price_ratio,
    SUM(is_high_freight_pressure) AS high_freight_pressure_items,
    SUM(is_medium_freight_pressure) AS medium_freight_pressure_items,
    SUM(is_low_freight_pressure) AS low_freight_pressure_items,
    SUM(high_freight_and_late_delivery_flag) AS high_freight_and_late_delivery_items,
    CAST(AVG(average_review_score) AS DECIMAL(18, 2)) AS average_review_score
FROM dbo.gold_order_item_profitability;
GO