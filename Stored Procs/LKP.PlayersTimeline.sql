IF OBJECT_ID('LKP.PlayersTimeline') IS NOT NULL
    DROP PROCEDURE [LKP].[PlayersTimeline];
GO

CREATE procedure LKP.PlayersTimeline
(@player1 as varchar(50),
 @player2 as varchar(50))
as
begin

;with cte_1 as (SELECT [PLAYERNAME],p.[SEX],[TYPE],[TOURNAMENT NAME],[FIRSTDAY],p.[SID]
  FROM [DARRELL_MASTER].[Player_Master].[PLAYERNAMES] p
  inner join Player_Master.TOURNAMENTS_TABLE t
  on p.SID = t.sid and p.FIRSTDAY = t.[FIRST DAY]
  where [PLAYERNAME] = @player1
  and ((p.INPUTNO > 0 and p.FIRSTDAY >= '20120101') or p.FIRSTDAY < '20120101')), 
  
  cte_2 as (SELECT [PLAYERNAME],p.[SEX],[TYPE],[TOURNAMENT NAME],[FIRSTDAY],p.[SID]
  FROM [DARRELL_MASTER].[Player_Master].[PLAYERNAMES] p
  inner join Player_Master.TOURNAMENTS_TABLE t
  on p.SID = t.sid and p.FIRSTDAY = t.[FIRST DAY]
  where [PLAYERNAME] = @player2
  and ((p.INPUTNO > 0 and p.FIRSTDAY >= '20120101') or p.FIRSTDAY < '20120101'))


select isnull(cte_1.SEX,'') as Sex1, 
		isnull(cte_1.[TYPE],'') as Tour1, 
		isnull(cte_1.[TOURNAMENT NAME],'') as Tournament1,
		coalesce(cte_1.FIRSTDAY, cte_2.FIRSTDAY) as TournamentDate,
		isnull(cte_2.SEX,'') as Sex2, 
		isnull(cte_2.[TYPE],'') as Tour2, 
		isnull(cte_2.[TOURNAMENT NAME],'') as Tournament2,
		coalesce(cte_1.[SID], cte_2.[SID]) as RowIndex
from cte_1 full outer join cte_2 
on cte_1.FIRSTDAY = cte_2.FIRSTDAY 
order by TournamentDate desc;

end
GO
