IF OBJECT_ID('MoneyBall.Fill_WebsiteDataPlayer1') IS NOT NULL
    DROP PROCEDURE [MoneyBall].[Fill_WebsiteDataPlayer1];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	Fill table MoneyBall.WebsiteDataPlayer1
-- =============================================

CREATE procedure [MoneyBall].[Fill_WebsiteDataPlayer1]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date,
	@PGASeasonNotFull integer
)
AS
Begin -- WebsiteDataPlayer1
Print 'Start WebsiteDataPlayer1'


--exec [MoneyBall].[Fill_WebsiteDataPlayer1] 'TGL', 2025, 61, '20250318', 2025


delete from MoneyBall.WebsiteDataPlayer1 where PGASeason = @PGASeason and SportTourId = @SportTourId
	
	
insert into MoneyBall.WebsiteDataPlayer1
([PlayerName] ,PGASeason,MoneyWon,MoneyYTDPercent,[PGARank],HighRanking,LowRanking,TournamentsPlayed,TournamentsWon,TournamentsTop10,DSRank,DSPoints, DSM,DSPointsYTDPercent,DSTrend
,WorldHighRanking,WorldLowRanking,WorldRank,MoneyWonUnofficial, MoneyWonUnofficialPercent, Country,SportTourId)
SELECT [PlayerName]
      ,PGASeason
      ,case when OfficialMoneyYTD = 0 then TotalMoneyYTD else OfficialMoneyYTD end as MoneyWon --for non PGA players to have yeartotals on the web
      ,OfficialMoneyYTD * 100.0 / nullif(SUM(OfficialMoneyYTD) over(PARTITION by PGASeason),0) as MoneyYTDPercent
      ,PGARank
      ,HighRanking
      ,LowRanking
      ,TotalStarts as TournamentsPlayed
      ,Wins as TournamentsWon
      ,Top10 as TournamentsTop10
      ,DSRank
      ,TotalDSPoints as DSPoints
	  ,DSM as DSM
      ,TotalDSPoints * 100.0 / nullif(SUM(TotalDSPoints) over(PARTITION by PGASeason),0) as DSPointsYTDPercent
      ,Trend as DSTrend
      ,WorldHighRanking 
      ,WorldLowRanking
      ,WorldRank
      ,TotalMoneyYTD as MoneyWonUnofficial
      ,TotalMoneyYTD  * 100.0 / nullif(SUM(TotalMoneyYTD ) over(PARTITION by PGASeason),0) as MoneyWonUnofficialPercent
	  ,Country
	  ,@SportTourId
  FROM [DARRELL_MASTER].[MoneyBall].[PlayerRank]
  where PGASeason = @PGASeason and SportTourId = @SportTourId
  order by PGASeason, playername 
 
 
 
;with cte_Final as (
select SUM(DSPoints) as TotalPoints, PlayerName, TournamentId, PGASeason 
from tv.tvaudit
--where PGASeason = @PGASeason and Caddie = 0 and IsUsedInCalculations = 1 and Tour = @Tour
where PGASeason = @PGASeason and Caddie = 0 and IsUsedInCalculations = 1 and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and TntNid in (26,351,353,355)))
group by PlayerName, TournamentId, PGASeason)


update z
set DSPointsHigh = MaxPoints, DSPointsLow = MinPoints, EventPointsAvg = AveragePoints/z.TournamentsPlayed
from MoneyBall.WebsiteDataPlayer1 z inner join
(Select Playername, 
		PGASeason,
		min(TotalPoints) as MinPoints,
		max(TotalPoints) as MaxPoints,
		SUM(TotalPoints) as AveragePoints
from cte_Final
group by Playername, PGASeason) a 
on z.PlayerName = a.PlayerName and z.PGASeason = a.PGASeason and SportTourId = @SportTourId




;with cte_TFRounds as (
select SUM(DSPoints) as TotalPoints, PlayerName, TournamentId, PGASeason 
from tv.tvaudit
--where PGASeason = @PGASeason and [ROUND] in (1, 2) and Caddie = 0  and IsUsedInCalculations = 1 and Tour = @Tour
where PGASeason = @PGASeason and [ROUND] in (1, 2) and Caddie = 0  and IsUsedInCalculations = 1 and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and TntNid in (26,351,353,355)))
group by PlayerName, TournamentId, PGASeason)


