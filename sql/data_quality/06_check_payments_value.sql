-- Check payment value and instalment quality in the raw payments table.
-- This helps validate payment records before using them for revenue and profitability analysis.

WITH
    payments
    AS
    (
        SELECT
            order_id,
            TRY_CAST(payment_sequential AS INT) AS payment_sequential,
            payment_type,
            TRY_CAST(payment_installments AS INT) AS payment_installments,
            TRY_CAST(payment_value AS DECIMAL(18, 2)) AS payment_value
        FROM dbo.olist_order_payments_dataset
    )

SELECT
    COUNT(*) AS total_payment_records,

    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS missing_order_id,
    SUM(CASE WHEN payment_sequential IS NULL THEN 1 ELSE 0 END) AS missing_or_invalid_payment_sequential,
    SUM(CASE WHEN payment_type IS NULL THEN 1 ELSE 0 END) AS missing_payment_type,
    SUM(CASE WHEN payment_installments IS NULL THEN 1 ELSE 0 END) AS missing_or_invalid_payment_installments,
    SUM(CASE WHEN payment_value IS NULL THEN 1 ELSE 0 END) AS missing_or_invalid_payment_value,

    SUM(CASE WHEN payment_installments < 0 THEN 1 ELSE 0 END) AS negative_payment_installments_count,
    SUM(CASE WHEN payment_installments = 0 THEN 1 ELSE 0 END) AS zero_payment_installments_count,
    SUM(CASE WHEN payment_value < 0 THEN 1 ELSE 0 END) AS negative_payment_value_count,
    SUM(CASE WHEN payment_value = 0 THEN 1 ELSE 0 END) AS zero_payment_value_count,

    CAST(AVG(payment_value) AS DECIMAL(18, 2)) AS average_payment_value
FROM payments;