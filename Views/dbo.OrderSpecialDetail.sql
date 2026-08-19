DROP VIEW IF EXISTS [dbo].[OrderSpecialDetail];
GO

CREATE VIEW [dbo].[OrderSpecialDetail]
AS
SELECT     TOP (100) PERCENT Billing.Customer.CompanyName, Billing.Customer.SurveyName, '' AS Tour, '' AS [TOURNAMENT NAME], '' AS [FIRST DAY], '' AS LASTDAY, 
                      LKP.Report.ReportName, Billing.OrderSpecial.Price, 0 AS Fee1Amount, '' AS Fee1TypeId, 0 AS Fee2Amount, '' AS Fee2TypeId, 0 AS Fee3Amount, '' AS Fee3TypeId, 
                      Billing.OrderSpecial.Discount, 0 AS PriceRuleId, Billing.OrderSpecial.OrderID, 1 AS OrderCase, Billing.Customer.CustomerId, '' AS LOCATION
FROM         Billing.Customer INNER JOIN
                      Billing.OrderSpecial ON Billing.Customer.CustomerId = Billing.OrderSpecial.CustomerId INNER JOIN
                      LKP.Report ON Billing.OrderSpecial.ReportId = LKP.Report.ReportId
ORDER BY Billing.Customer.SurveyName, LKP.Report.ReportName
GO
