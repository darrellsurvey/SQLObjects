IF OBJECT_ID('dbo.Woods') IS NOT NULL
    DROP VIEW [dbo].[Woods];
GO

CREATE VIEW dbo.Woods
AS
SELECT     TOP (100) PERCENT Player_Master.TOURNAMENTS_TABLE.SID, Player_Master.TOURNAMENTS_TABLE.TYPE AS TOUR, 
                      Player_Master.TOURNAMENTS_TABLE.PGASeason, Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME], 
                      Player_Master.TOURNAMENTS_TABLE.[FIRST DAY], Player_Master.[Wood Detail].Name AS PLAYERNAME, Player_Master.[Wood Detail].PKey, 
                      ISNULL(Player_Master.[Wood Detail].ISDRIVER, 0) AS ISDRIVER, dbo.[Club Labels].[Club Descr] AS [CLUB NUMBER], 
                      LKP.[Manufacturer Codes and Desc].[Mfgr Descr] AS BRAND, LKP.[Model Codes and Descr].[Model Descr] AS MODEL, 
                      COALESCE (NULLIF (LKP.[Model Codes and Descr].[Model Lvl1], N''), LKP.[Model Codes and Descr].[Model Descr]) AS SERIES, 
                      LKP.[Material Codes and Descript].[Matl Descr] AS MATERIAL, LKP.[Size Codes and Description].[Size Descr] AS SIZE, 
                      Player_Master.TOURNAMENTS_TABLE.TournamentId
FROM         Player_Master.[Wood Detail] LEFT OUTER JOIN
                      LKP.[Manufacturer Codes and Desc] ON LKP.[Manufacturer Codes and Desc].[Mfgr Code] = Player_Master.[Wood Detail].[Wood Brand Code] LEFT OUTER JOIN
                      LKP.[Model Codes and Descr] ON Player_Master.[Wood Detail].[Wood Model Code] = LKP.[Model Codes and Descr].[Model Code] INNER JOIN
                      Player_Master.TOURNAMENTS_TABLE ON Player_Master.[Wood Detail].[Survey ID] = Player_Master.TOURNAMENTS_TABLE.SID AND 
                      Player_Master.[Wood Detail].[First Day] = Player_Master.TOURNAMENTS_TABLE.[FIRST DAY] LEFT OUTER JOIN
                      LKP.[Material Codes and Descript] ON Player_Master.[Wood Detail].[Wood Mat'l Code] = LKP.[Material Codes and Descript].[Matl Code] LEFT OUTER JOIN
                      dbo.[Club Labels] ON Player_Master.[Wood Detail].[Wood Club Code] = dbo.[Club Labels].[Club Code] LEFT OUTER JOIN
                      LKP.[Size Codes and Description] ON Player_Master.[Wood Detail].[Wood Size Code] = LKP.[Size Codes and Description].[Size Code]
ORDER BY Player_Master.TOURNAMENTS_TABLE.[FIRST DAY] DESC, TOUR, Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME], PLAYERNAME, 
                      Player_Master.[Wood Detail].PKey
GO
