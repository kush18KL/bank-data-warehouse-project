/*
=============================================================
Execute Gold Layer ETL
Project : Banking Data Warehouse
Layer   : Gold
=============================================================
Description:
Executes the Gold Layer ETL process to populate
the Star Schema tables from the Silver Layer.
=============================================================
*/

EXEC gold.load_gold;
GO
