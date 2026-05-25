-- Check product category translation mapping quality.
-- This validates whether product categories can be mapped to English labels for reporting.

SELECT
    COUNT(*) AS total_products,
    SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) AS missing_product_category_count,
    COUNT(DISTINCT product_category_name) AS distinct_product_category_count
FROM dbo.olist_products_dataset;


-- Check products with a category that does not have an English translation.

SELECT
    COUNT(*) AS products_with_unmapped_category
FROM dbo.olist_products_dataset p
    LEFT JOIN dbo.product_category_name_translation t
    ON p.product_category_name = t.product_category_name
WHERE p.product_category_name IS NOT NULL
    AND t.product_category_name_english IS NULL;


-- List unmapped categories if any exist.

SELECT
    p.product_category_name,
    COUNT(*) AS product_count
FROM dbo.olist_products_dataset p
    LEFT JOIN dbo.product_category_name_translation t
    ON p.product_category_name = t.product_category_name
WHERE p.product_category_name IS NOT NULL
    AND t.product_category_name_english IS NULL
GROUP BY p.product_category_name
ORDER BY product_count DESC;