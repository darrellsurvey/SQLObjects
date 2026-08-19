DROP PROCEDURE IF EXISTS [MoneyBall].[Fill_WebsiteData1];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	Fill table MoneyBall.WebsiteData1
-- =============================================

CREATE procedure [MoneyBall].[Fill_WebsiteData1]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS
Begin -- WebsiteData1
Print 'Start WebsiteData1'

--exec [MoneyBall].[Fill_WebsiteData1] 'TGL', 2025,61,'20250606'

delete from MoneyBall.WebsiteData1 where PGASeason = @PGASeason and SportTourId = @SportTourId	

;with cte_1 as (SELECT a.TournamentId, [PLAYER NAME], a.[Tour Ranking], t.TYPE as Tour, t.PGASeason, t.[FIRST DAY] as FirstDay, t.[TOURNAMENT NAME] as TournamentName,
coalesce(tie, Cut, '') + isnull(cast([Finish Position] as varchar(3)),'') as Position, [Round 1], [Round 2], [Round 3], [Round 4], [Round 5], [Total Score], [Official Money]
FROM [Money].TourMoneyStats a inner join Player_Master.TOURNAMENTS_TABLE t on a.TournamentId = t.TournamentId 
--where t.PGASeason = @PGASeason and t.[FIRST DAY] < @LastFullTournamentEnd and t.[TYPE] = @Tour),
where t.PGASeason = @PGASeason and t.[FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and t.[type] = @Tour) or (@Sporttourid = 58 and t.[SID] in (26,351,353,355)))),


cte_2 as (
select TournamentId,PlayerName,
RANK() over(Partition by TournamentId order by sum(DSPoints) desc) as rn,
sum([ROUND 1]) as [ROUND 1],
sum([ROUND 2]) as [ROUND 2],
sum([ROUND 3]) as [ROUND 3],
sum([ROUND 4]) as [ROUND 4],
sum([ROUND 5]) as [ROUND 5],
sum([ROUND 1]) + sum([ROUND 2]) as TFTotal,
sum([ROUND 3]) + sum([ROUND 4]) + sum([ROUND 5]) as SSTotal,
(sum([ROUND 3]) + sum([ROUND 4]) + sum([ROUND 5]))*100.0 / sum(DSPoints) as SSProportion,
SUM(Shirt) *100.0/ sum(DSPoints) as Shirt,
SUM(Shoes) *100.0/ sum(DSPoints) as Shoes,
SUM(Headgear) *100.0/ sum(DSPoints) as Headgear,
SUM(Bag) *100.0/ sum(DSPoints) as Bag,
sum(DSPoints) as TotalDS,
sum(DSMoney) as TotalDSM
from (
select case when [ROUND] = 1 then DSPoints else 0 end as [ROUND 1],
		case when [ROUND] = 2 then DSPoints else 0 end as [ROUND 2],
		case when [ROUND] = 3 then DSPoints else 0 end as [ROUND 3],
		case when [ROUND] = 4 then DSPoints else 0 end as [ROUND 4],
		case when [ROUND] = 5 then DSPoints else 0 end as [ROUND 5],
		case when [Equip] = 'Shirt' then DSPoints else 0 end as [Shirt],
		case when [Equip] = 'Shoes' then DSPoints else 0 end as [Shoes],
		case when [Equip] = 'Headgear' then DSPoints else 0 end as [Headgear],
		case when [Equip] = 'Bag' then DSPoints else 0 end as [Bag],
		DSPoints,
		DSMoney,
		TournamentId,
		tv.PlayerName
from tv.tvaudit tv
--where TOUR = @Tour and PGASeason = @PGASeason and TntFirstDay < @LastFullTournamentEnd and IsUsedInCalculations = 1) a
where PGASeason = @PGASeason and TntFirstDay < @LastFullTournamentEnd and IsUsedInCalculations = 1 and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and TntNid in (26,351,353,355)))) a
group by TournamentId,PlayerName),


