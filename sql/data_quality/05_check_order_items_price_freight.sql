-- Check price and freight value quality in the raw order items table.
-- This helps identify item-level records that may affect freight pressure and profitability analysis.

WITH
    order_items
    AS
    (
        SELECT
            order_id,
            order_item_id,
            product_id,
            seller_id,
            TRY_CAST(price AS DECIMAL(18, 2)) AS price,
            TRY_CAST(freight_value AS DECIMAL(18, 2)) AS freight_value
        FROM dbo.olist_order_items_dataset
    )

SELECT
    COUNT(*) AS total_order_items,

    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS missing_order_id,
    SUM(CASE WHEN order_item_id IS NULL THEN 1 ELSE 0 END) AS missing_order_item_id,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS missing_product_id,
    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS missing_seller_id,

    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS missing_or_invalid_price,
    SUM(CASE WHEN freight_value IS NULL THEN 1 ELSE 0 END) AS missing_or_invalid_freight_value,

    SUM(CASE WHEN price <= 0 THEN 1 ELSE 0 END) AS zero_or_negative_price_count,
    SUM(CASE WHEN freight_value < 0 THEN 1 ELSE 0 END) AS negative_freight_value_count,
    SUM(CASE WHEN freight_value = 0 THEN 1 ELSE 0 END) AS zero_freight_value_count,

    CAST(AVG(price) AS DECIMAL(18, 2)) AS average_price,
    CAST(AVG(freight_value) AS DECIMAL(18, 2)) AS average_freight_value
FROM order_items;