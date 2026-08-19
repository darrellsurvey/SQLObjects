IF OBJECT_ID('dbo.Spikes') IS NOT NULL
    DROP VIEW [dbo].[Spikes];
GO

CREATE VIEW dbo.Spikes
AS
SELECT     TOP (100) PERCENT Player_Master.TOURNAMENTS_TABLE.SID, Player_Master.TOURNAMENTS_TABLE.TYPE AS TOUR, 
                      Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME], Player_Master.TOURNAMENTS_TABLE.[FIRST DAY], Player_Master.[All].PLAYERNAME, 
                      LKP.[Manufacturer Codes and Desc].[Mfgr Descr] AS BRAND, LKP.[Model Codes and Descr].[Model Descr] AS MODEL, 
                      Player_Master.TOURNAMENTS_TABLE.TournamentId
FROM         Player_Master.[All] INNER JOIN
                      Player_Master.TOURNAMENTS_TABLE ON Player_Master.[All].SID = Player_Master.TOURNAMENTS_TABLE.SID AND 
                      Player_Master.[All].[FIRST DAY] = Player_Master.TOURNAMENTS_TABLE.[FIRST DAY] INNER JOIN
                      LKP.[Model Codes and Descr] ON Player_Master.[All].SPIKEMODEL = LKP.[Model Codes and Descr].[Model Code] INNER JOIN
                      LKP.[Manufacturer Codes and Desc] ON Player_Master.[All].SPIKEBRAND = LKP.[Manufacturer Codes and Desc].[Mfgr Code]
ORDER BY Player_Master.TOURNAMENTS_TABLE.[FIRST DAY] DESC, TOUR, Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME], Player_Master.[All].PLAYERNAME
GO
