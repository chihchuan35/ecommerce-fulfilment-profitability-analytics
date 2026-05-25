-- Check row counts for raw tables loaded into Fabric.
-- These tables are loaded directly from the Olist CSV files.

    SELECT 'olist_customers_dataset' AS table_name, COUNT(*) AS row_count
    FROM dbo.olist_customers_dataset

UNION ALL

    SELECT 'olist_order_items_dataset' AS table_name, COUNT(*) AS row_count
    FROM dbo.olist_order_items_dataset

UNION ALL

    SELECT 'olist_order_payments_dataset' AS table_name, COUNT(*) AS row_count
    FROM dbo.olist_order_payments_dataset

UNION ALL

    SELECT 'olist_order_reviews_dataset' AS table_name, COUNT(*) AS row_count
    FROM dbo.olist_order_reviews_dataset

UNION ALL

    SELECT 'olist_orders_dataset' AS table_name, COUNT(*) AS row_count
    FROM dbo.olist_orders_dataset

UNION ALL

    SELECT 'olist_products_dataset' AS table_name, COUNT(*) AS row_count
    FROM dbo.olist_products_dataset

UNION ALL

    SELECT 'olist_sellers_dataset' AS table_name, COUNT(*) AS row_count
    FROM dbo.olist_sellers_dataset

UNION ALL

    SELECT 'product_category_name_translation' AS table_name, COUNT(*) AS row_count
    FROM dbo.product_category_name_translation;