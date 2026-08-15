/*
===============================================================================
Project Name : E-Commerce Sales Analysis using SQL Server

File Name    : 10_Seller_Analysis.sql

Author       : Mayur Sandip Mali

Description  :
This script analyzes seller performance, revenue contribution,
sales volume, and geographical distribution to identify the
best-performing sellers.

Database     : EcommerceDB
===============================================================================
*/


/*==============================================================================
Business Question 1:
How many sellers are registered in the marketplace?
==============================================================================*/
SELECT COUNT(*) AS Total_Sellers
FROM raw_sellers;
/*
Business Insight:
• Shows the total number of active sellers in the marketplace.
*/


/*==============================================================================
Business Question 2:
Which sellers have fulfilled the highest number of orders?
==============================================================================*/
SELECT TOP 10
    seller_id,
    COUNT(order_id) AS Total_Orders
FROM raw_order_items
GROUP BY seller_id
ORDER BY Total_Orders DESC;
/*
Business Insight:
• Identifies sellers with the highest order volume.
• These sellers are key contributors to marketplace activity.
*/


/*==============================================================================
Business Question 3:
Which sellers generated the highest revenue?
==============================================================================*/
SELECT TOP 10
    seller_id,
    ROUND(SUM(price),2) AS Revenue
FROM raw_order_items
GROUP BY seller_id
ORDER BY Revenue DESC;
/*
Business Insight:
• High revenue sellers contribute significantly to overall sales.
• Useful for reward programs and strategic partnerships.
*/


/*==============================================================================
Business Question 4:
Average Order Value by Seller
==============================================================================*/
SELECT TOP 10
    seller_id,
    ROUND(AVG(price),2) AS Average_Order_Value
FROM raw_order_items
GROUP BY seller_id
ORDER BY Average_Order_Value DESC;
/*
Business Insight:
• Sellers with higher average order values often specialize
  in premium products.
*/


/*==============================================================================
Business Question 5:
Seller Distribution by State
==============================================================================*/
SELECT
    seller_state,
    COUNT(*) AS Total_Sellers
FROM raw_sellers
GROUP BY seller_state
ORDER BY Total_Sellers DESC;
/*
Business Insight:
• Highlights regions with the highest concentration of sellers.
• Useful for supply chain and regional expansion planning.
*/


/*==============================================================================
Business Question 6:
Revenue by Seller State
==============================================================================*/
SELECT
    s.seller_state,
    ROUND(SUM(oi.price),2) AS Revenue
FROM raw_sellers s
JOIN raw_order_items oi
ON s.seller_id = oi.seller_id
GROUP BY s.seller_state
ORDER BY Revenue DESC;
/*
Business Insight:
• Identifies states generating the highest seller revenue.
*/


/*==============================================================================
Business Question 7:
Rank Sellers by Revenue
==============================================================================*/
SELECT
    seller_id,
    SUM(price) AS Revenue,
    RANK() OVER
    (
        ORDER BY SUM(price) DESC
    ) AS Seller_Rank
FROM raw_order_items
GROUP BY seller_id;
/*
Business Insight:
• Assigns revenue-based ranking to each seller.
• Useful for incentive and performance evaluation.
*/


/*==============================================================================
Business Question 8:
Top Seller in Each State
==============================================================================*/
WITH SellerRevenue AS
(
    SELECT
        s.seller_state,
        oi.seller_id,
        SUM(oi.price) AS Revenue,
        ROW_NUMBER() OVER
        (
            PARTITION BY s.seller_state
            ORDER BY SUM(oi.price) DESC
        ) AS RN
    FROM raw_sellers s
    JOIN raw_order_items oi
    ON s.seller_id = oi.seller_id
    GROUP BY
        s.seller_state,
        oi.seller_id
)
SELECT *
FROM SellerRevenue
WHERE RN = 1;
/*
Business Insight:
• Identifies the highest revenue-generating seller in every state.
*/


/*==============================================================================
Business Question 9:
Top 20% Sellers based on Revenue
==============================================================================*/
WITH SellerRevenue AS
(
    SELECT
        seller_id,
        SUM(price) AS Revenue,
        NTILE(5) OVER
        (
            ORDER BY SUM(price) DESC
        ) AS Revenue_Group

    FROM raw_order_items
    GROUP BY seller_id
)
SELECT *
FROM SellerRevenue
WHERE Revenue_Group = 1;
/*
Business Insight:
• Identifies the top-performing 20% sellers.
• Useful for loyalty and incentive programs.
*/


/*==============================================================================
Business Question 10:
Seller Performance Summary
==============================================================================*/
SELECT
    seller_id,
    COUNT(order_id) AS Orders_Fulfilled,
    ROUND(SUM(price),2) AS Revenue,
    ROUND(AVG(price),2) AS Average_Order_Value
FROM raw_order_items
GROUP BY seller_id
ORDER BY Revenue DESC;


/*
==============================================================================
SELLER ANALYSIS SUMMARY
==============================================================================

Key Findings:

• Identified top-performing sellers.
• Ranked sellers based on revenue.
• Analyzed seller-wise average order value.
• Compared seller distribution across states.
• Identified revenue contribution by state.
• Ranked sellers using Window Functions.
• Identified top 20% sellers using NTILE().

Business Value:

These insights help the company identify strategic sellers,
design reward programs, improve regional operations,
and optimize marketplace performance.

==============================================================================
*/