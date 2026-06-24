SELECT COUNT(*) AS customer_row 
FROM bronze.bank_customers

SELECT COUNT(*) AS account_rows 
FROM bronze.bank_accounts

SELECT COUNT(*) AS transaction_rows 
FROM bronze.bank_transactions

SELECT TOP 5 * FROM bronze.bank_customers;
SELECT TOP 5 * FROM bronze.bank_accounts;
SELECT TOP 5 * FROM bronze.bank_transactions;
