IF OBJECT_ID('MoneyBall.Fill_WebsiteDataPlayer6') IS NOT NULL
    DROP PROCEDURE [MoneyBall].[Fill_WebsiteDataPlayer6];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	Fill table MoneyBall.WebsiteDataPlayer6
-- =============================================

CREATE PROCEDURE [MoneyBall].[Fill_WebsiteDataPlayer6]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS
Begin -- WebsiteDataPlayer6
Print 'Start WebsiteDataPlayer6'

--exec [MoneyBall].[Fill_WebsiteDataPlayer6] 'PGA', 2025, 58, '20251030'

delete from MoneyBall.WebsiteDataPlayer6 where PGASeason = @PGASeason and SportTourId = @SportTourId

--rollback tran
begin tran
insert into MoneyBall.WebsiteDataPlayer6 (PlayerName, PGASeason, EventsPerSeason, TournamentsPlayed, EventsPlayerOnTV, TVExposure, TournamentsWon, TournamentsTop5, TournamentsTop10, TournamentsMadeCut,
	   PercentMadeCut, TournamentParticipation, DSRank, WorldRank, PGARank, MoneyWon, DSPoints,DSM, TFDSPoints, SSDSPoints, AvgTFDSPoints, AvgSSDSPoints, PortionOfEventTDueToSS, EventAvgDSPoints,
	   [ROUND 1], [ROUND 2], [ROUND 3], [ROUND 4], AvgScorePerHolePlayed,
	   AverageScore, AvgDrivingAccuracy, AvgDrivingDistance, TotalGreensInReg, AvgPuttingAvg, TotalGreensInRegPutts,
	   TotalFwysPlayed, TotalFwysHit, TotalSandSaves, TotalEagles, TotalBirdies, TotalHolesPlayed,SportTourId
	   )

SELECT w1.PlayerName, 
	   w1.PGASeason,
	   trn as EventsPerSeason,
	   TournamentsPlayed,
	   rn as EventsPlayerOnTV,
	   rn*100.0/TournamentsPlayed as TVExposure,
	   TournamentsWon,
	   TournamentsTop5,
	   TournamentsTop10,  
	   TournamentsMadeCut,
	   TournamentsMadeCut * 100.00 / nullif(TournamentsPlayed,0)  as PercentMadeCut,
	   TournamentsPlayed * 100.0 / nullif(trn,0) as TournamentParticipation,
	   w1.DSRank,
	   WorldRank, 
	   PGARank, 
	   w1.MoneyWon,
	   DSPoints,
	   DSM,
	   TFDSPoints, 
	   SSDSPoints,
	   TFDSPoints * 1.0 / rn as AvgTFDSPoints, 
	   SSDSPoints * 1.0 / rn as AvgSSDSPoints,
	   case when coalesce(DSPoints, 0) = 0 then NULL 
			when TFDSPoints = 0 then 100.00
			else case when SSDSPoints * 100.0 / nullif(DSPoints,0) > 999 then NULL else SSDSPoints * 100.0 / nullif(DSPoints,0) end end as PortionOfEventTDueToSS,
	   DSPoints * 1.0 / nullif(rn,0) as EventAvgDSPoints,
	   [ROUND 1],[ROUND 2],[ROUND 3],[ROUND 4], 
	   case when TotalHolesPlayed < 100 or isnull([ROUND 1]+[ROUND 2]+[ROUND 3],0) = 0 then NULL else TotalScore * 1.0 / nullif(TotalHolesPlayed,0) end as AvgScorePerHolePlayed,
	   [Total Score] as AverageScore,
	   AvgDrivingAccuracy,
	   AvgDrivingDistance,
	   TotalGreensInReg,
	   AvgPuttingAvg,
	   TotalGreensInRegPutts,
	   TotalFwysPlayed,
	   TotalFwysHit,
	   TotalSandSaves,
	   TotalEagles,
	   TotalBirdies,
	   TotalHolesPlayed,
	   @SportTourId
FROM MoneyBall.WebsiteDataPlayer1 w1
left outer join (select pgaseason, playername, COUNT(distinct tournamentid) as rn, sum(case when [ROUND] in (1, 2) then DSPoints else 0 end) as TFDSPoints,	sum(case when [ROUND] in (3, 4) then DSPoints else 0 end) as SSDSPoints 
					from TV.TVAudit 
					--where IsUsedInCalculations = 1 and PGASeason = @PGASeason  and tour = @Tour 
					where IsUsedInCalculations = 1 and PGASeason = @PGASeason and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and TntNid in (26,351,353,355))) 
					group by pgaseason, playername) a 
	on w1.PGASeason = a.PGASeason and w1.PlayerName = a.PlayerName and w1.SportTourId = @SportTourId
