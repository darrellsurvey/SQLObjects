DROP VIEW IF EXISTS [dbo].[OrderPreBillingDetail];
GO

CREATE VIEW [dbo].[OrderPreBillingDetail]
AS
SELECT     TOP (100) PERCENT Billing.Customer.CompanyName, Billing.Customer.SurveyName, Player_Master.TOURNAMENTS_TABLE.TYPE AS Tour, 
                      Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME], Player_Master.TOURNAMENTS_TABLE.[FIRST DAY], 
                      Player_Master.TOURNAMENTS_TABLE.[LAST DAY], LKP.Report.ReportName, Billing.OrderPreBilling.Price, Billing.OrderPreBilling.Fee1Amount, 
                      Billing.OrderPreBilling.Fee1TypeId, Billing.OrderPreBilling.Fee2Amount, Billing.OrderPreBilling.Fee2TypeId, Billing.OrderPreBilling.Fee3Amount, 
                      Billing.OrderPreBilling.Fee3TypeId, Billing.OrderPreBilling.Discount, Billing.OrderPreBilling.PriceRuleId, Billing.OrderPreBilling.OrderId, 2 AS OrderCase, 
                      Billing.OrderPreBilling.CustomerId, Player_Master.TOURNAMENTS_TABLE.LOCATION
FROM         Billing.OrderPreBilling INNER JOIN
                      Billing.Customer ON Billing.OrderPreBilling.CustomerId = Billing.Customer.CustomerId INNER JOIN
                      LKP.Report ON Billing.OrderPreBilling.ReportId = LKP.Report.ReportId INNER JOIN
                      Player_Master.TOURNAMENTS_TABLE ON Billing.OrderPreBilling.TournamentId = Player_Master.TOURNAMENTS_TABLE.TournamentId
ORDER BY Player_Master.TOURNAMENTS_TABLE.[FIRST DAY] DESC, Tour, Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME], Billing.Customer.SurveyName, 
                      LKP.Report.ReportName
GO
