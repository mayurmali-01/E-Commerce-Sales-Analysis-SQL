/*
======================================================================
Project Name : E-Commerce Sales Analysis using SQL Server

File Name    : 06_Exploratory_Data_Analysis.sql

Author       : Mayur Sandip Mali

Description  :
This script performs exploratory data analysis (EDA) to understand
the dataset before conducting detailed business analysis.

Database     : EcommerceDB

Created On   : DD-MM-YYYY
======================================================================
*/


/*==============================================================================
                            DATASET OVERVIEW
==============================================================================*/

/*----------------------------------------------------------------------------
Question 1: Total Customers
----------------------------------------------------------------------------*/
SELECT COUNT(*) AS Total_Customers FROM raw_customers;

/*----------------------------------------------------------------------------
Question 2: Unique Customers
----------------------------------------------------------------------------*/
SELECT COUNT(DISTINCT customer_unique_id) AS Unique_Customers
FROM raw_customers;

/*----------------------------------------------------------------------------
Question 3: Total Orders
----------------------------------------------------------------------------*/
SELECT COUNT(*) AS Total_Orders
FROM raw_orders;

/*----------------------------------------------------------------------------
Question 4: Order Status Distribution
----------------------------------------------------------------------------*/
SELECT order_status, COUNT(*) AS Total_Orders
FROM raw_orders
GROUP BY order_status
ORDER BY Total_Orders DESC;

/*----------------------------------------------------------------------------
Question 5: Total Products
----------------------------------------------------------------------------*/
SELECT COUNT(*) AS Total_Products
FROM raw_products;

/*----------------------------------------------------------------------------
Question 6: Total Sellers
----------------------------------------------------------------------------*/
SELECT COUNT(*) AS Total_Sellers
FROM raw_sellers;

/*----------------------------------------------------------------------------
Question 7: Payment Methods
----------------------------------------------------------------------------*/
SELECT DISTINCT payment_type
FROM raw_payments;

/*----------------------------------------------------------------------------
Question 8: Payment Method Distribution
----------------------------------------------------------------------------*/
SELECT payment_type, COUNT(*) AS Total_Transactions
FROM raw_payments
GROUP BY payment_type
ORDER BY Total_Transactions DESC;

/*==============================================================================
                            EXPLORATORY DATA ANALYSIS SUMMARY
==============================================================================

Dataset Overview:
• Total Customers           : 99,441
• Unique Customers          : [Output of Query 2]
• Total Orders              : 99,441
• Total Products            : 32,951
• Total Sellers             : 3,095

Key Observations:

1. Customer Base
   • The dataset contains a large customer base distributed across
     different cities and states in Brazil.
   • Comparing customer_id and customer_unique_id helps distinguish
     customer accounts from actual unique customers.

2. Orders
   • The number of orders is equal to the number of customer records,
     indicating that each order is associated with one customer.
   • The majority of orders have been successfully delivered, while
     cancelled and unavailable orders account for only a small percentage,
     reflecting an efficient order fulfillment process.

3. Products
   • The marketplace offers 32,951 products across multiple categories,
     providing a diverse product catalog for analysis.

4. Sellers
   • A total of 3,095 sellers operate on the platform, indicating a
     multi-vendor marketplace.

5. Payment Methods
   • Multiple payment methods are available, including credit card,
     boleto, voucher, debit card, and others.
   • Payment method distribution will help identify customer payment
     preferences during business analysis.

Conclusion:
• The dataset provides comprehensive information about customers,
  orders, products, sellers, and payments.
• The exploratory analysis confirms that the database is well-structured
  and suitable for advanced business analysis.
• The next phase will focus on sales, customer, product, seller,
  delivery, and payment performance to generate actionable business
  insights.

==============================================================================*/