left outer join (select pgaseason, COUNT(distinct tournamentid) as trn 
					from TV.TVAudit 
					--where PGASeason = @PGASeason and tour = @Tour 
					where PGASeason = @PGASeason and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and TntNid in (26,351,353,355))) 
					group by pgaseason) b 
	on w1.PGASeason = b.PGASeason and w1.SportTourId = @SportTourId
left outer join (SELECT PGASeason, [PLAYER NAME],
						sum(case when not [Finish Position] IS NULL then 1 else 0 end) as TournamentsMadeCut, 
						sum(case when [Finish Position] < 6 then 1 else 0 end) as TournamentsTop5, 
						SUM(isnull(ms.[Holes Played], 0)) as TotalHolesPlayed,
						SUM(isnull(ms.[Total Score], 0)) as TotalScore,
						avg(ms.[Driving Accuracy]) as AvgDrivingAccuracy,
						AVG(ms.[Driving Distance]) as AvgDrivingDistance,
						SUM(isnull(ms.[Total GIRs], 0)) as TotalGreensInReg,
						AVG(ms.[Putting Avg]) as AvgPuttingAvg,
						SUM(isnull(ms.[Total GIR Putts], 0)) as TotalGreensInRegPutts,
						SUM(isnull(ms.[Total Fwys Played], 0)) as TotalFwysPlayed,
						SUM(isnull(ms.[Total Fwys Hit], 0)) as TotalFwysHit,
						SUM(isnull(ms.[Total Sand Saves], 0)) as TotalSandSaves,
						SUM(isnull(ms.[Total Eagles], 0)) as TotalEagles,
						SUM(isnull(ms.[Total Birdies], 0)) as TotalBirdies,
						avg(cast(ms.[ROUND 1] as decimal(5,2))) as [ROUND 1],
						avg(cast(ms.[ROUND 2] as decimal(5,2))) as [ROUND 2],
						avg(cast(ms.[ROUND 3] as decimal(5,2))) as [ROUND 3],
						avg(cast(ms.[ROUND 4] as decimal(5,2))) as [ROUND 4],
						avg(cast(ms.[Total Score] as decimal(5,2))) as [Total Score]
					FROM [DARRELL_MASTER].[money].TourMoneyStats ms
					INNER JOIN [DARRELL_MASTER].Player_Master.TOURNAMENTS_TABLE tt ON ms.TournamentId = tt.TournamentId
					--where [TYPE] = @Tour and PGASeason = @PGASeason
					where PGASeason = @PGASeason and ((@Sporttourid <> 58 and tt.type = @Tour) or (@Sporttourid = 58 and tt.SID in (26,351,353,355)))
					group by PGASeason,[PLAYER NAME]) c
	on w1.PGASeason = c.PGASeason  and w1.playername = c.[PLAYER NAME] and w1.SportTourId = @SportTourId
where (TotalHolesPlayed > 0  or isnull([ROUND 1]+[ROUND 2]+[ROUND 3],0) = 0) and w1.PGASeason = @PGASeason and w1.SportTourId = @SportTourId
order by TournamentsMadeCut * 100.00 / nullif(TournamentsPlayed,0) desc

commit tran

print '1'

--Sim Index

begin tran

--;with cte_elite as (SELECT avg([PercentMadeCut]) as [PercentMadeCut]
--      ,avg([AvgDrivingAccuracy]) as [AvgDrivingAccuracy]
--      ,avg([TotalGreensInReg]) * 1.0 / avg([TotalHolesPlayed]) as [TotalGreensInReg]
--      ,avg([TotalGreensInRegPutts]) * 1.0 / avg([TotalHolesPlayed]) as [TotalGreensInRegPutts]
--      ,avg([TotalFwysPlayed]) * 1.0 / avg([TotalHolesPlayed]) as [TotalFwysPlayed]
--      ,avg([TotalFwysHit]) * 1.0 / avg([TotalHolesPlayed]) as [TotalFwysHit]
--      ,avg([TotalSandSaves]) * 1.0 / avg([TotalHolesPlayed]) as [TotalSandSaves]
--      ,avg([TotalEagles]) * 1.0 / avg([TotalHolesPlayed]) as [TotalEagles]
--      ,avg([TotalBirdies]) * 1.0 / avg([TotalHolesPlayed]) as [TotalBirdies]
--  FROM [DARRELL_MASTER].[MoneyBall].[WebsiteDataPlayer6]
--  where TournamentsWon > 2  and pgaseason > 2009),

