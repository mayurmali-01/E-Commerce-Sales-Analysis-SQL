/*
===============================================================================
Project Name : E-Commerce Sales Analysis using SQL Server

File Name    : 14_Views.sql

Author       : Mayur Sandip Mali

Description  :
This script creates reusable SQL Views for reporting,
business intelligence, and dashboard development.

Database     : EcommerceDB
===============================================================================
*/


/*==============================================================================
View 1 : Customer Order Details
==============================================================================*/
CREATE VIEW vw_Customer_Orders
AS
SELECT
    o.order_id,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_estimated_delivery_date,
    o.order_delivered_customer_date
FROM raw_orders o
JOIN raw_customers c
ON o.customer_id=c.customer_id;
GO
/*
Purpose:
Provides customer and order information in one place.
Useful for customer reports and dashboards.
*/


/*==============================================================================
View 2 : Sales Details
==============================================================================*/
CREATE VIEW vw_Sales_Details
AS
SELECT
    o.order_id,
    YEAR(o.order_purchase_timestamp) AS Order_Year,
    MONTH(o.order_purchase_timestamp) AS Order_Month,
    p.payment_type,
    p.payment_value
FROM raw_orders o
JOIN raw_payments p
ON o.order_id=p.order_id;
GO
/*
Purpose:
Provides sales information for revenue reporting.
*/


/*==============================================================================
View 3 : Product Sales
==============================================================================*/
CREATE VIEW vw_Product_Sales
AS
SELECT
    oi.product_id,
    p.product_category_name,
    COUNT(*) AS Units_Sold,
    SUM(oi.price) AS Revenue,
    AVG(oi.price) AS Average_Price
FROM raw_order_items oi
JOIN raw_products p
ON oi.product_id=p.product_id
GROUP BY
oi.product_id,
p.product_category_name;
GO
/*
Purpose:
Provides product performance information.
*/


/*==============================================================================
View 4 : Seller Performance
==============================================================================*/
CREATE VIEW vw_Seller_Performance
AS
SELECT
    s.seller_id,
    s.seller_state,
    COUNT(oi.order_id) AS Orders,
    SUM(oi.price) AS Revenue,
    AVG(oi.price) AS Average_Order_Value
FROM raw_sellers s
JOIN raw_order_items oi
ON s.seller_id=oi.seller_id
GROUP BY
s.seller_id,
s.seller_state;
GO
/*
Purpose:
Used to analyze seller performance.
*/


/*==============================================================================
View 5 : Delivery Performance
==============================================================================*/
CREATE VIEW vw_Delivery_Performance
AS
SELECT
order_id,
order_status,
DATEDIFF
(
DAY,
order_purchase_timestamp,
order_delivered_customer_date
) AS Delivery_Days
FROM raw_orders
WHERE order_status='delivered';
GO
/*
Purpose:
Provides delivery KPI for dashboards.
*/


/*==============================================================================
View 6 : Customer Revenue
==============================================================================*/
CREATE VIEW vw_Customer_Revenue
AS
SELECT
c.customer_unique_id,
SUM(p.payment_value) AS Total_Revenue
FROM raw_customers c
JOIN raw_orders o
ON c.customer_id=o.customer_id
JOIN raw_payments p
ON o.order_id=p.order_id
GROUP BY
c.customer_unique_id;
GO
/*
Purpose:
Shows total spending by each customer.
*/


/*==============================================================================
View 7 : State Revenue
==============================================================================*/
CREATE VIEW vw_State_Revenue
AS
SELECT
c.customer_state,
SUM(p.payment_value) AS Revenue
FROM raw_customers c
JOIN raw_orders o
ON c.customer_id=o.customer_id
JOIN raw_payments p
ON o.order_id=p.order_id
GROUP BY
c.customer_state;
GO
/*
Purpose:
State-wise revenue reporting.
*/


/*==============================================================================
View 8 : Monthly Revenue
==============================================================================*/
CREATE VIEW vw_Monthly_Revenue
AS
SELECT
YEAR(o.order_purchase_timestamp) AS Sales_Year,
MONTH(o.order_purchase_timestamp) AS Sales_Month,
SUM(p.payment_value) AS Revenue
FROM raw_orders o
JOIN raw_payments p
ON o.order_id=p.order_id
GROUP BY
YEAR(o.order_purchase_timestamp),
MONTH(o.order_purchase_timestamp);
GO
/*
Purpose:
Monthly revenue trend reporting.
*/


/*==============================================================================
Example Queries using Views
==============================================================================*/
SELECT TOP 10 *
FROM vw_Customer_Orders;
SELECT *
FROM vw_Product_Sales
ORDER BY Revenue DESC;
SELECT *
FROM vw_Seller_Performance
ORDER BY Revenue DESC;
SELECT *
FROM vw_State_Revenue
ORDER BY Revenue DESC;
SELECT *
FROM vw_Monthly_Revenue
ORDER BY Sales_Year, Sales_Month;


/*==============================================================================
VIEWS SUMMARY
==============================================================================

Views Created

✓ vw_Customer_Orders
✓ vw_Sales_Details
✓ vw_Product_Sales
✓ vw_Seller_Performance
✓ vw_Delivery_Performance
✓ vw_Customer_Revenue
✓ vw_State_Revenue
✓ vw_Monthly_Revenue

Business Value

• Eliminates repetitive JOIN operations.
• Simplifies dashboard creation.
• Improves query readability.
• Provides reusable business datasets.
• Supports Power BI and reporting tools.

===============================================================================
*/