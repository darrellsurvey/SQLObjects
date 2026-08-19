IF OBJECT_ID('MoneyBall.Fill_WebsiteData6') IS NOT NULL
    DROP PROCEDURE [MoneyBall].[Fill_WebsiteData6];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	
-- =============================================

CREATE procedure [MoneyBall].[Fill_WebsiteData6]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date,
	@PGASeasonNotFull integer
)
AS
Begin -- WebsiteData6
Print 'Start WebsiteData6'

delete from MoneyBall.WebsiteData6 where PGASeason = @PGASeason and SportTourId = @SportTourId
	
;with cte_PreMoney1 as (
          SELECT distinct PlayerName, Brand, TournamentId FROM tv.TVAudit Where PGASeason = @PGASeason and TntFirstDay < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and TntNid in (26,351,353,355)))
    union select distinct PLAYERNAME, BRAND, TournamentId from dbo.bag where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))
	union select distinct PLAYERNAME, BRAND, TournamentId from dbo.ball where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))
	union select distinct PLAYERNAME, BRAND, TournamentId from dbo.gloves where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))
	union select distinct PLAYERNAME, BRAND, TournamentId from dbo.grips where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))
	union select distinct PLAYERNAME, BRAND, TournamentId from dbo.headgear where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))
	union select distinct PLAYERNAME, BRAND, TournamentId from dbo.shirts where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))
	union select distinct PLAYERNAME, BRAND, TournamentId from dbo.irons where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))
	union select distinct PLAYERNAME, BRAND, TournamentId from dbo.putters where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))
	union select distinct PLAYERNAME, BRAND, TournamentId from dbo.shafts where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))
	union select distinct PLAYERNAME, BRAND, TournamentId from dbo.shoes where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))
	union select distinct PLAYERNAME, BRAND, TournamentId from dbo.Sunglasses where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))
	union select distinct PLAYERNAME, BRAND, TournamentId from dbo.wedges where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))
	union select distinct PLAYERNAME, BRAND, TournamentId from dbo.woods where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))),
	
cte_PreMoney as (select PlayerName, case when Brand = 'FOOT JOY' then 'FOOTJOY' else Brand end as Brand, TournamentId from cte_PreMoney1),
	
cte_money as (
select pm.Brand, isnull(sum(m.[Official Money]), 0) as MoneyWon, PGASeason 
from cte_PreMoney pm
left outer join DARRELL_MASTER.Money.TourMoneyStats m on pm.TournamentId = m.TournamentId and pm.PlayerName = m.[PLAYER NAME]
inner join DARRELL_MASTER.Player_Master.TOURNAMENTS_TABLE tt on pm.TournamentId = tt.TournamentId
group by Brand, PGASeason) 
			  

insert into MoneyBall.WebsiteData6
(PGASeason,Brand, MoneyWon, MoneyWonRank, DSPoints,DSM,DSPointsRank, SportTourId)
select m.PGASeason, m.Brand, m.MoneyWon, RANK() over(partition by m.PGASeason order by MoneyWon desc) as MoneyWonRank, r.DSPoints,r.dsm, r.PGASeasonRank, @SportTourId
from cte_money m
inner join MoneyBall.BrandDSRank r on m.PGASeason = r.PGASeason and m.Brand = r.Brand and r.SportTourId = @SportTourId
order by PGASeason, Brand 

  
  if  @SportTourId = 7 or @SportTourId = 8
	begin
		insert into MoneyBall.WebsiteData6
		(PGASeason,Brand, MoneyWon, MoneyWonRank, DSPoints,DSPointsRank, SportTourId)
		select PGASeason, Brand, NULL as MoneyWon, 0 as MoneyWonRank, sum(DSPoints) as DSPoints, RANK() over(order by Sum(DSPoints) desc) as PGASeasonRank, @SportTourId
			from TV.TVAudit
			where PGASeason = @PGASeason and [tntFirstDay] < @LastFullTournamentEnd and Tour = @Tour
			group by PGASeason, Brand
			order by PGASeason, Brand 
	end


update q set q.dspointspercent = o.dspointspercent
from MoneyBall.WebsiteData6 q inner join 
(SELECT PGASeason, Brand, DSPoints, DSPoints*100.0/nullif(SUM(dspoints) over (partition by PGASeason),0) as DSPointsPercent, SportTourId FROM MoneyBall.WebsiteData6
where PGASeason = @PGASeason and SportTourId = @SportTourId) o
on q.PGASeason = o.PGASeason and q.Brand = o.brand and q.SportTourId = o.SportTourId

