-- Create Gold order item profitability table in Fabric Warehouse.
-- Grain: one row per order item.
-- Purpose: support freight pressure, product category, seller, and fulfilment analysis.
-- Note: This table does not calculate actual profit because product cost data is not available.
-- It uses freight-to-price ratio as a margin pressure indicator.

IF OBJECT_ID('dbo.gold_order_item_profitability', 'U') IS NOT NULL
    DROP TABLE dbo.gold_order_item_profitability;
GO

CREATE TABLE dbo.gold_order_item_profitability
AS
SELECT
    oi.order_id,
    oi.order_item_id,
    oi.product_id,
    oi.seller_id,

    o.customer_id,
    c.customer_city,
    c.customer_state,

    s.seller_city,
    s.seller_state,

    p.product_category_name,
    p.product_category_name_english,
    p.product_category_name_english_label,

    oi.shipping_limit_date,
    o.order_purchase_timestamp,
    o.order_purchase_date,
    o.order_status,

    o.is_delivered,
    o.is_late_delivery,
    o.delivery_delay_days,
    o.has_invalid_delivery_sequence,

    oi.price AS item_price,
    oi.freight_value,
    oi.freight_to_price_ratio,

    CASE
        WHEN oi.freight_to_price_ratio >= 0.50 THEN 1
        ELSE 0
    END AS is_high_freight_pressure,

    CASE
        WHEN oi.freight_to_price_ratio >= 0.30
        AND oi.freight_to_price_ratio < 0.50
        THEN 1
        ELSE 0
    END AS is_medium_freight_pressure,

    CASE
        WHEN oi.freight_to_price_ratio < 0.30 THEN 1
        ELSE 0
    END AS is_low_freight_pressure,

    oi.has_invalid_price,
    oi.has_invalid_freight,
    oi.has_zero_freight,

    p.product_weight_g,
    p.product_volume_cm3,
    p.has_missing_product_category,
    p.has_missing_category_translation,
    p.has_invalid_product_weight,
    p.has_invalid_product_dimensions,

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
    END AS late_and_low_review_flag,

    CASE
        WHEN oi.freight_to_price_ratio >= 0.50
        AND o.is_late_delivery = 1
        THEN 1
        ELSE 0
    END AS high_freight_and_late_delivery_flag

FROM dbo.silver_order_items oi

    LEFT JOIN dbo.silver_orders o
    ON oi.order_id = o.order_id

    LEFT JOIN dbo.silver_customers c
    ON o.customer_id = c.customer_id

    LEFT JOIN dbo.silver_sellers s
    ON oi.seller_id = s.seller_id

    LEFT JOIN dbo.silver_products p
    ON oi.product_id = p.product_id

    LEFT JOIN (
    SELECT
        order_id,
        AVG(CAST(review_score AS DECIMAL(18, 2))) AS average_review_score,
        SUM(is_low_review_score) AS low_review_count,
        SUM(is_high_review_score) AS high_review_count
    FROM dbo.silver_order_reviews
    GROUP BY order_id
) rev
    ON oi.order_id = rev.order_id;
GO