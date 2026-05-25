-- Check order status distribution in the raw orders table.
-- This helps understand which records should be included in delivery analysis.

SELECT
    order_status,
    COUNT(*) AS order_count,
    CAST(
        COUNT(*) * 100.0 / NULLIF(SUM(COUNT(*)) OVER (), 0)
        AS DECIMAL(10, 2)
    ) AS order_percentage
FROM dbo.olist_orders_dataset
GROUP BY order_status
ORDER BY order_count DESC;