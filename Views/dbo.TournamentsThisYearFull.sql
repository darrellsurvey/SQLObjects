IF OBJECT_ID('dbo.TournamentsThisYearFull') IS NOT NULL
    DROP VIEW [dbo].[TournamentsThisYearFull];
GO

CREATE VIEW dbo.TournamentsThisYearFull
AS
SELECT        TOP (100) PERCENT TournamentId, SID, TYPE, SEX, [FIRST DAY], [LAST DAY], [TOURNAMENT NAME], CLUB, LOCATION
FROM            Player_Master.TOURNAMENTS_TABLE
WHERE        (Year = 2026) AND (active_flag = 1)
ORDER BY [FIRST DAY] DESC
GO
