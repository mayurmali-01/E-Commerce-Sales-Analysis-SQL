/*
===============================================================================
Project Name : E-Commerce Sales Analysis using SQL Server

File Name    : 13_Advanced_SQL.sql

Author       : Mayur Sandip Mali

Description  :
This script demonstrates advanced SQL concepts including
CTEs, Window Functions, Ranking, Subqueries and Business Analytics.

Database     : EcommerceDB
===============================================================================
*/


/*==============================================================================
Business Question 1:
Rank the Top 10 Customers by Total Spending
==============================================================================*/
WITH CustomerRevenue AS
(
    SELECT
        c.customer_unique_id,
        SUM(p.payment_value) AS Total_Spent
    FROM raw_customers c
    JOIN raw_orders o
        ON c.customer_id = o.customer_id
    JOIN raw_payments p
        ON o.order_id = p.order_id
    GROUP BY c.customer_unique_id
)
SELECT TOP 10
    customer_unique_id,
    Total_Spent,
    RANK() OVER(ORDER BY Total_Spent DESC) AS Customer_Rank
FROM CustomerRevenue;
/*
Business Insight:
• Identifies the company's highest-value customers.
*/


/*==============================================================================
Business Question 2:
Monthly Revenue Growth
==============================================================================*/
WITH MonthlyRevenue AS
(
    SELECT
        YEAR(o.order_purchase_timestamp) AS Sales_Year,
        MONTH(o.order_purchase_timestamp) AS Sales_Month,
        SUM(p.payment_value) AS Revenue
    FROM raw_orders o
    JOIN raw_payments p
        ON o.order_id = p.order_id
    GROUP BY
        YEAR(o.order_purchase_timestamp),
        MONTH(o.order_purchase_timestamp)
)
SELECT
    Sales_Year,
    Sales_Month,
    Revenue,
    LAG(Revenue) OVER
    (
        ORDER BY Sales_Year, Sales_Month
    ) AS Previous_Month_Revenue,
    Revenue -
    LAG(Revenue) OVER
    (
        ORDER BY Sales_Year, Sales_Month
    ) AS Revenue_Growth
FROM MonthlyRevenue;
/*
Business Insight:
• Measures month-over-month business growth.
*/


/*==============================================================================
Business Question 3:
Top Product in Each Category
==============================================================================*/
WITH ProductSales AS
(
SELECT
    p.product_category_name,
    oi.product_id,
    SUM(oi.price) AS Revenue,
    ROW_NUMBER() OVER
    (
        PARTITION BY p.product_category_name
        ORDER BY SUM(oi.price) DESC
    ) AS RN
FROM raw_products p
JOIN raw_order_items oi
ON p.product_id=oi.product_id
GROUP BY
p.product_category_name,
oi.product_id
)
SELECT *
FROM ProductSales
WHERE RN=1;
/*
Business Insight:
• Identifies the highest revenue product in every category.
*/


/*==============================================================================
Business Question 4:
Running Revenue Total
==============================================================================*/
WITH MonthlyRevenue AS
(
SELECT
YEAR(o.order_purchase_timestamp) AS Sales_Year,
MONTH(o.order_purchase_timestamp) AS Sales_Month,
SUM(p.payment_value) AS Revenue
FROM raw_orders o
JOIN raw_payments p
ON o.order_id=p.order_id
GROUP BY
YEAR(o.order_purchase_timestamp),
MONTH(o.order_purchase_timestamp)
)
SELECT
Sales_Year,
Sales_Month,
Revenue,
SUM(Revenue) OVER
(
ORDER BY Sales_Year,Sales_Month
) AS Running_Revenue
FROM MonthlyRevenue;
/*
Business Insight:
• Shows cumulative business growth.
*/


/*==============================================================================
Business Question 5:
Revenue Quartiles using NTILE()
==============================================================================*/
WITH CustomerRevenue AS
(
SELECT
c.customer_unique_id,
SUM(p.payment_value) AS Revenue
FROM raw_customers c
JOIN raw_orders o
ON c.customer_id=o.customer_id
JOIN raw_payments p
ON o.order_id=p.order_id
GROUP BY c.customer_unique_id
)
SELECT
customer_unique_id,
Revenue,
NTILE(4) OVER
(
ORDER BY Revenue DESC
) AS Revenue_Quartile
FROM CustomerRevenue;
/*
Business Insight:
• Segments customers into four spending groups.
*/


