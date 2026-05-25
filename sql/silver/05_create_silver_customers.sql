-- Create Silver customers table in Fabric Warehouse.
-- This table standardises customer identifiers and location fields.

IF OBJECT_ID('dbo.silver_customers', 'U') IS NOT NULL
    DROP TABLE dbo.silver_customers;
GO

CREATE TABLE dbo.silver_customers
AS
SELECT
    LTRIM(RTRIM(CAST(customer_id AS VARCHAR(100)))) AS customer_id,
    LTRIM(RTRIM(CAST(customer_unique_id AS VARCHAR(100)))) AS customer_unique_id,
    LTRIM(RTRIM(CAST(customer_zip_code_prefix AS VARCHAR(20)))) AS customer_zip_code_prefix,
    LOWER(LTRIM(RTRIM(CAST(customer_city AS VARCHAR(200))))) AS customer_city,
    UPPER(LTRIM(RTRIM(CAST(customer_state AS VARCHAR(10))))) AS customer_state,

    CASE
        WHEN customer_city IS NULL OR customer_state IS NULL THEN 1
        ELSE 0
    END AS has_missing_customer_location,

    CASE
        WHEN customer_state IS NULL
        OR LEN(LTRIM(RTRIM(CAST(customer_state AS VARCHAR(10))))) <> 2
        THEN 1
        ELSE 0
    END AS has_invalid_customer_state

FROM dbo.stg_customers;
GO