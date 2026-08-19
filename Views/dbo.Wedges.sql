IF OBJECT_ID('dbo.Wedges') IS NOT NULL
    DROP VIEW [dbo].[Wedges];
GO

CREATE VIEW dbo.Wedges
AS
SELECT        TOP (100) PERCENT Player_Master.TOURNAMENTS_TABLE.SID, Player_Master.TOURNAMENTS_TABLE.TYPE AS TOUR, 
                         Player_Master.TOURNAMENTS_TABLE.PGASeason, Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME], 
                         Player_Master.TOURNAMENTS_TABLE.[FIRST DAY], Player_Master.[Wedge Detail].Name AS PLAYERNAME, Player_Master.[Wedge Detail].PKey, 
                         Player_Master.[Wedge Detail].[Wedge Club Code] AS [CLUB NUMBER], LKP.[Manufacturer Codes and Desc].[Mfgr Descr] AS BRAND, 
                         LKP.[Model Codes and Descr].[Model Descr] AS MODEL, LKP.[Type Codes and Description].[Type Descr] AS SIZE, 
                         COALESCE (NULLIF (LKP.[Model Codes and Descr].[Model Lvl1], N''), LKP.[Model Codes and Descr].[Model Descr]) AS SERIES, 
                         Player_Master.TOURNAMENTS_TABLE.TournamentId
FROM            Player_Master.[Wedge Detail] INNER JOIN
                         LKP.[Manufacturer Codes and Desc] ON LKP.[Manufacturer Codes and Desc].[Mfgr Code] = Player_Master.[Wedge Detail].[Wedge Brand Code] INNER JOIN
                         LKP.[Model Codes and Descr] ON Player_Master.[Wedge Detail].[Wedge Model Code] = LKP.[Model Codes and Descr].[Model Code] INNER JOIN
                         Player_Master.TOURNAMENTS_TABLE ON Player_Master.[Wedge Detail].[Survey ID] = Player_Master.TOURNAMENTS_TABLE.SID AND 
                         Player_Master.[Wedge Detail].[First Day] = Player_Master.TOURNAMENTS_TABLE.[FIRST DAY] LEFT OUTER JOIN
                         LKP.[Type Codes and Description] ON Player_Master.[Wedge Detail].[Wedge Type Code] = LKP.[Type Codes and Description].[Type Code]
GO
