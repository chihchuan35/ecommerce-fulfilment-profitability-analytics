-- Create remaining Warehouse staging tables from Fabric Lakehouse raw tables.
-- These staging tables stay close to the source structure.
-- Cleaning, type conversion, and business rules are handled in the Silver layer.

IF OBJECT_ID('dbo.stg_customers', 'U') IS NOT NULL
    DROP TABLE dbo.stg_customers;
GO

CREATE TABLE dbo.stg_customers
AS
SELECT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
FROM [lh_olist_raw].[dbo].[olist_customers_dataset];
GO


IF OBJECT_ID('dbo.stg_order_items', 'U') IS NOT NULL
    DROP TABLE dbo.stg_order_items;
GO

CREATE TABLE dbo.stg_order_items
AS
SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
FROM [lh_olist_raw].[dbo].[olist_order_items_dataset];
GO


IF OBJECT_ID('dbo.stg_sellers', 'U') IS NOT NULL
    DROP TABLE dbo.stg_sellers;
GO

CREATE TABLE dbo.stg_sellers
AS
SELECT
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
FROM [lh_olist_raw].[dbo].[olist_sellers_dataset];
GO


IF OBJECT_ID('dbo.stg_products', 'U') IS NOT NULL
    DROP TABLE dbo.stg_products;
GO

CREATE TABLE dbo.stg_products
AS
SELECT
    product_id,
    product_category_name,
    product_name_lenght,
    product_description_lenght,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM [lh_olist_raw].[dbo].[olist_products_dataset];
GO


IF OBJECT_ID('dbo.stg_order_payments', 'U') IS NOT NULL
    DROP TABLE dbo.stg_order_payments;
GO

CREATE TABLE dbo.stg_order_payments
AS
SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
FROM [lh_olist_raw].[dbo].[olist_order_payments_dataset];
GO


IF OBJECT_ID('dbo.stg_order_reviews', 'U') IS NOT NULL
    DROP TABLE dbo.stg_order_reviews;
GO

CREATE TABLE dbo.stg_order_reviews
AS
SELECT
    review_id,
    order_id,
    review_score,
    review_creation_date,
    review_answer_timestamp
FROM [lh_olist_raw].[dbo].[olist_order_reviews_metadata];
GO


IF OBJECT_ID('dbo.stg_product_category_translation', 'U') IS NOT NULL
    DROP TABLE dbo.stg_product_category_translation;
GO

CREATE TABLE dbo.stg_product_category_translation
AS
SELECT
    product_category_name,
    product_category_name_english
FROM [lh_olist_raw].[dbo].[product_category_name_translation];
GO