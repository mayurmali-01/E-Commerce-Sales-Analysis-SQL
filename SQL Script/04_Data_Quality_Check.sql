/*
===============================================================================
Project Name : E-Commerce Sales Analysis using SQL Server

File Name    : 04_Data_Quality_Check.sql

Author       : Mayur Sandip Mali

Description  :
This script validates data quality by checking duplicates,
missing values, and primary key uniqueness.

Database     : EcommerceDB
===============================================================================
*/

SELECT customer_id, COUNT(*) AS duplicate_count FROM raw_customers GROUP BY customer_id HAVING COUNT(*) > 1;
SELECT order_id, COUNT(*) AS duplicate_count FROM raw_orders GROUP BY order_id HAVING COUNT(*) > 1;
SELECT product_id, COUNT(*) AS duplicate_count FROM raw_products GROUP BY product_id HAVING COUNT(*) > 1;
SELECT seller_id, COUNT(*) AS duplicate_count FROM raw_sellers GROUP BY seller_id HAVING COUNT(*) > 1;
SELECT seller_id, COUNT(*) AS duplicate_count FROM raw_sellers GROUP BY seller_id HAVING COUNT(*) > 1;
SELECT order_id,order_item_id, COUNT(*) AS duplicate_count FROM raw_order_items GROUP BY order_id,order_item_id HAVING COUNT(*) > 1;
SELECT order_id,payment_sequential, COUNT(*) AS duplicate_count FROM raw_payments GROUP BY order_id,payment_sequential HAVING COUNT(*) > 1;

/*===========================================================
                NULL VALUE ANALYSIS
Purpose:
Check for missing values in each table and determine
whether they are expected or indicate data quality issues.
===========================================================*/

/*-----------------------------------------------------------
Check NULL values in Customers table
-----------------------------------------------------------*/
SELECT
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS customer_id_nulls,
    SUM(CASE WHEN customer_unique_id IS NULL THEN 1 ELSE 0 END) AS customer_unique_id_nulls,
    SUM(CASE WHEN customer_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS zipcode_nulls,
    SUM(CASE WHEN customer_city IS NULL THEN 1 ELSE 0 END) AS city_nulls,
    SUM(CASE WHEN customer_state IS NULL THEN 1 ELSE 0 END) AS state_nulls
FROM raw_customers;

/*-----------------------------------------------------------
Check NULL values in Orders table
-----------------------------------------------------------*/
SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_nulls,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS customer_id_nulls,
    SUM(CASE WHEN order_status IS NULL THEN 1 ELSE 0 END) AS order_status_nulls,
    SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END) AS purchase_date_nulls,
    SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END) AS approved_date_nulls,
    SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) AS carrier_date_nulls,
    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS delivered_date_nulls,
    SUM(CASE WHEN order_estimated_delivery_date IS NULL THEN 1 ELSE 0 END) AS estimated_delivery_nulls
FROM raw_orders;

/*-----------------------------------------------------------
Check NULL values in Product table
-----------------------------------------------------------*/
SELECT
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS product_id_nulls,
    SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) AS category_nulls,
    SUM(CASE WHEN product_name_lenght IS NULL THEN 1 ELSE 0 END) AS name_length_nulls,
    SUM(CASE WHEN product_description_lenght IS NULL THEN 1 ELSE 0 END) AS description_length_nulls,
    SUM(CASE WHEN product_photos_qty IS NULL THEN 1 ELSE 0 END) AS photos_nulls,
    SUM(CASE WHEN product_weight_g IS NULL THEN 1 ELSE 0 END) AS weight_nulls,
    SUM(CASE WHEN product_length_cm IS NULL THEN 1 ELSE 0 END) AS length_nulls,
    SUM(CASE WHEN product_height_cm IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN product_width_cm IS NULL THEN 1 ELSE 0 END) AS width_nulls
FROM raw_products;