update z
set TFPointsMax = MaxPoints, TFPointsMin = MinPoints, TFPointsAvg = AvgPoints/z.TournamentsPlayed 
from MoneyBall.WebsiteDataPlayer1 z inner join
(Select Playername, 
		PGASeason,
		min(TotalPoints) as MinPoints,
		max(TotalPoints) as MaxPoints,
		sum(TotalPoints) as AvgPoints
from cte_TFRounds
group by Playername, PGASeason) a 
on z.PlayerName = a.PlayerName and z.PGASeason = a.PGASeason and SportTourId = @SportTourId





;with cte_SSRounds as (
select SUM(DSPoints) as TotalPoints, PlayerName, TournamentId, PGASeason 
from tv.tvaudit
--where PGASeason = @PGASeason and [ROUND] in (3, 4) and Caddie = 0  and IsUsedInCalculations = 1 and Tour = @Tour
where PGASeason = @PGASeason and [ROUND] in (3, 4) and Caddie = 0  and IsUsedInCalculations = 1 and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and TntNid in (26,351,353,355)))
group by PlayerName, TournamentId, PGASeason)


update z
set SSPointsMax = MaxPoints, SSPointsMin = MinPoints, SSPointsAvg = AvgPoints/z.TournamentsPlayed 
from MoneyBall.WebsiteDataPlayer1 z inner join
(Select Playername, 
		PGASeason,
		min(TotalPoints) as MinPoints,
		max(TotalPoints) as MaxPoints,
		Sum(TotalPoints) as AvgPoints
from cte_SSRounds
group by Playername, PGASeason) a 
on z.PlayerName = a.PlayerName and z.PGASeason = a.PGASeason and SportTourId = @SportTourId




update a1
set a1.DSPointsDifferencePercent =  (a1.[DSPoints] - a2.[DSPoints]) * 100.0 / a2.[DSPoints],
a1.DSPointsDifference =  (a1.[DSPoints] - a2.[DSPoints]),
a1.DSPointsPrevYear = a2.DSPoints

FROM [DARRELL_MASTER].[MoneyBall].[WebsiteDataPlayer1] a1
  inner join [DARRELL_MASTER].[MoneyBall].[WebsiteDataPlayer1] a2
  on a1.PlayerName = a2.PlayerName and a1.PGASeason = a2.PGASeason + 1 and a1.SportTourId = a2.SportTourId
  where a2.DSPoints > 0 and a1.PGASeason = @PGASeason and a1.SportTourId = @SportTourId 


--adjust prevYear ds points time span to cover the same time period as current season

if @PGASeason = @PGASeasonNotFull
begin
	Update [DARRELL_MASTER].[MoneyBall].[WebsiteDataPlayer1]
	set DSPointsDifference = null, DSPointsDifferencePercent = null, DSPointsPrevYear = null where PGASeason = @PGASeason

	;with cteA as (
	select SUM(DSPoints) as TotalPoints, PlayerName 
	from TV.TVAudit tv 
	--Where TOUR = @Tour and PGASeason = @PGASeason - 1 and IsUsedInCalculations = 1 and NOT DSPoints is null
	Where PGASeason = @PGASeason - 1 and IsUsedInCalculations = 1 and NOT DSPoints is null and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and TntNid in (26,351,353,355)))
	and tournamentid in (select TournamentId from Player_Master.TOURNAMENTS_TABLE 
							where PGASeason = @PGASeason - 1 and [SID]  in (select [sid] from Player_Master.TOURNAMENTS_TABLE 
							--where tournamentid in (select distinct tournamentid from TV.TVAudit  where PGASeason = @PGASeason and Tour = @Tour)))
							where tournamentid in (select distinct tournamentid from TV.TVAudit  where PGASeason = @PGASeason and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and TntNid in (26,351,353,355))))))
	group by PlayerName)


	Update a
	set DSPointsDifference = a.[DSPoints] - cteA.TotalPoints,
		DSPointsPrevYear = ctea.TotalPoints,
		DSPointsDifferencePercent = (a.[DSPoints] - cteA.TotalPoints) * 100.0 / ctea.TotalPoints

	from [DARRELL_MASTER].[MoneyBall].[WebsiteDataPlayer1] a
	inner join cteA on a.playername = cteA.playername and a.PGASeason = @PGASeason and a.SportTourId = @SportTourId
