IF OBJECT_ID('LKP.PlayerRank_NielsenRanking') IS NOT NULL
    DROP FUNCTION [LKP].[PlayerRank_NielsenRanking];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 3/10/2014
-- Description:	Get Player ranking for a player for a given year using Nielsen data and our TV time. 
--              Bruno MoneyBall project
-- =============================================

CREATE FUNCTION [LKP].[PlayerRank_NielsenRanking]
(
	@Tour varchar(25),
	@year integer
)
RETURNS Table
AS
RETURN
(

with CTE_TVTime as (SELECT SUM([Duration]) as TvTime
      ,[PlayerName]
      ,[RoundDate]
      ,[Round]
      ,[TntFirstDay]
      ,[TntNid]
  FROM [TV].[TVAudit] tv
  where year(TntFirstDay) = @year
  group by [PlayerName]
      ,tv.[RoundDate]
      ,[Round]
      ,[TntFirstDay]
      ,[TntNid]),
      
CTE_Nielsen as (SELECT tournamentid, 
							RoundDate, 
							ReachProj, 
							AverageMinutes * 100.0 / MinutesOfPlay2 as TimeWatchPercent
  FROM [TV].[Nielsen] tv
  where year(RoundDate) = @year and 
		TournamentId >0
  group by tournamentid, RoundDate, ReachProj, AverageMinutes, MinutesOfPlay2),      
      
CTE_TVAdjusted as (      
select N.TimeWatchPercent * tv.TvTime * N.ReachProj as AdjustedTVTime, 
		N.RoundDate, 
		n.TournamentId, 
		tv.PlayerName 
from CTE_Nielsen N
left outer join Player_Master.TOURNAMENTS_TABLE t
on N.TournamentId = t.TournamentId 
left outer join CTE_TVTime tv
on N.RoundDate = tv.RoundDate and t.[FIRST DAY] = tv.TntFirstDay  and t.SID = tv.TntNid 
where PlayerName is not null),

cte_Final as (
select SUM(AdjustedTVTime)/100000 as TotalPoints, PlayerName 
from CTE_TVAdjusted 
group by PlayerName)

select rank() over (order by TotalPoints desc) as YearRank, 
		[PLAYERNAME], 
		@year as YearPlayed, 
		TotalPoints
from cte_Final


)
GO
