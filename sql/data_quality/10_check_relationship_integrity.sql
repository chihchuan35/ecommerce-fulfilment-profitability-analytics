-- Check relationship integrity across raw loaded tables.
-- This validates whether key relationships required for Silver and Gold modelling can be joined correctly.

    SELECT
        'orders_to_customers' AS relationship_name,
        'olist_orders_dataset.customer_id -> olist_customers_dataset.customer_id' AS relationship_rule,
        COUNT(*) AS missing_reference_count
    FROM dbo.olist_orders_dataset o
        LEFT JOIN dbo.olist_customers_dataset c
        ON o.customer_id = c.customer_id
    WHERE c.customer_id IS NULL

UNION ALL

    SELECT
        'order_items_to_orders' AS relationship_name,
        'olist_order_items_dataset.order_id -> olist_orders_dataset.order_id' AS relationship_rule,
        COUNT(*) AS missing_reference_count
    FROM dbo.olist_order_items_dataset oi
        LEFT JOIN dbo.olist_orders_dataset o
        ON oi.order_id = o.order_id
    WHERE o.order_id IS NULL

UNION ALL

    SELECT
        'order_items_to_products' AS relationship_name,
        'olist_order_items_dataset.product_id -> olist_products_dataset.product_id' AS relationship_rule,
        COUNT(*) AS missing_reference_count
    FROM dbo.olist_order_items_dataset oi
        LEFT JOIN dbo.olist_products_dataset p
        ON oi.product_id = p.product_id
    WHERE p.product_id IS NULL

UNION ALL

    SELECT
        'order_items_to_sellers' AS relationship_name,
        'olist_order_items_dataset.seller_id -> olist_sellers_dataset.seller_id' AS relationship_rule,
        COUNT(*) AS missing_reference_count
    FROM dbo.olist_order_items_dataset oi
        LEFT JOIN dbo.olist_sellers_dataset s
        ON oi.seller_id = s.seller_id
    WHERE s.seller_id IS NULL

UNION ALL

    SELECT
        'payments_to_orders' AS relationship_name,
        'olist_order_payments_dataset.order_id -> olist_orders_dataset.order_id' AS relationship_rule,
        COUNT(*) AS missing_reference_count
    FROM dbo.olist_order_payments_dataset pay
        LEFT JOIN dbo.olist_orders_dataset o
        ON pay.order_id = o.order_id
    WHERE o.order_id IS NULL

UNION ALL

    SELECT
        'reviews_to_orders' AS relationship_name,
        'olist_order_reviews_metadata.order_id -> olist_orders_dataset.order_id' AS relationship_rule,
        COUNT(*) AS missing_reference_count
    FROM dbo.olist_order_reviews_metadata r
        LEFT JOIN dbo.olist_orders_dataset o
        ON r.order_id = o.order_id
    WHERE o.order_id IS NULL;