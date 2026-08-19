DROP FUNCTION IF EXISTS [LKP].[PlayerRank_Median];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 1/21/2014
-- Description:	Get median ranking for a player for a given year. Bruno MoneyBall project
-- =============================================

Create FUNCTION [LKP].[PlayerRank_Median]
(
	@PlayerName varchar(50),
	@Tour varchar(25),
	@year int
)
RETURNS Integer
AS
BEGIN

DECLARE @RESULT int


SELECT @RESULT = ((
        SELECT TOP 1 [Tour Ranking]
        FROM   (
                SELECT  TOP 50 PERCENT [Tour Ranking]
                FROM [DARRELL_MASTER].[Money].[TourMoneyStats] m
					inner join DARRELL_MASTER.Player_Master.TOURNAMENTS_TABLE t
					on m.TournamentId = t.TournamentId 
					where t.Type = @Tour and 
							year(t.[FIRST DAY]) = @year and
							m.[player name] = @PlayerName and
							[Tour Ranking] IS NOT NULL
                ORDER BY [Tour Ranking]
                ) AS A
        ORDER BY [Tour Ranking] DESC) +
        (
        SELECT TOP 1 [Tour Ranking]
        FROM   (
                SELECT  TOP 50 PERCENT [Tour Ranking]
                FROM [DARRELL_MASTER].[Money].[TourMoneyStats] m
					inner join DARRELL_MASTER.Player_Master.TOURNAMENTS_TABLE t
					on m.TournamentId = t.TournamentId 
					where t.Type = @Tour and 
							year(t.[FIRST DAY]) = @year and
							m.[player name] = @PlayerName and
							[Tour Ranking] IS NOT NULL
                ORDER BY [Tour Ranking] DESC
                ) AS A
        ORDER BY [Tour Ranking] ASC)) / 2


RETURN @RESULT

END
GO