update q set q.MoneyWonpercent = o.MoneyWonpercent
from MoneyBall.WebsiteData6 q inner join 
(SELECT PGASeason, Brand, MoneyWon, MoneyWon*100.0/nullif(SUM(MoneyWon) over (partition by PGASeason),0) as MoneyWonPercent, SportTourId FROM MoneyBall.WebsiteData6
where PGASeason = @PGASeason and SportTourId = @SportTourId) o
on q.PGASeason = o.PGASeason and q.Brand = o.brand and q.SportTourId = o.SportTourId


update q 
			set q.DSPointsYear1 = o.[DSPoints],  
			    q.DSPointsYear1Rank = o.[DSPointsRank],
			    q.DSPointsYear2 = z.[DSPoints], 
			    q.[MoneyWonYear1] = o.[MoneyWon], 	 
			    q.[MoneyWonYear1Rank] = o.[MoneyWonRank],
			    q.[MoneyWonYear2] = z.[MoneyWon], 
			    q.DSPointsYear1Partial = o.[DSPoints],
			    q.DSPointsYear2Partial = z.[DSPoints] 
			    
  FROM [DARRELL_MASTER].[MoneyBall].[WebsiteData6] q 
  left outer join [DARRELL_MASTER].[MoneyBall].[WebsiteData6] o on q.PGASeason = o.PGASeason + 1 and q.Brand = o.brand and q.SportTourId = o.SportTourId
  left outer join [DARRELL_MASTER].[MoneyBall].[WebsiteData6] z on q.PGASeason = z.PGASeason + 2 and q.Brand = z.brand and q.SportTourId = o.SportTourId
  where q.PGASeason = @PGASeason and q.SportTourId = @SportTourId
   
  
 
 --udjust prevYear ds points time span to cover the same time period as current season

if @PGASeason = @PGASeasonNotFull
begin
	Update [DARRELL_MASTER].[MoneyBall].[WebsiteData6]
	set DSPointsYear1Partial = null, DSPointsYear2Partial = null where PGASeason = @PGASeason and SportTourId = @SportTourId

	;with cteA as (
	select SUM(DSPoints) as TotalPoints, Brand 
	from TV.TVAudit tv 
	Where TOUR = @Tour and PGASeason = @PGASeason - 1 and NOT DSPoints is null
	and tournamentid in (select TournamentId from Player_Master.TOURNAMENTS_TABLE 
							where PGASeason = @PGASeason - 1 and [SID]  in (select [sid] from Player_Master.TOURNAMENTS_TABLE 
							where tournamentid in (select distinct tournamentid from TV.TVAudit  where PGASeason = @PGASeason and Tour = @Tour)))
	group by Brand)


	Update a
	set DSPointsYear1Partial = ctea.TotalPoints
		
	from [DARRELL_MASTER].[MoneyBall].[WebsiteData6] a
	inner join cteA on a.Brand = cteA.Brand and a.PGASeason = @PGASeason and a.SportTourId = @SportTourId
end


 
  
  
;  with cte_temp as (
select distinct p4.playername, p4.pgaseason, brand, p1.DSRank, p1.DSPoints from [DARRELL_MASTER].[MoneyBall].[WebsiteDataplayer4] p4
inner join MoneyBall.WebsiteDataPlayer1 p1 on p4.PGASeason = p1.PGASeason and p4.PlayerName = p1.PlayerName and p4.SportTourId = p1.SportTourId
where p4.pgaseason = @PGASeason and p4.SportTourId = @SportTourId
--where not p1.DSPoints is null
),



cte_counts as (
SELECT [PGASeason],[Brand],
count(distinct [PlayerName]) as SponsoredPlayer, 
Sum(case when dsrank < 25 then 1 else 0 end) as Top25,
Sum(case when dsrank between 26 and 50 then 1 else 0 end) as Top26to50,
Sum(case when dsrank between 51 and 100 then 1 else 0 end) as Top51to100,
Sum(case when dsrank > 100 then 1 else 0 end) as Top101andOver,
avg(dspoints) as PlayerAverage
FROM cte_temp
group by [PGASeason],[Brand])



