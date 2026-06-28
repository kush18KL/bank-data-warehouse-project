
--transaction_id
SELECT
    transaction_id,
    COUNT(*) AS duplicate_count
FROM bronze.bank_transactions
GROUP BY transaction_id
HAVING COUNT(*) > 1;

SELECT *
FROM bronze.bank_transactions
WHERE transaction_id IS NULL
   OR TRIM(transaction_id) = '';

   SELECT TOP (20)
transaction_id
FROM bronze.bank_transactions;

--account_id
SELECT *
FROM bronze.bank_transactions
WHERE account_id IS NULL
   OR TRIM(account_id) = '';

SELECT TOP (20) account_id
FROM bronze.bank_transactions;
SELECT COUNT(*) AS InvalidAccountReferences
FROM bronze.bank_transactions t
LEFT JOIN silver.bank_accounts a
    ON TRIM(t.account_id) = a.account_id
WHERE a.account_id IS NULL
  AND UPPER(TRIM(t.account_id)) NOT IN ('NULL', 'N/A')
  AND TRIM(t.account_id) <> '';

SELECT DISTINCT TOP (20)
    t.account_id
FROM bronze.bank_transactions t
LEFT JOIN silver.bank_accounts a
    ON TRIM(t.account_id) = a.account_id
WHERE a.account_id IS NULL
  AND t.account_id IS NOT NULL
  AND TRIM(t.account_id) <> ''
  AND UPPER(TRIM(t.account_id)) NOT IN ('NULL', 'N/A');

--transaction_date
SELECT transaction_date
FROM bronze.bank_transactions
WHERE TRY_CAST(transaction_date AS DATE) IS NULL
  AND transaction_date IS NOT NULL
  AND TRIM(transaction_date) <> '';

  SELECT *
FROM bronze.bank_transactions
WHERE TRY_CAST(transaction_date AS DATE) > GETDATE();

SELECT TOP (20)
transaction_date
FROM bronze.bank_transactions;


SELECT DISTINCT
    '[' + transaction_date + ']' AS ValueShown,
    LEN(transaction_date) AS Length,
    UNICODE(RIGHT(transaction_date,1)) AS LastChar
FROM bronze.bank_transactions;

--amount
SELECT COUNT(*) AS NullAmounts
FROM bronze.bank_transactions
WHERE amount IS NULL;

SELECT amount
FROM bronze.bank_transactions
WHERE TRY_CAST(
        REPLACE(
            REPLACE(
                REPLACE(amount, '$', ''),
                'USD', ''
            ),
            ',', ''
        ) AS DECIMAL(18,2)
      ) IS NULL
  AND amount IS NOT NULL;

  SELECT *
FROM bronze.bank_transactions
WHERE TRY_CAST(
        REPLACE(
            REPLACE(
                REPLACE(amount, '$', ''),
                'USD', ''
            ),
            ',', ''
        ) AS DECIMAL(18,2)
      ) < 0;

--transaction_type
SELECT
    transaction_type,
    COUNT(*) AS count
FROM bronze.bank_transactions
GROUP BY transaction_type
ORDER BY count DESC;

SELECT
    transaction_type,
    COUNT(*) AS count
FROM bronze.bank_transactions
WHERE transaction_type IS NULL
   OR TRIM(transaction_type) = ''
   OR UPPER(TRIM(transaction_type)) IN ('NULL', 'N/A')
GROUP BY transaction_type;

SELECT DISTINCT
    '[' + transaction_type + ']' AS ValueShown,
    LEN(transaction_type) AS Length,
    UNICODE(RIGHT(transaction_type,1)) AS LastChar
FROM bronze.bank_transactions;

--channel
SELECT
    channel,
    COUNT(*) AS count
FROM bronze.bank_transactions
GROUP BY channel
ORDER BY count DESC;

SELECT
    channel,
    COUNT(*) AS count
FROM bronze.bank_transactions
WHERE channel IS NULL
   OR TRIM(channel) = ''
   OR UPPER(TRIM(channel)) IN ('NULL', 'N/A')
GROUP BY channel;

SELECT DISTINCT
    '[' + channel + ']' AS ValueShown,
    LEN(channel) AS Length,
    UNICODE(RIGHT(channel,1)) AS LastChar
FROM bronze.bank_transactions;

--merchant
SELECT
    merchant,
    COUNT(*) AS count
FROM bronze.bank_transactions
GROUP BY merchant
ORDER BY count DESC;

SELECT
    merchant,
    COUNT(*) AS count
FROM bronze.bank_transactions
WHERE merchant IS NULL
   OR TRIM(merchant) = ''
   OR UPPER(TRIM(merchant)) IN ('NULL', 'N/A')
GROUP BY merchant;

SELECT DISTINCT
    '[' + merchant + ']' AS ValueShown,
    LEN(merchant) AS Length,
    UNICODE(RIGHT(merchant,1)) AS LastChar
FROM bronze.bank_transactions;

SELECT
    UPPER(TRIM(merchant)) AS merchant_name,
    COUNT(*) AS count
FROM bronze.bank_transactions
WHERE merchant IS NOT NULL
GROUP BY UPPER(TRIM(merchant))
ORDER BY merchant_name;


--description
SELECT
    description,
    COUNT(*) AS count
FROM bronze.bank_transactions
WHERE description IS NULL
   OR TRIM(description) = ''
   OR UPPER(TRIM(description)) IN ('NULL', 'N/A')
GROUP BY description;

SELECT DISTINCT
    '[' + description + ']' AS ValueShown,
    LEN(description) AS Length,
    UNICODE(RIGHT(description,1)) AS LastChar
FROM bronze.bank_transactions;

SELECT TOP (20)
    description,
    LEN(description) AS length
FROM bronze.bank_transactions
ORDER BY LEN(description) DESC;

SELECT TOP (20)
    '[' + description + ']' AS ValueShown
FROM bronze.bank_transactions
WHERE description <> TRIM(description);


