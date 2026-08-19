IF OBJECT_ID('dbo.TournamentsThisWeek') IS NOT NULL
    DROP VIEW [dbo].[TournamentsThisWeek];
GO

CREATE VIEW dbo.TournamentsThisWeek
AS
SELECT     TOP (100) PERCENT TournamentId, SID, TYPE, [FIRST DAY], [TOURNAMENT NAME], ISFLASH
FROM         Player_Master.TOURNAMENTS_TABLE
WHERE     ([FIRST DAY] BETWEEN DATEADD(Day, - 7, { fn NOW() }) AND { fn NOW() })
ORDER BY [FIRST DAY] DESC
GO
