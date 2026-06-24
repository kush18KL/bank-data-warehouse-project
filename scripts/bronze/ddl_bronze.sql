/* ============================================================
   BRONZE LAYER - TABLE CREATION
   Purpose : Land raw data AS-IS, no cleaning, no type conversion.
             Every column is NVARCHAR because the raw CSVs contain
             mixed/dirty formats (e.g. "$1,234.56", multiple date
             formats, "NULL"/"N/A" text). We don't trust the data
             yet, so we don't force real types on it yet either.
   ============================================================ */
 
-- Drop and recreate so this script is safely re-runnable_

IF OBJECT_ID('bronze.bank_customers', 'U') IS NOT NULL
	DROP TABLE bronze.bank_customers;


CREATE TABLE bronze.bank_customers(
	customer_id NVARCHAR(50),
	full_name NVARCHAR(50),
	email NVARCHAR(50),
	phone NVARCHAR(50),
	dob NVARCHAR(50),
	gender NVARCHAR(50),
	country NVARCHAR(50),
	signup_date NVARCHAR(50),
	customer_status NVARCHAR(50)
);

IF OBJECT_ID('bronze.bank_accounts', 'U') IS NOT NULL
	DROP TABLE bronze.bank_accounts;

CREATE TABLE bronze.bank_accounts (
	account_id NVARCHAR(50),
	customer_id NVARCHAR(50),
	account_type NVARCHAR(50),
	balance NVARCHAR(50),
	currency NVARCHAR(50),
	opened_date NVARCHAR(50),
	account_status NVARCHAR(50),
	branch_code NVARCHAR(50)
);

IF OBJECT_ID('bronze.bank_transactions', 'U') IS NOT NULL
	DROP TABLE bronze.bank_transactions;

CREATE TABLE bronze.bank_transactions(
	transaction_id NVARCHAR(50),
	account_id NVARCHAR(50),
	transaction_date NVARCHAR(50),
	amount NVARCHAR(50),
	transaction_type NVARCHAR(50),
	channel NVARCHAR(50),
	merchant NVARCHAR(200),
	description NVARCHAR(200)
)
