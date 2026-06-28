-- Check duplicates

SELECT
account_id,
COUNT(*)
FROM bronze.bank_accounts
GROUP BY account_id
HAVING COUNT(*) > 1;

SELECT
*
FROM bronze.bank_accounts
WHERE account_id IS NULL
OR TRIM(account_id) = ''

SELECT TOP (20) account_id
FROM bronze.bank_accounts

SELECT *
FROM bronze.bank_accounts
WHERE customer_id IS NULL
   OR TRIM(customer_id) = '';

   SELECT customer_id
FROM bronze.bank_accounts
WHERE TRIM(customer_id) NOT LIKE 'CUST[0-9][0-9][0-9][0-9][0-9]';

SELECT DISTINCT b.customer_id
FROM bronze.bank_accounts b
LEFT JOIN silver.bank_customers s
    ON TRIM(b.customer_id) = s.customer_id
WHERE s.customer_id IS NULL;

SELECT TOP (20) customer_id
FROM bronze.bank_accounts
WHERE customer_id IS NOT NULL
  AND UPPER(TRIM(customer_id)) NOT IN ('NULL','N/A');

  SELECT COUNT(*) AS InvalidCustomerReferences
FROM bronze.bank_accounts b
LEFT JOIN silver.bank_customers s
    ON TRIM(b.customer_id) = s.customer_id
WHERE s.customer_id IS NULL
  AND UPPER(TRIM(b.customer_id)) NOT IN ('NULL', 'N/A')
  AND TRIM(b.customer_id) <> '';

SELECT
    account_type,
    COUNT(*) AS count
FROM bronze.bank_accounts
GROUP BY account_type
ORDER BY count DESC;

SELECT
    account_type,
    COUNT(*) AS count
FROM bronze.bank_accounts
WHERE account_type IS NULL
   OR TRIM(account_type) = ''
   OR UPPER(TRIM(account_type)) IN ('NULL', 'N/A')
GROUP BY account_type;

SELECT DISTINCT
    '[' + account_type + ']' AS ValueShown,
    LEN(account_type) AS Length,
    UNICODE(RIGHT(account_type,1)) AS LastChar
FROM bronze.bank_accounts;

SELECT COUNT(*) AS NullBalances
FROM bronze.bank_accounts
WHERE balance IS NULL;

SELECT *
FROM bronze.bank_accounts
WHERE TRY_CAST(balance AS DECIMAL(18,2)) < 0;

SELECT balance
FROM bronze.bank_accounts
WHERE TRY_CAST(balance AS DECIMAL(18,2)) IS NULL
  AND balance IS NOT NULL;

SELECT DISTINCT balance
FROM bronze.bank_accounts
WHERE balance LIKE '%[A-Za-z]%';

SELECT TOP (20)
balance
FROM silver.bank_accounts;

SELECT
    currency,
    COUNT(*) AS count
FROM bronze.bank_accounts
GROUP BY currency
ORDER BY count DESC;

SELECT
    currency,
    COUNT(*) AS count
FROM bronze.bank_accounts
WHERE currency IS NULL
   OR TRIM(currency) = ''
   OR UPPER(TRIM(currency)) IN ('NULL', 'N/A')
GROUP BY currency;
SELECT DISTINCT
    '[' + currency + ']' AS ValueShown,
    LEN(currency) AS Length,
    UNICODE(RIGHT(currency,1)) AS LastChar
FROM bronze.bank_accounts;

SELECT opened_date
FROM bronze.bank_accounts
WHERE TRY_CONVERT(DATE, TRIM(opened_date), 103) IS NULL
  AND opened_date IS NOT NULL
  AND TRIM(opened_date) <> '';

  SELECT *
FROM bronze.bank_accounts
WHERE TRY_CONVERT(DATE, TRIM(opened_date), 103) > GETDATE();

SELECT TOP (20) opened_date
FROM bronze.bank_accounts;

SELECT
    COUNT(*) AS FutureDateCount
FROM bronze.bank_accounts
WHERE TRY_CAST(opened_date AS DATE) > GETDATE();


SELECT
    account_status,
    COUNT(*) AS count
FROM bronze.bank_accounts
GROUP BY account_status
ORDER BY count DESC;

SELECT
    account_status,
    COUNT(*) AS count
FROM bronze.bank_accounts
WHERE account_status IS NULL
   OR TRIM(account_status) = ''
   OR UPPER(TRIM(account_status)) IN ('NULL', 'N/A')
GROUP BY account_status;

SELECT DISTINCT
    '[' + account_status + ']' AS ValueShown,
    LEN(account_status) AS Length,
    UNICODE(RIGHT(account_status,1)) AS LastChar
FROM bronze.bank_accounts;

SELECT
    branch_code,
    COUNT(*) AS count
FROM bronze.bank_accounts
GROUP BY branch_code
ORDER BY branch_code;

SELECT
    branch_code,
    COUNT(*) AS count
FROM bronze.bank_accounts
WHERE branch_code IS NULL
   OR TRIM(branch_code) = ''
   OR UPPER(TRIM(branch_code)) IN ('NULL', 'N/A')
GROUP BY branch_code;

SELECT DISTINCT
    '[' + branch_code + ']' AS ValueShown,
    LEN(branch_code) AS Length,
    UNICODE(RIGHT(branch_code,1)) AS LastChar
FROM bronze.bank_accounts;

SELECT branch_code
FROM silver.bank_accounts
WHERE TRIM(branch_code) NOT LIKE 'BR[0-9][0-9][0-9]';

SELECT branch_code
FROM silver.bank_accounts
WHERE branch_code IS NOT NULL
  AND TRIM(branch_code) <> ''
  AND TRIM(REPLACE(REPLACE(branch_code, CHAR(13), ''), CHAR(10), ''))
      NOT LIKE 'BR[0-9][0-9][0-9]';


         