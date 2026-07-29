ALTER PROCEDURE gold.load_gold  
AS  
BEGIN  
  
    PRINT '====================================';  
    PRINT 'Loading Gold Layer';  
    PRINT '====================================';  
  
    --------------------------------------------------  
    -- Truncate Gold Tables  
    --------------------------------------------------  
  
    TRUNCATE TABLE gold.fact_transactions;  
    TRUNCATE TABLE gold.dim_accounts;  
    TRUNCATE TABLE gold.dim_customers;  
    TRUNCATE TABLE gold.dim_date;  
  
    PRINT 'Gold tables truncated successfully.';  
      
        --------------------------------------------------  
    -- Load Customer Dimension  
    --------------------------------------------------  
  
    INSERT INTO gold.dim_customers  
    (  
        customer_id,  
        full_name,  
        gender,  
        country,  
        customer_status  
    )  
  
    SELECT  
        customer_id,  
        full_name,  
        gender,  
        country,  
        customer_status  
    FROM silver.bank_customers;  
  
    PRINT 'Customer Dimension Loaded.';  
  
    --------------------------------------------------  
    -- Load Account Dimension  
    --------------------------------------------------  
  
    INSERT INTO gold.dim_accounts  
    (  
        account_id,  
        customer_key,  
        account_type,  
        currency,  
        branch_code,  
        account_status  
    )  
    SELECT  
        ba.account_id,  
        dc.customer_key,  
        ba.account_type,  
        ba.currency,  
        ba.branch_code,  
        ba.account_status  
    FROM silver.bank_accounts ba  
    INNER JOIN gold.dim_customers dc  
        ON ba.customer_id = dc.customer_id;  
  
    PRINT 'Account Dimension Loaded.';  

    --------------------------------------------------
-- Load Date Dimension
--------------------------------------------------

INSERT INTO gold.dim_date
(
    date_key,
    full_date,
    day_number,
    month_number,
    month_name,
    quarter_number,
    year_number,
    day_name,
    week_number
)
SELECT
    CONVERT(INT, FORMAT(transaction_date,'yyyyMMdd')),
    transaction_date,
    DAY(transaction_date),
    MONTH(transaction_date),
    DATENAME(MONTH,transaction_date),
    DATEPART(QUARTER,transaction_date),
    YEAR(transaction_date),
    DATENAME(WEEKDAY,transaction_date),
    DATEPART(WEEK,transaction_date)
FROM
(
    SELECT DISTINCT transaction_date
    FROM silver.bank_transactions
    WHERE transaction_date IS NOT NULL
) d;

PRINT 'Date Dimension Loaded.';
--------------------------------------------------
-- Load Fact Transactions
--------------------------------------------------

INSERT INTO gold.fact_transactions
(
    transaction_id,
    account_key,
    date_key,
    amount,
    transaction_type,
    channel,
    merchant
)
SELECT
    t.transaction_id,
    a.account_key,
    CONVERT(INT, FORMAT(t.transaction_date,'yyyyMMdd')),
    t.amount,
    t.transaction_type,
    t.channel,
    t.merchant
FROM silver.bank_transactions t
INNER JOIN gold.dim_accounts a
    ON t.account_id = a.account_id
INNER JOIN gold.dim_date d
    ON d.full_date = t.transaction_date;

PRINT 'Fact Transactions Loaded.';

PRINT '====================================';
PRINT 'Gold Layer Loaded Successfully';
PRINT '====================================';

END;  
