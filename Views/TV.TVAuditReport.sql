DROP VIEW IF EXISTS [TV].[TVAuditReport];
GO

CREATE VIEW TV.TVAuditReport
AS
SELECT     TV.TournamentAudit.TournamentAuditID, TV.TournamentAudit.Duration, TV.TournamentAudit.PlayerName, TV.Equipment.Equipment, 
                      LKP.[Manufacturer Codes and Desc].[Mfgr Descr] AS Brand, TV.TournamentAudit.Model, TV.Placement.Placement, TV.TournamentAudit.IsCaddie, 
                      TV.TournamentAudit.IsReplay, TV.TournamentAudit.IsInterview, TV.TournamentRound.RoundNumber, TV.TournamentRound.TournamentID
FROM         TV.TournamentAudit INNER JOIN
                      TV.TournamentRoundNetwork ON TV.TournamentAudit.TournamentRoundNetworkID = TV.TournamentRoundNetwork.TournamentRoundNetworkID AND 
                      TV.TournamentAudit.TournamentRoundNetworkID = TV.TournamentRoundNetwork.TournamentRoundNetworkID AND 
                      TV.TournamentAudit.TournamentRoundNetworkID = TV.TournamentRoundNetwork.TournamentRoundNetworkID INNER JOIN
                      TV.TournamentRound ON TV.TournamentRoundNetwork.TournamentRoundID = TV.TournamentRound.TournamentRoundID AND 
                      TV.TournamentRoundNetwork.TournamentRoundID = TV.TournamentRound.TournamentRoundID AND 
                      TV.TournamentRoundNetwork.TournamentRoundID = TV.TournamentRound.TournamentRoundID INNER JOIN
                      TV.Placement ON TV.TournamentAudit.PlacementID = TV.Placement.PlacementID AND TV.TournamentAudit.PlacementID = TV.Placement.PlacementID AND 
                      TV.TournamentAudit.PlacementID = TV.Placement.PlacementID INNER JOIN
                      TV.Equipment ON TV.TournamentAudit.EquipmentID = TV.Equipment.EquipmentID AND TV.TournamentAudit.EquipmentID = TV.Equipment.EquipmentID AND 
                      TV.TournamentAudit.EquipmentID = TV.Equipment.EquipmentID INNER JOIN
                      LKP.[Manufacturer Codes and Desc] ON TV.TournamentAudit.BrandID = LKP.[Manufacturer Codes and Desc].[Mfgr Code]
GO