end




----Update Majors Player1 with latest Money stats
--update M
--set m.MoneyWon = p.MoneyWon, 
--	m.MoneyYTDPercent = p.MoneyYTDPercent,
--	m.PGARank = p.PGARank
--from MoneyBall.WebsiteDataPlayer1Majors M inner join MoneyBall.WebsiteDataPlayer1 P
--on M.PlayerName = P.PlayerName and M.PGASeason = P.PGASeason and M.SportTourId = @SportTourId




--Value index on LIV Players

if @SportTourId = 56 
	begin
		;with ctea as (SELECT max([WeekEndDate]) as WeekEndDate
			  ,[PGASeason]
		  FROM [DARRELL_MASTER].[Money].[WorldRank]
		  where PGASeason > @PGASeason - 3
		  group by [PGASeason]),


		cte1 as (SELECT coalesce([PlayerName], [PlayerNameOriginal]) as PlayerName
			  ,wr.[PGASeason]
			  ,PointsAvg
		  FROM [DARRELL_MASTER].[Money].[WorldRank] wr 
		  inner join ctea on wr.weekenddate = ctea.WeekEndDate),

		cte2 as (

		select PlayerName, SimIndex, rank() over(order by SimIndex desc) as EquityRank from (
		select w1.[PlayerName]
		,(avg(w1.[MoneyWon]) * 1.0 / sum(avg(w1.[MoneyWon])) over() + avg(w1.[DSPoints]) * 1.0 / sum(avg(w1.[DSPoints])) over() + avg(cte1.PointsAvg) * 1.0 / sum(avg(cte1.PointsAvg)) over()) / 3 as SimIndex
		from moneyball.WebsiteDataPlayer1 w1
		left outer join cte1 on w1.PlayerName = cte1.PlayerName and w1.PGASeason = cte1.pgaseason
		where w1.pgaseason > @PGASeason - 3  and SportTourid in (1,56)
			and  w1.playername in (
		'JOHNSON, DUSTIN', 'KOEPKA, BROOKS', 'OOSTHUIZEN, LOUIS', 'ANCER, ABRAHAM', 
		'DECHAMBEAU, BRYSON', 'NA, KEVIN', 'GOOCH, TALOR', 'REED, PATRICK', 'GARCIA, SERGIO', 
		'LARRAZABAL, PABLO', 'BLAND, RICHARD', 'JONES, MATT', 'WOLFF, MATTHEW', 
		'NORRIS, SHAUN', 'HORSFIELD, SAM', 'MICKELSON, PHIL', 'WESTWOOD, LEE', 
		'VINCENT, SCOTT', 'KINOSHITA, RYOSUKE', 'POULTER, IAN', 'SWAFFORD, HUDSON', 
		'BEKKER, OLIVER', 'WIESBERGER, BERND', 'KOZUMA, JINICHIRO', 'HARDING, JUSTIN', 
		'ORTIZ, CARLOS', 'KAEWKANJANA, SADOM', 'SCHWARTZEL, CHARL', 'CANTER, LAURIE', 
		'GRACE, BRANDEN', 'KAYMER, MARTIN', 'MORGAN, JEDIAH', 'UIHLEIN, PETER', 'MCDOWELL, GRAEME', 'PETTIT, TURK', 'OGLETREE, ANDY', 'KOEPKA, CHASE', 
		'KHONGWATMAI, PHACHARA', 'KIM, SIHWAN', 'ORMSBY, WADE', 'OTAEGUI, ADRIAN', 'RITCHIE, JC', 
		'TANIHARA, HIDETO', 'STENSON, HENRIK', 'CASEY, PAUL', 'PEREZ, PAT', 'HOWELL III, CHARLES', 'KOKRAK, JASON', 
		'WATSON, BUBBA', 'SMITH, CAMERON', 'LEISHMAN, MARC', 'NIEMANN, JOAQUIN', 'VARNER, HAROLD', 'TRINGALE, CAMERON', 'LAHIRI, ANIRBAN')

		group by w1.[PlayerName]) a)


			Update a
			set EquityIndex = cte2.SimIndex,
				EquityRank = cte2.EquityRank
			from [DARRELL_MASTER].[MoneyBall].[WebsiteDataPlayer1] a
			inner join cte2 on a.playername = cte2.playername and a.PGASeason = @PGASeason and a.SportTourId = @SportTourId
	end
