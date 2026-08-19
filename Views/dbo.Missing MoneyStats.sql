IF OBJECT_ID('dbo.Missing MoneyStats') IS NOT NULL
    DROP VIEW [dbo].[Missing MoneyStats];
GO

CREATE VIEW dbo.[Missing MoneyStats]
AS
SELECT     TournamentId, SID, TYPE, [FIRST DAY], [LAST DAY], [TOURNAMENT NAME], LOCATION
FROM         dbo.TournamentsThisYear
WHERE     (TournamentId NOT IN
                          (SELECT DISTINCT TournamentId
                            FROM          Money.TourMoneyStats)) AND (TYPE IN ('PGA', 'WEB.COM', 'CHAMPIONS', 'JGTO'))
GO
