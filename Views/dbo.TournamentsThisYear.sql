IF OBJECT_ID('dbo.TournamentsThisYear') IS NOT NULL
    DROP VIEW [dbo].[TournamentsThisYear];
GO

CREATE VIEW dbo.TournamentsThisYear
AS
SELECT        TOP (100) PERCENT TournamentId, SID, TYPE, [FIRST DAY], [LAST DAY], [TOURNAMENT NAME], LOCATION
FROM            Player_Master.TOURNAMENTS_TABLE
WHERE        (Year = 2026) AND (ISFLASH = 0)
ORDER BY [FIRST DAY] DESC
GO
