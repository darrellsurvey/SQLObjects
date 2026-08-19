DROP VIEW IF EXISTS [dbo].[Grip_Iron];
GO

CREATE VIEW dbo.Grip_Iron
AS
SELECT     TOP (100) PERCENT Player_Master.TOURNAMENTS_TABLE.SID, Player_Master.TOURNAMENTS_TABLE.TYPE AS TOUR, 
                      Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME], Player_Master.TOURNAMENTS_TABLE.[FIRST DAY], 
                      Player_Master.[Grip Detail].Name AS PLAYERNAME, Player_Master.[Grip Detail].PKey, Player_Master.[Grip Detail].[Grip Equip Type] AS EQUIPMENT, 
                      Player_Master.[Iron Detail].ISSET AS SPEC_FLAG, Player_Master.[Grip Detail].[Grip Club Code] AS [CLUB NUMBER], 
                      LKP.[Manufacturer Codes and Desc].[Mfgr Descr] AS BRAND, LKP.[Model Codes and Descr].[Model Descr] AS MODEL, 
                      LKP.[Material Codes and Descript].[Matl Descr] AS MATERIAL, Player_Master.TOURNAMENTS_TABLE.TournamentId
FROM         LKP.[Manufacturer Codes and Desc] INNER JOIN
                      Player_Master.[Grip Detail] ON LKP.[Manufacturer Codes and Desc].[Mfgr Code] = Player_Master.[Grip Detail].[Grip Brand Code] INNER JOIN
                      LKP.[Model Codes and Descr] ON Player_Master.[Grip Detail].[Grip Model Code] = LKP.[Model Codes and Descr].[Model Code] INNER JOIN
                      Player_Master.TOURNAMENTS_TABLE ON Player_Master.[Grip Detail].[Survey ID] = Player_Master.TOURNAMENTS_TABLE.SID AND 
                      Player_Master.[Grip Detail].[First Day] = Player_Master.TOURNAMENTS_TABLE.[FIRST DAY] INNER JOIN
                      LKP.[Material Codes and Descript] ON Player_Master.[Grip Detail].[Grip Mat'l Code] = LKP.[Material Codes and Descript].[Matl Code] INNER JOIN
                      Player_Master.[Iron Detail] ON Player_Master.[Grip Detail].PKey = Player_Master.[Iron Detail].PKey AND 
                      Player_Master.[Grip Detail].Name = Player_Master.[Iron Detail].Name AND Player_Master.[Grip Detail].[Survey ID] = Player_Master.[Iron Detail].[Survey ID] AND 
                      Player_Master.[Grip Detail].[First Day] = Player_Master.[Iron Detail].[First Day]
WHERE     (Player_Master.[Grip Detail].[Grip Equip Type] = N'IRON')
ORDER BY Player_Master.TOURNAMENTS_TABLE.[FIRST DAY] DESC, TOUR, Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME], PLAYERNAME, EQUIPMENT, 
                      Player_Master.[Grip Detail].PKey
GO
