DROP VIEW IF EXISTS [dbo].[Ball];
GO

CREATE VIEW dbo.Ball
AS
SELECT     TOP (100) PERCENT Player_Master.TOURNAMENTS_TABLE.SID, Player_Master.TOURNAMENTS_TABLE.TYPE AS TOUR, 
                      Player_Master.TOURNAMENTS_TABLE.PGASeason, Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME], 
                      Player_Master.TOURNAMENTS_TABLE.[FIRST DAY], Player_Master.TOURNAMENTS_TABLE.[LAST DAY], Player_Master.[All].PLAYERNAME, 
                      LKP.[Manufacturer Codes and Desc].[Mfgr Descr] AS BRAND, LKP.[Model Codes and Descr].[Model Descr] AS MODEL, 
                      COALESCE (NULLIF (LKP.[Model Codes and Descr].[Model Lvl1], N''), LKP.[Model Codes and Descr].[Model Descr]) AS SERIES, 
                      Player_Master.TOURNAMENTS_TABLE.TournamentId
FROM         Player_Master.[All] INNER JOIN
                      LKP.[Manufacturer Codes and Desc] ON Player_Master.[All].BALLBRAND = LKP.[Manufacturer Codes and Desc].[Mfgr Code] INNER JOIN
                      LKP.[Model Codes and Descr] ON Player_Master.[All].BALLMODEL = LKP.[Model Codes and Descr].[Model Code] INNER JOIN
                      Player_Master.TOURNAMENTS_TABLE ON Player_Master.[All].SID = Player_Master.TOURNAMENTS_TABLE.SID AND 
                      Player_Master.[All].[FIRST DAY] = Player_Master.TOURNAMENTS_TABLE.[FIRST DAY]
ORDER BY Player_Master.TOURNAMENTS_TABLE.[FIRST DAY] DESC, TOUR, Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME], Player_Master.[All].PLAYERNAME
GO
