DROP VIEW IF EXISTS [dbo].[PriceRules];
GO

CREATE VIEW dbo.PriceRules
AS
SELECT     TOP (100) PERCENT Billing.PriceRule.CustomerId, Billing.Customer.CompanyName, LKP.Tour.TourName, Billing.Customer.SurveyName, LKP.Report.ReportName, 
                      Billing.PriceRule.Price, Billing.PriceRule.Fee1Amount, Billing.PriceRule.YearApplicable
FROM         Billing.PriceRule INNER JOIN
                      Billing.Customer ON Billing.PriceRule.CustomerId = Billing.Customer.CustomerId INNER JOIN
                      LKP.Report ON Billing.PriceRule.ReportId = LKP.Report.ReportId INNER JOIN
                      LKP.Tour ON Billing.PriceRule.TourId = LKP.Tour.TourId
ORDER BY Billing.Customer.CompanyName, LKP.Tour.TourName, LKP.Report.ReportName
GO
