-- Create source-aligned staging table for Olist orders data.
-- Data type conversion and business rules are handled in the Silver layer.

IF OBJECT_ID('dbo.stg_orders', 'U') IS NOT NULL
    DROP TABLE dbo.stg_orders;
GO

CREATE TABLE dbo.stg_orders
(
    order_id VARCHAR(50) NOT NULL,
    customer_id VARCHAR(50) NULL,
    order_status VARCHAR(50) NULL,
    order_purchase_timestamp VARCHAR(50) NULL,
    order_approved_at VARCHAR(50) NULL,
    order_delivered_carrier_date VARCHAR(50) NULL,
    order_delivered_customer_date VARCHAR(50) NULL,
    order_estimated_delivery_date VARCHAR(50) NULL
);
GO