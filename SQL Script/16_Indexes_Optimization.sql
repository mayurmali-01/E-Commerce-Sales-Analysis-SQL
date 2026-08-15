/*
===============================================================================
Project Name : E-Commerce Sales Analysis using SQL Server

File Name    : 16_Indexes_Optimization.sql

Author       : Mayur Sandip Mali

Description  :
This script creates indexes to improve query performance and
demonstrates basic SQL Server optimization techniques.

Database     : EcommerceDB
===============================================================================
*/


/******************************************************************************
STEP 1 : Check Existing Indexes
******************************************************************************/
EXEC sp_helpindex 'raw_customers';
GO
EXEC sp_helpindex 'raw_orders';
GO
EXEC sp_helpindex 'raw_order_items';
GO
EXEC sp_helpindex 'raw_products';
GO
EXEC sp_helpindex 'raw_sellers';
GO
EXEC sp_helpindex 'raw_payments';
GO
/*
Business Insight:
• Before creating new indexes, always inspect existing indexes.
• Avoid creating duplicate indexes because they consume storage
  and slow INSERT, UPDATE, and DELETE operations.
*/


/******************************************************************************
STEP 2 : Create Non-Clustered Indexes
******************************************************************************/
CREATE NONCLUSTERED INDEX IX_raw_orders_customer_id
ON raw_orders(customer_id);
GO
CREATE NONCLUSTERED INDEX IX_raw_orders_purchase_date
ON raw_orders(order_purchase_timestamp);
GO
CREATE NONCLUSTERED INDEX IX_raw_order_items_product_id
ON raw_order_items(product_id);
GO
CREATE NONCLUSTERED INDEX IX_raw_order_items_seller_id
ON raw_order_items(seller_id);
GO
CREATE NONCLUSTERED INDEX IX_raw_payments_order_id
ON raw_payments(order_id);
GO
CREATE NONCLUSTERED INDEX IX_raw_customers_state
ON raw_customers(customer_state);
GO


/********************************************************************************
Business Insight
These indexes improve:
✓ JOIN performance
✓ WHERE clause filtering
✓ GROUP BY
✓ ORDER BY
********************************************************************************/


/******************************************************************************
STEP 3 : Composite Index
******************************************************************************/
CREATE NONCLUSTERED INDEX IX_raw_orders_Status_Date
ON raw_orders
(
    order_status,
    order_purchase_timestamp
);
GO
/*
Business Insight:
Useful for queries such as
WHERE order_status='delivered'
AND YEAR(order_purchase_timestamp)=2018
*/


/******************************************************************************
STEP 4 : Query Before Optimization
******************************************************************************/
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO
SELECT
customer_state,
COUNT(*) AS Orders
FROM raw_customers c
JOIN raw_orders o
ON c.customer_id=o.customer_id
GROUP BY customer_state;
GO
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO
/*
Business Insight:
Review:
• CPU Time
• Elapsed Time
• Logical Reads
before and after indexing.
*/


/******************************************************************************
STEP 5 : Check Execution Plan
******************************************************************************/
SELECT
customer_state,
COUNT(*) AS Orders
FROM raw_customers c
JOIN raw_orders o
ON c.customer_id=o.customer_id
GROUP BY customer_state;
/*
Business Insight:
Execution Plan helps identify:
✓ Table Scan
✓ Index Scan
✓ Index Seek
✓ Missing Index Recommendations
Aim for Index Seek whenever appropriate.
*/


/******************************************************************************
STEP 6 : Most Frequently Used Query Example
******************************************************************************/
SELECT
YEAR(order_purchase_timestamp) AS Sales_Year,
MONTH(order_purchase_timestamp) AS Sales_Month,
COUNT(*) AS Orders
FROM raw_orders
GROUP BY
YEAR(order_purchase_timestamp),
MONTH(order_purchase_timestamp);
GO
/*
Optimization Suggestion

IX_raw_orders_purchase_date

will improve this query.
*/


/******************************************************************************
STEP 7 : Verify Indexes
******************************************************************************/

EXEC sp_helpindex 'raw_orders';
GO
EXEC sp_helpindex 'raw_order_items';
GO
EXEC sp_helpindex 'raw_customers';
GO
EXEC sp_helpindex 'raw_payments';
GO


/******************************************************************************
STEP 8 : Drop Index (If Required)
******************************************************************************/

-- DROP INDEX IX_raw_orders_customer_id
-- ON raw_orders;

-- DROP INDEX IX_raw_orders_purchase_date
-- ON raw_orders;

-- DROP INDEX IX_raw_order_items_product_id
-- ON raw_order_items;


/*
Business Insight

Indexes should only be dropped if they are

• Unused
• Duplicate
• Increasing write overhead

Never drop indexes without proper analysis.
*/


/******************************************************************************
PERFORMANCE OPTIMIZATION BEST PRACTICES
******************************************************************************/

/*

1. Create indexes on columns frequently used in JOINs.

2. Index columns used in WHERE conditions.

3. Avoid SELECT * whenever possible.

4. Retrieve only required columns.

5. Prefer INNER JOIN over unnecessary OUTER JOIN.

6. Avoid functions on indexed columns inside WHERE clauses.

7. Filter data as early as possible.

8. Keep statistics updated.

9. Review execution plans regularly.

10. Remove unused indexes.

*/


/******************************************************************************
INDEX OPTIMIZATION SUMMARY
******************************************************************************/
/*

Indexes Created

✓ Customer ID Index
✓ Purchase Date Index
✓ Product ID Index
✓ Seller ID Index
✓ Payment Order Index
✓ Customer State Index
✓ Composite Index

SQL Server Concepts Demonstrated

✓ Non-Clustered Index
✓ Composite Index
✓ Statistics IO
✓ Statistics Time
✓ Execution Plan
✓ Query Optimization
✓ Performance Monitoring

Business Value

• Faster reporting
• Faster dashboard refresh
• Reduced query execution time
• Improved scalability
• Better SQL Server performance

******************************************************************************/