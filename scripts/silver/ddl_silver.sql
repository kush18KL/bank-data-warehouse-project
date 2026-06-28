/*
===============================================================================
DDL Script: Silver Layer
Project      : Banking Data Warehouse
Description  : Creates the Silver schema and tables for cleaned and standardized
               customer, account, and transaction data.
Author       : Kushal Kumar Y
===============================================================================
*/

IF NOT EXISTS
(
    SELECT *
    FROM sys.schemas
    WHERE name = 'silver'
)
BEGIN
    EXEC('CREATE SCHEMA silver');
END;
GO

-- Drop tables in dependency order
DROP TABLE IF EXISTS silver.bank_transactions;
DROP TABLE IF EXISTS silver.bank_accounts;
DROP TABLE IF EXISTS silver.bank_customers;
GO

-- ==========================
-- Customers
-- ==========================
CREATE TABLE silver.bank_customers
(
    customer_id         NVARCHAR(20)    NOT NULL,
    full_name           NVARCHAR(100)   NOT NULL,
    email               NVARCHAR(100)   NULL,
    phone               NVARCHAR(30)    NULL,
    dob                 DATE            NULL,
    gender              NVARCHAR(10)    NULL,
    country             NVARCHAR(50)    NULL,
    signup_date         DATE            NULL,
    customer_status     NVARCHAR(20)    NULL,

    CONSTRAINT PK_bank_customers
        PRIMARY KEY (customer_id)
);
GO

-- ==========================
-- Accounts
-- ==========================
CREATE TABLE silver.bank_accounts
(
    account_id          NVARCHAR(20)    NOT NULL,
    customer_id         NVARCHAR(20)    NOT NULL,
    account_type        NVARCHAR(30)    NULL,
    balance             DECIMAL(18,2)   NULL,
    currency            NVARCHAR(10)    NULL,
    opened_date         DATE            NULL,
    account_status      NVARCHAR(20)    NULL,
    branch_code         NVARCHAR(20)    NULL,

    CONSTRAINT PK_bank_accounts
        PRIMARY KEY (account_id),

    CONSTRAINT FK_accounts_customers
        FOREIGN KEY (customer_id)
        REFERENCES silver.bank_customers(customer_id)
);
GO

-- ==========================
-- Transactions
-- ==========================
CREATE TABLE silver.bank_transactions
(
    transaction_id      NVARCHAR(20)    NOT NULL,
    account_id          NVARCHAR(20)    NOT NULL,
    transaction_date    DATE            NULL,
    amount              DECIMAL(18,2)   NULL,
    transaction_type    NVARCHAR(20)    NULL,
    channel             NVARCHAR(20)    NULL,
    merchant            NVARCHAR(150)   NULL,
    description         NVARCHAR(255)   NULL,

    CONSTRAINT PK_bank_transactions
        PRIMARY KEY (transaction_id),

    CONSTRAINT FK_transactions_accounts
        FOREIGN KEY (account_id)
        REFERENCES silver.bank_accounts(account_id)
);
GO
