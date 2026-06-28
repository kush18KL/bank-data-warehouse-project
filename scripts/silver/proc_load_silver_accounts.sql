;WITH account_details AS
(
    SELECT
        account_id,
        customer_id,
        account_type,
        balance,
        currency,
        opened_date,
        account_status,
        branch_code,
        ROW_NUMBER() OVER
        (
            PARTITION BY TRIM(account_id)
            ORDER BY TRY_CONVERT(DATE, TRIM(opened_date), 103) DESC
        ) AS rn
    FROM bronze.bank_accounts
)

INSERT INTO silver.bank_accounts
(
    account_id,
    customer_id,
    account_type,
    balance,
    currency,
    opened_date,
    account_status,
    branch_code
)

SELECT
    TRIM(REPLACE(REPLACE(account_id, CHAR(13), ''), CHAR(10), '')) AS account_id,

    TRIM(REPLACE(REPLACE(customer_id, CHAR(13), ''), CHAR(10), '')) AS customer_id,

    CASE
        WHEN UPPER(TRIM(REPLACE(REPLACE(account_type, CHAR(13), ''), CHAR(10), '')))
             IN ('SAVINGS', 'LOAN', 'CHECKING', 'CURRENT', 'CREDIT CARD')
        THEN UPPER(TRIM(REPLACE(REPLACE(account_type, CHAR(13), ''), CHAR(10), '')))
        ELSE NULL
    END AS account_type,

     TRY_CAST(
    REPLACE(
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        TRIM(balance),
                        '$',''
                    ),
                    'USD',''
                ),
                ',',''
            ),
            CHAR(13),''
        ),
        CHAR(10),''
    )
AS DECIMAL(18,2)) AS balance,
    CASE
    WHEN UPPER(TRIM(REPLACE(REPLACE(currency, CHAR(13), ''), CHAR(10), '')))
         IN ('USD', 'US DOLLAR', '$')
        THEN 'USD'

    ELSE NULL
END AS currency,
CASE
    WHEN COALESCE(
            TRY_CONVERT(DATE, opened_date, 103),  -- DD/MM/YYYY
            TRY_CONVERT(DATE, opened_date, 101),  -- MM/DD/YYYY
            TRY_CONVERT(DATE, opened_date, 120),  -- YYYY-MM-DD HH:MI:SS
            TRY_CAST(opened_date AS DATE)
         ) > GETDATE()
    THEN NULL

    ELSE COALESCE(
            TRY_CONVERT(DATE, opened_date, 103),
            TRY_CONVERT(DATE, opened_date, 101),
            TRY_CONVERT(DATE, opened_date, 120),
            TRY_CAST(opened_date AS DATE)
         )
END AS opened_date,
    CASE
    WHEN account_status IS NULL THEN NULL

    WHEN UPPER(TRIM(account_status)) = 'ACTIVE'
        THEN 'ACTIVE'

    WHEN UPPER(TRIM(account_status)) = 'INACTIVE'
        THEN 'INACTIVE'

    WHEN UPPER(TRIM(account_status)) = 'PENDING'
        THEN 'PENDING'

    WHEN UPPER(TRIM(account_status)) = 'CLOSED'
        THEN 'CLOSED'

    ELSE NULL
END AS account_status,
    CASE
    WHEN branch_code IS NULL
         OR TRIM(REPLACE(REPLACE(branch_code, CHAR(13), ''), CHAR(10), '')) = ''
         OR UPPER(TRIM(REPLACE(REPLACE(branch_code, CHAR(13), ''), CHAR(10), '')))
            IN ('NULL', 'N/A')
    THEN NULL

    WHEN TRIM(REPLACE(REPLACE(branch_code, CHAR(13), ''), CHAR(10), ''))
         LIKE 'BR[0-9][0-9][0-9]'
    THEN TRIM(REPLACE(REPLACE(branch_code, CHAR(13), ''), CHAR(10), ''))

    ELSE NULL
END AS branch_code

FROM account_details
WHERE rn = 1
  AND customer_id IS NOT NULL
  AND UPPER(TRIM(customer_id)) NOT IN ('NULL', 'N/A')
  AND EXISTS
  (
      SELECT 1
      FROM silver.bank_customers c
      WHERE c.customer_id = TRIM(account_details.customer_id)
  );
