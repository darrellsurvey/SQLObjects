DROP VIEW IF EXISTS [dbo].[Irons];
GO

CREATE VIEW dbo.Irons
AS
SELECT     TOP (100) PERCENT Player_Master.TOURNAMENTS_TABLE.SID, Player_Master.TOURNAMENTS_TABLE.TYPE AS TOUR, 
                      Player_Master.TOURNAMENTS_TABLE.PGASeason, Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME], 
                      Player_Master.TOURNAMENTS_TABLE.[FIRST DAY], Player_Master.[Iron Detail].Name AS PLAYERNAME, Player_Master.[Iron Detail].PKey, 
                      Player_Master.[Iron Detail].ISSET, Player_Master.[Iron Detail].[Iron Club Code] AS [CLUB NUMBER], LKP.[Manufacturer Codes and Desc].[Mfgr Descr] AS BRAND, 
                      LKP.[Model Codes and Descr].[Model Descr] AS MODEL, COALESCE (NULLIF (LKP.[Model Codes and Descr].[Model Lvl1], N''), 
                      LKP.[Model Codes and Descr].[Model Descr]) AS SERIES, Player_Master.TOURNAMENTS_TABLE.TournamentId
FROM         LKP.[Manufacturer Codes and Desc] INNER JOIN
                      Player_Master.[Iron Detail] ON LKP.[Manufacturer Codes and Desc].[Mfgr Code] = Player_Master.[Iron Detail].[Iron Brand Code] INNER JOIN
                      LKP.[Model Codes and Descr] ON Player_Master.[Iron Detail].[Iron Model Code] = LKP.[Model Codes and Descr].[Model Code] INNER JOIN
                      Player_Master.TOURNAMENTS_TABLE ON Player_Master.[Iron Detail].[Survey ID] = Player_Master.TOURNAMENTS_TABLE.SID AND 
                      Player_Master.[Iron Detail].[First Day] = Player_Master.TOURNAMENTS_TABLE.[FIRST DAY]
ORDER BY Player_Master.TOURNAMENTS_TABLE.[FIRST DAY] DESC, TOUR, Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME], PLAYERNAME, 
                      Player_Master.[Iron Detail].PKey
GO
