-- Check invalid fulfilment date sequences in the raw orders table.
-- This identifies records where the order timeline is logically inconsistent.

WITH
    orders_with_dates
    AS
    (
        SELECT
            order_id,
            order_status,
            TRY_CAST(order_purchase_timestamp AS DATETIME2) AS purchase_timestamp,
            TRY_CAST(order_approved_at AS DATETIME2) AS approved_at,
            TRY_CAST(order_delivered_carrier_date AS DATETIME2) AS delivered_carrier_date,
            TRY_CAST(order_delivered_customer_date AS DATETIME2) AS delivered_customer_date,
            TRY_CAST(order_estimated_delivery_date AS DATETIME2) AS estimated_delivery_date
        FROM dbo.olist_orders_dataset
    )

SELECT
    COUNT(*) AS total_orders,

    SUM(
        CASE
            WHEN approved_at IS NOT NULL
        AND purchase_timestamp IS NOT NULL
        AND approved_at < purchase_timestamp
            THEN 1 ELSE 0
        END
    ) AS approved_before_purchase_count,

    SUM(
        CASE
            WHEN delivered_carrier_date IS NOT NULL
        AND approved_at IS NOT NULL
        AND delivered_carrier_date < approved_at
            THEN 1 ELSE 0
        END
    ) AS carrier_before_approval_count,

    SUM(
        CASE
            WHEN delivered_customer_date IS NOT NULL
        AND delivered_carrier_date IS NOT NULL
        AND delivered_customer_date < delivered_carrier_date
            THEN 1 ELSE 0
        END
    ) AS customer_delivery_before_carrier_count,

    SUM(
        CASE
            WHEN estimated_delivery_date IS NOT NULL
        AND purchase_timestamp IS NOT NULL
        AND estimated_delivery_date < purchase_timestamp
            THEN 1 ELSE 0
        END
    ) AS estimated_delivery_before_purchase_count

FROM orders_with_dates;