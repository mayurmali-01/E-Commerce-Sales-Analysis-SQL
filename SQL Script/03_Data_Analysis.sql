/*
===============================================================================
Project Name : E-Commerce Sales Analysis using SQL Server

File Name    : 03_Data_Analysis.sql

Author       : Mayur Sandip Mali

Description  :
This script validates data quality by checking duplicates,
missing values, and primary key uniqueness.

Database     : EcommerceDB
===============================================================================
*/


/******************************************************************************
STEP 1 : Check Total Records
******************************************************************************/
SELECT 'customers' AS Table_Name, COUNT(*) AS Total_Rows FROM raw_customers
UNION ALL
SELECT 'orders', COUNT(*) FROM raw_orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM raw_order_items
UNION ALL
SELECT 'products', COUNT(*) FROM raw_products
UNION ALL
SELECT 'sellers', COUNT(*) FROM raw_sellers
UNION ALL
SELECT 'payments', COUNT(*) FROM raw_payments
UNION ALL
SELECT 'category_translation', COUNT(*) FROM raw_category_translation;


SELECT TOP 5 * FROM raw_customers;
SELECT TOP 5 * FROM raw_orders;
SELECT TOP 5 * FROM raw_order_items;
SELECT TOP 5 * FROM raw_products;
SELECT TOP 5 * FROM raw_sellers;
SELECT TOP 5 * FROM raw_category_translation;
SELECT TOP 5 * FROM raw_payments;