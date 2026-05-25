-- Create Warehouse staging table for Olist orders.
-- Source data is read from the Fabric Lakehouse raw table.

IF OBJECT_ID('dbo.stg_orders', 'U') IS NOT NULL
    DROP TABLE dbo.stg_orders;
GO

CREATE TABLE dbo.stg_orders
AS
SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM [lh_olist_raw].[dbo].[olist_orders_dataset];
GO