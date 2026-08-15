/*
===============================================================================
Project Name : E-Commerce Sales Analysis using SQL Server

File Name    : 01_Create_Database.sql

Author       : Mayur Sandip Mali

Description  :
This script creates the database for the E-Commerce Analytics Project.

Database     : EcommerceDB
===============================================================================
*/

CREATE DATABASE EcommerceDB;
USE EcommerceDB;
select name from sys.databases;
EXEC sp_help customers;