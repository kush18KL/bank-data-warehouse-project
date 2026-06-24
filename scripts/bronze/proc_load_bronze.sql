/*
===============================================================================
Stored Procedure: bronze.load_bronze
===============================================================================
Purpose:
    Loads raw data into the Bronze layer schema from external CSV source files.
    Performs a full reload: truncates each Bronze table and re-populates it
    using BULK INSERT. No data cleansing or transformation is applied here —
    Bronze tables store data exactly as it exists in the source files.
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY	
		SET @batch_start_time = GETDATE();
		PRINT'====================================================='
		PRINT'Loading Bronze Layer'
		PRINT'====================================================='

		SET @start_time = GETDATE();
		PRINT'>> Truncating Table: bronze.bank_customers'
		TRUNCATE TABLE bronze.bank_customers;
		PRINT'>> Bulk Inserting Into: bronze.bank_customers'
		BULK INSERT bronze.bank_customers
		FROM 'C:\Users\hp\OneDrive\Desktop\files\customers_raw.csv'
		WITH (
			FIRSTROW       = 2,
			FORMAT         = 'CSV',
			FIELDQUOTE     = '"',
			FIELDTERMINATOR = ',',
			ROWTERMINATOR  = '0x0a',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + 'Seconds';
		PRINT'>>...............';

		SET @start_time = GETDATE();
		PRINT'>> Truncating Table: bronze.bank_accounts'
		TRUNCATE TABLE bronze.bank_accounts;
		PRINT'>> Bulk Inserting Into: bronze.bank_accounts'

		BULK INSERT bronze.bank_accounts
		FROM 'C:\Users\hp\OneDrive\Desktop\files\accounts_raw.csv'
		WITH (
			FIRSTROW       = 2,
			FORMAT         = 'CSV',
			FIELDQUOTE     = '"',
			FIELDTERMINATOR = ',',
			ROWTERMINATOR  = '0x0a',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT'Loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + 'Seconds';
		PRINT'>>................';

		SET @start_time = GETDATE();

		PRINT'>> Truncating Table: bronze.bank_transactions'
		TRUNCATE TABLE bronze.bank_transactions;
		PRINT'>> Bulk Inserting Into: bronze.bank_transactions'

		BULK INSERT bronze.bank_transactions
		FROM 'C:\Users\hp\OneDrive\Desktop\files\transactions_raw.csv'
		WITH (
			FIRSTROW       = 2,
			FORMAT         = 'CSV',
			FIELDQUOTE     = '"',
			FIELDTERMINATOR = ',',
			ROWTERMINATOR  = '0x0a',
			TABLOCK
		);

		SET @end_time = GETDATE();

		PRINT'>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + 'Seconds';
		PRINT'>>................';

		SET @batch_end_time = GETDATE();
		PRINT'====================================================='
		PRINT'LOADING BRONZE LAYER IS COMPLETED'
		PRINT'Total Duartion: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'Seconds';
		PRINT'====================================================='
	END TRY
		BEGIN CATCH
		PRINT'====================================================='
			PRINT'ERROR OCCURED DURING LOADING BRONZE LAYER '
			PRINT'Error Message: ' + Error_Message();
			PRINT'Error Message: ' + CAST(Error_Message() AS NVARCHAR);
			PRINT'Error Message: ' + CAST(Error_State() AS NVARCHAR);
			PRINT'====================================================='
		END CATCH
	
END
