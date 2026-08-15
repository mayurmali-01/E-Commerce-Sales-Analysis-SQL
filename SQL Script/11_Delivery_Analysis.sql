/*
===============================================================================
Project Name : E-Commerce Sales Analysis using SQL Server

File Name    : 11_Delivery_Analysis.sql

Author       : Mayur Sandip Mali

Description  :
This script analyzes delivery performance, shipping efficiency,
delivery delays, and logistics KPIs.

Database     : EcommerceDB
===============================================================================
*/


/*==============================================================================
Business Question 1:
What is the average delivery time for delivered orders?
==============================================================================*/
SELECT
    ROUND(
        AVG(DATEDIFF(DAY,
            order_purchase_timestamp,
            order_delivered_customer_date
        )),2
    ) AS Avg_Delivery_Days
FROM raw_orders
WHERE order_status = 'delivered';
/*
Business Insight:
• Measures the average number of days taken to deliver an order.
• Helps evaluate overall logistics performance.
*/


/*==============================================================================
Business Question 2:
What is the average time taken to hand over an order to the carrier?
==============================================================================*/
SELECT
    ROUND(
        AVG(DATEDIFF(DAY,
            order_purchase_timestamp,
            order_delivered_carrier_date
        )),2
    ) AS Avg_Shipping_Days
FROM raw_orders
WHERE order_status = 'delivered';
/*
Business Insight:
• Indicates the efficiency of order processing before shipment.
*/


/*==============================================================================
Business Question 3:
What is the average transit time from carrier to customer?
==============================================================================*/
SELECT
    ROUND(
        AVG(DATEDIFF(DAY,
            order_delivered_carrier_date,
            order_delivered_customer_date
        )),2
    ) AS Avg_Transit_Days
FROM raw_orders
WHERE order_status = 'delivered';
/*
Business Insight:
• Measures how long the shipping carrier takes to deliver
  an order after receiving it.
*/


/*==============================================================================
Business Question 4:
How many orders were delivered after the estimated delivery date?
==============================================================================*/
SELECT
    COUNT(*) AS Late_Deliveries
FROM raw_orders
WHERE order_status = 'delivered'
AND order_delivered_customer_date > order_estimated_delivery_date;
/*
Business Insight:
• Late deliveries negatively impact customer satisfaction
  and overall service quality.
*/


/*==============================================================================
Business Question 5:
How many orders were delivered on or before the estimated date?
==============================================================================*/
SELECT
    COUNT(*) AS On_Time_Deliveries
FROM raw_orders
WHERE order_status = 'delivered'
AND order_delivered_customer_date <= order_estimated_delivery_date;
/*
Business Insight:
• Represents successful on-time deliveries and logistics efficiency.
*/


/*==============================================================================
Business Question 6:
What percentage of delivered orders were delivered on time?
==============================================================================*/
SELECT
    ROUND(
        (
            SUM(CASE
                    WHEN order_delivered_customer_date <= order_estimated_delivery_date
                    THEN 1
                    ELSE 0
                END) * 100.0
        ) / COUNT(*),
        2
    ) AS On_Time_Delivery_Percentage
FROM raw_orders
WHERE order_status = 'delivered';
/*
Business Insight:
• A key logistics KPI used to evaluate delivery performance.
• Higher percentages indicate better customer service.
*/


/*==============================================================================
Business Question 7:
What is the average delivery time for each order status?
==============================================================================*/
SELECT
    order_status,
    ROUND(
        AVG(DATEDIFF(DAY,
            order_purchase_timestamp,
            order_delivered_customer_date
        )),2
    ) AS Avg_Delivery_Days
FROM raw_orders
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY order_status
ORDER BY Avg_Delivery_Days;
/*
Business Insight:
• Helps compare delivery performance across different order statuses.
*/


/*==============================================================================
Business Question 8:
Which states placed the highest number of delivered orders?
==============================================================================*/
SELECT
    c.customer_state,
    COUNT(o.order_id) AS Total_Orders
FROM raw_customers c
JOIN raw_orders o
ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY Total_Orders DESC;
/*
Business Insight:
• Identifies states with the highest delivery demand.
• Useful for warehouse and logistics planning.
*/


/*==============================================================================
Business Question 9:
Which states have the longest average delivery time?
==============================================================================*/
SELECT
    c.customer_state,
    ROUND(
        AVG(DATEDIFF(DAY,
            o.order_purchase_timestamp,
            o.order_delivered_customer_date
        )),2
    ) AS Avg_Delivery_Days
FROM raw_customers c
JOIN raw_orders o
ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY Avg_Delivery_Days DESC;
/*
Business Insight:
• States with higher delivery times may require logistics improvements.
*/


/*==============================================================================
Business Question 10:
Which orders were delivered the fastest?
==============================================================================*/
SELECT TOP 10
    order_id,
    DATEDIFF(
        DAY,
        order_purchase_timestamp,
        order_delivered_customer_date
    ) AS Delivery_Days
FROM raw_orders
WHERE order_status = 'delivered'
ORDER BY Delivery_Days ASC;
/*
Business Insight:
• Highlights the fastest deliveries in the dataset.
• Can be used to identify best-performing logistics operations.
*/


/*==============================================================================
Business Question 11:
Which orders took the longest to deliver?
==============================================================================*/
SELECT TOP 10
    order_id,
    DATEDIFF(
        DAY,
        order_purchase_timestamp,
        order_delivered_customer_date
    ) AS Delivery_Days
FROM raw_orders
WHERE order_status = 'delivered'
ORDER BY Delivery_Days DESC;
/*
Business Insight:
• Identifies extreme delivery delays.
• These cases should be investigated to improve logistics performance.
*/


/*==============================================================================
DELIVERY ANALYSIS SUMMARY
==============================================================================
Key Findings:

• Calculated the average delivery time for completed orders.
• Measured order processing and shipping efficiency.
• Evaluated average transit time from carrier to customer.
• Identified late and on-time deliveries.
• Calculated the overall on-time delivery percentage.
• Compared delivery performance across different states.
• Identified the fastest and slowest deliveries.

Business Value:

This analysis helps evaluate logistics performance, monitor delivery
service quality, identify operational bottlenecks, and improve customer
satisfaction by optimizing the order fulfillment process.

==============================================================================*/