--cte_players as (
--SELECT [PlayerName]
--      ,[PGASeason]
--      ,[PercentMadeCut]
--      ,[AvgDrivingAccuracy]
--      ,[TotalGreensInReg] * 1.0 / [TotalHolesPlayed] as GIRPercent
--      ,[TotalGreensInRegPutts] * 1.0 / [TotalHolesPlayed] as GIRPuttPercent
--      ,[TotalFwysPlayed] * 1.0 / [TotalHolesPlayed] as FWPlayedPercent
--      ,[TotalFwysHit] * 1.0 / [TotalHolesPlayed] as FWHitPercent
--      ,[TotalSandSaves] * 1.0 / [TotalHolesPlayed] as SandSavesPercent
--      ,[TotalEagles] * 1.0 / [TotalHolesPlayed] as EaglesPercent
--      ,[TotalBirdies] * 1.0 / [TotalHolesPlayed] as BirdiesPercent

--  FROM [DARRELL_MASTER].[MoneyBall].[WebsiteDataPlayer6]
--  where TournamentsPlayed > 9),

--  ctefinal as (
--  select PlayerName, PGASeason, (p.PercentMadeCut - e.PercentMadeCut) / 100.0 + 
--								(p.AvgDrivingAccuracy - e.AvgDrivingAccuracy) / 100.0 +
--								(p.GIRPercent - e.TotalGreensInReg) +
--								(p.GIRPuttPercent - e.TotalGreensInRegPutts) +
--								(p.FWPlayedPercent - e.TotalFwysPlayed) +
--								(p.FWHitPercent - e.TotalFwysHit) +
--								(p.SandSavesPercent - e.TotalSandSaves) +
--								(p.EaglesPercent - e.TotalEagles) +
--								(p.BirdiesPercent - e.TotalBirdies) as SimIndex
	
--  from cte_players p
--  inner join cte_elite e on 1 = 1)



declare @PrevSeasonEvents as smallint
declare @CutOff as smallint


select @CutOff = count(*) * 0.2, @PrevSeasonEvents = count(*) from [DARRELL_MASTER].[MoneyBall].[WebsiteData2] where PGASeason = @PGASeason - 1 and SportTourId = @SportTourId

;with cte_elite as (SELECT avg([PercentMadeCut]) / 100.0 as [PercentMadeCut]
      ,avg([AvgDrivingAccuracy]) / 100.0 as [AvgDrivingAccuracy]
      ,avg([TotalGreensInReg]) * 1.0 / avg([TotalHolesPlayed]) as [TotalGreensInReg]
      ,avg([TotalGreensInRegPutts]) * 1.0 / avg([TotalHolesPlayed]) as [TotalGreensInRegPutts]
      ,avg([TotalFwysPlayed]) * 1.0 / avg([TotalHolesPlayed]) as [TotalFwysPlayed]
      ,avg([TotalFwysHit]) * 1.0 / avg([TotalHolesPlayed]) as [TotalFwysHit]
      ,avg([TotalSandSaves]) * 1.0 / avg([TotalHolesPlayed]) as [TotalSandSaves]
      ,avg([TotalEagles]) * 1.0 / avg([TotalHolesPlayed]) as [TotalEagles]
      ,avg([TotalBirdies]) * 1.0 / avg([TotalHolesPlayed]) as [TotalBirdies]
  FROM [DARRELL_MASTER].[MoneyBall].[WebsiteDataPlayer6]
  where TournamentsWon > 2  and pgaseason > @PGASeason - 11 and SportTourId = @SportTourId),

--cte_players as (
--SELECT [PlayerName]
--      ,[PGASeason]
--	    ,TournamentsPlayed
--      ,[PercentMadeCut] / 100.0 as [PercentMadeCut]
--      ,[AvgDrivingAccuracy] / 100.0 as [AvgDrivingAccuracy]
--      ,[TotalGreensInReg] * 1.0 / [TotalHolesPlayed] as GIRPercent
--      ,[TotalGreensInRegPutts] * 1.0 / [TotalHolesPlayed] as GIRPuttPercent
--      ,[TotalFwysPlayed] * 1.0 / [TotalHolesPlayed] as FWPlayedPercent
--      ,[TotalFwysHit] * 1.0 / [TotalHolesPlayed] as FWHitPercent
--      ,[TotalSandSaves] * 1.0 / [TotalHolesPlayed] as SandSavesPercent
--      ,[TotalEagles] * 1.0 / [TotalHolesPlayed] as EaglesPercent
--      ,[TotalBirdies] * 1.0 / [TotalHolesPlayed] as BirdiesPercent

--  FROM [DARRELL_MASTER].[MoneyBall].[WebsiteDataPlayer6]
--  where TournamentsPlayed > 9 and PGASeason = @PGASeason),


