IF OBJECT_ID('dbo.Towel') IS NOT NULL
    DROP VIEW [dbo].[Towel];
GO

CREATE VIEW dbo.Towel
AS
SELECT        TOP (100) PERCENT Player_Master.TOURNAMENTS_TABLE.SID, Player_Master.TOURNAMENTS_TABLE.TYPE AS TOUR, 
                         Player_Master.TOURNAMENTS_TABLE.PGASeason, Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME], 
                         Player_Master.TOURNAMENTS_TABLE.[FIRST DAY], Player_Master.TOURNAMENTS_TABLE.[LAST DAY], 
                         Player_Master.[All].PLAYERNAME + CASE WHEN caddie IS NULL THEN '' ELSE ' | ' + Caddie END AS PLAYERNAME, 
                         CASE WHEN LKP.[Manufacturer Codes and Desc].[Mfgr Descr] = 'JANI-KING' THEN LKP.[Manufacturer Codes and Desc].[Mfgr Descr] ELSE 'UNSPECIFIED' END AS BRAND,
                          '' AS MODEL, Player_Master.TOURNAMENTS_TABLE.TournamentId
FROM            Player_Master.[All] INNER JOIN
                         Player_Master.TOURNAMENTS_TABLE ON Player_Master.[All].SID = Player_Master.TOURNAMENTS_TABLE.SID AND 
                         Player_Master.[All].[FIRST DAY] = Player_Master.TOURNAMENTS_TABLE.[FIRST DAY] INNER JOIN
                         LKP.[Manufacturer Codes and Desc] ON Player_Master.[All].TOWELBRAND = LKP.[Manufacturer Codes and Desc].[Mfgr Code] INNER JOIN
                         Player_Master.PLAYERNAMES ON Player_Master.[All].PLAYERNAME = Player_Master.PLAYERNAMES.PLAYERNAME AND 
                         Player_Master.[All].SID = Player_Master.PLAYERNAMES.SID AND Player_Master.[All].[FIRST DAY] = Player_Master.PLAYERNAMES.FIRSTDAY
ORDER BY Player_Master.TOURNAMENTS_TABLE.[FIRST DAY] DESC, TOUR, Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME], PLAYERNAME
GO
