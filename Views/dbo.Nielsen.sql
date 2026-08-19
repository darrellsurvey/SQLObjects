IF OBJECT_ID('dbo.Nielsen') IS NOT NULL
    DROP VIEW [dbo].[Nielsen];
GO

CREATE VIEW dbo.Nielsen
AS
SELECT        Player_Master.TOURNAMENTS_TABLE.TYPE, Player_Master.TOURNAMENTS_TABLE.PGASeason, Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME], 
                         Player_Master.TOURNAMENTS_TABLE.[FIRST DAY], Player_Master.TOURNAMENTS_TABLE.[LAST DAY], TV.Nielsen.RoundDate, DATENAME(WEEKDAY, 
                         TV.Nielsen.RoundDate) AS WeekDate, TV.Nielsen.NielsenCoefficient, TV.Nielsen.IsUsedInCalculations
FROM            TV.Nielsen INNER JOIN
                         Player_Master.TOURNAMENTS_TABLE ON TV.Nielsen.TournamentId = Player_Master.TOURNAMENTS_TABLE.TournamentId
GO
