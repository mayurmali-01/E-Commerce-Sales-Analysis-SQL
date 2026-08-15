/*
===============================================================================
Project Name : E-Commerce Sales Analysis using SQL Server

File Name    : 05_Referential_Integrity_Check.sql

Author       : Mayur Sandip Mali

Description  :
This script validates relationships between tables by checking
for orphan records.

Database     : EcommerceDB
===============================================================================
*/

/*-----------------------------------------------------------
Business Rule:
Every order must belong to a valid customer.
-----------------------------------------------------------*/

SELECT COUNT(*) AS Invalid_Customer_References
FROM raw_orders o
LEFT JOIN raw_customers c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

/*-----------------------------------------------------------
Check 1: Orders → Customers
Business Rule:
Every order must belong to a valid customer.
-----------------------------------------------------------*/
SELECT COUNT(*) AS Invalid_Customer_References
FROM raw_orders o
LEFT JOIN raw_customers c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

/*-----------------------------------------------------------
Check 2: Order_Items → Orders
Business Rule:
Every order item should reference an existing order.
-----------------------------------------------------------*/
SELECT COUNT(*) AS Invalid_Order_References
FROM raw_order_items oi
LEFT JOIN raw_orders o
ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

/*-----------------------------------------------------------
Check 3: Order_Items → Products
Business Rule:
Every ordered product should exist in the products table.
-----------------------------------------------------------*/
SELECT COUNT(*) AS Invalid_Product_References
FROM raw_order_items oi
LEFT JOIN raw_products p
ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

/*-----------------------------------------------------------
Check 4: Order_Items → Sellers
Business Rule:
Every order item should reference an existing seller.
-----------------------------------------------------------*/
SELECT COUNT(*) AS Invalid_Seller_References
FROM raw_order_items oi
LEFT JOIN raw_sellers s
ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

/*-----------------------------------------------------------
Check 5: Payments → Orders
Business Rule:
Every payment should reference an existing order.
-----------------------------------------------------------*/
SELECT COUNT(*) AS Invalid_Payment_Order_References
FROM raw_payments p
LEFT JOIN raw_orders o
ON p.order_id = o.order_id
WHERE o.order_id IS NULL;

/*
============================================================
REFERENTIAL INTEGRITY SUMMARY

✓ Every order belongs to a valid customer.
✓ Every order item belongs to a valid order.
✓ Every ordered product exists in the products table.
✓ Every seller referenced in an order exists.
✓ Every payment belongs to a valid order.

Conclusion:
The dataset passed all referential integrity checks.
No orphan records were found.
The database is ready for business analysis.

============================================================
*/