update q 
			set q.SponsoredPlayer = o.SponsoredPlayer,  
			    q.SponsoredPlayerPercent = o.SponsoredPlayerPercent,
			    q.SponsoredPlayerTop25 = Top25, 
			    q.SponsoredPlayerTop25Percent = Top25Percent, 	 
			    q.SponsoredPlayer2650 = Top26to50,
			    q.SponsoredPlayer2650Percent = Top26to50Percent,
			    q.SponsoredPlayer51100 = Top51to100,
			    q.SponsoredPlayer51100Percent = Top51to100Percent,
			    q.SponsoredPlayer101Plus = Top101andOver,
			    q.SponsoredPlayer101PlusPercent = Top101andOverPercent,
			    q.AveragePlayerImpressions = PlayerAverage 
  FROM [DARRELL_MASTER].[MoneyBall].[WebsiteData6] q 
  left outer join 
  (select *, 
SponsoredPlayer*100.0/(select COUNT(distinct playername) from cte_temp a where a.PGASeason = z.PGASeason) as SponsoredPlayerPercent,
Top25*100.0/25 as Top25Percent,
Top26to50*100.0/25 as Top26to50Percent,
Top51to100*100.0/50 as Top51to100Percent,
Top101andOver*100.0/((select COUNT(distinct playername) from cte_temp a where a.PGASeason = z.PGASeason)-100) as Top101andOverPercent
from cte_counts z) o 
  on q.PGASeason = o.PGASeason and q.Brand = o.brand
  where q.PGASeason = @PGASeason and q.SportTourId = @SportTourId





;with cte_temp as (
select distinct p4.playername, p4.pgaseason, brand, p1.DSRank, p1.DSPoints, PGARank  from [DARRELL_MASTER].[MoneyBall].[WebsiteDataplayer4] p4
inner join MoneyBall.WebsiteDataPlayer1 p1 on p4.PGASeason = p1.PGASeason and p4.PlayerName = p1.PlayerName and p4.SportTourId = p1.SportTourId
where p4.pgaseason = @PGASeason and p4.SportTourId = @SportTourId 
--where not p1.DSPoints is null
)

update q set q.[ViewershipKeyPlayer] = o.Playername
FROM [DARRELL_MASTER].[MoneyBall].[WebsiteData6] q 
left outer join 
  (select pgaseason, brand,Playername from (select *, RANK() over (partition by pgaseason, brand order by dspoints desc) as rn  from cte_temp a1) a where rn = 1) o 
  on q.PGASeason = o.PGASeason and q.Brand = o.brand
  where q.PGASeason = @PGASeason and q.SportTourId = @SportTourId
  
  
 
  
  

;with cte_temp as (
select distinct p4.playername, p4.pgaseason, brand, p1.DSRank, p1.DSPoints, p1.MoneyWon,  PGARank  from [DARRELL_MASTER].[MoneyBall].[WebsiteDataplayer4] p4
inner join MoneyBall.WebsiteDataPlayer1 p1 on p4.PGASeason = p1.PGASeason and p4.PlayerName = p1.PlayerName and p4.SportTourId = p1.SportTourId
where p4.pgaseason = @PGASeason and p4.SportTourId = @SportTourId 
--where not p1.DSPoints is null
)

update q set q.PerformanceKeyPlayer = o.Playername
FROM [DARRELL_MASTER].[MoneyBall].[WebsiteData6] q 
left outer join 
  (select pgaseason, brand,Playername from (select *, RANK() over (partition by pgaseason, brand order by MoneyWon desc) as rn  from cte_temp a1) a  where rn = 1) o 
  on q.PGASeason = o.PGASeason and q.Brand = o.brand
  where q.PGASeason = @PGASeason and q.SportTourId = @SportTourId
  
  
  
  
  
  
  
  --viewership bigest mover (need to fix missing 2010)
--  update  [DARRELL_MASTER].[MoneyBall].[WebsiteData6] set ViewershipMover = null
  
  ;with cte_temp as (
select distinct p4.playername, p4.pgaseason, brand, p1.DSRank, p1.DSPoints, PGARank  from [DARRELL_MASTER].[MoneyBall].[WebsiteDataplayer4] p4
inner join MoneyBall.WebsiteDataPlayer1 p1 on p4.PGASeason = p1.PGASeason and p4.PlayerName = p1.PlayerName and p4.SportTourId = p1.SportTourId
--where p4.pgaseason = @PGASeason
)

