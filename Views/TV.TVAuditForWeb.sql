IF OBJECT_ID('TV.TVAuditForWeb') IS NOT NULL
    DROP VIEW [TV].[TVAuditForWeb];
GO

CREATE VIEW TV.TVAuditForWeb
AS
SELECT     Player_Master.TOURNAMENTS_TABLE.TYPE AS TOUR, TV.TournamentAudit.TournamentAuditID, NULL AS Timeline, TV.TournamentAudit.Duration, 
                      TV.TournamentAudit.PlayerName, TV.Equipment.Equipment AS Equip, LKP.[Manufacturer Codes and Desc].[Mfgr Descr] AS Brand, TV.TournamentAudit.Model, 
                      TV.Placement.Placement, NULL AS ProAm, TV.TournamentAudit.IsCaddie, NULL AS ReplayCurrent, TV.TournamentAudit.IsReplay AS ReplayOther, 
                      TV.TournamentAudit.IsInterview, NULL AS RoundDate, TV.TournamentRound.RoundNumber AS Round, TV.TournamentRound.RoundNumber AS Day, 
                      Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME] AS TntName, Player_Master.TOURNAMENTS_TABLE.[FIRST DAY] AS TntFirstDay, 
                      Player_Master.TOURNAMENTS_TABLE.[LAST DAY] AS TntLastDay, TV.Network.NetworkName AS Network, Player_Master.TOURNAMENTS_TABLE.SID AS TntNid, 
                      Player_Master.TOURNAMENTS_TABLE.SID AS TnTDid, TV.TournamentAudit.Notes, TV.TournamentRound.TournamentID, 
                      LKP.[Manufacturer Codes and Desc].[Mfgr Code]
FROM         TV.TournamentAudit INNER JOIN
                      TV.TournamentRoundNetwork ON TV.TournamentAudit.TournamentRoundNetworkID = TV.TournamentRoundNetwork.TournamentRoundNetworkID AND 
                      TV.TournamentAudit.TournamentRoundNetworkID = TV.TournamentRoundNetwork.TournamentRoundNetworkID AND 
                      TV.TournamentAudit.TournamentRoundNetworkID = TV.TournamentRoundNetwork.TournamentRoundNetworkID INNER JOIN
                      TV.TournamentRound ON TV.TournamentRoundNetwork.TournamentRoundID = TV.TournamentRound.TournamentRoundID AND 
                      TV.TournamentRoundNetwork.TournamentRoundID = TV.TournamentRound.TournamentRoundID AND 
                      TV.TournamentRoundNetwork.TournamentRoundID = TV.TournamentRound.TournamentRoundID INNER JOIN
                      Player_Master.TOURNAMENTS_TABLE ON TV.TournamentRound.TournamentID = Player_Master.TOURNAMENTS_TABLE.TournamentId AND 
                      TV.TournamentRound.TournamentID = Player_Master.TOURNAMENTS_TABLE.TournamentId INNER JOIN
                      TV.Placement ON TV.TournamentAudit.PlacementID = TV.Placement.PlacementID AND TV.TournamentAudit.PlacementID = TV.Placement.PlacementID AND 
                      TV.TournamentAudit.PlacementID = TV.Placement.PlacementID INNER JOIN
                      TV.Equipment ON TV.TournamentAudit.EquipmentID = TV.Equipment.EquipmentID AND TV.TournamentAudit.EquipmentID = TV.Equipment.EquipmentID AND 
                      TV.TournamentAudit.EquipmentID = TV.Equipment.EquipmentID INNER JOIN
                      TV.Network ON TV.TournamentRoundNetwork.NetworkID = TV.Network.NetworkID AND TV.TournamentRoundNetwork.NetworkID = TV.Network.NetworkID AND 
                      TV.TournamentRoundNetwork.NetworkID = TV.Network.NetworkID INNER JOIN
                      LKP.[Manufacturer Codes and Desc] ON TV.TournamentAudit.BrandID = LKP.[Manufacturer Codes and Desc].[Mfgr Code]
GO
