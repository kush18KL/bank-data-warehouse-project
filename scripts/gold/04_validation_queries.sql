/*
=============================================================
Gold Layer Validation Queries
Project : Banking Data Warehouse
Layer   : Gold
=============================================================
Description:
Validates that all Gold Layer tables have been
loaded successfully.
=============================================================
*/

-------------------------------------------------------------
-- Customer Dimension
-------------------------------------------------------------
SELECT COUNT(*) AS Total_Customers
FROM gold.dim_customers;

-------------------------------------------------------------
-- Account Dimension
-------------------------------------------------------------
SELECT COUNT(*) AS Total_Accounts
FROM gold.dim_accounts;

-------------------------------------------------------------
-- Date Dimension
-------------------------------------------------------------
SELECT COUNT(*) AS Total_Dates
FROM gold.dim_date;

-------------------------------------------------------------
-- Fact Transactions
-------------------------------------------------------------
SELECT COUNT(*) AS Total_Transactions
FROM gold.fact_transactions;

-------------------------------------------------------------
-- Preview Customer Dimension
-------------------------------------------------------------
SELECT TOP (10) *
FROM gold.dim_customers;

-------------------------------------------------------------
-- Preview Account Dimension
-------------------------------------------------------------
SELECT TOP (10) *
FROM gold.dim_accounts;

-------------------------------------------------------------
-- Preview Date Dimension
-------------------------------------------------------------
SELECT TOP (10) *
FROM gold.dim_date;

-------------------------------------------------------------
-- Preview Fact Table
-------------------------------------------------------------
SELECT TOP (10) *
FROM gold.fact_transactions;
