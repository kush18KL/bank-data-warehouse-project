# Bank-Data-Warehouse-Project
A SQL Server data warehouse project using Medallion Architecture (Bronze, Silver, Gold) to consolidate banking customer, account, and transaction data for analytics.

## Sample Output

Bronze layer load executed successfully via `EXEC bronze.load_bronze;`

![Bronze Load Success](outputs_screenshots/proc_load_bronze.png)

## Silver Layer

Cleans and standardizes Bronze data:
- Deduplication of exact duplicate records
- Date parsing across multiple inconsistent source formats
- Categorical standardization (gender, country, account type, status)
- Referential integrity checks (accounts must reference a valid customer, 
  transactions must reference a valid account)
- Currency/amount cleanup (stripped symbols, commas, suffixes)

Loaded via `silver.load_silver`, run after `bronze.load_bronze`.
[silver layer completed final output](outputs_screenshots/silver_layer_output.png)
