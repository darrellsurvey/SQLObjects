IF OBJECT_ID('dbo.Putters') IS NOT NULL
    DROP VIEW [dbo].[Putters];
GO

CREATE VIEW dbo.Putters
AS
SELECT     TOP (100) PERCENT Player_Master.TOURNAMENTS_TABLE.SID, Player_Master.TOURNAMENTS_TABLE.TYPE AS TOUR, 
                      Player_Master.TOURNAMENTS_TABLE.PGASeason, Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME], 
                      Player_Master.TOURNAMENTS_TABLE.[FIRST DAY], Player_Master.[Putter Detail].Name AS PLAYERNAME, Player_Master.[Putter Detail].PKey, 
                      LKP.[Manufacturer Codes and Desc].[Mfgr Descr] AS BRAND, LKP.[Model Codes and Descr].[Model Descr] AS MODEL, 
                      LKP.[Size Codes and Description].[Size Descr] AS SIZE, COALESCE (NULLIF (LKP.[Model Codes and Descr].[Model Lvl1], N''), 
                      LKP.[Model Codes and Descr].[Model Descr]) AS SERIES, Player_Master.TOURNAMENTS_TABLE.TournamentId
FROM         LKP.[Manufacturer Codes and Desc] INNER JOIN
                      Player_Master.[Putter Detail] ON LKP.[Manufacturer Codes and Desc].[Mfgr Code] = Player_Master.[Putter Detail].[Putter Brand Code] INNER JOIN
                      LKP.[Model Codes and Descr] ON Player_Master.[Putter Detail].[Putter Model Code] = LKP.[Model Codes and Descr].[Model Code] INNER JOIN
                      Player_Master.TOURNAMENTS_TABLE ON Player_Master.[Putter Detail].[Survey ID] = Player_Master.TOURNAMENTS_TABLE.SID AND 
                      Player_Master.[Putter Detail].[First Day] = Player_Master.TOURNAMENTS_TABLE.[FIRST DAY] LEFT OUTER JOIN
                      LKP.[Size Codes and Description] ON Player_Master.[Putter Detail].[Putter Size Code] = LKP.[Size Codes and Description].[Size Code]
ORDER BY Player_Master.TOURNAMENTS_TABLE.[FIRST DAY] DESC, TOUR, Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME], PLAYERNAME, 
                      Player_Master.[Putter Detail].PKey
GO