cte3 as (
select cte_1.Tournamentid, Tour, PGASeason, FirstDay, TournamentName, cte_1.[PLAYER NAME] as PlayerName,  
cte_1.Position, cte_1.[Tour Ranking] as CurrentTourRanking, [Official Money] as TournamentEarnings,
cte_1.[Round 1] as Round1Score, cte_2.[Round 1],
cte_1.[Round 2] as Round2Score, cte_2.[Round 2],
cte_1.[Round 3] as Round3Score, cte_2.[Round 3],
cte_1.[Round 4] as Round4Score, cte_2.[Round 4],
cte_1.[Round 5] as Round5Score, cte_2.[Round 5],
TFTotal,
SSTotal,
SSProportion,
[Shirt],
[Shoes],
[Headgear],
[Bag],
TotalDS,TotalDSM,
RANK() over(PARTITION by cte_1.tournamentid order by TotalDS desc) as DSRank
from cte_1 left outer join cte_2 on cte_1.tournamentid = cte_2.TournamentID and cte_1.[PLAYER NAME] = cte_2.PlayerName 
)


Insert into MoneyBall.WebsiteData1 (Tournamentid,Tour, PGASeason, FirstDay, TournamentName, PlayerName,  Position, CurrentTourRanking, TournamentEarnings,
Round1Score, [Round1DS], Round2Score, [Round2DS], Round3Score, [Round3DS], Round4Score, [Round4DS], Round5Score, [Round5DS], TotalDS, DSEventRank,
TFDSTotal, SSDSTotal, SSProportion, [Shirt], [Shoes], [Headgear], [Bag],SportTourId, DSM)

select Tournamentid,Tour, PGASeason, FirstDay, TournamentName, PlayerName,  Position, CurrentTourRanking, TournamentEarnings,
Round1Score, [Round 1], Round2Score, [Round 2], Round3Score, [Round 3], Round4Score, [Round 4], Round5Score, [Round 5], TotalDS, DSRank,
TFTotal, SSTotal, SSProportion, [Shirt], [Shoes], [Headgear], [Bag],@SportTourId, TotalDSM
from cte3 order by FirstDay, TournamentName, PlayerName



if @SportTourId = 8 
	begin
		Insert into MoneyBall.WebsiteData1 (Tournamentid,Tour, PGASeason, FirstDay, TournamentName, PlayerName,  Position, CurrentTourRanking, TournamentEarnings,
	Round1Score, [Round1DS], Round2Score, [Round2DS], Round3Score, [Round3DS], Round4Score, [Round4DS], Round5Score, [Round5DS], TotalDS, DSEventRank,
	TFDSTotal, SSDSTotal, SSProportion, [Shirt], [Shoes], [Headgear], [Bag],SportTourId)
		
		select TournamentId,Tour, PGASeason, TntFirstDay as  FirstDay, tntName as TournamentName, PlayerName, NULL, NULL, NULL, 
		NULL, NULL,  NULL,  NULL,  NULL,  NULL,  NULL,  NULL,  NULL,  NULL,  sum(DSPoints) as TotalDS, RANK() over(Partition by TournamentId order by sum(DSPoints) desc) as DSEventRank,
				NULL as TFTotal, NULL as SSTotal, NULL as SSProportion,
				SUM(case when equip = 'Shirt' then DSPoints else 0 end) *100.0/ sum(DSPoints) as Shirt,
				SUM(case when equip = 'Shoes' then DSPoints else 0 end) *100.0/ sum(DSPoints) as Shoes,
				SUM(case when equip = 'Headgear' then DSPoints else 0 end) *100.0/ sum(DSPoints) as Headgear,
				SUM(case when equip = 'Bag' then DSPoints else 0 end) *100.0/ sum(DSPoints) as Bag,
				@SportTourId
		from tv.tvaudit tv
		where TOUR = @Tour and PGASeason = @PGASeason and TntFirstDay < @LastFullTournamentEnd
		group by TournamentId,PlayerName, Tour, PGASeason, TntFirstDay, tntName
	end



update MoneyBall.WebsiteData1 set DSEventRank = null where PGASeason = @PGASeason and (TotalDS = 0.0 or TotalDS is null)

Print 'Finished WebsiteData1'; 
end  -- WebsiteData1
GO
