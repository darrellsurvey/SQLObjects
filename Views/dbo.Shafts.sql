IF OBJECT_ID('dbo.Shafts') IS NOT NULL
    DROP VIEW [dbo].[Shafts];
GO

CREATE VIEW dbo.Shafts
AS
SELECT     TOP (100) PERCENT Player_Master.TOURNAMENTS_TABLE.SID, Player_Master.TOURNAMENTS_TABLE.TYPE AS TOUR, 
                      Player_Master.TOURNAMENTS_TABLE.PGASeason, Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME], 
                      Player_Master.TOURNAMENTS_TABLE.[FIRST DAY], Player_Master.[Shaft Detail].Name AS PLAYERNAME, Player_Master.[Shaft Detail].PKey, 
                      Player_Master.[Shaft Detail].[Shaft Equip Type] AS EQUIPMENT, COALESCE (dbo.[Club Labels].[Club Descr], Player_Master.[Shaft Detail].[Shaft Club Code]) 
                      AS [CLUB NUMBER], [Manufacturer Codes and Desc_1].[Mfgr Descr] AS MANUFACTURER, LKP.[Manufacturer Codes and Desc].[Mfgr Descr] AS BRAND, 
                      LKP.[Model Codes and Descr].[Model Descr] AS MODEL, LKP.[Flex Codes and Desc].[Flex Descr] AS FLEX, 
                      LKP.[Material Codes and Descript].[Matl Descr] AS MATERIAL, Player_Master.TOURNAMENTS_TABLE.TournamentId
FROM         LKP.[Manufacturer Codes and Desc] INNER JOIN
                      Player_Master.[Shaft Detail] ON LKP.[Manufacturer Codes and Desc].[Mfgr Code] = Player_Master.[Shaft Detail].[Shaft Brand Code] INNER JOIN
                      LKP.[Model Codes and Descr] ON Player_Master.[Shaft Detail].[Shaft Model Code] = LKP.[Model Codes and Descr].[Model Code] INNER JOIN
                      Player_Master.TOURNAMENTS_TABLE ON Player_Master.[Shaft Detail].[Survey ID] = Player_Master.TOURNAMENTS_TABLE.SID AND 
                      Player_Master.[Shaft Detail].[First Day] = Player_Master.TOURNAMENTS_TABLE.[FIRST DAY] INNER JOIN
                      LKP.[Material Codes and Descript] ON Player_Master.[Shaft Detail].[Shaft Mat'l Code] = LKP.[Material Codes and Descript].[Matl Code] INNER JOIN
                      LKP.[Manufacturer Codes and Desc] AS [Manufacturer Codes and Desc_1] ON 
                      Player_Master.[Shaft Detail].[Shaft Mfgr Code] = [Manufacturer Codes and Desc_1].[Mfgr Code] LEFT OUTER JOIN
                      dbo.[Club Labels] ON Player_Master.[Shaft Detail].[Shaft Club Code] = dbo.[Club Labels].[Club Code] LEFT OUTER JOIN
                      LKP.[Flex Codes and Desc] ON Player_Master.[Shaft Detail].[Shaft Flex Code] = LKP.[Flex Codes and Desc].[Flex Code]
ORDER BY Player_Master.TOURNAMENTS_TABLE.[FIRST DAY] DESC, TOUR, Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME], PLAYERNAME, EQUIPMENT, 
                      Player_Master.[Shaft Detail].PKey
GO