if @SportTourId = 1 
	begin
		;with ctea as (SELECT max([WeekEndDate]) as WeekEndDate
			  ,[PGASeason]
		  FROM [DARRELL_MASTER].[Money].[WorldRank]
		  where PGASeason > 2022
		  group by [PGASeason]),


		cte1 as (SELECT coalesce([PlayerName], [PlayerNameOriginal]) as PlayerName
			  ,wr.[PGASeason]
			  ,PointsAvg
		  FROM [DARRELL_MASTER].[Money].[WorldRank] wr 
		  inner join ctea on wr.weekenddate = ctea.WeekEndDate),

		cte2 as (

		select PlayerName, SimIndex, rank() over(order by SimIndex desc) as EquityRank from (
		select w1.[PlayerName]
		,(avg(w1.[MoneyWon]) * 1.0 / sum(avg(w1.[MoneyWon])) over() + avg(w1.[DSPoints]) * 1.0 / sum(avg(w1.[DSPoints])) over() + avg(cte1.PointsAvg) * 1.0 / sum(avg(cte1.PointsAvg)) over()) / 3 as SimIndex
		from moneyball.WebsiteDataPlayer1 w1
		left outer join cte1 on w1.PlayerName = cte1.PlayerName and w1.PGASeason = cte1.pgaseason
		where w1.pgaseason > @PGASeason - 3  and SportTourid = @SportTourId
			and not w1.playername in (
		'JOHNSON, DUSTIN', 'KOEPKA, BROOKS', 'OOSTHUIZEN, LOUIS', 'ANCER, ABRAHAM', 
		'DECHAMBEAU, BRYSON', 'NA, KEVIN', 'GOOCH, TALOR', 'REED, PATRICK', 'GARCIA, SERGIO', 
		'LARRAZABAL, PABLO', 'BLAND, RICHARD', 'JONES, MATT', 'WOLFF, MATTHEW', 
		'NORRIS, SHAUN', 'HORSFIELD, SAM', 'MICKELSON, PHIL', 'WESTWOOD, LEE', 
		'VINCENT, SCOTT', 'KINOSHITA, RYOSUKE', 'POULTER, IAN', 'SWAFFORD, HUDSON', 
		'BEKKER, OLIVER', 'WIESBERGER, BERND', 'KOZUMA, JINICHIRO', 'HARDING, JUSTIN', 
		'ORTIZ, CARLOS', 'KAEWKANJANA, SADOM', 'SCHWARTZEL, CHARL', 'CANTER, LAURIE', 
		'GRACE, BRANDEN', 'KAYMER, MARTIN', 'MORGAN, JEDIAH', 'UIHLEIN, PETER', 'MCDOWELL, GRAEME', 'PETTIT, TURK', 'OGLETREE, ANDY', 'KOEPKA, CHASE', 
		'KHONGWATMAI, PHACHARA', 'KIM, SIHWAN', 'ORMSBY, WADE', 'OTAEGUI, ADRIAN', 'RITCHIE, JC', 
		'TANIHARA, HIDETO', 'STENSON, HENRIK', 'CASEY, PAUL', 'PEREZ, PAT', 'HOWELL III, CHARLES', 'KOKRAK, JASON', 
		'WATSON, BUBBA', 'SMITH, CAMERON', 'LEISHMAN, MARC', 'NIEMANN, JOAQUIN', 'VARNER, HAROLD', 'TRINGALE, CAMERON', 'LAHIRI, ANIRBAN')

		group by w1.[PlayerName]) a
		where not SimIndex is null
		)


			Update a
			set EquityIndex = cte2.SimIndex,
				EquityRank = cte2.EquityRank
			from [DARRELL_MASTER].[MoneyBall].[WebsiteDataPlayer1] a
			inner join cte2 on a.playername = cte2.playername and a.PGASeason = @PGASeason and a.SportTourId = @SportTourId
	end


Print 'Finished WebsiteDataPlayer1'; 
end -- WebsiteDataPlayer1
GO
