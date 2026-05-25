-- Create Silver orders table in Fabric Warehouse.
-- This table standardises order timestamps and creates fulfilment-related flags.

IF OBJECT_ID('dbo.silver_orders', 'U') IS NOT NULL
    DROP TABLE dbo.silver_orders;
GO

CREATE TABLE dbo.silver_orders
AS
SELECT
    order_id,
    customer_id,
    order_status,

    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,

    CAST(order_purchase_timestamp AS DATE) AS order_purchase_date,
    CAST(order_estimated_delivery_date AS DATE) AS estimated_delivery_date,
    CAST(order_delivered_customer_date AS DATE) AS actual_delivery_date,

    CASE
        WHEN order_status = 'delivered' THEN 1
        ELSE 0
    END AS is_delivered,

    CASE
        WHEN order_status = 'delivered'
        AND order_delivered_customer_date IS NOT NULL
        AND order_estimated_delivery_date IS NOT NULL
        AND order_delivered_customer_date > order_estimated_delivery_date
        THEN 1
        ELSE 0
    END AS is_late_delivery,

    CASE
        WHEN order_status = 'delivered'
        AND order_delivered_customer_date IS NOT NULL
        AND order_estimated_delivery_date IS NOT NULL
        THEN DATEDIFF(
            DAY,
            CAST(order_estimated_delivery_date AS DATE),
            CAST(order_delivered_customer_date AS DATE)
        )
        ELSE NULL
    END AS delivery_delay_days,

    CASE
        WHEN order_approved_at IS NULL THEN 1
        ELSE 0
    END AS has_missing_approval_date,

    CASE
        WHEN order_status = 'delivered'
        AND order_delivered_carrier_date IS NULL
        THEN 1
        ELSE 0
    END AS has_missing_carrier_date,

    CASE
        WHEN order_status = 'delivered'
        AND order_delivered_customer_date IS NULL
        THEN 1
        ELSE 0
    END AS has_missing_delivery_date,

    CASE
        WHEN (
            order_approved_at IS NOT NULL
        AND order_purchase_timestamp IS NOT NULL
        AND order_approved_at < order_purchase_timestamp
        )
        OR (
            order_delivered_carrier_date IS NOT NULL
        AND order_approved_at IS NOT NULL
        AND order_delivered_carrier_date < order_approved_at
        )
        OR (
            order_delivered_customer_date IS NOT NULL
        AND order_delivered_carrier_date IS NOT NULL
        AND order_delivered_customer_date < order_delivered_carrier_date
        )
        OR (
            order_estimated_delivery_date IS NOT NULL
        AND order_purchase_timestamp IS NOT NULL
        AND order_estimated_delivery_date < order_purchase_timestamp
        )
        THEN 1
        ELSE 0
    END AS has_invalid_delivery_sequence

FROM (
    SELECT
        LTRIM(RTRIM(CAST(order_id AS VARCHAR(100)))) AS order_id,
        LTRIM(RTRIM(CAST(customer_id AS VARCHAR(100)))) AS customer_id,
        LOWER(LTRIM(RTRIM(CAST(order_status AS VARCHAR(50))))) AS order_status,

        TRY_CAST(order_purchase_timestamp AS DATETIME2(0)) AS order_purchase_timestamp,
        TRY_CAST(order_approved_at AS DATETIME2(0)) AS order_approved_at,
        TRY_CAST(order_delivered_carrier_date AS DATETIME2(0)) AS order_delivered_carrier_date,
        TRY_CAST(order_delivered_customer_date AS DATETIME2(0)) AS order_delivered_customer_date,
        TRY_CAST(order_estimated_delivery_date AS DATETIME2(0)) AS order_estimated_delivery_date
    FROM dbo.stg_orders
) orders_clean;
GO