-- Check duplicate business keys across raw loaded tables.
-- This helps confirm whether each source table matches the expected table grain.

    SELECT
        'olist_orders_dataset' AS table_name,
        'order_id' AS business_key,
        COUNT(*) AS duplicate_key_count,
        COALESCE(SUM(record_count), 0) AS duplicate_record_count
    FROM (
    SELECT order_id, COUNT(*) AS record_count
        FROM dbo.olist_orders_dataset
        GROUP BY order_id
        HAVING COUNT(*) > 1
) d

UNION ALL

    SELECT
        'olist_customers_dataset' AS table_name,
        'customer_id' AS business_key,
        COUNT(*) AS duplicate_key_count,
        COALESCE(SUM(record_count), 0) AS duplicate_record_count
    FROM (
    SELECT customer_id, COUNT(*) AS record_count
        FROM dbo.olist_customers_dataset
        GROUP BY customer_id
        HAVING COUNT(*) > 1
) d

UNION ALL

    SELECT
        'olist_sellers_dataset' AS table_name,
        'seller_id' AS business_key,
        COUNT(*) AS duplicate_key_count,
        COALESCE(SUM(record_count), 0) AS duplicate_record_count
    FROM (
    SELECT seller_id, COUNT(*) AS record_count
        FROM dbo.olist_sellers_dataset
        GROUP BY seller_id
        HAVING COUNT(*) > 1
) d

UNION ALL

    SELECT
        'olist_products_dataset' AS table_name,
        'product_id' AS business_key,
        COUNT(*) AS duplicate_key_count,
        COALESCE(SUM(record_count), 0) AS duplicate_record_count
    FROM (
    SELECT product_id, COUNT(*) AS record_count
        FROM dbo.olist_products_dataset
        GROUP BY product_id
        HAVING COUNT(*) > 1
) d

UNION ALL

    SELECT
        'olist_order_items_dataset' AS table_name,
        'order_id + order_item_id' AS business_key,
        COUNT(*) AS duplicate_key_count,
        COALESCE(SUM(record_count), 0) AS duplicate_record_count
    FROM (
    SELECT order_id, order_item_id, COUNT(*) AS record_count
        FROM dbo.olist_order_items_dataset
        GROUP BY order_id, order_item_id
        HAVING COUNT(*) > 1
) d

UNION ALL

    SELECT
        'olist_order_payments_dataset' AS table_name,
        'order_id + payment_sequential' AS business_key,
        COUNT(*) AS duplicate_key_count,
        COALESCE(SUM(record_count), 0) AS duplicate_record_count
    FROM (
    SELECT order_id, payment_sequential, COUNT(*) AS record_count
        FROM dbo.olist_order_payments_dataset
        GROUP BY order_id, payment_sequential
        HAVING COUNT(*) > 1
) d

UNION ALL

    SELECT
        'olist_order_reviews_metadata' AS table_name,
        'review_id' AS business_key,
        COUNT(*) AS duplicate_key_count,
        COALESCE(SUM(record_count), 0) AS duplicate_record_count
    FROM (
    SELECT review_id, COUNT(*) AS record_count
        FROM dbo.olist_order_reviews_metadata
        GROUP BY review_id
        HAVING COUNT(*) > 1
) d

UNION ALL

    SELECT
        'product_category_name_translation' AS table_name,
        'product_category_name' AS business_key,
        COUNT(*) AS duplicate_key_count,
        COALESCE(SUM(record_count), 0) AS duplicate_record_count
    FROM (
    SELECT product_category_name, COUNT(*) AS record_count
        FROM dbo.product_category_name_translation
        GROUP BY product_category_name
        HAVING COUNT(*) > 1
) d;