/*==============================================================================
Business Question 6:
Highest Order Value in Every State
==============================================================================*/
WITH StateRevenue AS
(
SELECT
c.customer_state,
o.order_id,
SUM(p.payment_value) AS Revenue,
ROW_NUMBER() OVER
(
PARTITION BY c.customer_state
ORDER BY SUM(p.payment_value) DESC
) AS RN
FROM raw_customers c
JOIN raw_orders o
ON c.customer_id=o.customer_id
JOIN raw_payments p
ON o.order_id=p.order_id
GROUP BY
c.customer_state,
o.order_id
)
SELECT *
FROM StateRevenue
WHERE RN=1;
/*
Business Insight:
• Finds the highest-value order from each state.
*/


/*==============================================================================
Business Question 7:
Above Average Orders
==============================================================================*/
SELECT
order_id,
payment_value
FROM raw_payments
WHERE payment_value >
(
SELECT AVG(payment_value)
FROM raw_payments
);
/*
Business Insight:
• Identifies payments above the company average.
*/


/*==============================================================================
Business Question 8:
Customer Classification
==============================================================================*/
WITH CustomerRevenue AS
(
SELECT
c.customer_unique_id,
SUM(p.payment_value) AS Revenue
FROM raw_customers c
JOIN raw_orders o
ON c.customer_id=o.customer_id
JOIN raw_payments p
ON o.order_id=p.order_id
GROUP BY c.customer_unique_id
)
SELECT
customer_unique_id,
Revenue,
CASE
WHEN Revenue>=1000 THEN 'Premium'
WHEN Revenue>=500 THEN 'Gold'
WHEN Revenue>=200 THEN 'Silver'
ELSE 'Regular'
END AS Customer_Category
FROM CustomerRevenue
ORDER BY Revenue DESC;
/*
Business Insight:
• Segments customers into spending categories.
*/


/*==============================================================================
Business Question 9:
Top 5 Products by Revenue in Each Category
==============================================================================*/
WITH ProductRevenue AS
(
SELECT
p.product_category_name,
oi.product_id,
SUM(oi.price) AS Revenue,
DENSE_RANK() OVER
(
PARTITION BY p.product_category_name
ORDER BY SUM(oi.price) DESC
) AS Product_Rank
FROM raw_products p
JOIN raw_order_items oi
ON p.product_id=oi.product_id
GROUP BY
p.product_category_name,
oi.product_id
)
SELECT *
FROM ProductRevenue
WHERE Product_Rank<=5;
/*
Business Insight:
• Identifies the five highest revenue products in each category.
*/


/*==============================================================================
Business Question 10:
Overall Business KPI
==============================================================================*/
SELECT
COUNT(DISTINCT o.order_id) AS Total_Orders,
COUNT(DISTINCT c.customer_unique_id) AS Unique_Customers,
COUNT(DISTINCT oi.product_id) AS Products_Sold,
ROUND(SUM(p.payment_value),2) AS Total_Revenue,
ROUND(AVG(p.payment_value),2) AS Average_Order_Value
FROM raw_orders o
JOIN raw_customers c
ON o.customer_id=c.customer_id
JOIN raw_payments p
ON o.order_id=p.order_id
JOIN raw_order_items oi
ON o.order_id=oi.order_id;
/*
Business Insight:
• Provides an executive-level KPI summary.
*/


/*==============================================================================
ADVANCED SQL SUMMARY
==============================================================================

Advanced SQL Concepts Covered

✓ Common Table Expressions (CTEs)
✓ Window Functions
✓ RANK()
✓ DENSE_RANK()
✓ ROW_NUMBER()
✓ NTILE()
✓ LAG()
✓ Running Total
✓ CASE Expression
✓ Aggregate Functions
✓ Complex JOINs
✓ Subqueries
✓ Business Segmentation
✓ Executive KPI Reporting

Business Value

This file demonstrates advanced SQL techniques commonly used by
Data Analysts and Business Intelligence professionals for reporting,
customer segmentation, trend analysis, and executive dashboards.

==============================================================================*/