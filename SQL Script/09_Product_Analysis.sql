/*
===============================================================================
Project Name : E-Commerce Sales Analysis using SQL Server

File Name    : 09_Product_Analysis.sql

Author       : Mayur Sandip Mali

Description  :
This script analyzes product performance, category-wise sales,
pricing, and revenue contribution to identify high-performing
products and business opportunities.

Database     : EcommerceDB
===============================================================================
*/

/*==============================================================================
Business Question 1:
Top 10 Best-Selling Products
==============================================================================*/
SELECT TOP 10
    oi.product_id,
    COUNT(*) AS Total_Units_Sold
FROM raw_order_items oi
GROUP BY oi.product_id
ORDER BY Total_Units_Sold DESC;
/*
Business Insight:

• These products have the highest sales volume.
• They should receive priority in inventory management.
• High-demand products can be featured in promotional campaigns.
*/

/*==============================================================================
Business Question 2:
Top 10 Revenue Generating Products
==============================================================================*/
SELECT TOP 10
    oi.product_id,
    ROUND(SUM(oi.price),2) AS Revenue
FROM raw_order_items oi
GROUP BY oi.product_id
ORDER BY Revenue DESC;
/*
Business Insight:

• These products contribute the highest revenue.
• Revenue leaders are not always the most frequently sold products.
• Comparing sales volume with revenue helps identify premium products.
*/

/*==============================================================================
Business Question 3:
Products with Highest Average Selling Price
==============================================================================*/
SELECT TOP 10
    product_id,
    ROUND(AVG(price),2) AS Average_Price
FROM raw_order_items
GROUP BY product_id
ORDER BY Average_Price DESC;

/*==============================================================================
Business Question 4:
Product Category Performance
==============================================================================*/
SELECT
    p.product_category_name,
    COUNT(oi.order_id) AS Total_Items_Sold
FROM raw_products p
JOIN raw_order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY Total_Items_Sold DESC;
/*
Business Insight:

• Identifies the most popular product categories.
• Helps marketing teams focus on high-performing categories.
• Useful for assortment planning and category management.
*/

/*==============================================================================
Business Question 5:
Revenue by Product Category
==============================================================================*/
SELECT
    p.product_category_name,
    ROUND(SUM(oi.price),2) AS Revenue
FROM raw_products p
JOIN raw_order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY Revenue DESC;

/*==============================================================================
Business Question 6:
Average Freight Cost by Category
==============================================================================*/
SELECT
    p.product_category_name,
    ROUND(AVG(oi.freight_value),2) AS Average_Freight
FROM raw_products p
JOIN raw_order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY Average_Freight DESC;
/*
Business Insight:

• Categories with high freight costs may impact profitability.
• Useful for logistics optimization and shipping strategy.
*/

/*==============================================================================
Business Question 7:
Rank Products by Revenue
==============================================================================*/
SELECT
    product_id,
    SUM(price) AS Revenue,
    RANK() OVER
    (
        ORDER BY SUM(price) DESC
    ) AS Product_Rank
FROM raw_order_items
GROUP BY product_id;

/*==============================================================================
Business Question 8:
Top 5 Products in Each Category
==============================================================================*/
WITH ProductRevenue AS
(
    SELECT
        p.product_category_name,
        oi.product_id,
        SUM(oi.price) AS Revenue,

        ROW_NUMBER() OVER
        (
            PARTITION BY p.product_category_name
            ORDER BY SUM(oi.price) DESC
        ) AS Rank_Number
    FROM raw_products p
    JOIN raw_order_items oi
        ON p.product_id = oi.product_id
    GROUP BY
        p.product_category_name,
        oi.product_id
)
SELECT *
FROM ProductRevenue
WHERE Rank_Number <= 5
ORDER BY
    product_category_name,
    Revenue DESC;

/*
==============================================================================
PRODUCT ANALYSIS SUMMARY
==============================================================================

Key Findings:

• Identified the top-selling products by sales volume.
• Identified products generating the highest revenue.
• Analyzed average selling prices across products.
• Evaluated product category performance.
• Compared freight costs across categories.
• Ranked products using SQL window functions.
• Identified the top 5 products within each category.

Business Value:

These insights support inventory management, pricing strategies,
product promotions, and category-level decision making while helping
the business maximize revenue and optimize product performance.

==============================================================================*/