-- Create Silver products table in Fabric Warehouse.
-- This table standardises product attributes and joins English product category labels.

IF OBJECT_ID('dbo.silver_products', 'U') IS NOT NULL
    DROP TABLE dbo.silver_products;
GO

CREATE TABLE dbo.silver_products
AS
SELECT
    p.product_id,
    p.product_category_name,
    t.product_category_name_english,
    t.product_category_name_english_label,

    p.product_name_length,
    p.product_description_length,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm,

    CASE
        WHEN p.product_length_cm > 0
        AND p.product_height_cm > 0
        AND p.product_width_cm > 0
        THEN p.product_length_cm * p.product_height_cm * p.product_width_cm
        ELSE NULL
    END AS product_volume_cm3,

    CASE
        WHEN p.product_category_name IS NULL THEN 1
        ELSE 0
    END AS has_missing_product_category,

    CASE
        WHEN p.product_category_name IS NOT NULL
        AND t.product_category_name_english IS NULL
        THEN 1
        ELSE 0
    END AS has_missing_category_translation,

    CASE
        WHEN p.product_weight_g IS NULL OR p.product_weight_g <= 0 THEN 1
        ELSE 0
    END AS has_invalid_product_weight,

    CASE
        WHEN p.product_length_cm IS NULL OR p.product_length_cm <= 0
        OR p.product_height_cm IS NULL OR p.product_height_cm <= 0
        OR p.product_width_cm IS NULL OR p.product_width_cm <= 0
        THEN 1
        ELSE 0
    END AS has_invalid_product_dimensions

FROM (
    SELECT
        LTRIM(RTRIM(CAST(product_id AS VARCHAR(100)))) AS product_id,
        LOWER(LTRIM(RTRIM(CAST(product_category_name AS VARCHAR(200))))) AS product_category_name,

        TRY_CAST(product_name_lenght AS INT) AS product_name_length,
        TRY_CAST(product_description_lenght AS INT) AS product_description_length,
        TRY_CAST(product_photos_qty AS INT) AS product_photos_qty,
        TRY_CAST(product_weight_g AS DECIMAL(18, 2)) AS product_weight_g,
        TRY_CAST(product_length_cm AS DECIMAL(18, 2)) AS product_length_cm,
        TRY_CAST(product_height_cm AS DECIMAL(18, 2)) AS product_height_cm,
        TRY_CAST(product_width_cm AS DECIMAL(18, 2)) AS product_width_cm
    FROM dbo.stg_products
) p
    LEFT JOIN dbo.silver_product_category_translation t
    ON p.product_category_name = t.product_category_name;
GO