update q set q.ViewershipMover = o.Playername
FROM [DARRELL_MASTER].[MoneyBall].[WebsiteData6] q 
left outer join 
  (select pgaseason, brand,Playername from (
select *, RANK() over (partition by PGASeason, brand order by dif desc) as rnMover
 from (select a1.PGASeason, a1.brand, a1.PlayerName, a1.dspoints - a2.DSpoints as dif
from cte_temp a1 left outer join cte_temp a2 on a1.PGASeason = a2.PGASeason + 1 and a1.Brand = a2.brand and a1.PlayerName = a2.PlayerName 
where not a2.PlayerName is null ) a) b
where b.rnMover = 1
) o 
  on q.PGASeason = o.PGASeason and q.Brand = o.brand
  where q.PGASeason = @PGASeason and q.SportTourId = @SportTourId
  
  
  
  
  
  --viewership bigest drop (need to fix missing 2010)
--  update  [DARRELL_MASTER].[MoneyBall].[WebsiteData6] set ViewershipDROP = null
;with cte_temp as (
select distinct p4.playername, p4.pgaseason, brand, p1.DSRank, p1.DSPoints, PGARank  from [DARRELL_MASTER].[MoneyBall].[WebsiteDataplayer4] p4
inner join MoneyBall.WebsiteDataPlayer1 p1 on p4.PGASeason = p1.PGASeason and p4.PlayerName = p1.PlayerName and p4.SportTourId = p1.SportTourId
--where p4.pgaseason = @PGASeason
)

update q set q.ViewershipDrop = o.Playername
FROM [DARRELL_MASTER].[MoneyBall].[WebsiteData6] q 
left outer join 
  (select pgaseason, brand,Playername from (
select *, RANK() over (partition by PGASeason, brand order by dif Asc) as rnMover
 from (select a1.PGASeason, a1.brand, a1.PlayerName, a1.dspoints - a2.DSpoints as dif
from cte_temp a1 left outer join cte_temp a2 on a1.PGASeason = a2.PGASeason + 1 and a1.Brand = a2.brand and a1.PlayerName = a2.PlayerName 
where not a2.PlayerName is null ) a) b
where b.rnMover = 1
) o 
  on q.PGASeason = o.PGASeason and q.Brand = o.brand
  where q.PGASeason = @PGASeason and q.SportTourId = @SportTourId
  
  
  
  --viewership sleeper
 ; with cte_temp as (
select distinct p4.playername, p4.pgaseason, brand, p1.DSRank, PGARank  from [DARRELL_MASTER].[MoneyBall].[WebsiteDataplayer4] p4
inner join MoneyBall.WebsiteDataPlayer1 p1 on p4.PGASeason = p1.PGASeason and p4.PlayerName = p1.PlayerName and p4.SportTourId = p1.SportTourId
--where p4.pgaseason = @PGASeason
)

update q set q.ViewershipSleeper = o.Playername
FROM [DARRELL_MASTER].[MoneyBall].[WebsiteData6] q 
left outer join 
(select PGASeason, brand, PlayerName from (
select PGASeason, brand, PlayerName,dsrank, PGARank, dsrank - pgarank as dif, RANK() over (partition by PGASeason, brand order by dsrank - pgarank asc) as rnMover
from cte_temp where not dsrank - pgarank is null) a  where rnmover = 1
) o 
  on q.PGASeason = o.PGASeason and q.Brand = o.brand
  where q.PGASeason = @PGASeason and q.SportTourId = @SportTourId


  
  
   --performance bigest mover (need to fix missing 2010)
    
  ;with cte_temp as (
select distinct p4.playername, p4.pgaseason, brand, p1.DSRank, MoneyWon from [DARRELL_MASTER].[MoneyBall].[WebsiteDataplayer4] p4
inner join MoneyBall.WebsiteDataPlayer1 p1 on p4.PGASeason = p1.PGASeason and p4.PlayerName = p1.PlayerName and p4.SportTourId = p1.SportTourId
--where p4.pgaseason = @PGASeason
)

update q set q.PerformanceMover = o.Playername
FROM [DARRELL_MASTER].[MoneyBall].[WebsiteData6] q 
left outer join 
  (select pgaseason, brand,Playername from (
select *, RANK() over (partition by PGASeason, brand order by dif desc) as rnMover
 from (select a1.PGASeason, a1.brand, a1.PlayerName, a1.MoneyWon - a2.MoneyWon as dif
from cte_temp a1 left outer join cte_temp a2 on a1.PGASeason = a2.PGASeason + 1 and a1.Brand = a2.brand and a1.PlayerName = a2.PlayerName 
where not a2.PlayerName is null ) a) b
where b.rnMover = 1
) o 
  on q.PGASeason = o.PGASeason and q.Brand = o.brand
  where q.PGASeason = @PGASeason and q.SportTourId = @SportTourId
  
  
  
  
  
  --performance bigest drop (need to fix missing 2010)
    ;with cte_temp as (
select distinct p4.playername, p4.pgaseason, brand, p1.DSRank, MoneyWon from [DARRELL_MASTER].[MoneyBall].[WebsiteDataplayer4] p4
inner join MoneyBall.WebsiteDataPlayer1 p1 on p4.PGASeason = p1.PGASeason and p4.PlayerName = p1.PlayerName and p4.SportTourId = p1.SportTourId
--where p4.pgaseason = @PGASeason
)

