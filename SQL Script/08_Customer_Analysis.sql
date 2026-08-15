/*
===============================================================================
Project Name : E-Commerce Sales Analysis using SQL Server

File Name    : 08_Customer_Analysis.sql

Author       : Mayur Sandip Mali

Description  :
This script analyzes customer behavior, geographical distribution,
and purchasing patterns to generate business insights.

Database     : EcommerceDB
===============================================================================
*/

/*==============================================================================
Business Question 1:
Customer Distribution by State
==============================================================================*/
SELECT customer_state, COUNT(*) AS Total_Customers
FROM raw_customers
GROUP BY customer_state
ORDER BY Total_Customers DESC;
/*
Business Insight:
• States with the highest customer counts represent the company's
  strongest markets.
• These regions are ideal for targeted marketing campaigns and
  customer retention strategies.
*/

/*==============================================================================
Business Question 2:
Top 10 Cities by Customer Count
==============================================================================*/
SELECT TOP 10 customer_city, COUNT(*) AS Total_Customers
FROM raw_customers
GROUP BY customer_city
ORDER BY Total_Customers DESC;
/*
Business Insight:

• Identifies cities contributing the largest customer base.
• Useful for planning regional promotions and logistics.
*/

/*==============================================================================
Business Question 3:
Customer Distribution by State and City
==============================================================================*/
SELECT
    customer_state,
    customer_city,
    COUNT(*) AS Total_Customers
FROM raw_customers
GROUP BY
    customer_state,
    customer_city
ORDER BY
    customer_state,
    Total_Customers DESC;

/*==============================================================================
Business Question 4:
Which states place the highest number of orders?
==============================================================================*/
SELECT c.customer_state, COUNT(o.order_id) AS Total_Orders
FROM raw_customers c
INNER JOIN raw_orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_state
ORDER BY Total_Orders DESC;
/*
Business Insight:

• States with the highest order volumes contribute significantly
  to overall business activity.
• These regions may require stronger logistics and inventory support.
*/

/*==============================================================================
Business Question 5:
Delivered vs Cancelled Orders by State
==============================================================================*/
SELECT
    c.customer_state,
    o.order_status,
    COUNT(*) AS Total_Orders
FROM raw_customers c
JOIN raw_orders o
ON c.customer_id = o.customer_id
WHERE o.order_status IN ('delivered','canceled')
GROUP BY
    c.customer_state,
    o.order_status
ORDER BY
    c.customer_state,
    Total_Orders DESC;
/*
Business Insight:

• Compares successful and cancelled orders across states.
• States with relatively higher cancellation counts may require
  further investigation into operational or customer issues.
*/

/*==============================================================================
Business Question 6:
Top 10 Customers by Order Count
==============================================================================*/
SELECT TOP 10 c.customer_unique_id, COUNT(o.order_id) AS Total_Orders
FROM raw_customers c
JOIN raw_orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
ORDER BY Total_Orders DESC;
/*
Business Insight:

• Identifies the most active customers based on order frequency.
• These customers are valuable candidates for loyalty programs
  and personalized marketing campaigns.
*/


/*
==============================================================================
CUSTOMER ANALYSIS SUMMARY
==============================================================================

Key Findings:

• Customer distribution varies significantly across Brazilian states.
• A few major cities contribute a large share of the customer base.
• Order activity is concentrated in specific regions.
• Customer ordering behavior differs across locations.
• Highly active customers can be targeted for retention and loyalty
  initiatives.

Business Value:

Understanding customer distribution and purchasing behavior helps
the company improve marketing strategies, optimize logistics, and
enhance customer retention.

==============================================================================*/