-- Create Silver product category translation table.
-- This table standardises category names and prepares English reporting labels.

IF OBJECT_ID('dbo.silver_product_category_translation', 'U') IS NOT NULL
    DROP TABLE dbo.silver_product_category_translation;
GO

CREATE TABLE dbo.silver_product_category_translation
AS
SELECT
    LOWER(LTRIM(RTRIM(CAST(product_category_name AS VARCHAR(200))))) AS product_category_name,
    LOWER(LTRIM(RTRIM(CAST(product_category_name_english AS VARCHAR(200))))) AS product_category_name_english,
    REPLACE(
        LOWER(LTRIM(RTRIM(CAST(product_category_name_english AS VARCHAR(200))))),
        '_',
        ' '
    ) AS product_category_name_english_label
FROM dbo.stg_product_category_translation;
GO