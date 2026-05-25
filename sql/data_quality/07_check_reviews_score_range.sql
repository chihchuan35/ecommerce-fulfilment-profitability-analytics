-- Check review score quality in the raw order reviews table.
-- This validates whether review scores are within the expected 1 to 5 range.

WITH
    reviews
    AS
    (
        SELECT
            review_id,
            order_id,
            TRY_CAST(review_score AS INT) AS review_score,
            review_creation_date,
            review_answer_timestamp
        FROM dbo.olist_order_reviews_dataset
    )

SELECT
    COUNT(*) AS total_review_records,

    SUM(CASE WHEN review_id IS NULL THEN 1 ELSE 0 END) AS missing_review_id,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS missing_order_id,
    SUM(CASE WHEN review_score IS NULL THEN 1 ELSE 0 END) AS missing_or_invalid_review_score,

    SUM(CASE WHEN review_score < 1 THEN 1 ELSE 0 END) AS review_score_below_1_count,
    SUM(CASE WHEN review_score > 5 THEN 1 ELSE 0 END) AS review_score_above_5_count,

    SUM(CASE WHEN review_creation_date IS NULL THEN 1 ELSE 0 END) AS missing_review_creation_date,
    SUM(CASE WHEN review_answer_timestamp IS NULL THEN 1 ELSE 0 END) AS missing_review_answer_timestamp,

    CAST(AVG(CAST(review_score AS DECIMAL(18, 2))) AS DECIMAL(18, 2)) AS average_review_score
FROM reviews;