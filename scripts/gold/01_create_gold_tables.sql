USE [Bank_Warehouse]
GO

/****** Object:  Table [gold].[dim_customers]    Script Date: 29-07-2026 15:10:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [gold].[dim_customers](
	[customer_key] [int] IDENTITY(1,1) NOT NULL,
	[customer_id] [nvarchar](20) NOT NULL,
	[full_name] [nvarchar](100) NULL,
	[gender] [nvarchar](10) NULL,
	[country] [nvarchar](50) NULL,
	[customer_status] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[customer_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


USE [Bank_Warehouse]
GO

/****** Object:  Table [gold].[dim_accounts]    Script Date: 29-07-2026 15:11:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [gold].[dim_accounts](
	[account_key] [int] IDENTITY(1,1) NOT NULL,
	[account_id] [nvarchar](20) NOT NULL,
	[customer_key] [int] NOT NULL,
	[account_type] [nvarchar](30) NULL,
	[currency] [nvarchar](10) NULL,
	[branch_code] [nvarchar](20) NULL,
	[account_status] [nvarchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[account_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


USE [Bank_Warehouse]
GO

/****** Object:  Table [gold].[dim_date]    Script Date: 29-07-2026 15:12:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [gold].[dim_date](
	[date_key] [int] NOT NULL,
	[full_date] [date] NOT NULL,
	[day_number] [int] NULL,
	[month_number] [int] NULL,
	[month_name] [nvarchar](20) NULL,
	[quarter_number] [int] NULL,
	[year_number] [int] NULL,
	[day_name] [nvarchar](20) NULL,
	[week_number] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[date_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


USE [Bank_Warehouse]
GO

/****** Object:  Table [gold].[fact_transactions]    Script Date: 29-07-2026 15:12:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [gold].[fact_transactions](
	[transaction_key] [int] IDENTITY(1,1) NOT NULL,
	[transaction_id] [nvarchar](20) NOT NULL,
	[account_key] [int] NOT NULL,
	[date_key] [int] NOT NULL,
	[amount] [decimal](18, 2) NULL,
	[transaction_type] [nvarchar](20) NULL,
	[channel] [nvarchar](20) NULL,
	[merchant] [nvarchar](150) NULL,
PRIMARY KEY CLUSTERED 
(
	[transaction_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


