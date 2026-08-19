DROP PROCEDURE IF EXISTS [MoneyBall].[Fill_PlayerRank];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	Fill table MoneyBall.PlayerRank
-- =============================================

CREATE procedure [MoneyBall].[Fill_PlayerRank]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS
Begin -- PlayerRank

delete from MoneyBall.PlayerRank where PGASeason = @PGASeason and SportTourId = @SportTourId

Print 'Start PlayerRank'


;with cte_money as (
select a.PGASeason,
	  [PLAYER NAME], 
	  OfficialMoneyYTD, 
	  RANK() over(partition by a.PGASeason order by OfficialMoneyYTD desc) as PGARank,
	  TotalMoneyYTD,
	  RANK() over(partition by a.PGASeason order by TotalMoneyYTD desc) as MoneyRank,
	  LowRanking, HighRanking, Wins, Top10, TotalStarts
from
(SELECT PGASeason,
			  isnull(max([Money YTD]), 0) as OfficialMoneyYTD, 
			  isnull(sum([Official Money]), 0) as TotalMoneyYTD,
			  max([Tour Ranking]) as LowRanking,
			  min([Tour Ranking]) as HighRanking,
			  sum(case when [Finish Position] = 1 then 1 else 0 end) as Wins,
			  sum(case when [Finish Position] < 11 then 1 else 0 end) as Top10,
			  count(*) as TotalStarts,
			  [PLAYER NAME]
FROM [DARRELL_MASTER].[money].TourMoneyStats ms 
INNER JOIN [DARRELL_MASTER].Player_Master.TOURNAMENTS_TABLE tt ON ms.TournamentId = tt.TournamentId
--where [TYPE] = @Tour and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd
where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and Type = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))
group by PGASeason,[PLAYER NAME]) a),

			  
cte_ds as (select * from MoneyBall.PlayerDSRank where PGASeason = @PGASeason and SportTourId = @SportTourId)


Insert into MoneyBall.PlayerRank (PGASeason,[PLAYERNAME],OfficialMoneyYTD,PGARank,TotalMoneyYTD,MoneyRank,LowRanking, HighRanking, 
Wins, Top10,TotalStarts,DSRank,Trend,TotalDSPoints,ShirtDSPoints,HatDSPoints,BagDSPoints, SportTourId, DSM)

select coalesce(a.PGASeason, ds.PGASeason) as PGASeason,
coalesce(a.[PLAYER NAME], ds.playername) as PlayerName,
OfficialMoneyYTD, PGARank, TotalMoneyYTD, MoneyRank, LowRanking, HighRanking, Wins, Top10, TotalStarts,
DSRank, Trend, DSPoints as TotalDSPoints, ShirtDSPoints, HatDSPoints, BagDSPoints, @SportTourId, DSM
from cte_money a
full outer join cte_ds ds on a.PGASeason = ds.PGASeason and a.[PLAYER NAME] = ds.PlayerName
order by PGASeason, PGARank, PlayerName 



update a 
set a.WorldRank = b.[Rank], Country = CountryCode 
from MoneyBall.PlayerRank a inner join 
(select * from Money.WorldRank
where WeekEndDate = (select max(WeekEndDate) from Money.WorldRank where WeekEndDate < @LastFullTournamentEnd and PGASeason = @PGASeason)) b
on a.PGASeason = b.PGASeason and a.PlayerName = b.PlayerName and a.SportTourId = @SportTourId


update a 
set a.WorldLowRanking = b.MaxRank , a.WorldHighRanking = b.MinRank
from MoneyBall.PlayerRank a inner join 
(select PGASeason, coalesce(playername, playernameoriginal) as PlayerName, MIN([Rank]) as MinRank , Max([Rank]) as MaxRank 
from [Money].WorldRank where PGASeason = @PGASeason
group by PGASeason, coalesce(playername, playernameoriginal)) b
on a.PGASeason = b.PGASeason and a.PlayerName = b.PlayerName

update MoneyBall.PlayerRank set PGARank = Null where OfficialMoneyYTD = 0
update MoneyBall.PlayerRank set MoneyRank = Null where TotalMoneyYTD = 0


if @SportTourId = 8
begin
	Insert into MoneyBall.PlayerRank (PGASeason,[PLAYERNAME],OfficialMoneyYTD,PGARank,TotalMoneyYTD,MoneyRank,LowRanking, HighRanking, 
	Wins, Top10,TotalStarts,DSRank,Trend,TotalDSPoints,ShirtDSPoints,HatDSPoints,BagDSPoints, SportTourId)
	
	select PGASeason,[PLAYERNAME],NULL as OfficialMoneyYTD,NULL as PGARank,NULL as TotalMoneyYTD,NULL as MoneyRank,NULL as LowRanking, NULL as HighRanking, 
	NULL as Wins, NULL as Top10,count(distinct tournamentid) as TotalStarts, rank() over(order by Sum(DSPoints) desc) as DSRank, NULL as Trend,sum(dsPoints) as TotalDSPoints,
	sum(case when Equip = 'Shirt' then dsPoints else 0 end) as ShirtDSPoints,
	sum(case when Equip = 'Headgear' then dsPoints else 0 end) as HatDSPoints,
	sum(case when Equip = 'Bag' then dsPoints else 0 end) as BagDSPoints, 
	@SportTourId
	from TV.TVAudit
	where PGASeason = @PGASeason and Tour = @Tour
	group by PGASeason,[PLAYERNAME]

end




Print 'Finished PlayerRank'; 

end
GO