cte_players as (select  [Player Name] as [PlayerName]
		, @PGASeason as PGASeason
		, count([Player Name]) as TournamentsPlayed
        , sum(case when [Finish Position] is null then 0 else 1 end) * 1.0 / count(*) as PercentMadeCut
	    , avg([Driving Accuracy]) / 100.0 as AvgDrivingAccuracy
		, SUM(isnull([Total GIRs], 0)) * 1.0 / nullif(sum([Holes Played]),0) as GIRPercent
		, SUM(isnull([Total GIR Putts], 0)) * 1.0 / nullif(sum([Holes Played]),0) as GIRPuttPercent
		, SUM(isnull([Total Fwys Played], 0)) * 1.0 /nullif(sum([Holes Played]),0) as FWPlayedPercent
		, SUM(isnull([Total Fwys Hit], 0)) * 1.0 / nullif(sum([Holes Played]),0) as FWHitPercent
		, SUM(isnull([Total Sand Saves], 0)) * 1.0 / nullif(sum([Holes Played]),0) as SandSavesPercent
		, SUM(isnull([Total Eagles], 0)) * 1.0 / nullif(sum([Holes Played]),0) as EaglesPercent
		, SUM(isnull([Total Birdies], 0)) * 1.0 / nullif(sum([Holes Played]),0) as BirdiesPercent
from [MoneyBall].[WebsiteDataPlayer5] 
where SportTourId = @SportTourId and TournamentId in (SELECT top (@PrevSeasonEvents) TournamentId
							FROM [MoneyBall].[WebsiteData2]
							order by FirstDay desc)  
group by [Player Name] 
having count(*) > @CutOff),



  ctefinal as (
  select PlayerName, PGASeason, TournamentsPlayed, cast((
								(p.PercentMadeCut - e.PercentMadeCut) + 
								(p.AvgDrivingAccuracy - e.AvgDrivingAccuracy) +
								(p.GIRPercent - e.TotalGreensInReg) +
								(p.GIRPuttPercent - e.TotalGreensInRegPutts) +
								(p.FWPlayedPercent - e.TotalFwysPlayed) +
								(p.FWHitPercent - e.TotalFwysHit) +
								(p.SandSavesPercent - e.TotalSandSaves) +
								(p.EaglesPercent - e.TotalEagles) +
								(p.BirdiesPercent - e.TotalBirdies)) * 100.0 as decimal(5,2)) as SimIndex
	
  from cte_players p
  inner join cte_elite e on 1 = 1)


  update p
  set p.SimIndex1 = f.SimIndex, p.SimIndex1Count = f.TournamentsPlayed
  from [DARRELL_MASTER].[MoneyBall].[WebsiteDataPlayer6] p inner join ctefinal f
  on p.PlayerName = f.PlayerName and p.PGASeason = f.PGASeason and p.PGASeason = @PGASeason and p.SportTourId = @SportTourId

  commit tran



  if @SportTourId = 1
  begin

begin tran

;with ctea as (SELECT max([WeekEndDate]) as WeekEndDate, [PGASeason] FROM [DARRELL_MASTER].[Money].[WorldRank] where PGASeason = @PGASeason group by [PGASeason])
,cte1 as (
SELECT coalesce([PlayerName], [PlayerNameOriginal]) as PlayerName,wr.[PGASeason],PointsAvg FROM [DARRELL_MASTER].[Money].[WorldRank] wr inner join ctea on wr.weekenddate = ctea.WeekEndDate
),
cte2 as (select PlayerName, avg(DSPoints) as DSPoints, avg(MoneyWon) as MoneyWon 
		 from moneyball.WebsiteDataPlayer1 
		 where PGASeason = @PGASeason and SportTourid = @SportTourId 
		 group by PlayerName),

cte3 as (
select cte2.*, c1.AVGWRPoints
from cte2 left join 
	(select Playername, avg(PointsAvg) as AVGWRPoints from cte1 group by Playername) c1 
	on cte2.playername  = c1.PlayerName),

ctefinal as (
select PlayerName, SimIndex, rank() over(order by SimIndex desc) as EquityRank
from (	
	select [PlayerName]
			,(avg([MoneyWon]) * 1.0 / sum(avg([MoneyWon])) over() + avg([DSPoints]) * 1.0 / sum(avg([DSPoints])) over() + avg(AVGWRPoints) * 1.0 / sum(avg(AVGWRPoints)) over()) / 3.0 * 100.0 as SimIndex
	from cte3 
	group by [PlayerName]
) a)