update q set q.PerformanceDrop = o.Playername
FROM [DARRELL_MASTER].[MoneyBall].[WebsiteData6] q 
left outer join 
  (select pgaseason, brand,Playername from (
select *, RANK() over (partition by PGASeason, brand order by dif asc) as rnMover
 from (select a1.PGASeason, a1.brand, a1.PlayerName, a1.MoneyWon - a2.MoneyWon as dif
from cte_temp a1 left outer join cte_temp a2 on a1.PGASeason = a2.PGASeason + 1 and a1.Brand = a2.brand and a1.PlayerName = a2.PlayerName 
where not a2.PlayerName is null ) a) b
where b.rnMover = 1
) o 
  on q.PGASeason = o.PGASeason and q.Brand = o.brand
  where q.PGASeason = @PGASeason and q.SportTourId = @SportTourId
  
  
  
  
  
  --tournaments won and rank
  ;with cte_temp as (
select t.PGASeason, m.[PLAYER NAME], count(m.[Finish Position]) as TopFinish from  Money.TourMoneyStats m inner join Player_Master.TOURNAMENTS_TABLE t
on m.TournamentId = t.TournamentId 
--where t.[TYPE] = @Tour and [Finish Position] = 1 and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd
where [Finish Position] = 1 and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and T.TYPE = @Tour) or (@Sporttourid = 58 and t.SID in (26,351,353,355)))
group by t.PGASeason, m.[PLAYER NAME]),

cte_2 as (
select distinct p4.playername, p4.pgaseason, brand, t.TopFinish  from [DARRELL_MASTER].[MoneyBall].[WebsiteDataplayer4] p4
inner join cte_temp t on p4.PlayerName = t.[PLAYER NAME] and p4.PGASeason = t.PGASeason 
where p4.pgaseason = @PGASeason and p4.SportTourId = @SportTourId)


update q set q.TournamentWon  = o.TopFinish, q.TournamentWonRank = rn
FROM [DARRELL_MASTER].[MoneyBall].[WebsiteData6] q 
left outer join 
  (select pgaseason, Brand, SUM(topfinish) as TopFinish, rank() over(partition by pgaseason order by SUM(topfinish) desc) rn  from cte_2 group by pgaseason, Brand) o 
  on q.PGASeason = o.PGASeason and q.Brand = o.brand
  where q.PGASeason = @PGASeason and q.SportTourId = @SportTourId
  
  
  
  --top10 finishes and rank
  
  ;with cte_temp as (
select t.PGASeason, m.[PLAYER NAME], count(m.[Finish Position]) as TopFinish from  Money.TourMoneyStats m inner join Player_Master.TOURNAMENTS_TABLE t
on m.TournamentId = t.TournamentId 
--where t.[TYPE] = @Tour and [Finish Position] < 11 and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd
where [Finish Position] < 11 and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and T.TYPE = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))
group by t.PGASeason, m.[PLAYER NAME]),

cte_2 as (
select distinct p4.playername, p4.pgaseason, brand, t.TopFinish  from [DARRELL_MASTER].[MoneyBall].[WebsiteDataplayer4] p4
inner join cte_temp t on p4.PlayerName = t.[PLAYER NAME] and p4.PGASeason = t.PGASeason
where p4.pgaseason = @PGASeason and p4.SportTourId = @SportTourId)


update q set q.Top10Finishes  = o.TopFinish, q.Top10FinishesRank = rn
FROM [DARRELL_MASTER].[MoneyBall].[WebsiteData6] q 
left outer join 
  (select pgaseason, Brand, SUM(topfinish) as TopFinish, rank() over(partition by pgaseason order by SUM(topfinish) desc) rn  from cte_2 group by pgaseason, Brand) o 
  on q.PGASeason = o.PGASeason and q.Brand = o.brand
  where q.PGASeason = @PGASeason and q.SportTourId = @SportTourId


Print 'Finished WebsiteData6'; 
 end -- WebsiteData6
GO
