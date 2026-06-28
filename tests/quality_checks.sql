--trim customers id
SELECT
TRIM(customer_id) AS customer_id
FROM bronze.bank_customers
--check for nulls
SELECT
*
FROM bronze.bank_customers
WHERE full_name IS NULL
OR TRIM(full_name) = ''

-- staderdize full_name
SELECT TOP(20)
full_name
FROM bronze.bank_customers
WHERE full_name = LOWER(full_name)
-- staderdize full_name
SELECT TOP(20)
full_name
FROM bronze.bank_customers
WHERE full_name = UPPER(full_name)
-- mixed full_name
SELECT TOP (20) full_name
FROM bronze.bank_customers
WHERE full_name <> UPPER(full_name)
  AND full_name <> LOWER(full_name);

  --duplicate emails
  SELECT
  LOWER(TRIM(email)) AS email,
  COUNT(*) AS duplicate
  FROM bronze.bank_customers
  GROUP BY LOWER(TRIM(email))
  HAVING COUNT(*) > 1

  --nulls or blanks

SELECT
*
FROM bronze.bank_customers
WHERE email IS NULL OR TRIM(email) = ''

--invalid emails
SELECT
email
FROM bronze.bank_customers
WHERE email IS NOT NULL
AND TRIM(email) <> ''
AND email NOT LIKE '%_@%._%';

--nulls or blanks in phone
SELECT
phone,
COUNT(*) AS count
FROM bronze.bank_customers
WHERE phone IS NULL OR TRIM(phone) = '' OR UPPER(TRIM(phone)) IN ('NULL', 'N/A')
GROUP BY phone

--duplicate phone numbers
SELECT
phone,
COUNT(*) AS duplicate_count
FROM bronze.bank_customers
WHERE phone IS NOT NULL
AND TRIM(phone) <> ''
GROUP BY phone
HAVING COUNT(*) > 1;

--check the types of gender 
SELECT
DISTINCT gender
FROM bronze.bank_customers

-- check different types of country
SELECT
    country,
    COUNT(*) AS count
FROM bronze.bank_customers
GROUP BY country
ORDER BY count DESC

-- invalid dates

SELECT signup_date
FROM bronze.bank_customers
WHERE TRY_CAST(TRIM(signup_date) AS DATE) IS NULL
  AND signup_date IS NOT NULL
  AND TRIM(signup_date) <> '';


--future dates
SELECT *
FROM bronze.bank_customers
WHERE TRY_CAST(signup_date AS DATE) > GETDATE();

--different types of customer
SELECT
DISTINCT customer_status
FROM bronze.bank_customers

SELECT DISTINCT
'[' + customer_status + ']' AS customer_status
FROM bronze.bank_customers;

SELECT
    customer_status,
    UPPER(TRIM(customer_status)) AS cleaned_status
FROM bronze.bank_customers;

SELECT
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'bronze'
  AND TABLE_NAME = 'bank_customers'
  AND COLUMN_NAME = 'customer_status';

SELECT TOP (20)
    customer_status,
    LEN(customer_status) AS Length,
    DATALENGTH(customer_status) AS DataLength,
    UNICODE(LEFT(customer_status,1)) AS FirstChar,
    UNICODE(RIGHT(customer_status,1)) AS LastChar,
    '[' + customer_status + ']' AS ValueShown
FROM bronze.bank_customers;

SELECT DISTINCT
    '[' + customer_status + ']' AS ValueShown
FROM bronze.bank_customers;

SELECT DISTINCT
    customer_status,
    UPPER(LTRIM(RTRIM(REPLACE(customer_status, CHAR(13), '')))) AS CleanStatus
FROM bronze.bank_customers;