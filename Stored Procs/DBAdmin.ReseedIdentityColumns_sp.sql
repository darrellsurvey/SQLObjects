IF OBJECT_ID('DBAdmin.ReseedIdentityColumns_sp') IS NOT NULL
    DROP PROCEDURE [DBAdmin].[ReseedIdentityColumns_sp];
GO

CREATE PROCEDURE DBAdmin.ReseedIdentityColumns_sp
AS
BEGIN

SET NOCOUNT ON

--IF OBJECT_ID(N'[Billing].[OrderRule]', 'U') IS NULL
--CREATE TABLE [Billing].[OrderRule]

-- Reseed identity on [LKP].[ReportType]
DBCC CHECKIDENT(N'[LKP].[ReportType]', RESEED, 1)
DBCC CHECKIDENT(N'[LKP].[ReportType]', RESEED)

-- Reseed identity on [LKP].[Report]
DBCC CHECKIDENT(N'[LKP].[Report]', RESEED, 1)
DBCC CHECKIDENT(N'[LKP].[Report]', RESEED)

-- Reseed identity on [Billing].[FeeType]
DBCC CHECKIDENT(N'[Billing].[FeeType]', RESEED, 1)
DBCC CHECKIDENT(N'[Billing].[FeeType]', RESEED)

-- Reseed identity on [Billing].[Customer]
DBCC CHECKIDENT(N'[Billing].[Customer]', RESEED, 1)
DBCC CHECKIDENT(N'[Billing].[Customer]', RESEED)

-- Reseed identity on [Billing].[CustomerNote]
DBCC CHECKIDENT(N'[Billing].[CustomerNote]', RESEED, 1)
DBCC CHECKIDENT(N'[Billing].[CustomerNote]', RESEED)
 
-- Reseed identity on [Billing].[PriceRule]
DBCC CHECKIDENT(N'[Billing].[PriceRule]', RESEED, 1)
DBCC CHECKIDENT(N'[Billing].[PriceRule]', RESEED)

-- Reseed identity on [Billing].[OrderRule]
DBCC CHECKIDENT(N'[Billing].[OrderRule]', RESEED, 1)
DBCC CHECKIDENT(N'[Billing].[OrderRule]', RESEED)

-- Reseed identity on [Billing].[OrderCompleted]
DBCC CHECKIDENT(N'[Billing].[OrderCompleted]', RESEED, 1)
DBCC CHECKIDENT(N'[Billing].[OrderCompleted]', RESEED)

-- Reseed identity on [Billing].[OrderSpecial]
DBCC CHECKIDENT(N'[Billing].[OrderSpecial]', RESEED, 1)
DBCC CHECKIDENT(N'[Billing].[OrderSpecial]', RESEED)

-- Reseed identity on [Billing].[InvoiceOrder]
DBCC CHECKIDENT(N'[Billing].[Invoice]', RESEED, 1)
DBCC CHECKIDENT(N'[Billing].[Invoice]', RESEED)

-- Reseed identity on [Billing].[InvoiceOrder]
DBCC CHECKIDENT(N'[Billing].[InvoiceOrder]', RESEED, 1)
DBCC CHECKIDENT(N'[Billing].[InvoiceOrder]', RESEED)

-- Reseed identity on [Billing].[InvoiceOrderSpecial]
DBCC CHECKIDENT(N'[Billing].[InvoiceOrderSpecial]', RESEED, 1)
DBCC CHECKIDENT(N'[Billing].[InvoiceOrderSpecial]', RESEED)

-- Reseed identity on [TV].[TVAudit]
--DBCC CHECKIDENT(N'[TV].[TVAudit]', RESEED, 1)
--DBCC CHECKIDENT(N'[TV].[TVAudit]', RESEED)

-- Reseed identity on [Player_Master].[Tournaments_Table]
DBCC CHECKIDENT(N'[Player_Master].[Tournaments_Table]', RESEED, 1)
DBCC CHECKIDENT(N'[Player_Master].[Tournaments_Table]', RESEED)

-- Reseed identity on [LKP].[Tour]
DBCC CHECKIDENT(N'[LKP].[Tour]', RESEED, 1)
DBCC CHECKIDENT(N'[LKP].[Tour]', RESEED)

-- Reseed identity on [LKP].[TourMaster]
DBCC CHECKIDENT(N'[LKP].[TourMaster]', RESEED, 1)
DBCC CHECKIDENT(N'[LKP].[TourMaster]', RESEED)

-- Reseed identity on [LKP].[TournamentMaster]
DBCC CHECKIDENT(N'[LKP].[TournamentMaster]', RESEED, 1)
DBCC CHECKIDENT(N'[LKP].[TournamentMaster]', RESEED)

END
GO
