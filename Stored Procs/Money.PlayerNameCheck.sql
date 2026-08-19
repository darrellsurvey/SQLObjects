IF OBJECT_ID('Money.PlayerNameCheck') IS NOT NULL
    DROP PROCEDURE [Money].[PlayerNameCheck];
GO

CREATE procedure [Money].[PlayerNameCheck]
as
begin
set nocount on;

with CTE_m as (SELECT  m.TourMoneyStatsId, 
						m.TournamentId, 
						m.[PLAYER NAME]
				FROM [DARRELL_MASTER].[Money].[TourMoneyStats] m
					inner join dbo.TournamentsThisYear t
					on m.TournamentId = t.TournamentId
				where [FIRST DAY] > DATEADD(DAY, -90, getdate())),

CTE_n as (select t.TournamentId, 
				 PLAYERNAME
		   from [DARRELL_MASTER].[Player_Master].[All] n
				inner join DARRELL_MASTER.Player_Master.TOURNAMENTS_TABLE t
				on n.SID = t.SID and n.[FIRST DAY] = t.[FIRST DAY]
				inner join (select distinct tournamentid from CTE_m) x 
				on t.TournamentId = x.TournamentId)

SELECT CTE_m.*, CTE_n.*
  FROM CTE_m full outer join CTE_n
  on [PLAYER NAME] = PLAYERNAME and 
		CTE_m.TournamentId = CTE_n.TournamentId
  where [PLAYER NAME] is null or PLAYERNAME is null
  order by [PLAYER NAME], PLAYERNAME
  
end
GO
