-- Create Silver order items table in Fabric Warehouse.
-- This table standardises item-level product, seller, price, freight, and shipping fields.

IF OBJECT_ID('dbo.silver_order_items', 'U') IS NOT NULL
    DROP TABLE dbo.silver_order_items;
GO

CREATE TABLE dbo.silver_order_items
AS
SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value,

    CASE
        WHEN price > 0 THEN CAST(freight_value / price AS DECIMAL(18, 4))
        ELSE NULL
    END AS freight_to_price_ratio,

    CASE
        WHEN price IS NULL OR price <= 0 THEN 1
        ELSE 0
    END AS has_invalid_price,

    CASE
        WHEN freight_value IS NULL OR freight_value < 0 THEN 1
        ELSE 0
    END AS has_invalid_freight,

    CASE
        WHEN freight_value = 0 THEN 1
        ELSE 0
    END AS has_zero_freight

FROM (
    SELECT
        LTRIM(RTRIM(CAST(order_id AS VARCHAR(100)))) AS order_id,
        TRY_CAST(order_item_id AS INT) AS order_item_id,
        LTRIM(RTRIM(CAST(product_id AS VARCHAR(100)))) AS product_id,
        LTRIM(RTRIM(CAST(seller_id AS VARCHAR(100)))) AS seller_id,
        TRY_CAST(shipping_limit_date AS DATETIME2(0)) AS shipping_limit_date,
        TRY_CAST(price AS DECIMAL(18, 2)) AS price,
        TRY_CAST(freight_value AS DECIMAL(18, 2)) AS freight_value
    FROM dbo.stg_order_items
) order_items_clean;
GO