update p
  set p.SimIndex1year = f.SimIndex, p.SimIndex1yearRank = f.EquityRank
  from [DARRELL_MASTER].[MoneyBall].[WebsiteDataPlayer6] p inner join ctefinal f
  on p.PlayerName = f.PlayerName and p.PGASeason = @PGASeason and p.SportTourId = @SportTourId



commit tran


begin tran

declare @FarBack integer = 3

;with ctea as (SELECT max([WeekEndDate]) as WeekEndDate, [PGASeason] FROM [DARRELL_MASTER].[Money].[WorldRank] where PGASeason between @PGASeason - @FarBack + 1 and @PGASeason group by [PGASeason])
,cte1 as (
SELECT coalesce([PlayerName], [PlayerNameOriginal]) as PlayerName,wr.[PGASeason],PointsAvg FROM [DARRELL_MASTER].[Money].[WorldRank] wr inner join ctea on wr.weekenddate = ctea.WeekEndDate
),
cte2 as (select PlayerName, avg(DSPoints) as DSPoints, avg(MoneyWon) as MoneyWon 
		 from moneyball.WebsiteDataPlayer1 
		 where PGASeason between @PGASeason - @FarBack + 1 and @PGASeason and SportTourid = @SportTourId 
		 group by PlayerName),

cte3 as (
select cte2.*, c1.AVGWRPoints
from cte2 left join 
	(select Playername, avg(PointsAvg) as AVGWRPoints from cte1 group by Playername) c1 
	on cte2.playername  = c1.PlayerName),

ctefinal as (
select PlayerName, SimIndex, rank() over(order by SimIndex desc) as EquityRank
from (	
	select [PlayerName]
			,(avg([MoneyWon]) * 1.0 / sum(avg([MoneyWon])) over() + avg([DSPoints]) * 1.0 / sum(avg([DSPoints])) over() + avg(AVGWRPoints) * 1.0 / sum(avg(AVGWRPoints)) over()) / 3.0 * 100.0 as SimIndex
	from cte3 
	group by [PlayerName]
) a)

update p
  set p.SimIndex3year = f.SimIndex, p.SimIndex3yearRank = f.EquityRank
  from [DARRELL_MASTER].[MoneyBall].[WebsiteDataPlayer6] p inner join ctefinal f
  on p.PlayerName = f.PlayerName and p.PGASeason = @PGASeason and p.SportTourId = @SportTourId

commit tran


begin tran

set @FarBack = 5

;with ctea as (SELECT max([WeekEndDate]) as WeekEndDate, [PGASeason] FROM [DARRELL_MASTER].[Money].[WorldRank] where PGASeason between @PGASeason - @FarBack + 1 and @PGASeason group by [PGASeason])
,cte1 as (
SELECT coalesce([PlayerName], [PlayerNameOriginal]) as PlayerName,wr.[PGASeason],PointsAvg FROM [DARRELL_MASTER].[Money].[WorldRank] wr inner join ctea on wr.weekenddate = ctea.WeekEndDate
),
cte2 as (select PlayerName, avg(DSPoints) as DSPoints, avg(MoneyWon) as MoneyWon 
		 from moneyball.WebsiteDataPlayer1 
		 where PGASeason between @PGASeason - @FarBack + 1 and @PGASeason and SportTourid = @SportTourId 
		 group by PlayerName),

cte3 as (
select cte2.*, c1.AVGWRPoints
from cte2 left join 
	(select Playername, avg(PointsAvg) as AVGWRPoints from cte1 group by Playername) c1 
	on cte2.playername  = c1.PlayerName),

ctefinal as (
select PlayerName, SimIndex, rank() over(order by SimIndex desc) as EquityRank
from (	
	select [PlayerName]
			,(avg([MoneyWon]) * 1.0 / sum(avg([MoneyWon])) over() + avg([DSPoints]) * 1.0 / sum(avg([DSPoints])) over() + avg(AVGWRPoints) * 1.0 / sum(avg(AVGWRPoints)) over()) / 3.0 * 100.0 as SimIndex
	from cte3 
	group by [PlayerName]
) a)

update p
  set p.SimIndex3year = f.SimIndex, p.SimIndex3yearRank = f.EquityRank
  from [DARRELL_MASTER].[MoneyBall].[WebsiteDataPlayer6] p inner join ctefinal f
  on p.PlayerName = f.PlayerName and p.PGASeason = @PGASeason and p.SportTourId = @SportTourId

commit tran

end
	
Print 'Finished WebsiteDataPlayer6'; 
end  -- WebsiteDataPlayer6
GO
