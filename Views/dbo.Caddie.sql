IF OBJECT_ID('dbo.Caddie') IS NOT NULL
    DROP VIEW [dbo].[Caddie];
GO

CREATE VIEW dbo.Caddie
AS
SELECT        TOP (100) PERCENT Player_Master.TOURNAMENTS_TABLE.SID, Player_Master.TOURNAMENTS_TABLE.TYPE AS TOUR, 
                         Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME], Player_Master.TOURNAMENTS_TABLE.[FIRST DAY], 
                         Player_Master.TOURNAMENTS_TABLE.TournamentId, Player_Master.PLAYERNAMES.PLAYERNAME, Player_Master.PLAYERNAMES.CADDIE
FROM            Player_Master.TOURNAMENTS_TABLE INNER JOIN
                         Player_Master.PLAYERNAMES ON Player_Master.TOURNAMENTS_TABLE.SID = Player_Master.PLAYERNAMES.SID AND 
                         Player_Master.TOURNAMENTS_TABLE.[FIRST DAY] = Player_Master.PLAYERNAMES.FIRSTDAY
ORDER BY Player_Master.TOURNAMENTS_TABLE.[FIRST DAY] DESC, TOUR, Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME]
GO
