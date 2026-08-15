/*
===============================================================================
Project Name : E-Commerce Sales Analysis using SQL Server

File Name    : 07_Sales_Analysis.sql

Author       : Mayur Sandip Mali

Description  :
This script analyzes the sales performance of the e-commerce business
by answering key business questions related to revenue, order trends,
and sales growth.

Database     : EcommerceDB
===============================================================================
*/

/*==============================================================================
Business Question 1:
What is the total revenue generated?
==============================================================================*/
SELECT SUM(payment_value) AS Total_Revenue
FROM raw_payments;
/*
Business Insight:

• This KPI represents the total revenue generated from all customer payments.
• It provides a high-level overview of business performance.
• This metric serves as the baseline for all future sales analysis.
*/

/*==============================================================================
Business Question 2:
What is the Average Order Value (AOV)?
==============================================================================*/
SELECT AVG(payment_value) AS Average_Order_Value
FROM raw_payments;
/*
Business Insight:

• Average Order Value (AOV) measures the average amount spent
  by customers per payment transaction.
• Increasing AOV is a common business strategy to improve revenue.
*/

/*==============================================================================
Business Question 3:
Revenue by Payment Method
==============================================================================*/
SELECT payment_type, ROUND(SUM(payment_value),2) AS Revenue
FROM raw_payments
GROUP BY payment_type
ORDER BY Revenue DESC;
/*
Business Insight:

• Identifies the payment methods contributing the most revenue.
• Helps the finance team understand customer payment preferences.
• Can support decisions on payment gateway optimization.
*/

/*==============================================================================
Business Question 4:
How many orders were placed using each payment method?
==============================================================================*/
SELECT payment_type, COUNT(*) AS Total_Transactions
FROM raw_payments
GROUP BY payment_type
ORDER BY Total_Transactions DESC;

/*==============================================================================
Business Question 5:
What is the highest payment recorded?
==============================================================================*/
SELECT MAX(payment_value) AS Highest_Payment
FROM raw_payments;

/*==============================================================================
Business Question 6:
What is the lowest payment recorded?
==============================================================================*/
SELECT MIN(payment_value) AS Lowest_Payment
FROM raw_payments;

/*==============================================================================
Business Question 7:
Overall Payment Statistics
==============================================================================*/
SELECT
    COUNT(*) AS Total_Payments,
    SUM(payment_value) AS Total_Revenue,
    AVG(payment_value) AS Average_Payment,
    MIN(payment_value) AS Minimum_Payment,
    MAX(payment_value) AS Maximum_Payment
FROM raw_payments;

/*==============================================================================
Business Question 8:
Monthly Revenue Trend
==============================================================================*/
SELECT
    YEAR(o.order_purchase_timestamp) AS Order_Year,
    MONTH(o.order_purchase_timestamp) AS Order_Month,
    ROUND(SUM(p.payment_value),2) AS Total_Revenue
FROM raw_orders o
INNER JOIN raw_payments p
ON o.order_id = p.order_id
GROUP BY
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)
ORDER BY
    Order_Year,
    Order_Month;
/*
Business Insight:

• Monthly revenue trend highlights seasonal fluctuations in sales.
• Peak-performing months may correspond to promotional campaigns,
  festive seasons, or increased customer demand.
• Low-performing months can help management identify opportunities
  for marketing and sales improvement.

*/

/*==============================================================================
Business Question 9:
Yearly Revenue
==============================================================================*/
SELECT
    YEAR(o.order_purchase_timestamp) AS Order_Year,
    ROUND(SUM(p.payment_value),2) AS Total_Revenue
FROM raw_orders o
JOIN raw_payments p
ON o.order_id = p.order_id
GROUP BY YEAR(o.order_purchase_timestamp)
ORDER BY Order_Year;
/*
Business Insight:

• Shows annual business growth.
• Useful for comparing overall company performance across years.
*/

/*==============================================================================
Business Question 10:
Monthly Order Trend
==============================================================================*/
SELECT
    YEAR(order_purchase_timestamp) AS Order_Year,
    MONTH(order_purchase_timestamp) AS Order_Month,
    COUNT(order_id) AS Total_Orders
FROM raw_orders
GROUP BY
    YEAR(order_purchase_timestamp),
    MONTH(order_purchase_timestamp)
ORDER BY
    Order_Year,
    Order_Month;
/*
Business Insight:

• Helps understand customer purchasing activity over time.
• Comparing monthly orders with monthly revenue can reveal
  whether revenue changes are driven by more orders or
  higher order values.
*/


/*==============================================================================
Business Question 11:
Average Monthly Revenue
==============================================================================*/
WITH MonthlyRevenue AS
(
    SELECT
        YEAR(o.order_purchase_timestamp) AS Order_Year,
        MONTH(o.order_purchase_timestamp) AS Order_Month,
        SUM(p.payment_value) AS Revenue
    FROM raw_orders o
    JOIN raw_payments p
        ON o.order_id = p.order_id
    GROUP BY
        YEAR(o.order_purchase_timestamp),
        MONTH(o.order_purchase_timestamp)
)

SELECT
    ROUND(AVG(Revenue),2) AS Average_Monthly_Revenue
FROM MonthlyRevenue;