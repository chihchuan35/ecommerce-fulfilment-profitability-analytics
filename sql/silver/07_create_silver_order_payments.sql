-- Create Silver order payments table in Fabric Warehouse.
-- This table standardises payment fields and creates payment exception flags.

IF OBJECT_ID('dbo.silver_order_payments', 'U') IS NOT NULL
    DROP TABLE dbo.silver_order_payments;
GO

CREATE TABLE dbo.silver_order_payments
AS
SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value,

    CASE
        WHEN payment_value IS NULL OR payment_value < 0 THEN 1
        ELSE 0
    END AS has_invalid_payment_value,

    CASE
        WHEN payment_value = 0 THEN 1
        ELSE 0
    END AS has_zero_payment_value,

    CASE
        WHEN payment_installments IS NULL OR payment_installments < 0 THEN 1
        ELSE 0
    END AS has_invalid_payment_installments,

    CASE
        WHEN payment_installments = 0 THEN 1
        ELSE 0
    END AS has_zero_payment_installments,

    CASE
        WHEN payment_type = 'voucher' THEN 1
        ELSE 0
    END AS is_voucher_payment

FROM (
    SELECT
        LTRIM(RTRIM(CAST(order_id AS VARCHAR(100)))) AS order_id,
        TRY_CAST(payment_sequential AS INT) AS payment_sequential,
        LOWER(LTRIM(RTRIM(CAST(payment_type AS VARCHAR(50))))) AS payment_type,
        TRY_CAST(payment_installments AS INT) AS payment_installments,
        TRY_CAST(payment_value AS DECIMAL(18, 2)) AS payment_value
    FROM dbo.stg_order_payments
) payments_clean;
GO