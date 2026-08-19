DROP VIEW IF EXISTS [Billing].[AllOrdersYTD];
GO

CREATE VIEW Billing.AllOrdersYTD
AS
SELECT     Billing.Customer.SurveyName AS Company, Player_Master.TOURNAMENTS_TABLE.TYPE, Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME], 
                      Player_Master.TOURNAMENTS_TABLE.SID AS TD, Player_Master.TOURNAMENTS_TABLE.[FIRST DAY], Player_Master.TOURNAMENTS_TABLE.[LAST DAY], 
                      LKP.Report.ReportName AS [Report Name], Billing.OrderCompleted.Rep_ID, Billing.OrderCompleted.OrderId AS pkey, Billing.OrderCompleted.CustomerId, 
                      Billing.OrderCompleted.TournamentId, Billing.OrderCompleted.ReportId, Billing.OrderCompleted.Price, Billing.OrderCompleted.Fee1Amount, 
                      Billing.OrderCompleted.Fee1TypeId, Billing.OrderCompleted.Fee2Amount, Billing.OrderCompleted.Fee2TypeId, Billing.OrderCompleted.Fee3Amount, 
                      Billing.OrderCompleted.Fee3TypeId, Billing.OrderCompleted.Discount, Billing.OrderCompleted.Year, Billing.OrderCompleted.PriceRuleId, 
                      Billing.OrderCompleted.OrderRuleId, Billing.OrderCompleted.Notes, Billing.OrderCompleted.AddedBy, Billing.OrderCompleted.AddedOn AS CreatedDateTime
FROM         Billing.OrderCompleted INNER JOIN
                      LKP.Report ON Billing.OrderCompleted.ReportId = LKP.Report.ReportId INNER JOIN
                      Billing.Customer ON Billing.OrderCompleted.CustomerId = Billing.Customer.CustomerId INNER JOIN
                      Player_Master.TOURNAMENTS_TABLE ON Billing.OrderCompleted.TournamentId = Player_Master.TOURNAMENTS_TABLE.TournamentId
GO
