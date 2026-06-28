CREATE OR ALTER PROCEDURE silver.load_silver_transactions
AS
BEGIN

SET NOCOUNT ON;

TRUNCATE TABLE silver.bank_transactions;

WITH transaction_dedup AS
(
SELECT *,
ROW_NUMBER() OVER
(
    PARTITION BY TRIM(transaction_id)
    ORDER BY
    COALESCE
    (
        TRY_CONVERT(DATE, TRIM(transaction_date), 103),
        TRY_CONVERT(DATE, TRIM(transaction_date), 101),
        TRY_CONVERT(DATE, TRIM(transaction_date), 120),
        TRY_CAST(TRIM(transaction_date) AS DATE)
    ) DESC
) AS rn
FROM bronze.bank_transactions
)

INSERT INTO silver.bank_transactions
(
    transaction_id,
    account_id,
    transaction_date,
    amount,
    transaction_type,
    channel,
    merchant,
    description
)

SELECT

TRIM(REPLACE(REPLACE(transaction_id, CHAR(13), ''), CHAR(10), '')) AS transaction_id,

TRIM(REPLACE(REPLACE(account_id, CHAR(13), ''), CHAR(10), '')) AS account_id,

CASE
WHEN COALESCE
(
    TRY_CONVERT(DATE, TRIM(transaction_date), 103),
    TRY_CONVERT(DATE, TRIM(transaction_date), 101),
    TRY_CONVERT(DATE, TRIM(transaction_date), 120),
    TRY_CAST(TRIM(transaction_date) AS DATE)
) > GETDATE()
THEN NULL

ELSE COALESCE
(
    TRY_CONVERT(DATE, TRIM(transaction_date), 103),
    TRY_CONVERT(DATE, TRIM(transaction_date), 101),
    TRY_CONVERT(DATE, TRIM(transaction_date), 120),
    TRY_CAST(TRIM(transaction_date) AS DATE)
)
END AS transaction_date,

TRY_CAST
(
REPLACE
(
    REPLACE
    (
        REPLACE
        (
            REPLACE
            (
                REPLACE
                (
                    UPPER(TRIM(amount)),
                    'USD', ''
                ),
                '$', ''
            ),
            ',', ''
        ),
        CHAR(13), ''
    ),
    CHAR(10), ''
)
AS DECIMAL(18,2)) AS amount,

CASE
    WHEN UPPER(TRIM(transaction_type))
            IN ('DEBIT','CREDIT','TRANSFER','DEPOSIT','WITHDRAWAL')
    THEN UPPER(TRIM(transaction_type))

    ELSE NULL
END AS transaction_type,

CASE
    WHEN channel IS NULL
            OR TRIM(REPLACE(REPLACE(channel, CHAR(13), ''), CHAR(10), '')) = ''
            OR UPPER(TRIM(REPLACE(REPLACE(channel, CHAR(13), ''), CHAR(10), '')))
            IN ('NULL','N/A')
    THEN NULL

    WHEN UPPER(TRIM(REPLACE(REPLACE(channel, CHAR(13), ''), CHAR(10), '')))
            IN ('ATM','POS','ONLINE','MOBILE','BRANCH')
    THEN UPPER(TRIM(REPLACE(REPLACE(channel, CHAR(13), ''), CHAR(10), '')))

    ELSE NULL
END AS channel,

CASE
    WHEN merchant IS NULL
            OR TRIM(REPLACE(REPLACE(merchant, CHAR(13), ''), CHAR(10), '')) = ''
            OR UPPER(TRIM(REPLACE(REPLACE(merchant, CHAR(13), ''), CHAR(10), '')))
            IN ('NULL','N/A')
    THEN NULL

    ELSE TRIM(REPLACE(REPLACE(merchant, CHAR(13), ''), CHAR(10), ''))
END AS merchant,

CASE
    WHEN description IS NULL THEN NULL

    WHEN TRIM(REPLACE(REPLACE(description, CHAR(13), ''), CHAR(10), '')) = ''
    THEN NULL

    ELSE TRIM(REPLACE(REPLACE(description, CHAR(13), ''), CHAR(10), ''))
END AS description

    FROM transaction_dedup

    WHERE rn = 1

    AND account_id IS NOT NULL

    AND TRIM(account_id) <> ''

    AND UPPER(TRIM(account_id)) NOT IN ('NULL','N/A')

    AND EXISTS
    (
        SELECT 1
        FROM silver.bank_accounts a
        WHERE a.account_id =
        TRIM(REPLACE(REPLACE(transaction_dedup.account_id, CHAR(13), ''), CHAR(10), ''))
    );

END;
