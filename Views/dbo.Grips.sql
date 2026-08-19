IF OBJECT_ID('dbo.Grips') IS NOT NULL
    DROP VIEW [dbo].[Grips];
GO

CREATE VIEW dbo.Grips
AS
SELECT        TOP (100) PERCENT Player_Master.TOURNAMENTS_TABLE.SID, Player_Master.TOURNAMENTS_TABLE.TYPE AS TOUR, 
                         Player_Master.TOURNAMENTS_TABLE.PGASeason, Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME], 
                         Player_Master.TOURNAMENTS_TABLE.[FIRST DAY], Player_Master.[Grip Detail].Name AS PLAYERNAME, Player_Master.[Grip Detail].PKey, 
                         Player_Master.[Grip Detail].[Grip Equip Type] AS EQUIPMENT, 
                         CASE WHEN [Grip Equip Type] = 'IRON' THEN [GRIP CLUB CODE] ELSE dbo.[Club Labels].[Club Descr] END AS [CLUB NUMBER], 
                         [Manufacturer Codes and Desc_1].[Mfgr Descr] AS MANUFACTURER, LKP.[Manufacturer Codes and Desc].[Mfgr Descr] AS BRAND, 
                         LKP.[Model Codes and Descr].[Model Descr] AS MODEL, LKP.[Material Codes and Descript].[Matl Descr] AS MATERIAL, 
                         Player_Master.TOURNAMENTS_TABLE.TournamentId
FROM            LKP.[Manufacturer Codes and Desc] INNER JOIN
                         Player_Master.[Grip Detail] ON LKP.[Manufacturer Codes and Desc].[Mfgr Code] = Player_Master.[Grip Detail].[Grip Brand Code] INNER JOIN
                         LKP.[Model Codes and Descr] ON Player_Master.[Grip Detail].[Grip Model Code] = LKP.[Model Codes and Descr].[Model Code] INNER JOIN
                         Player_Master.TOURNAMENTS_TABLE ON Player_Master.[Grip Detail].[Survey ID] = Player_Master.TOURNAMENTS_TABLE.SID AND 
                         Player_Master.[Grip Detail].[First Day] = Player_Master.TOURNAMENTS_TABLE.[FIRST DAY] INNER JOIN
                         LKP.[Material Codes and Descript] ON Player_Master.[Grip Detail].[Grip Mat'l Code] = LKP.[Material Codes and Descript].[Matl Code] INNER JOIN
                         LKP.[Manufacturer Codes and Desc] AS [Manufacturer Codes and Desc_1] ON 
                         Player_Master.[Grip Detail].[Grip Mfgr Code] = [Manufacturer Codes and Desc_1].[Mfgr Code] LEFT OUTER JOIN
                         dbo.[Club Labels] ON Player_Master.[Grip Detail].[Grip Club Code] = dbo.[Club Labels].[Club Code]
ORDER BY TOUR, Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME]
GO
