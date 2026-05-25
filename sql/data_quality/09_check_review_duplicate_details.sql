-- Inspect duplicate review_id records in the Fabric-safe review metadata table.
-- This helps determine whether review_id can be used as the table grain,
-- or whether the Silver review table should use a different business rule.

WITH
    duplicate_reviews
    AS
    (
        SELECT
            review_id
        FROM dbo.olist_order_reviews_metadata
        GROUP BY review_id
        HAVING COUNT(*) > 1
    )

SELECT TOP 100
    r.review_id,
    r.order_id,
    r.review_score,
    r.review_creation_date,
    r.review_answer_timestamp
FROM dbo.olist_order_reviews_metadata r
    INNER JOIN duplicate_reviews d
    ON r.review_id = d.review_id
ORDER BY
    r.review_id,
    r.order_id,
    r.review_creation_date;