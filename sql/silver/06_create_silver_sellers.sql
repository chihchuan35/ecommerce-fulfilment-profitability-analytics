-- Create Silver sellers table in Fabric Warehouse.
-- This table standardises seller identifiers and location fields.

IF OBJECT_ID('dbo.silver_sellers', 'U') IS NOT NULL
    DROP TABLE dbo.silver_sellers;
GO

CREATE TABLE dbo.silver_sellers
AS
SELECT
    LTRIM(RTRIM(CAST(seller_id AS VARCHAR(100)))) AS seller_id,
    LTRIM(RTRIM(CAST(seller_zip_code_prefix AS VARCHAR(20)))) AS seller_zip_code_prefix,
    LOWER(LTRIM(RTRIM(CAST(seller_city AS VARCHAR(200))))) AS seller_city,
    UPPER(LTRIM(RTRIM(CAST(seller_state AS VARCHAR(10))))) AS seller_state,

    CASE
        WHEN seller_city IS NULL OR seller_state IS NULL THEN 1
        ELSE 0
    END AS has_missing_seller_location,

    CASE
        WHEN seller_state IS NULL
        OR LEN(LTRIM(RTRIM(CAST(seller_state AS VARCHAR(10))))) <> 2
        THEN 1
        ELSE 0
    END AS has_invalid_seller_state

FROM dbo.stg_sellers;
GO