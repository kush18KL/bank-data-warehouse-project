WITH customer_dedup AS
    (
    SELECT *,
    ROW_NUMBER() OVER
    (
        PARTITION BY TRIM(customer_id)
        ORDER BY TRY_CONVERT(DATE, TRIM(signup_date), 103) DESC
    ) AS rn
FROM bronze.bank_customers
    )

    SELECT
    TRIM(customer_id) AS customer_id,

    UPPER(TRIM(REPLACE(REPLACE(full_name, CHAR(13), ''), CHAR(10), ''))) AS full_name,

    CASE
        WHEN email IS NULL THEN NULL
        WHEN UPPER(TRIM(REPLACE(REPLACE(email, CHAR(13), ''), CHAR(10), ''))) IN ('NULL', 'N/A', '')
        THEN NULL
        ELSE LOWER(TRIM(REPLACE(REPLACE(email, CHAR(13), ''), CHAR(10), '')))
    END AS email,

    CASE
        WHEN phone IS NULL THEN NULL
        WHEN UPPER(TRIM(REPLACE(REPLACE(phone, CHAR(13), ''), CHAR(10), ''))) IN ('NULL', 'N/A', '')
        THEN NULL
        ELSE
        REPLACE(
        REPLACE(
        REPLACE(
        REPLACE(
        REPLACE(
        TRIM(REPLACE(REPLACE(phone, CHAR(13), ''), CHAR(10), '')),
        '(', ''
        ),
        ')', ''
        ),
        '-', ''
        ),
        '.', ''
        ),
        ' ', ''
        )
    END AS phone,

    TRY_CAST(TRIM(dob) AS DATE) AS dob,

    CASE
        WHEN UPPER(TRIM(REPLACE(REPLACE(gender, CHAR(13), ''), CHAR(10), ''))) IN ('F', 'FEMALE')
        THEN 'FEMALE'
        WHEN UPPER(TRIM(REPLACE(REPLACE(gender, CHAR(13), ''), CHAR(10), ''))) IN ('M', 'MALE')
        THEN 'MALE'
        ELSE NULL
    END AS gender,

    CASE
        WHEN UPPER(TRIM(REPLACE(REPLACE(country, CHAR(13), ''), CHAR(10), ''))) IN ('INDIA', 'BHARAT', 'IN')
        THEN 'INDIA'

        WHEN UPPER(TRIM(REPLACE(REPLACE(country, CHAR(13), ''), CHAR(10), ''))) IN ('UK', 'U.K.', 'UNITED KINGDOM', 'ENGLAND')
        THEN 'UNITED KINGDOM'

        WHEN UPPER(TRIM(REPLACE(REPLACE(country, CHAR(13), ''), CHAR(10), ''))) IN
        ('US', 'USA', 'UNITED STATES', 'UNITED STATES OF AMERICA', 'U.S.A.')
        THEN 'UNITED STATES'

        ELSE UPPER(TRIM(REPLACE(REPLACE(country, CHAR(13), ''), CHAR(10), '')))
        END AS country,

        TRY_CONVERT(DATE, TRIM(signup_date), 103) AS signup_date,

        CASE
        WHEN UPPER(TRIM(REPLACE(REPLACE(customer_status, CHAR(13), ''), CHAR(10), ''))) = 'ACTIVE'
        THEN 'ACTIVE'

        WHEN UPPER(TRIM(REPLACE(REPLACE(customer_status, CHAR(13), ''), CHAR(10), ''))) = 'PENDING'
        THEN 'PENDING'

        WHEN UPPER(TRIM(REPLACE(REPLACE(customer_status, CHAR(13), ''), CHAR(10), ''))) = 'INACTIVE'
        THEN 'INACTIVE'

        WHEN UPPER(TRIM(REPLACE(REPLACE(customer_status, CHAR(13), ''), CHAR(10), ''))) = 'CLOSED'
        THEN 'CLOSED'

        ELSE NULL
    END AS customer_status

FROM customer_dedup
WHERE rn = 1
AND full_name IS NOT NULL
AND TRIM(full_name) <> '';
