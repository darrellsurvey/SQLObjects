IF OBJECT_ID('LKP.TournamentInfo') IS NOT NULL
    DROP VIEW [LKP].[TournamentInfo];
GO

CREATE VIEW LKP.TournamentInfo
AS
SELECT        LKP.Tour.TourName AS Tour, LKP.Tour.Year AS YearPlayed, Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME] AS TournamentName, Player_Master.TOURNAMENTS_TABLE.CLUB, 
                         Player_Master.TOURNAMENTS_TABLE.LOCATION, Player_Master.TOURNAMENTS_TABLE.[FIRST DAY] AS FirstDay, Player_Master.TOURNAMENTS_TABLE.[LAST DAY] AS LastDay, 
                         Player_Master.TOURNAMENTS_TABLE.ISFLASH, Player_Master.TOURNAMENTS_TABLE.TournamentId, Player_Master.TOURNAMENTS_TABLE.SID
FROM            Player_Master.TOURNAMENTS_TABLE INNER JOIN
                         LKP.Tour ON Player_Master.TOURNAMENTS_TABLE.TourId = LKP.Tour.TourId
GO
