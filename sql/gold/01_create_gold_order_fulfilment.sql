-- Create Gold order fulfilment table in Fabric Warehouse.
-- Grain: one row per order.
-- Purpose: support fulfilment reliability, customer satisfaction, regional analysis, and order-level commercial analysis.

IF OBJECT_ID('dbo.gold_order_fulfilment', 'U') IS NOT NULL
    DROP TABLE dbo.gold_order_fulfilment;
GO

CREATE TABLE dbo.gold_order_fulfilment
AS
SELECT
    o.order_id,
    o.customer_id,

    c.customer_unique_id,
    c.customer_city,
    c.customer_state,

    o.order_status,
    o.order_purchase_timestamp,
    o.order_purchase_date,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    o.estimated_delivery_date,
    o.actual_delivery_date,

    o.is_delivered,
    o.is_late_delivery,
    o.delivery_delay_days,
    o.has_missing_approval_date,
    o.has_missing_carrier_date,
    o.has_missing_delivery_date,
    o.has_invalid_delivery_sequence,

    CASE
        WHEN o.is_delivered = 1 AND o.is_late_delivery = 0 THEN 1
        ELSE 0
    END AS is_on_time_delivery,

    CASE
        WHEN o.delivery_delay_days > 0 THEN o.delivery_delay_days
        ELSE 0
    END AS late_delivery_delay_days,

    CASE
        WHEN o.delivery_delay_days < 0 THEN ABS(o.delivery_delay_days)
        ELSE 0
    END AS early_delivery_days,

    COALESCE(oi.order_item_count, 0) AS order_item_count,
    COALESCE(oi.distinct_product_count, 0) AS distinct_product_count,
    COALESCE(oi.distinct_seller_count, 0) AS distinct_seller_count,
    oi.total_item_revenue,
    oi.total_freight_value,
    oi.average_freight_to_price_ratio,
    oi.has_zero_freight_order,

    pay.payment_record_count,
    pay.total_payment_value,
    pay.primary_payment_type,
    pay.max_payment_installments,
    pay.has_payment_exception,

    rev.review_record_count,
    rev.average_review_score,
    rev.low_review_count,
    rev.high_review_count,

    CASE
        WHEN rev.average_review_score <= 2 THEN 1
        ELSE 0
    END AS has_low_customer_satisfaction,

    CASE
        WHEN o.is_late_delivery = 1
        AND rev.average_review_score <= 2
        THEN 1
        ELSE 0
    END AS late_and_low_review_flag

FROM dbo.silver_orders o

    LEFT JOIN dbo.silver_customers c
    ON o.customer_id = c.customer_id

    LEFT JOIN (
    SELECT
        order_id,
        COUNT(*) AS order_item_count,
        COUNT(DISTINCT product_id) AS distinct_product_count,
        COUNT(DISTINCT seller_id) AS distinct_seller_count,
        SUM(price) AS total_item_revenue,
        SUM(freight_value) AS total_freight_value,
        AVG(freight_to_price_ratio) AS average_freight_to_price_ratio,
        MAX(has_zero_freight) AS has_zero_freight_order
    FROM dbo.silver_order_items
    GROUP BY order_id
) oi
    ON o.order_id = oi.order_id

    LEFT JOIN (
    SELECT
        order_id,
        COUNT(*) AS payment_record_count,
        SUM(payment_value) AS total_payment_value,
        MAX(payment_installments) AS max_payment_installments,
        MAX(has_invalid_payment_value + has_zero_payment_value + has_invalid_payment_installments + has_zero_payment_installments) AS has_payment_exception,
        MIN(payment_type) AS primary_payment_type
    FROM dbo.silver_order_payments
    GROUP BY order_id
) pay
    ON o.order_id = pay.order_id

    LEFT JOIN (
    SELECT
        order_id,
        COUNT(*) AS review_record_count,
        AVG(CAST(review_score AS DECIMAL(18, 2))) AS average_review_score,
        SUM(is_low_review_score) AS low_review_count,
        SUM(is_high_review_score) AS high_review_count
    FROM dbo.silver_order_reviews
    GROUP BY order_id
) rev
    ON o.order_id = rev.order_id;
GO