/*-----------------------------------------------------------
Check NULL values in Sellers table
-----------------------------------------------------------*/
SELECT
    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS seller_id_nulls,
    SUM(CASE WHEN seller_zip_code_prefix IS NULL THEN 1 ELSE 0 END) AS zipcode_nulls,
    SUM(CASE WHEN seller_city IS NULL THEN 1 ELSE 0 END) AS city_nulls,
    SUM(CASE WHEN seller_state IS NULL THEN 1 ELSE 0 END) AS state_nulls
FROM raw_sellers;

/*-----------------------------------------------------------
Check NULL values in Payments table
-----------------------------------------------------------*/
SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_nulls,
    SUM(CASE WHEN payment_sequential IS NULL THEN 1 ELSE 0 END) AS payment_sequence_nulls,
    SUM(CASE WHEN payment_type IS NULL THEN 1 ELSE 0 END) AS payment_type_nulls,
    SUM(CASE WHEN payment_installments IS NULL THEN 1 ELSE 0 END) AS installments_nulls,
    SUM(CASE WHEN payment_value IS NULL THEN 1 ELSE 0 END) AS payment_value_nulls
FROM raw_payments;

/*-----------------------------------------------------------
Check NULL values in Order_items table
-----------------------------------------------------------*/
SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS order_id_nulls,
    SUM(CASE WHEN order_item_id IS NULL THEN 1 ELSE 0 END) AS order_item_nulls,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS product_id_nulls,
    SUM(CASE WHEN seller_id IS NULL THEN 1 ELSE 0 END) AS seller_id_nulls,
    SUM(CASE WHEN shipping_limit_date IS NULL THEN 1 ELSE 0 END) AS shipping_limit_nulls,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS price_nulls,
    SUM(CASE WHEN freight_value IS NULL THEN 1 ELSE 0 END) AS freight_nulls
FROM raw_order_items;

/*-----------------------------------------------------------
Check NULL values in Category_translation table
-----------------------------------------------------------*/
SELECT
    SUM(CASE WHEN column1 IS NULL THEN 1 ELSE 0 END) AS category_name_nulls,
    SUM(CASE WHEN column2 IS NULL THEN 1 ELSE 0 END) AS english_name_nulls
FROM raw_category_translation;

--Count of null values 
SELECT
    COUNT(*) AS Total_Orders,
    SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END) AS order_approved_at_nulls,
    SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) AS carrier_date_nulls,
    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS delivered_customer_date_nulls
FROM raw_orders;

SELECT
    COUNT(*) AS Total_Products,
    SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) AS category_nulls,
    SUM(CASE WHEN product_name_lenght IS NULL THEN 1 ELSE 0 END) AS name_length_nulls,
    SUM(CASE WHEN product_description_lenght IS NULL THEN 1 ELSE 0 END) AS description_length_nulls,
    SUM(CASE WHEN product_photos_qty IS NULL THEN 1 ELSE 0 END) AS photos_nulls,
    SUM(CASE WHEN product_weight_g IS NULL THEN 1 ELSE 0 END) AS weight_nulls,
    SUM(CASE WHEN product_length_cm IS NULL THEN 1 ELSE 0 END) AS length_nulls,
    SUM(CASE WHEN product_height_cm IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN product_width_cm IS NULL THEN 1 ELSE 0 END) AS width_nulls
FROM raw_products;

SELECT order_status, COUNT(*) AS Total_Orders
FROM raw_orders
WHERE order_approved_at IS NULL
GROUP BY order_status;

SELECT TOP 20 *
FROM raw_products
WHERE product_category_name IS NULL;

SELECT *
FROM raw_orders
WHERE order_status = 'delivered'
AND order_approved_at IS NULL;

/*
============================================================
Insight - Orders Table

Observation:
The orders table contains NULL values in approval and
delivery-related date columns.

Investigation:
• 141 NULL approval dates belong to cancelled orders.
• 5 NULL approval dates belong to created orders.
• 14 delivered orders have NULL approval dates.

Analysis:
Cancelled and created orders are expected to have
missing approval timestamps.

However, delivered orders should normally have an
approval timestamp before shipment. These 14 records
represent inconsistencies in the source dataset.

Decision:
The records will be retained because they represent
less than 0.02% of the dataset and do not materially
affect overall business analysis.

============================================================
*/

