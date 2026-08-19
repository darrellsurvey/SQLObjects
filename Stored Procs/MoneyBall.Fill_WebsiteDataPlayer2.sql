IF OBJECT_ID('MoneyBall.Fill_WebsiteDataPlayer2') IS NOT NULL
    DROP PROCEDURE [MoneyBall].[Fill_WebsiteDataPlayer2];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	Fill table MoneyBall.WebsiteDataPlayer2
-- =============================================

CREATE procedure [MoneyBall].[Fill_WebsiteDataPlayer2]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS
Begin -- WebsiteDataPlayer2
Print 'Start WebsiteDataPlayer2'

delete from MoneyBall.WebsiteDataPlayer2 where PGASeason = @PGASeason and SportTourId = @SportTourId


;with CTE_TVTime as (select isnull(SUM(DSPoints), 0) as TotalPoints, isnull(SUM(DSMoney), 0) as DSM,
							isnull(SUM(case when equip = 'Shirt' then DSPoints end), 0) as TotalPointsShirt,
							isnull(SUM(case when equip = 'Bag' then DSPoints end), 0) as TotalPointsBag, 
							isnull(SUM(case when equip = 'Headgear' then DSPoints end), 0) as TotalPointsHat, 
							PlayerName, PGASeason, TournamentId, TntFirstDay, TntName
					from TV.TVAudit 
					--Where TOUR = @Tour and PGASeason = @PGASeason and TntFirstDay < @LastFullTournamentEnd and IsUsedInCalculations = 1 and Caddie = 0 
					Where PGASeason = @PGASeason and TntFirstDay < @LastFullTournamentEnd and IsUsedInCalculations = 1 and Caddie = 0 and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and TntNid in (26,351,353,355))) 
					group by PlayerName, PGASeason, TournamentId, TntFirstDay, TntName),
      
 
CTE_Money as (SELECT m.TournamentId, m.[Official Money], 
	isnull(m.Tie, '') + isnull(cast(m.[Finish Position] as varchar(4)), '') + ISNULL(m.Cut,'') as FinishPos,
	m.[Tour Ranking], [PLAYER NAME], [TOURNAMENT NAME], [FIRST DAY], PGASeason
  FROM [Money].TourMoneyStats m
  inner join Player_Master.TOURNAMENTS_TABLE t on m.TournamentId = t.TournamentId 
  --where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and t.TYPE = @Tour) 
  where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd  and ((@Sporttourid <> 58 and t.TYPE = @Tour) or (@Sporttourid = 58 and t.SID in (26,351,353,355)))) 




Insert Into MoneyBall.WebsiteDataPlayer2
(TournamentId,PGASeason,FirstDay,TournamentName,[PlayerName],Position,TournamentEarnings,CurrentTourRanking,DSPoints,DSM,DSPointsShirt,DSPointsHat,DSPointsBag,SportTourId)
      
select coalesce(m.TournamentId, n.tournamentid), coalesce(m.PGASeason, n.pgaseason), coalesce([FIRST DAY], tntFirstDay) as FirstDay, coalesce([TOURNAMENT NAME], tntName) as TournamentName, coalesce(n.PlayerName,m.[PLAYER NAME]) as PlayerName,
m.FinishPos as Position, m.[Official Money] as TournamentEarnings, m.[Tour Ranking] as CurrentTourRanking,
TotalPoints as DSPoints,
DSM,
TotalPointsShirt as DSPointsShirt, 
TotalPointsHat as DSPointsHat, 
TotalPointsBag as DSPointsBag,
@SportTourId
from CTE_TVTime N
full outer join CTE_Money m
on N.TournamentId = m.TournamentId and N.PlayerName = m.[PLAYER NAME] 
order by PlayerName, [FIRST DAY]

update w
set w.TournamentPlayerDSRank = a.rn
from MoneyBall.WebsiteDataPlayer2 w inner join
(select TournamentId, PlayerName, rank() over(partition by tournamentid order by DSPoints desc) as rn from MoneyBall.WebsiteDataPlayer2 where PGASeason = @PGASeason and SportTourId = @SportTourId) a
on w.TournamentId = a.TournamentId and w.PlayerName = a.PlayerName 
where PGASeason = @PGASeason 


;with CTE_rounds as (select isnull(SUM(case when [Round] = 1 then DSPoints end), 0) as Round1,
							isnull(SUM(case when [Round] = 2 then DSPoints end), 0) as Round2,
							isnull(SUM(case when [Round] = 3 then DSPoints end), 0) as Round3,
							isnull(SUM(case when [Round] in (4, 5) then DSPoints end), 0) as Round4,
							PlayerName, PGASeason, TournamentId 
					from TV.TVAudit 
					--Where TOUR = @Tour and PGASeason = @PGASeason and TntFirstDay < @LastFullTournamentEnd and Caddie = 0 and IsUsedInCalculations = 1
					Where PGASeason = @PGASeason and TntFirstDay < @LastFullTournamentEnd and Caddie = 0 and IsUsedInCalculations = 1  and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and TntNid in (26,351,353,355)))
					group by PlayerName, PGASeason, TournamentId)


update w
set w.DSPointsRound1 = a.Round1, w.DSPointsRound2 = a.Round2, w.DSPointsRound3 = a.Round3, w.DSPointsRound4 = a.Round4
from MoneyBall.WebsiteDataPlayer2 w inner join
(select * from CTE_rounds) a
on w.TournamentId = a.TournamentId and w.PlayerName = a.PlayerName 

Print 'Finished WebsiteDataPlayer2'; 
end  -- WebsiteDataPlayer2
GO
