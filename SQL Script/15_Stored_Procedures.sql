/*
===============================================================================
Project Name : E-Commerce Sales Analysis using SQL Server

File Name    : 15_Stored_Procedures.sql

Author       : Mayur Sandip Mali

Description  :
This script creates reusable Stored Procedures for business reporting
and analysis.

Database     : EcommerceDB
===============================================================================
*/

-------------------------------------------------------------------------------
-- Procedure 1 : Total Revenue
-------------------------------------------------------------------------------
CREATE PROCEDURE sp_TotalRevenue
AS
BEGIN
    SELECT
        ROUND(SUM(payment_value),2) AS Total_Revenue
    FROM raw_payments;
END;
GO
-------------------------------------------------------------------------------
-- Execute
-------------------------------------------------------------------------------
EXEC sp_TotalRevenue;
GO


-------------------------------------------------------------------------------
-- Procedure 2 : Revenue by Year
-------------------------------------------------------------------------------
CREATE PROCEDURE sp_RevenueByYear
    @Year INT
AS
BEGIN
    SELECT
        YEAR(o.order_purchase_timestamp) AS Sales_Year,
        ROUND(SUM(p.payment_value),2) AS Revenue
    FROM raw_orders o
    JOIN raw_payments p
        ON o.order_id=p.order_id
    WHERE YEAR(o.order_purchase_timestamp)=@Year
    GROUP BY YEAR(o.order_purchase_timestamp);
END;
GO
EXEC sp_RevenueByYear @Year=2018;
GO


-------------------------------------------------------------------------------
-- Procedure 3 : Top N Customers
-------------------------------------------------------------------------------
CREATE PROCEDURE sp_TopCustomers
@TopN INT
AS
BEGIN
SELECT TOP (@TopN)
c.customer_unique_id,
ROUND(SUM(p.payment_value),2) AS Total_Spent
FROM raw_customers c
JOIN raw_orders o
ON c.customer_id=o.customer_id
JOIN raw_payments p
ON o.order_id=p.order_id
GROUP BY c.customer_unique_id
ORDER BY Total_Spent DESC;
END;
GO
EXEC sp_TopCustomers @TopN=10;
GO


-------------------------------------------------------------------------------
-- Procedure 4 : Top N Products
-------------------------------------------------------------------------------
CREATE PROCEDURE sp_TopProducts
@TopN INT
AS
BEGIN
SELECT TOP (@TopN)
oi.product_id,
ROUND(SUM(oi.price),2) AS Revenue
FROM raw_order_items oi
GROUP BY oi.product_id
ORDER BY Revenue DESC;
END;
GO
EXEC sp_TopProducts @TopN=10;
GO


-------------------------------------------------------------------------------
-- Procedure 5 : Revenue by State
-------------------------------------------------------------------------------
CREATE PROCEDURE sp_StateRevenue
@State CHAR(2)
AS
BEGIN
SELECT
c.customer_state,
ROUND(SUM(p.payment_value),2) AS Revenue
FROM raw_customers c
JOIN raw_orders o
ON c.customer_id=o.customer_id
JOIN raw_payments p
ON o.order_id=p.order_id
WHERE c.customer_state=@State
GROUP BY c.customer_state;
END;
GO
EXEC sp_StateRevenue @State='SP';
GO


-------------------------------------------------------------------------------
-- Procedure 6 : Seller Performance
-------------------------------------------------------------------------------
CREATE PROCEDURE sp_SellerPerformance
@SellerID VARCHAR(50)
AS
BEGIN
SELECT
seller_id,
COUNT(order_id) AS Orders,
ROUND(SUM(price),2) AS Revenue,
ROUND(AVG(price),2) AS Average_Order_Value
FROM raw_order_items
WHERE seller_id=@SellerID
GROUP BY seller_id;
END;
GO
-- Replace with an actual seller_id from your dataset
EXEC sp_SellerPerformance
@SellerID='3442f8959a84dea7ee197c632cb2df15';
GO


-------------------------------------------------------------------------------
-- Procedure 7 : Monthly Revenue
-------------------------------------------------------------------------------
CREATE PROCEDURE sp_MonthlyRevenue
@Year INT
AS
BEGIN
SELECT
MONTH(o.order_purchase_timestamp) AS Sales_Month,
ROUND(SUM(p.payment_value),2) AS Revenue
FROM raw_orders o
JOIN raw_payments p
ON o.order_id=p.order_id
WHERE YEAR(o.order_purchase_timestamp)=@Year
GROUP BY MONTH(o.order_purchase_timestamp)
ORDER BY Sales_Month;
END;
GO
EXEC sp_MonthlyRevenue @Year=2018;
GO


-------------------------------------------------------------------------------
-- Procedure 8 : Product Category Revenue
-------------------------------------------------------------------------------
CREATE PROCEDURE sp_CategoryRevenue
AS
BEGIN
SELECT
pr.product_category_name,
ROUND(SUM(oi.price),2) AS Revenue
FROM raw_products pr
JOIN raw_order_items oi
ON pr.product_id=oi.product_id
GROUP BY pr.product_category_name
ORDER BY Revenue DESC;
END;
GO
EXEC sp_CategoryRevenue;
GO


-------------------------------------------------------------------------------
-- Procedure 9 : Delivery Performance
-------------------------------------------------------------------------------
CREATE PROCEDURE sp_DeliveryPerformance
AS
BEGIN
SELECT
ROUND(
AVG(
DATEDIFF(
DAY,
order_purchase_timestamp,
order_delivered_customer_date
)
),2
) AS Average_Delivery_Days
FROM raw_orders
WHERE order_status='delivered';
END;
GO
EXEC sp_DeliveryPerformance;
GO


-------------------------------------------------------------------------------
-- Procedure 10 : Customer Purchase History
-------------------------------------------------------------------------------
CREATE PROCEDURE sp_CustomerHistory
@CustomerID VARCHAR(50)
AS
BEGIN
SELECT
o.order_id,
o.order_purchase_timestamp,
o.order_status,
p.payment_value
FROM raw_orders o
JOIN raw_payments p
ON o.order_id=p.order_id
WHERE o.customer_id=@CustomerID
ORDER BY o.order_purchase_timestamp;
END;
GO


-- Replace with an actual customer_id from your dataset
EXEC sp_CustomerHistory
@CustomerID='06b8999e2fba1a1fbc88172c00ba8bc7';
GO


/********************************************************************************
                            STORED PROCEDURE SUMMARY
*********************************************************************************

Stored Procedures Created

✓ sp_TotalRevenue
✓ sp_RevenueByYear
✓ sp_TopCustomers
✓ sp_TopProducts
✓ sp_StateRevenue
✓ sp_SellerPerformance
✓ sp_MonthlyRevenue
✓ sp_CategoryRevenue
✓ sp_DeliveryPerformance
✓ sp_CustomerHistory

Business Value

• Automates frequently used reports.
• Accepts parameters for dynamic reporting.
• Reduces repetitive SQL code.
• Improves maintainability.
• Can be directly consumed by reporting tools and applications.

********************************************************************************/