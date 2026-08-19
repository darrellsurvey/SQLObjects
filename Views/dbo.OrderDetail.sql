IF OBJECT_ID('dbo.OrderDetail') IS NOT NULL
    DROP VIEW [dbo].[OrderDetail];
GO

CREATE VIEW [dbo].[OrderDetail]
AS
SELECT     TOP (100) PERCENT Billing.Customer.CompanyName, Billing.Customer.SurveyName, Player_Master.TOURNAMENTS_TABLE.TYPE AS Tour, 
                      Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME], Player_Master.TOURNAMENTS_TABLE.[FIRST DAY], 
                      Player_Master.TOURNAMENTS_TABLE.[LAST DAY], LKP.Report.ReportName, Billing.OrderCompleted.Price, Billing.OrderCompleted.Fee1Amount, 
                      Billing.OrderCompleted.Fee1TypeId, Billing.OrderCompleted.Fee2Amount, Billing.OrderCompleted.Fee2TypeId, Billing.OrderCompleted.Fee3Amount, 
                      Billing.OrderCompleted.Fee3TypeId, Billing.OrderCompleted.Discount, Billing.OrderCompleted.PriceRuleId, Billing.OrderCompleted.OrderId, 2 AS OrderCase, 
                      Billing.OrderCompleted.CustomerId, Player_Master.TOURNAMENTS_TABLE.LOCATION
FROM         Billing.OrderCompleted INNER JOIN
                      Billing.Customer ON Billing.OrderCompleted.CustomerId = Billing.Customer.CustomerId INNER JOIN
                      LKP.Report ON Billing.OrderCompleted.ReportId = LKP.Report.ReportId INNER JOIN
                      Player_Master.TOURNAMENTS_TABLE ON Billing.OrderCompleted.TournamentId = Player_Master.TOURNAMENTS_TABLE.TournamentId
ORDER BY Player_Master.TOURNAMENTS_TABLE.[FIRST DAY] DESC, Tour, Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME], Billing.Customer.SurveyName, 
                      LKP.Report.ReportName
GO
