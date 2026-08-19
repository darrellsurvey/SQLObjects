IF OBJECT_ID('LKP.PlayerRank_BucketList') IS NOT NULL
    DROP FUNCTION [LKP].[PlayerRank_BucketList];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 1/21/2014
-- Description:	Get median ranking for a player for a given year. Bruno MoneyBall project
-- =============================================

CREATE FUNCTION [LKP].[PlayerRank_BucketList]
(
	@Tour varchar(25),
	@year integer
)
RETURNS Table
AS
RETURN
(


with CTE_Bucket as (
		SELECT case when [Finish Position] = 1 then 100
					when [Finish Position] = 2 then 90
					when [Finish Position] between 3 and 5 then 80
					when [Finish Position] between 6 and 10 then 70
					when [Finish Position] between 11 and 25 then 60
					when [Finish Position] between 26 and 50 then 50
					when [Finish Position] > 50 then 30
					else 5
			   end as PointsWon,
			   
			   case when [sid] in (116,356,651,652,691) then 1.25 -- WGC
			        when [sid] in (355,351,22,26,353) then 1.5 -- Majors
			        else 1
			   end as TournamentRatio,
			   
			   1 - (cast(@year - year(t.[FIRST DAY]) as integer) * 0.25) as YearRatio,
			   m.[PLAYER NAME]
        FROM [DARRELL_MASTER].[Money].[TourMoneyStats] m
		inner join DARRELL_MASTER.Player_Master.TOURNAMENTS_TABLE t
		on m.TournamentId = t.TournamentId 
		where t.Type = @Tour and 
				year(t.[FIRST DAY]) between @year-2 and @year),

CTE_Points as (select [PLAYER NAME], @year as YearPlayed, sum(PointsWon * TournamentRatio * YearRatio) as YearPoints 
from CTE_Bucket  
group by [PLAYER NAME])


select rank() over (order by YearPoints desc) as YearRank, [PLAYER NAME], YearPlayed, YearPoints
from CTE_Points
 
)
GO
