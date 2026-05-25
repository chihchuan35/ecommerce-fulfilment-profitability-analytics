-- Create Silver order reviews table in Fabric Warehouse.
-- This table uses the Fabric-safe review metadata staging table.
-- The expected grain is one row per order-review relationship.

IF OBJECT_ID('dbo.silver_order_reviews', 'U') IS NOT NULL
    DROP TABLE dbo.silver_order_reviews;
GO

CREATE TABLE dbo.silver_order_reviews
AS
SELECT
    review_grain_key,
    review_id,
    order_id,
    review_score,
    review_creation_date,
    review_answer_timestamp,
    review_creation_date_only,

    CASE
        WHEN review_score IS NULL OR review_score < 1 OR review_score > 5 THEN 1
        ELSE 0
    END AS has_invalid_review_score,

    CASE
        WHEN review_score <= 2 THEN 1
        ELSE 0
    END AS is_low_review_score,

    CASE
        WHEN review_score >= 4 THEN 1
        ELSE 0
    END AS is_high_review_score

FROM (
    SELECT
        CONCAT(
            LTRIM(RTRIM(CAST(review_id AS VARCHAR(100)))),
            '|',
            LTRIM(RTRIM(CAST(order_id AS VARCHAR(100))))
        ) AS review_grain_key,

        LTRIM(RTRIM(CAST(review_id AS VARCHAR(100)))) AS review_id,
        LTRIM(RTRIM(CAST(order_id AS VARCHAR(100)))) AS order_id,
        TRY_CAST(review_score AS INT) AS review_score,
        TRY_CAST(review_creation_date AS DATETIME2(0)) AS review_creation_date,
        TRY_CAST(review_answer_timestamp AS DATETIME2(0)) AS review_answer_timestamp,
        CAST(TRY_CAST(review_creation_date AS DATETIME2(0)) AS DATE) AS review_creation_date_only
    FROM dbo.stg_order_reviews
) reviews_clean;
GO