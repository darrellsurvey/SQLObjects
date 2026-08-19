DROP PROCEDURE IF EXISTS [MoneyBall].[Fill_WebsiteData14];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	
-- =============================================

CREATE procedure [MoneyBall].[Fill_WebsiteData14]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS
Begin -- WebsiteData14
Print 'Begin WebsiteData14';
	

if @SportTourId = 1 
begin


delete from MoneyBall.WebsiteData14 where PGASeason = @PGASeason and SportTourId = @SportTourId


declare @sqltext1 as varchar(max), @sqltext2 as varchar(max), @sqltext3 as varchar(max), @sqltext4 as varchar(max), @sqltext5 as varchar(max), @sqltext6 as varchar(max), @sqltext7 as varchar(max)


declare @Equip1 as varchar(15) = 'woods'
declare @Equip2 as varchar(15) = 'Wood - Driver'
declare @Equip3 as varchar(15) = 'Driver'
declare @Where as varchar(200) = ' and isdriver = 1 '


set @sqltext1 = '

;with cte1 as (select b.PGASeason, b.PLAYERNAME, case when b.brand = ''FOOT Joy'' then ''FOOTJOY'' else b.Brand end as brand, ms.[Official Money],
				case when pr.DSRank < 11 then b.PLAYERNAME else null end as DSRankTop10,
			    case when pr.DSRank < 26 then b.PLAYERNAME else null end as DSRankTop25,
			    case when pr.DSRank between 26 and 50 then b.PLAYERNAME else null end as DSRank26to50,
			    case when pr.DSRank between 51 and 100 then b.PLAYERNAME else null end as DSRank51to100,
			    case when pr.DSRank between 101 and 150 then b.PLAYERNAME else null end as DSRank101to150,
			    case when pr.DSRank between 151 and 200 then b.PLAYERNAME else null end as DSRank151to200,
			    case when pr.DSRank > 200 then b.PLAYERNAME else null end as DSRank201Plus,
				case when ms.[Finish Position] between 1 and 10 then ms.[Finish Position] else null end as TournamentsTop10,
				case when ms.[Finish Position] = 1 then 1 else null end as TournamentsWon
				from [DARRELL_MASTER].[dbo].[' + @Equip1 + '] b 
				inner join [DARRELL_MASTER].Money.TourMoneyStats ms
				on b.PLAYERNAME = ms.[PLAYER NAME] and b.TournamentId = ms.TournamentId
				left outer join [MoneyBall].[PlayerRank] pr on
				b.PLAYERNAME = pr.PlayerName and b.PGASeason = pr.PGASeason
				Where b.PGASeason = ' + cast(@PGASeason as varchar(4)) + ' and pr.SportTourId = ' + cast(@SportTourId as varchar(4)) + ' and Tour = ''' + @Tour + ''' ' + @Where + '),

cte2 as (SELECT ''' + @Equip3 + ''' as Equipment, cte1.[PGASeason]
      ,cte1.[BRAND]
      ,COUNT(*) as BrandTotalUse
	  ,COUNT(*) * 1.0 / sum(COUNT(*)) over (partition by cte1.[PGASeason]) as BrandTotalUsePercent
      ,COUNT(distinct PlayerName) as BrandUniquePlayerUse
	  ,COUNT(distinct PlayerName) * 1.0 / sum(COUNT(distinct PlayerName)) over(partition by cte1.[PGASeason]) as BrandUniquePlayerUsePercent
      ,sum([Official Money]) as MoneyWon
	  ,sum([Official Money]) * 1.0 / sum(sum([Official Money])) over (partition by cte1.[PGASeason]) as MoneyWonPercent
	  ,count(distinct DSRankTop10) / 10.0 as DSRankTop10
	  ,count(distinct DSRankTop25)  / 25.0 as DSRankTop25
	  ,count(distinct DSRank26to50)  / 25.0 as DSRank26to50
	  ,count(distinct DSRank51to100)  / 50.0 as DSRank51to100
	  ,count(distinct DSRank101to150)  / 50.0 as DSRank101to150
	  ,count(distinct DSRank151to200)  / 50.0 as DSRank151to200
	  ,count(distinct DSRank201Plus)  / nullif((select count(distinct DSRank201Plus) from cte1),0) as DSRank201Plus
	  ,count(TournamentsTop10) as TournamentsTop10
	  ,count(TournamentsWon) as TournamentsWon
	  ,count(TournamentsTop10) / (10.0 * YearlyEvents) as TournamentsTop10Percent
	  ,count(TournamentsWon) * 1.0 / YearlyEvents as TournamentsWonPercent
FROM cte1
inner join (select count(distinct TournamentId) as YearlyEvents, PGASeason from [TV].[TVAudit] where Tour = ''' + @Tour + ''' group by PGASeason) t on cte1.PGASeason = t.PGASeason
group by cte1.[PGASeason], cte1.[BRAND], YearlyEvents)



insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)
 
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''BrandTotalUse'' as Header,  BrandTotalUse as UserData FROM cte2 where BrandTotalUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''BrandTotalUsePercent'' as Header,  BrandTotalUsePercent as UserData FROM cte2 where BrandTotalUsePercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''BrandUniquePlayerUse'' as Header,  BrandUniquePlayerUse as UserData FROM cte2 where BrandUniquePlayerUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''BrandUniquePlayerUsePercent'' as Header,  BrandUniquePlayerUsePercent as UserData FROM cte2 where BrandUniquePlayerUsePercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''MoneyWon'' as Header,  MoneyWon as UserData FROM cte2 where MoneyWon > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''MoneyYTDPercent'' as Header,  MoneyWonPercent as UserData FROM cte2 where MoneyWonPercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSRankTop10'' as Header,  DSRankTop10 as UserData FROM cte2 where DSRankTop10 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSRankTop25'' as Header,  DSRankTop25 as UserData FROM cte2 where DSRankTop25 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSRank26to50'' as Header,  DSRank26to50 as UserData FROM cte2 where DSRank26to50 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSRank51to100'' as Header,  DSRank51to100 as UserData FROM cte2 where DSRank51to100 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSRank101to150'' as Header,  DSRank101to150 as UserData FROM cte2 where DSRank101to150 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSRank151to200'' as Header,  DSRank151to200 as UserData FROM cte2 where DSRank151to200 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSRank201Plus'' as Header,  DSRank201Plus as UserData FROM cte2 where DSRank201Plus > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''TournamentsTop10'' as Header,  TournamentsTop10 as UserData FROM cte2 where TournamentsTop10 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''TournamentsWon'' as Header,  TournamentsWon as UserData FROM cte2 where TournamentsWon > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''TournamentsTop10Percent'' as Header,  TournamentsTop10Percent as UserData FROM cte2 where TournamentsTop10Percent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''TournamentsWonPercent'' as Header,  TournamentsWonPercent as UserData FROM cte2 where TournamentsWonPercent > 0


;with cte1 as (select * from (select ''' + @Equip3 + ''' as Equipment, PGASeason, BRAND, DSPoints, DSPointsPercent / 100.0 as DSPointsPercent 
				FROM [MoneyBall].[WebsiteData6] where [SportTourId] = ' + cast(@SportTourId as varchar(4)) + ' and PGASeason = ' + cast(@PGASeason as varchar(4)) + ') a 
				where brand in (select distinct Brand from MoneyBall.WebsiteDataPlayerTourEquipment where [SportTourId] = ' + cast(@SportTourId as varchar(4)) + ' and PGASeason = ' + cast(@PGASeason as varchar(4)) + '))

insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)
Select Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSPoints'' as Header, DSPoints as UserData from cte1 where DSPoints > 0 union all
Select Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSPointsPercent'' as Header, DSPointsPercent as UserData from cte1 where DSPoints > 0



;with cte1 as (select ''' + @Equip3 + ''' as Equipment, PGASeason, BRAND, Sum(DSPoints) * 1.0 / sum(sum(DSPoints)) over(Partition by PGASeason) as DSPointsPercent 
				FROM [MoneyBall].[WebsiteData6] where PGASeason = ' + cast(@PGASeason as varchar(4)) + ' and [SportTourId] = ' + cast(@SportTourId as varchar(4)) + ' and
				brand in (select distinct Brand from MoneyBall.WebsiteDataPlayerTourEquipment 
							where [SportTourId] = ' + cast(@SportTourId as varchar(4)) + ' and PGASeason = ' + cast(@PGASeason as varchar(4)) + ' and Equipment = ''' + @Equip3 + ''')
				group by [PGASeason], [BRAND])

insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)
Select Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSPointsEquipmentPercent'' as Header, DSPointsPercent as UserData from cte1'


--Majors----------------------------------------------------------------

set @sqltext2 = '

;with cte1 as (select b.PGASeason, b.PLAYERNAME, case when b.brand = ''FOOT Joy'' then ''FOOTJOY'' else b.Brand end as brand, ms.[Official Money],
				case when ms.[Finish Position] between 1 and 10 then ms.[Finish Position] else null end as TournamentsTop10,
				case when ms.[Finish Position] = 1 then 1 else null end as TournamentsWon
				from [DARRELL_MASTER].[dbo].[' + @Equip1 + '] b 
				inner join [DARRELL_MASTER].Money.TourMoneyStats ms
				on b.PLAYERNAME = ms.[PLAYER NAME] and b.TournamentId = ms.TournamentId
				left outer join [MoneyBall].[PlayerRank] pr on
				b.PLAYERNAME = pr.PlayerName and b.PGASeason = pr.PGASeason
				Where b.PGASeason = ' + cast(@PGASeason as varchar(4)) + ' and pr.SportTourId = ' + cast(@SportTourId as varchar(4)) + ' and Tour = ''' + @Tour + ''' ' + @Where + ' and SID in (26,351,353,355)),

cte2 as (SELECT ''' + @Equip3 + ''' as Equipment, cte1.[PGASeason]
      ,cte1.[BRAND]
      ,COUNT(*) as BrandTotalUse
	  ,COUNT(*) * 1.0 / sum(COUNT(*)) over (partition by cte1.[PGASeason]) as BrandTotalUsePercent
      ,COUNT(distinct PlayerName) as BrandUniquePlayerUse
	  ,COUNT(distinct PlayerName) * 1.0 / sum(COUNT(distinct PlayerName)) over(partition by cte1.[PGASeason]) as BrandUniquePlayerUsePercent
      ,sum([Official Money]) as MoneyWon
	  ,sum([Official Money]) * 1.0 / sum(sum([Official Money])) over (partition by cte1.[PGASeason]) as MoneyWonPercent
	  ,count(TournamentsTop10) as TournamentsTop10
	  ,count(TournamentsWon) as TournamentsWon
	  ,count(TournamentsTop10) / (10.0 * YearlyEvents) as TournamentsTop10Percent
	  ,count(TournamentsWon) * 1.0 / YearlyEvents as TournamentsWonPercent
FROM cte1
inner join (select count(distinct TournamentId) as YearlyEvents, PGASeason from [TV].[TVAudit] where Tour = ''' + @Tour + ''' and TntNid  in (26,351,353,355) group by PGASeason) t on cte1.PGASeason = t.PGASeason
group by cte1.[PGASeason], cte1.[BRAND], YearlyEvents)



insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)
 
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''BrandTotalUse'' as Header,  BrandTotalUse as UserData FROM cte2 where BrandTotalUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''BrandTotalUsePercent'' as Header,  BrandTotalUsePercent as UserData FROM cte2 where BrandTotalUsePercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''BrandUniquePlayerUse'' as Header,  BrandUniquePlayerUse as UserData FROM cte2 where BrandUniquePlayerUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''BrandUniquePlayerUsePercent'' as Header,  BrandUniquePlayerUsePercent as UserData FROM cte2 where BrandUniquePlayerUsePercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''MoneyWon'' as Header,  MoneyWon as UserData FROM cte2 where MoneyWon > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''MoneyWonPercent'' as Header,  MoneyWonPercent as UserData FROM cte2 where MoneyWonPercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''TournamentsTop10'' as Header,  TournamentsTop10 as UserData FROM cte2 where TournamentsTop10 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''TournamentsWon'' as Header,  TournamentsWon as UserData FROM cte2 where TournamentsWon > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''TournamentsTop10Percent'' as Header,  TournamentsTop10Percent as UserData FROM cte2 where TournamentsTop10Percent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''TournamentsWonPercent'' as Header,  TournamentsWonPercent as UserData FROM cte2 where TournamentsWonPercent > 0

;with cte1 as (select * from (select ''' + @Equip3 + ''' as Equipment, PGASeason, BRAND, DSPoints, DSPointsPercent / 100.0 as DSPointsPercent 
				FROM [MoneyBall].[WebsiteData6] where [SportTourId] = 58 and PGASeason = ' + cast(@PGASeason as varchar(4)) + ') a 
				where brand in (select distinct Brand from MoneyBall.WebsiteDataPlayerTourEquipment where [SportTourId] = 58 and PGASeason = ' + cast(@PGASeason as varchar(4)) + '))

insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)

Select Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''DSPoints'' as Header, DSPoints as UserData from cte1 where DSPoints > 0 union all
Select Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''DSPointsPercent'' as Header, DSPointsPercent as UserData from cte1 where DSPoints > 0



;with cte1 as (select ''' + @Equip3 + ''' as Equipment, PGASeason, BRAND, Sum(DSPoints) * 1.0 / sum(sum(DSPoints)) over(Partition by PGASeason) as DSPointsPercent 
				FROM [MoneyBall].[WebsiteData6] where PGASeason = ' + cast(@PGASeason as varchar(4)) + ' and [SportTourId] = 58 and
				brand in (select distinct Brand from MoneyBall.WebsiteDataPlayerTourEquipment
							where [SportTourId] = 58 and PGASeason = ' + cast(@PGASeason as varchar(4)) + ' and Equipment = ''' + @Equip3 + ''')
				group by [PGASeason], [BRAND])

insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)
Select Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''DSPointsEquipmentPercent'' as Header, DSPointsPercent as UserData from cte1'



--Amateurs-----------------------------------------------------------

set @sqltext3 = '

--NCAAMensChamp

;with cte1 as (select year([first Day]) as PGASeason, b.PLAYERNAME, case when b.brand = ''FOOT Joy'' then ''FOOTJOY'' else b.Brand end as brand
				from [DARRELL_MASTER].[dbo].[' + @Equip1 + '] b 
				Where year([first Day]) = ' + cast(@PGASeason as varchar(4)) + ' ' + @Where + ' and SID = 423),

cte2 as (SELECT ''' + @Equip3 + ''' as Equipment, cte1.[PGASeason]
      ,cte1.[BRAND]
      ,COUNT(*) as BrandTotalUse
	  ,COUNT(*) * 1.0 / sum(COUNT(*)) over (partition by cte1.[PGASeason]) as BrandTotalUsePercent
      ,COUNT(distinct PlayerName) as BrandUniquePlayerUse
	  ,COUNT(distinct PlayerName) * 1.0 / sum(COUNT(distinct PlayerName)) over(partition by cte1.[PGASeason]) as BrandUniquePlayerUsePercent
FROM cte1
group by cte1.[PGASeason], cte1.[BRAND])



insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)
 
SELECT Equipment, [PGASeason], [BRAND], ''NCAA'' as DataBlock, ''BrandTotalUse'' as Header,  BrandTotalUse as UserData FROM cte2 where BrandTotalUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''NCAA'' as DataBlock, ''BrandTotalUsePercent'' as Header,  BrandTotalUsePercent as UserData FROM cte2 where BrandTotalUsePercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''NCAA'' as DataBlock, ''BrandUniquePlayerUse'' as Header,  BrandUniquePlayerUse as UserData FROM cte2 where BrandUniquePlayerUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''NCAA'' as DataBlock, ''BrandUniquePlayerUsePercent'' as Header,  BrandUniquePlayerUsePercent as UserData FROM cte2 where BrandUniquePlayerUsePercent > 0



--US Am

;with cte1 as (select year([first Day]) as PGASeason, b.PLAYERNAME, case when b.brand = ''FOOT Joy'' then ''FOOTJOY'' else b.Brand end as brand
				from [DARRELL_MASTER].[dbo].[' + @Equip1 + '] b 
				Where year([first Day]) = ' + cast(@PGASeason as varchar(4)) + ' ' + @Where + ' and SID in (415,411,418,316,414,995,374)),

cte2 as (SELECT ''' + @Equip3 + ''' as Equipment, cte1.[PGASeason]
      ,cte1.[BRAND]
      ,COUNT(*) as BrandTotalUse
	  ,COUNT(*) * 1.0 / sum(COUNT(*)) over (partition by cte1.[PGASeason]) as BrandTotalUsePercent
      ,COUNT(distinct PlayerName) as BrandUniquePlayerUse
	  ,COUNT(distinct PlayerName) * 1.0 / sum(COUNT(distinct PlayerName)) over(partition by cte1.[PGASeason]) as BrandUniquePlayerUsePercent
FROM cte1
group by cte1.[PGASeason], cte1.[BRAND])



insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)
 
SELECT Equipment, [PGASeason], [BRAND], ''Amateur'' as DataBlock, ''BrandTotalUse'' as Header,  BrandTotalUse as UserData FROM cte2 where BrandTotalUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Amateur'' as DataBlock, ''BrandTotalUsePercent'' as Header,  BrandTotalUsePercent as UserData FROM cte2 where BrandTotalUsePercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Amateur'' as DataBlock, ''BrandUniquePlayerUse'' as Header,  BrandUniquePlayerUse as UserData FROM cte2 where BrandUniquePlayerUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Amateur'' as DataBlock, ''BrandUniquePlayerUsePercent'' as Header,  BrandUniquePlayerUsePercent as UserData FROM cte2 where BrandUniquePlayerUsePercent > 0



--Junior Am

;with cte1 as (select year([first Day]) as PGASeason, b.PLAYERNAME, case when b.brand = ''FOOT Joy'' then ''FOOTJOY'' else b.Brand end as brand
				from [DARRELL_MASTER].[dbo].[' + @Equip1 + '] b 
				Where year([first Day]) = ' + cast(@PGASeason as varchar(4)) + ' ' + @Where + ' and SID in (412, 413)),

cte2 as (SELECT ''' + @Equip3 + ''' as Equipment, cte1.[PGASeason]
      ,cte1.[BRAND]
      ,COUNT(*) as BrandTotalUse
	  ,COUNT(*) * 1.0 / sum(COUNT(*)) over (partition by cte1.[PGASeason]) as BrandTotalUsePercent
      ,COUNT(distinct PlayerName) as BrandUniquePlayerUse
	  ,COUNT(distinct PlayerName) * 1.0 / sum(COUNT(distinct PlayerName)) over(partition by cte1.[PGASeason]) as BrandUniquePlayerUsePercent
FROM cte1
group by cte1.[PGASeason], cte1.[BRAND])



insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)
 
SELECT Equipment, [PGASeason], [BRAND], ''JRAmateur'' as DataBlock, ''BrandTotalUse'' as Header,  BrandTotalUse as UserData FROM cte2 where BrandTotalUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''JRAmateur'' as DataBlock, ''BrandTotalUsePercent'' as Header,  BrandTotalUsePercent as UserData FROM cte2 where BrandTotalUsePercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''JRAmateur'' as DataBlock, ''BrandUniquePlayerUse'' as Header,  BrandUniquePlayerUse as UserData FROM cte2 where BrandUniquePlayerUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''JRAmateur'' as DataBlock, ''BrandUniquePlayerUsePercent'' as Header,  BrandUniquePlayerUsePercent as UserData FROM cte2 where BrandUniquePlayerUsePercent > 0
'

------------US Consumer

Set @Sqltext4 = 
'
;with ctebody as (
SELECT p.YEAR, [BRAND],
COUNT(*) as BrandTotal, ' 
if @Equip1 = 'Ball' 
	set @sqltext4 = @sqltext4 + ' CAST(NULL AS INTEGER) ' 
else 
	set @sqltext4 = @sqltext4 + ' sum(case when b.Years < 2 then 1 else 0 end) ' 

set @sqltext4 = @sqltext4 + ' as CountNew,
sum(case when p.HANDICAP < 6 then 1 else 0 end) as h1,
sum(case when p.HANDICAP between 6 and 10 then 1 else 0 end) as h2,
sum(case when p.HANDICAP between 11 and 20 then 1 else 0 end) as h3,
sum(case when p.HANDICAP > 20 then 1 else 0 end) as h4,
sum(case when p.HANDICAP is null then 1 else 0 end) as h5,
sum(case when p.AGE between 1 and 2 then 1 else 0 end) as age1,
sum(case when p.AGE between 3 and 4 then 1 else 0 end) as age2,
sum(case when p.AGE > 4 then 1 else 0 end) as age3

FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equip2) + ' b
inner join Consumer.PlayerProfile p 
on b.PlayerProfileId = p.PlayerProfileId
where not brand is null and p.COUNTRY = ''USA'' and p.YEAR = ' + cast(@PGASeason as varchar(4)) + ' '
+ [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equip2) + '
group by [YEAR], Brand
),

cteTotals as (
select [YEAR], SUM(BrandTotal) as TotalCount,
SUM(CountNew) as AllNewTotal,
SUM(h1) as h1,
SUM(h2) as h2,
SUM(h3) as h3,
SUM(h4) as h4,
SUM(age1) as age1,
SUM(age2) as age2,
SUM(age3) as age3
from ctebody
group by [YEAR]),


cteFinal as (
select ''' + @Equip3 + ''' as Equipment, b.[YEAR], b.Brand, 
	b.BrandTotal * 1.0 / t.TotalCount as BrandPercent,
	b.CountNew * 1.0 / t.AllNewTotal as BrandNewPercent,
	b.h1 * 1.0 / t.h1 as h1,
	b.h2 * 1.0 / t.h2 as h2,
	b.h3 * 1.0 / t.h3 as h3,
	b.h4 * 1.0 / t.h4 as h4,
	b.age1 * 1.0 / t.age1 as age1,
	b.age2 * 1.0 / t.age2 as age2,
	b.age3 * 1.0 / t.age3 as age3
	from ctebody b
	inner join cteTotals t on b.[YEAR] = t.[YEAR]
	inner join (select distinct PGASeason, Brand from [MoneyBall].[WebsiteData14]) a on b.[YEAR] = a.PGASeason and b.Brand = a.brand)
	
	
	insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)

	
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentAll'' as Header, BrandPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentAllNew'' as Header, BrandNewPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentHandicap0to5'' as Header, h1 as UserData from cteFinal where h1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentHandicap6to10'' as Header, h2 as UserData from cteFinal where h2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentHandicap11to20'' as Header, h3 as UserData from cteFinal where h3 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentHandicap21Plus'' as Header, h4 as UserData from cteFinal where h4 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentAgeUnder30'' as Header, age1 as UserData from cteFinal where age1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentAge30to49'' as Header, age2 as UserData from cteFinal where age2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentAge50Plus'' as Header, age3 as UserData from cteFinal where age3 > 0
'

------------Japan COnsumer

Set @Sqltext5 = 
'
;with ctebody as (
SELECT p.YEAR, [BRAND],
COUNT(*) as BrandTotal, ' 
if @Equip1 = 'Ball' 
	set @sqltext5 = @sqltext5 + ' CAST(NULL AS INTEGER) ' 
else 
	set @sqltext5 = @sqltext5 + ' sum(case when b.Years < 2 then 1 else 0 end) ' 

set @sqltext5 = @sqltext5 + ' as CountNew,
sum(case when p.HANDICAP < 6 then 1 else 0 end) as h1,
sum(case when p.HANDICAP between 6 and 10 then 1 else 0 end) as h2,
sum(case when p.HANDICAP between 11 and 20 then 1 else 0 end) as h3,
sum(case when p.HANDICAP > 20 then 1 else 0 end) as h4,
sum(case when p.HANDICAP is null then 1 else 0 end) as h5,
sum(case when p.AGE between 1 and 2 then 1 else 0 end) as age1,
sum(case when p.AGE between 3 and 4 then 1 else 0 end) as age2,
sum(case when p.AGE > 4 then 1 else 0 end) as age3

FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equip2) + ' b
inner join Consumer.PlayerProfile p 
on b.PlayerProfileId = p.PlayerProfileId
where not brand is null and p.COUNTRY = ''Japan'' and p.YEAR = ' + cast(@PGASeason as varchar(4)) + ' '
+ [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equip2) + '
group by [YEAR], Brand
),

cteTotals as (
select [YEAR], SUM(BrandTotal) as TotalCount,
SUM(CountNew) as AllNewTotal,
SUM(h1) as h1,
SUM(h2) as h2,
SUM(h3) as h3,
SUM(h4) as h4,
SUM(age1) as age1,
SUM(age2) as age2,
SUM(age3) as age3
from ctebody
group by [YEAR]),


cteFinal as (
select ''' + @Equip3 + ''' as Equipment, b.[YEAR], b.Brand, 
	b.BrandTotal * 1.0 / t.TotalCount as BrandPercent,
	b.CountNew * 1.0 / t.AllNewTotal as BrandNewPercent,
	b.h1 * 1.0 / t.h1 as h1,
	b.h2 * 1.0 / t.h2 as h2,
	b.h3 * 1.0 / t.h3 as h3,
	b.h4 * 1.0 / t.h4 as h4,
	b.age1 * 1.0 / t.age1 as age1,
	b.age2 * 1.0 / t.age2 as age2,
	b.age3 * 1.0 / t.age3 as age3
	from ctebody b
	inner join cteTotals t on b.[YEAR] = t.[YEAR]
	inner join (select distinct PGASeason, Brand from [MoneyBall].[WebsiteData14]) a on b.[YEAR] = a.PGASeason and b.Brand = a.brand)
	
	
	insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)

	
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentAll'' as Header, BrandPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentAllNew'' as Header, BrandNewPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentHandicap0to5'' as Header, h1 as UserData from cteFinal where h1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentHandicap6to10'' as Header, h2 as UserData from cteFinal where h2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentHandicap11to20'' as Header, h3 as UserData from cteFinal where h3 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentHandicap21Plus'' as Header, h4 as UserData from cteFinal where h4 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentAgeUnder30'' as Header, age1 as UserData from cteFinal where age1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentAge30to49'' as Header, age2 as UserData from cteFinal where age2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentAge50Plus'' as Header, age3 as UserData from cteFinal where age3 > 0
'


------------China COnsumer

Set @Sqltext6 = 
'
;with ctebody as (
SELECT p.YEAR, [BRAND],
COUNT(*) as BrandTotal, ' 
if @Equip1 = 'Ball' 
	set @sqltext6 = @sqltext6 + ' CAST(NULL AS INTEGER) ' 
else 
	set @sqltext6 = @sqltext6 + ' sum(case when b.Years < 2 then 1 else 0 end) ' 

set @sqltext6 = @sqltext6 + ' as CountNew,
sum(case when p.HANDICAP < 6 then 1 else 0 end) as h1,
sum(case when p.HANDICAP between 6 and 10 then 1 else 0 end) as h2,
sum(case when p.HANDICAP between 11 and 20 then 1 else 0 end) as h3,
sum(case when p.HANDICAP > 20 then 1 else 0 end) as h4,
sum(case when p.HANDICAP is null then 1 else 0 end) as h5,
sum(case when p.AGE between 1 and 2 then 1 else 0 end) as age1,
sum(case when p.AGE between 3 and 4 then 1 else 0 end) as age2,
sum(case when p.AGE > 4 then 1 else 0 end) as age3

FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equip2) + ' b
inner join Consumer.PlayerProfile p 
on b.PlayerProfileId = p.PlayerProfileId
where not brand is null and p.COUNTRY = ''China'' and p.YEAR = ' + cast(@PGASeason as varchar(4)) + ' '
+ [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equip2) + '
group by [YEAR], Brand
),

cteTotals as (
select [YEAR], SUM(BrandTotal) as TotalCount,
SUM(CountNew) as AllNewTotal,
SUM(h1) as h1,
SUM(h2) as h2,
SUM(h3) as h3,
SUM(h4) as h4,
SUM(age1) as age1,
SUM(age2) as age2,
SUM(age3) as age3
from ctebody
group by [YEAR]),


cteFinal as (
select ''' + @Equip3 + ''' as Equipment, b.[YEAR], b.Brand, 
	b.BrandTotal * 1.0 / t.TotalCount as BrandPercent,
	b.CountNew * 1.0 / t.AllNewTotal as BrandNewPercent,
	b.h1 * 1.0 / t.h1 as h1,
	b.h2 * 1.0 / t.h2 as h2,
	b.h3 * 1.0 / t.h3 as h3,
	b.h4 * 1.0 / t.h4 as h4,
	b.age1 * 1.0 / t.age1 as age1,
	b.age2 * 1.0 / t.age2 as age2,
	b.age3 * 1.0 / t.age3 as age3
	from ctebody b
	inner join cteTotals t on b.[YEAR] = t.[YEAR]
	inner join (select distinct PGASeason, Brand from [MoneyBall].[WebsiteData14]) a on b.[YEAR] = a.PGASeason and b.Brand = a.brand)
	
	
	insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)

	
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentAll'' as Header, BrandPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentAllNew'' as Header, BrandNewPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentHandicap0to5'' as Header, h1 as UserData from cteFinal where h1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentHandicap6to10'' as Header, h2 as UserData from cteFinal where h2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentHandicap11to20'' as Header, h3 as UserData from cteFinal where h3 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentHandicap21Plus'' as Header, h4 as UserData from cteFinal where h4 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentAgeUnder30'' as Header, age1 as UserData from cteFinal where age1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentAge30to49'' as Header, age2 as UserData from cteFinal where age2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentAge50Plus'' as Header, age3 as UserData from cteFinal where age3 > 0
'




------------SEA COnsumer

Set @Sqltext7 = 
'
;with ctebody as (
SELECT p.YEAR, [BRAND],
COUNT(*) as BrandTotal, ' 
if @Equip1 = 'Ball' 
	set @sqltext7 = @sqltext7 + ' CAST(NULL AS INTEGER) ' 
else 
	set @sqltext7 = @sqltext7 + ' sum(case when b.Years < 2 then 1 else 0 end) ' 

set @sqltext7 = @sqltext7 + ' as CountNew,
sum(case when p.HANDICAP < 6 then 1 else 0 end) as h1,
sum(case when p.HANDICAP between 6 and 10 then 1 else 0 end) as h2,
sum(case when p.HANDICAP between 11 and 20 then 1 else 0 end) as h3,
sum(case when p.HANDICAP > 20 then 1 else 0 end) as h4,
sum(case when p.HANDICAP is null then 1 else 0 end) as h5,
sum(case when p.AGE between 1 and 2 then 1 else 0 end) as age1,
sum(case when p.AGE between 3 and 4 then 1 else 0 end) as age2,
sum(case when p.AGE > 4 then 1 else 0 end) as age3

FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equip2) + ' b
inner join Consumer.PlayerProfile p 
on b.PlayerProfileId = p.PlayerProfileId
where not brand is null and p.COUNTRY in (''Singapore'',''Thailand'',''Malaysia'',''Indonesia'')  and p.YEAR = ' + cast(@PGASeason as varchar(4)) + ' '
+ [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equip2) + '
group by [YEAR], Brand
),

cteTotals as (
select [YEAR], SUM(BrandTotal) as TotalCount,
SUM(CountNew) as AllNewTotal,
SUM(h1) as h1,
SUM(h2) as h2,
SUM(h3) as h3,
SUM(h4) as h4,
SUM(age1) as age1,
SUM(age2) as age2,
SUM(age3) as age3
from ctebody
group by [YEAR]),


cteFinal as (
select ''' + @Equip3 + ''' as Equipment, b.[YEAR], b.Brand, 
	b.BrandTotal * 1.0 / t.TotalCount as BrandPercent,
	b.CountNew * 1.0 / t.AllNewTotal as BrandNewPercent,
	b.h1 * 1.0 / t.h1 as h1,
	b.h2 * 1.0 / t.h2 as h2,
	b.h3 * 1.0 / t.h3 as h3,
	b.h4 * 1.0 / t.h4 as h4,
	b.age1 * 1.0 / t.age1 as age1,
	b.age2 * 1.0 / t.age2 as age2,
	b.age3 * 1.0 / t.age3 as age3
	from ctebody b
	inner join cteTotals t on b.[YEAR] = t.[YEAR]
	inner join (select distinct PGASeason, Brand from [MoneyBall].[WebsiteData14]) a on b.[YEAR] = a.PGASeason and b.Brand = a.brand)
	
	
	insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)

	
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentAll'' as Header, BrandPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentAllNew'' as Header, BrandNewPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentHandicap0to5'' as Header, h1 as UserData from cteFinal where h1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentHandicap6to10'' as Header, h2 as UserData from cteFinal where h2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentHandicap11to20'' as Header, h3 as UserData from cteFinal where h3 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentHandicap21Plus'' as Header, h4 as UserData from cteFinal where h4 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentAgeUnder30'' as Header, age1 as UserData from cteFinal where age1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentAge30to49'' as Header, age2 as UserData from cteFinal where age2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentAge50Plus'' as Header, age3 as UserData from cteFinal where age3 > 0
'

exec (@sqltext1 + @sqltext2 + @sqltext3 + @sqltext4 + @sqltext5 + @sqltext6 + @sqltext7)





set @Equip1 = 'ball'
set @Equip2 = 'ball'
set @Equip3 = 'Ball'
set @Where = ' '


set @sqltext1 = '

;with cte1 as (select b.PGASeason, b.PLAYERNAME, case when b.brand = ''FOOT Joy'' then ''FOOTJOY'' else b.Brand end as brand, ms.[Official Money],
				case when pr.DSRank < 11 then b.PLAYERNAME else null end as DSRankTop10,
			    case when pr.DSRank < 26 then b.PLAYERNAME else null end as DSRankTop25,
			    case when pr.DSRank between 26 and 50 then b.PLAYERNAME else null end as DSRank26to50,
			    case when pr.DSRank between 51 and 100 then b.PLAYERNAME else null end as DSRank51to100,
			    case when pr.DSRank between 101 and 150 then b.PLAYERNAME else null end as DSRank101to150,
			    case when pr.DSRank between 151 and 200 then b.PLAYERNAME else null end as DSRank151to200,
			    case when pr.DSRank > 200 then b.PLAYERNAME else null end as DSRank201Plus,
				case when ms.[Finish Position] between 1 and 10 then ms.[Finish Position] else null end as TournamentsTop10,
				case when ms.[Finish Position] = 1 then 1 else null end as TournamentsWon
				from [DARRELL_MASTER].[dbo].[' + @Equip1 + '] b 
				inner join [DARRELL_MASTER].Money.TourMoneyStats ms
				on b.PLAYERNAME = ms.[PLAYER NAME] and b.TournamentId = ms.TournamentId
				left outer join [MoneyBall].[PlayerRank] pr on
				b.PLAYERNAME = pr.PlayerName and b.PGASeason = pr.PGASeason
				Where b.PGASeason = ' + cast(@PGASeason as varchar(4)) + ' and pr.SportTourId = ' + cast(@SportTourId as varchar(4)) + ' and Tour = ''' + @Tour + ''' ' + @Where + '),

cte2 as (SELECT ''' + @Equip3 + ''' as Equipment, cte1.[PGASeason]
      ,cte1.[BRAND]
      ,COUNT(*) as BrandTotalUse
	  ,COUNT(*) * 1.0 / sum(COUNT(*)) over (partition by cte1.[PGASeason]) as BrandTotalUsePercent
      ,COUNT(distinct PlayerName) as BrandUniquePlayerUse
	  ,COUNT(distinct PlayerName) * 1.0 / sum(COUNT(distinct PlayerName)) over(partition by cte1.[PGASeason]) as BrandUniquePlayerUsePercent
      ,sum([Official Money]) as MoneyWon
	  ,sum([Official Money]) * 1.0 / sum(sum([Official Money])) over (partition by cte1.[PGASeason]) as MoneyWonPercent
	  ,count(distinct DSRankTop10) / 10.0 as DSRankTop10
	  ,count(distinct DSRankTop25)  / 25.0 as DSRankTop25
	  ,count(distinct DSRank26to50)  / 25.0 as DSRank26to50
	  ,count(distinct DSRank51to100)  / 50.0 as DSRank51to100
	  ,count(distinct DSRank101to150)  / 50.0 as DSRank101to150
	  ,count(distinct DSRank151to200)  / 50.0 as DSRank151to200
	  ,count(distinct DSRank201Plus)  / nullif((select count(distinct DSRank201Plus) from cte1),0) as DSRank201Plus
	  ,count(TournamentsTop10) as TournamentsTop10
	  ,count(TournamentsWon) as TournamentsWon
	  ,count(TournamentsTop10) / (10.0 * YearlyEvents) as TournamentsTop10Percent
	  ,count(TournamentsWon) * 1.0 / YearlyEvents as TournamentsWonPercent
FROM cte1
inner join (select count(distinct TournamentId) as YearlyEvents, PGASeason from [TV].[TVAudit] where Tour = ''' + @Tour + ''' group by PGASeason) t on cte1.PGASeason = t.PGASeason
group by cte1.[PGASeason], cte1.[BRAND], YearlyEvents)



insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)
 
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''BrandTotalUse'' as Header,  BrandTotalUse as UserData FROM cte2 where BrandTotalUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''BrandTotalUsePercent'' as Header,  BrandTotalUsePercent as UserData FROM cte2 where BrandTotalUsePercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''BrandUniquePlayerUse'' as Header,  BrandUniquePlayerUse as UserData FROM cte2 where BrandUniquePlayerUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''BrandUniquePlayerUsePercent'' as Header,  BrandUniquePlayerUsePercent as UserData FROM cte2 where BrandUniquePlayerUsePercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''MoneyWon'' as Header,  MoneyWon as UserData FROM cte2 where MoneyWon > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''MoneyYTDPercent'' as Header,  MoneyWonPercent as UserData FROM cte2 where MoneyWonPercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSRankTop10'' as Header,  DSRankTop10 as UserData FROM cte2 where DSRankTop10 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSRankTop25'' as Header,  DSRankTop25 as UserData FROM cte2 where DSRankTop25 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSRank26to50'' as Header,  DSRank26to50 as UserData FROM cte2 where DSRank26to50 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSRank51to100'' as Header,  DSRank51to100 as UserData FROM cte2 where DSRank51to100 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSRank101to150'' as Header,  DSRank101to150 as UserData FROM cte2 where DSRank101to150 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSRank151to200'' as Header,  DSRank151to200 as UserData FROM cte2 where DSRank151to200 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSRank201Plus'' as Header,  DSRank201Plus as UserData FROM cte2 where DSRank201Plus > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''TournamentsTop10'' as Header,  TournamentsTop10 as UserData FROM cte2 where TournamentsTop10 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''TournamentsWon'' as Header,  TournamentsWon as UserData FROM cte2 where TournamentsWon > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''TournamentsTop10Percent'' as Header,  TournamentsTop10Percent as UserData FROM cte2 where TournamentsTop10Percent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''TournamentsWonPercent'' as Header,  TournamentsWonPercent as UserData FROM cte2 where TournamentsWonPercent > 0




;with cte1 as (select * from (select ''' + @Equip3 + ''' as Equipment, PGASeason, BRAND, DSPoints, DSPointsPercent / 100.0 as DSPointsPercent 
				FROM [MoneyBall].[WebsiteData6] where [SportTourId] = ' + cast(@SportTourId as varchar(4)) + ' and PGASeason = ' + cast(@PGASeason as varchar(4)) + ') a 
				where brand in (select distinct Brand from MoneyBall.WebsiteDataPlayerTourEquipment where [SportTourId] = ' + cast(@SportTourId as varchar(4)) + ' and PGASeason = ' + cast(@PGASeason as varchar(4)) + '))

insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)

Select Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSPoints'' as Header, DSPoints as UserData from cte1 where DSPoints > 0 union all
Select Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSPointsPercent'' as Header, DSPointsPercent as UserData from cte1 where DSPoints > 0


;with cte1 as (select ''' + @Equip3 + ''' as Equipment, PGASeason, BRAND, Sum(DSPoints) * 1.0 / sum(sum(DSPoints)) over(Partition by PGASeason) as DSPointsPercent 
				FROM [MoneyBall].[WebsiteData6] where PGASeason = ' + cast(@PGASeason as varchar(4)) + ' and [SportTourId] = ' + cast(@SportTourId as varchar(4)) + ' and
				brand in (select distinct Brand from MoneyBall.WebsiteDataPlayerTourEquipment
							where [SportTourId] = ' + cast(@SportTourId as varchar(4)) + ' and PGASeason = ' + cast(@PGASeason as varchar(4)) + ' and Equipment = ''' + @Equip3 + ''')
				group by [PGASeason], [BRAND])

insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)
Select Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSPointsEquipmentPercent'' as Header, DSPointsPercent as UserData from cte1'


--Majors----------------------------------------------------------------

set @sqltext2 = '

;with cte1 as (select b.PGASeason, b.PLAYERNAME, case when b.brand = ''FOOT Joy'' then ''FOOTJOY'' else b.Brand end as brand, ms.[Official Money],
				case when ms.[Finish Position] between 1 and 10 then ms.[Finish Position] else null end as TournamentsTop10,
				case when ms.[Finish Position] = 1 then 1 else null end as TournamentsWon
				from [DARRELL_MASTER].[dbo].[' + @Equip1 + '] b 
				inner join [DARRELL_MASTER].Money.TourMoneyStats ms
				on b.PLAYERNAME = ms.[PLAYER NAME] and b.TournamentId = ms.TournamentId
				left outer join [MoneyBall].[PlayerRank] pr on
				b.PLAYERNAME = pr.PlayerName and b.PGASeason = pr.PGASeason
				Where b.PGASeason = ' + cast(@PGASeason as varchar(4)) + ' and pr.SportTourId = ' + cast(@SportTourId as varchar(4)) + ' and Tour = ''' + @Tour + ''' ' + @Where + ' and SID in (26,351,353,355)),

cte2 as (SELECT ''' + @Equip3 + ''' as Equipment, cte1.[PGASeason]
      ,cte1.[BRAND]
      ,COUNT(*) as BrandTotalUse
	  ,COUNT(*) * 1.0 / sum(COUNT(*)) over (partition by cte1.[PGASeason]) as BrandTotalUsePercent
      ,COUNT(distinct PlayerName) as BrandUniquePlayerUse
	  ,COUNT(distinct PlayerName) * 1.0 / sum(COUNT(distinct PlayerName)) over(partition by cte1.[PGASeason]) as BrandUniquePlayerUsePercent
      ,sum([Official Money]) as MoneyWon
	  ,sum([Official Money]) * 1.0 / sum(sum([Official Money])) over (partition by cte1.[PGASeason]) as MoneyWonPercent
	  ,count(TournamentsTop10) as TournamentsTop10
	  ,count(TournamentsWon) as TournamentsWon
	  ,count(TournamentsTop10) / (10.0 * YearlyEvents) as TournamentsTop10Percent
	  ,count(TournamentsWon) * 1.0 / YearlyEvents as TournamentsWonPercent
FROM cte1
inner join (select count(distinct TournamentId) as YearlyEvents, PGASeason from [TV].[TVAudit] where Tour = ''' + @Tour + ''' and TntNid  in (26,351,353,355) group by PGASeason) t on cte1.PGASeason = t.PGASeason
group by cte1.[PGASeason], cte1.[BRAND], YearlyEvents)



insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)
 
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''BrandTotalUse'' as Header,  BrandTotalUse as UserData FROM cte2 where BrandTotalUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''BrandTotalUsePercent'' as Header,  BrandTotalUsePercent as UserData FROM cte2 where BrandTotalUsePercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''BrandUniquePlayerUse'' as Header,  BrandUniquePlayerUse as UserData FROM cte2 where BrandUniquePlayerUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''BrandUniquePlayerUsePercent'' as Header,  BrandUniquePlayerUsePercent as UserData FROM cte2 where BrandUniquePlayerUsePercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''MoneyWon'' as Header,  MoneyWon as UserData FROM cte2 where MoneyWon > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''MoneyWonPercent'' as Header,  MoneyWonPercent as UserData FROM cte2 where MoneyWonPercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''TournamentsTop10'' as Header,  TournamentsTop10 as UserData FROM cte2 where TournamentsTop10 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''TournamentsWon'' as Header,  TournamentsWon as UserData FROM cte2 where TournamentsWon > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''TournamentsTop10Percent'' as Header,  TournamentsTop10Percent as UserData FROM cte2 where TournamentsTop10Percent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''TournamentsWonPercent'' as Header,  TournamentsWonPercent as UserData FROM cte2 where TournamentsWonPercent > 0

;with cte1 as (select * from (select ''' + @Equip3 + ''' as Equipment, PGASeason, BRAND, DSPoints, DSPointsPercent / 100.0 as DSPointsPercent 
				FROM [MoneyBall].[WebsiteData6] where [SportTourId] = 58 and PGASeason = ' + cast(@PGASeason as varchar(4)) + ') a 
				where brand in (select distinct Brand from MoneyBall.WebsiteDataPlayerTourEquipment where [SportTourId] = 58 and PGASeason = ' + cast(@PGASeason as varchar(4)) + '))

insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)

Select Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''DSPoints'' as Header, DSPoints as UserData from cte1 where DSPoints > 0 union all
Select Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''DSPointsPercent'' as Header, DSPointsPercent as UserData from cte1 where DSPoints > 0



;with cte1 as (select ''' + @Equip3 + ''' as Equipment, PGASeason, BRAND, Sum(DSPoints) * 1.0 / sum(sum(DSPoints)) over(Partition by PGASeason) as DSPointsPercent 
				FROM [MoneyBall].[WebsiteData6] where PGASeason = ' + cast(@PGASeason as varchar(4)) + ' and [SportTourId] = 58 and
				brand in (select distinct Brand from MoneyBall.WebsiteDataPlayerTourEquipment
							where [SportTourId] = 58 and PGASeason = ' + cast(@PGASeason as varchar(4)) + ' and Equipment = ''' + @Equip3 + ''')
				group by [PGASeason], [BRAND])

insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)
Select Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''DSPointsEquipmentPercent'' as Header, DSPointsPercent as UserData from cte1'




--Amateurs-----------------------------------------------------------

set @sqltext3 = '

--NCAAMensChamp

;with cte1 as (select year([first Day]) as PGASeason, b.PLAYERNAME, case when b.brand = ''FOOT Joy'' then ''FOOTJOY'' else b.Brand end as brand
				from [DARRELL_MASTER].[dbo].[' + @Equip1 + '] b 
				Where year([first Day]) = ' + cast(@PGASeason as varchar(4)) + ' ' + @Where + ' and SID = 423),

cte2 as (SELECT ''' + @Equip3 + ''' as Equipment, cte1.[PGASeason]
      ,cte1.[BRAND]
      ,COUNT(*) as BrandTotalUse
	  ,COUNT(*) * 1.0 / sum(COUNT(*)) over (partition by cte1.[PGASeason]) as BrandTotalUsePercent
      ,COUNT(distinct PlayerName) as BrandUniquePlayerUse
	  ,COUNT(distinct PlayerName) * 1.0 / sum(COUNT(distinct PlayerName)) over(partition by cte1.[PGASeason]) as BrandUniquePlayerUsePercent
FROM cte1
group by cte1.[PGASeason], cte1.[BRAND])



insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)
 
SELECT Equipment, [PGASeason], [BRAND], ''NCAA'' as DataBlock, ''BrandTotalUse'' as Header,  BrandTotalUse as UserData FROM cte2 where BrandTotalUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''NCAA'' as DataBlock, ''BrandTotalUsePercent'' as Header,  BrandTotalUsePercent as UserData FROM cte2 where BrandTotalUsePercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''NCAA'' as DataBlock, ''BrandUniquePlayerUse'' as Header,  BrandUniquePlayerUse as UserData FROM cte2 where BrandUniquePlayerUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''NCAA'' as DataBlock, ''BrandUniquePlayerUsePercent'' as Header,  BrandUniquePlayerUsePercent as UserData FROM cte2 where BrandUniquePlayerUsePercent > 0



--US Am

;with cte1 as (select year([first Day]) as PGASeason, b.PLAYERNAME, case when b.brand = ''FOOT Joy'' then ''FOOTJOY'' else b.Brand end as brand
				from [DARRELL_MASTER].[dbo].[' + @Equip1 + '] b 
				Where year([first Day]) = ' + cast(@PGASeason as varchar(4)) + ' ' + @Where + ' and SID in (415,411,418,316,414,995,374)),

cte2 as (SELECT ''' + @Equip3 + ''' as Equipment, cte1.[PGASeason]
      ,cte1.[BRAND]
      ,COUNT(*) as BrandTotalUse
	  ,COUNT(*) * 1.0 / sum(COUNT(*)) over (partition by cte1.[PGASeason]) as BrandTotalUsePercent
      ,COUNT(distinct PlayerName) as BrandUniquePlayerUse
	  ,COUNT(distinct PlayerName) * 1.0 / sum(COUNT(distinct PlayerName)) over(partition by cte1.[PGASeason]) as BrandUniquePlayerUsePercent
FROM cte1
group by cte1.[PGASeason], cte1.[BRAND])



insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)
 
SELECT Equipment, [PGASeason], [BRAND], ''Amateur'' as DataBlock, ''BrandTotalUse'' as Header,  BrandTotalUse as UserData FROM cte2 where BrandTotalUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Amateur'' as DataBlock, ''BrandTotalUsePercent'' as Header,  BrandTotalUsePercent as UserData FROM cte2 where BrandTotalUsePercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Amateur'' as DataBlock, ''BrandUniquePlayerUse'' as Header,  BrandUniquePlayerUse as UserData FROM cte2 where BrandUniquePlayerUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Amateur'' as DataBlock, ''BrandUniquePlayerUsePercent'' as Header,  BrandUniquePlayerUsePercent as UserData FROM cte2 where BrandUniquePlayerUsePercent > 0



--Junior Am

;with cte1 as (select year([first Day]) as PGASeason, b.PLAYERNAME, case when b.brand = ''FOOT Joy'' then ''FOOTJOY'' else b.Brand end as brand
				from [DARRELL_MASTER].[dbo].[' + @Equip1 + '] b 
				Where year([first Day]) = ' + cast(@PGASeason as varchar(4)) + ' ' + @Where + ' and SID in (412, 413)),

cte2 as (SELECT ''' + @Equip3 + ''' as Equipment, cte1.[PGASeason]
      ,cte1.[BRAND]
      ,COUNT(*) as BrandTotalUse
	  ,COUNT(*) * 1.0 / sum(COUNT(*)) over (partition by cte1.[PGASeason]) as BrandTotalUsePercent
      ,COUNT(distinct PlayerName) as BrandUniquePlayerUse
	  ,COUNT(distinct PlayerName) * 1.0 / sum(COUNT(distinct PlayerName)) over(partition by cte1.[PGASeason]) as BrandUniquePlayerUsePercent
FROM cte1
group by cte1.[PGASeason], cte1.[BRAND])



insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)
 
SELECT Equipment, [PGASeason], [BRAND], ''JRAmateur'' as DataBlock, ''BrandTotalUse'' as Header,  BrandTotalUse as UserData FROM cte2 where BrandTotalUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''JRAmateur'' as DataBlock, ''BrandTotalUsePercent'' as Header,  BrandTotalUsePercent as UserData FROM cte2 where BrandTotalUsePercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''JRAmateur'' as DataBlock, ''BrandUniquePlayerUse'' as Header,  BrandUniquePlayerUse as UserData FROM cte2 where BrandUniquePlayerUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''JRAmateur'' as DataBlock, ''BrandUniquePlayerUsePercent'' as Header,  BrandUniquePlayerUsePercent as UserData FROM cte2 where BrandUniquePlayerUsePercent > 0
'

------------US Consumer

Set @Sqltext4 = 
'
;with ctebody as (
SELECT p.YEAR, [BRAND],
COUNT(*) as BrandTotal, ' 
if @Equip1 = 'Ball' 
	set @sqltext4 = @sqltext4 + ' CAST(NULL AS INTEGER) ' 
else 
	set @sqltext4 = @sqltext4 + ' sum(case when b.Years < 2 then 1 else 0 end) ' 

set @sqltext4 = @sqltext4 + ' as CountNew,
sum(case when p.HANDICAP < 6 then 1 else 0 end) as h1,
sum(case when p.HANDICAP between 6 and 10 then 1 else 0 end) as h2,
sum(case when p.HANDICAP between 11 and 20 then 1 else 0 end) as h3,
sum(case when p.HANDICAP > 20 then 1 else 0 end) as h4,
sum(case when p.HANDICAP is null then 1 else 0 end) as h5,
sum(case when p.AGE between 1 and 2 then 1 else 0 end) as age1,
sum(case when p.AGE between 3 and 4 then 1 else 0 end) as age2,
sum(case when p.AGE > 4 then 1 else 0 end) as age3

FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equip2) + ' b
inner join Consumer.PlayerProfile p 
on b.PlayerProfileId = p.PlayerProfileId
where not brand is null and p.COUNTRY = ''USA'' and p.YEAR = ' + cast(@PGASeason as varchar(4)) + ' '
+ [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equip2) + '
group by [YEAR], Brand
),

cteTotals as (
select [YEAR], SUM(BrandTotal) as TotalCount,
SUM(CountNew) as AllNewTotal,
SUM(h1) as h1,
SUM(h2) as h2,
SUM(h3) as h3,
SUM(h4) as h4,
SUM(age1) as age1,
SUM(age2) as age2,
SUM(age3) as age3
from ctebody
group by [YEAR]),


cteFinal as (
select ''' + @Equip3 + ''' as Equipment, b.[YEAR], b.Brand, 
	b.BrandTotal * 1.0 / t.TotalCount as BrandPercent,
	b.CountNew * 1.0 / t.AllNewTotal as BrandNewPercent,
	b.h1 * 1.0 / t.h1 as h1,
	b.h2 * 1.0 / t.h2 as h2,
	b.h3 * 1.0 / t.h3 as h3,
	b.h4 * 1.0 / t.h4 as h4,
	b.age1 * 1.0 / t.age1 as age1,
	b.age2 * 1.0 / t.age2 as age2,
	b.age3 * 1.0 / t.age3 as age3
	from ctebody b
	inner join cteTotals t on b.[YEAR] = t.[YEAR]
	inner join (select distinct PGASeason, Brand from [MoneyBall].[WebsiteData14]) a on b.[YEAR] = a.PGASeason and b.Brand = a.brand)
	
	
	insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)

	
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentAll'' as Header, BrandPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentAllNew'' as Header, BrandNewPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentHandicap0to5'' as Header, h1 as UserData from cteFinal where h1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentHandicap6to10'' as Header, h2 as UserData from cteFinal where h2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentHandicap11to20'' as Header, h3 as UserData from cteFinal where h3 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentHandicap21Plus'' as Header, h4 as UserData from cteFinal where h4 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentAgeUnder30'' as Header, age1 as UserData from cteFinal where age1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentAge30to49'' as Header, age2 as UserData from cteFinal where age2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentAge50Plus'' as Header, age3 as UserData from cteFinal where age3 > 0
'

------------Japan COnsumer

Set @Sqltext5 = 
'
;with ctebody as (
SELECT p.YEAR, [BRAND],
COUNT(*) as BrandTotal, ' 
if @Equip1 = 'Ball' 
	set @sqltext5 = @sqltext5 + ' CAST(NULL AS INTEGER) ' 
else 
	set @sqltext5 = @sqltext5 + ' sum(case when b.Years < 2 then 1 else 0 end) ' 

set @sqltext5 = @sqltext5 + ' as CountNew,
sum(case when p.HANDICAP < 6 then 1 else 0 end) as h1,
sum(case when p.HANDICAP between 6 and 10 then 1 else 0 end) as h2,
sum(case when p.HANDICAP between 11 and 20 then 1 else 0 end) as h3,
sum(case when p.HANDICAP > 20 then 1 else 0 end) as h4,
sum(case when p.HANDICAP is null then 1 else 0 end) as h5,
sum(case when p.AGE between 1 and 2 then 1 else 0 end) as age1,
sum(case when p.AGE between 3 and 4 then 1 else 0 end) as age2,
sum(case when p.AGE > 4 then 1 else 0 end) as age3

FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equip2) + ' b
inner join Consumer.PlayerProfile p 
on b.PlayerProfileId = p.PlayerProfileId
where not brand is null and p.COUNTRY = ''Japan'' and p.YEAR = ' + cast(@PGASeason as varchar(4)) + ' '
+ [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equip2) + '
group by [YEAR], Brand
),

cteTotals as (
select [YEAR], SUM(BrandTotal) as TotalCount,
SUM(CountNew) as AllNewTotal,
SUM(h1) as h1,
SUM(h2) as h2,
SUM(h3) as h3,
SUM(h4) as h4,
SUM(age1) as age1,
SUM(age2) as age2,
SUM(age3) as age3
from ctebody
group by [YEAR]),


cteFinal as (
select ''' + @Equip3 + ''' as Equipment, b.[YEAR], b.Brand, 
	b.BrandTotal * 1.0 / t.TotalCount as BrandPercent,
	b.CountNew * 1.0 / t.AllNewTotal as BrandNewPercent,
	b.h1 * 1.0 / t.h1 as h1,
	b.h2 * 1.0 / t.h2 as h2,
	b.h3 * 1.0 / t.h3 as h3,
	b.h4 * 1.0 / t.h4 as h4,
	b.age1 * 1.0 / t.age1 as age1,
	b.age2 * 1.0 / t.age2 as age2,
	b.age3 * 1.0 / t.age3 as age3
	from ctebody b
	inner join cteTotals t on b.[YEAR] = t.[YEAR]
	inner join (select distinct PGASeason, Brand from [MoneyBall].[WebsiteData14]) a on b.[YEAR] = a.PGASeason and b.Brand = a.brand)
	
	
	insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)

	
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentAll'' as Header, BrandPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentAllNew'' as Header, BrandNewPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentHandicap0to5'' as Header, h1 as UserData from cteFinal where h1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentHandicap6to10'' as Header, h2 as UserData from cteFinal where h2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentHandicap11to20'' as Header, h3 as UserData from cteFinal where h3 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentHandicap21Plus'' as Header, h4 as UserData from cteFinal where h4 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentAgeUnder30'' as Header, age1 as UserData from cteFinal where age1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentAge30to49'' as Header, age2 as UserData from cteFinal where age2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentAge50Plus'' as Header, age3 as UserData from cteFinal where age3 > 0
'


------------China COnsumer

Set @Sqltext6 = 
'
;with ctebody as (
SELECT p.YEAR, [BRAND],
COUNT(*) as BrandTotal, ' 
if @Equip1 = 'Ball' 
	set @sqltext6 = @sqltext6 + ' CAST(NULL AS INTEGER) ' 
else 
	set @sqltext6 = @sqltext6 + ' sum(case when b.Years < 2 then 1 else 0 end) ' 

set @sqltext6 = @sqltext6 + ' as CountNew,
sum(case when p.HANDICAP < 6 then 1 else 0 end) as h1,
sum(case when p.HANDICAP between 6 and 10 then 1 else 0 end) as h2,
sum(case when p.HANDICAP between 11 and 20 then 1 else 0 end) as h3,
sum(case when p.HANDICAP > 20 then 1 else 0 end) as h4,
sum(case when p.HANDICAP is null then 1 else 0 end) as h5,
sum(case when p.AGE between 1 and 2 then 1 else 0 end) as age1,
sum(case when p.AGE between 3 and 4 then 1 else 0 end) as age2,
sum(case when p.AGE > 4 then 1 else 0 end) as age3

FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equip2) + ' b
inner join Consumer.PlayerProfile p 
on b.PlayerProfileId = p.PlayerProfileId
where not brand is null and p.COUNTRY = ''China'' and p.YEAR = ' + cast(@PGASeason as varchar(4)) + ' '
+ [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equip2) + '
group by [YEAR], Brand
),

cteTotals as (
select [YEAR], SUM(BrandTotal) as TotalCount,
SUM(CountNew) as AllNewTotal,
SUM(h1) as h1,
SUM(h2) as h2,
SUM(h3) as h3,
SUM(h4) as h4,
SUM(age1) as age1,
SUM(age2) as age2,
SUM(age3) as age3
from ctebody
group by [YEAR]),


cteFinal as (
select ''' + @Equip3 + ''' as Equipment, b.[YEAR], b.Brand, 
	b.BrandTotal * 1.0 / t.TotalCount as BrandPercent,
	b.CountNew * 1.0 / t.AllNewTotal as BrandNewPercent,
	b.h1 * 1.0 / t.h1 as h1,
	b.h2 * 1.0 / t.h2 as h2,
	b.h3 * 1.0 / t.h3 as h3,
	b.h4 * 1.0 / t.h4 as h4,
	b.age1 * 1.0 / t.age1 as age1,
	b.age2 * 1.0 / t.age2 as age2,
	b.age3 * 1.0 / t.age3 as age3
	from ctebody b
	inner join cteTotals t on b.[YEAR] = t.[YEAR]
	inner join (select distinct PGASeason, Brand from [MoneyBall].[WebsiteData14]) a on b.[YEAR] = a.PGASeason and b.Brand = a.brand)
	
	
	insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)

	
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentAll'' as Header, BrandPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentAllNew'' as Header, BrandNewPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentHandicap0to5'' as Header, h1 as UserData from cteFinal where h1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentHandicap6to10'' as Header, h2 as UserData from cteFinal where h2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentHandicap11to20'' as Header, h3 as UserData from cteFinal where h3 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentHandicap21Plus'' as Header, h4 as UserData from cteFinal where h4 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentAgeUnder30'' as Header, age1 as UserData from cteFinal where age1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentAge30to49'' as Header, age2 as UserData from cteFinal where age2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentAge50Plus'' as Header, age3 as UserData from cteFinal where age3 > 0
'




------------SEA COnsumer

Set @Sqltext7 = 
'
;with ctebody as (
SELECT p.YEAR, [BRAND],
COUNT(*) as BrandTotal, ' 
if @Equip1 = 'Ball' 
	set @sqltext7 = @sqltext7 + ' CAST(NULL AS INTEGER) ' 
else 
	set @sqltext7 = @sqltext7 + ' sum(case when b.Years < 2 then 1 else 0 end) ' 

set @sqltext7 = @sqltext7 + ' as CountNew,
sum(case when p.HANDICAP < 6 then 1 else 0 end) as h1,
sum(case when p.HANDICAP between 6 and 10 then 1 else 0 end) as h2,
sum(case when p.HANDICAP between 11 and 20 then 1 else 0 end) as h3,
sum(case when p.HANDICAP > 20 then 1 else 0 end) as h4,
sum(case when p.HANDICAP is null then 1 else 0 end) as h5,
sum(case when p.AGE between 1 and 2 then 1 else 0 end) as age1,
sum(case when p.AGE between 3 and 4 then 1 else 0 end) as age2,
sum(case when p.AGE > 4 then 1 else 0 end) as age3

FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equip2) + ' b
inner join Consumer.PlayerProfile p 
on b.PlayerProfileId = p.PlayerProfileId
where not brand is null and p.COUNTRY in (''Singapore'',''Thailand'',''Malaysia'',''Indonesia'')  and p.YEAR = ' + cast(@PGASeason as varchar(4)) + ' '
+ [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equip2) + '
group by [YEAR], Brand
),

cteTotals as (
select [YEAR], SUM(BrandTotal) as TotalCount,
SUM(CountNew) as AllNewTotal,
SUM(h1) as h1,
SUM(h2) as h2,
SUM(h3) as h3,
SUM(h4) as h4,
SUM(age1) as age1,
SUM(age2) as age2,
SUM(age3) as age3
from ctebody
group by [YEAR]),


cteFinal as (
select ''' + @Equip3 + ''' as Equipment, b.[YEAR], b.Brand, 
	b.BrandTotal * 1.0 / t.TotalCount as BrandPercent,
	b.CountNew * 1.0 / t.AllNewTotal as BrandNewPercent,
	b.h1 * 1.0 / t.h1 as h1,
	b.h2 * 1.0 / t.h2 as h2,
	b.h3 * 1.0 / t.h3 as h3,
	b.h4 * 1.0 / t.h4 as h4,
	b.age1 * 1.0 / t.age1 as age1,
	b.age2 * 1.0 / t.age2 as age2,
	b.age3 * 1.0 / t.age3 as age3
	from ctebody b
	inner join cteTotals t on b.[YEAR] = t.[YEAR]
	inner join (select distinct PGASeason, Brand from [MoneyBall].[WebsiteData14]) a on b.[YEAR] = a.PGASeason and b.Brand = a.brand)
	
	
	insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)

	
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentAll'' as Header, BrandPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentAllNew'' as Header, BrandNewPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentHandicap0to5'' as Header, h1 as UserData from cteFinal where h1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentHandicap6to10'' as Header, h2 as UserData from cteFinal where h2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentHandicap11to20'' as Header, h3 as UserData from cteFinal where h3 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentHandicap21Plus'' as Header, h4 as UserData from cteFinal where h4 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentAgeUnder30'' as Header, age1 as UserData from cteFinal where age1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentAge30to49'' as Header, age2 as UserData from cteFinal where age2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentAge50Plus'' as Header, age3 as UserData from cteFinal where age3 > 0
'

exec (@sqltext1 + @sqltext2 + @sqltext3 + @sqltext4 + @sqltext5 + @sqltext6 + @sqltext7)




Set @Equip1 = 'irons'
Set @Equip2 = 'iron'
Set @Equip3 = 'Iron'
Set @Where = ' and isset = 1 '

set @sqltext1 = '

;with cte1 as (select b.PGASeason, b.PLAYERNAME, case when b.brand = ''FOOT Joy'' then ''FOOTJOY'' else b.Brand end as brand, ms.[Official Money],
				case when pr.DSRank < 11 then b.PLAYERNAME else null end as DSRankTop10,
			    case when pr.DSRank < 26 then b.PLAYERNAME else null end as DSRankTop25,
			    case when pr.DSRank between 26 and 50 then b.PLAYERNAME else null end as DSRank26to50,
			    case when pr.DSRank between 51 and 100 then b.PLAYERNAME else null end as DSRank51to100,
			    case when pr.DSRank between 101 and 150 then b.PLAYERNAME else null end as DSRank101to150,
			    case when pr.DSRank between 151 and 200 then b.PLAYERNAME else null end as DSRank151to200,
			    case when pr.DSRank > 200 then b.PLAYERNAME else null end as DSRank201Plus,
				case when ms.[Finish Position] between 1 and 10 then ms.[Finish Position] else null end as TournamentsTop10,
				case when ms.[Finish Position] = 1 then 1 else null end as TournamentsWon
				from [DARRELL_MASTER].[dbo].[' + @Equip1 + '] b 
				inner join [DARRELL_MASTER].Money.TourMoneyStats ms
				on b.PLAYERNAME = ms.[PLAYER NAME] and b.TournamentId = ms.TournamentId
				left outer join [MoneyBall].[PlayerRank] pr on
				b.PLAYERNAME = pr.PlayerName and b.PGASeason = pr.PGASeason
				Where b.PGASeason = ' + cast(@PGASeason as varchar(4)) + ' and pr.SportTourId = ' + cast(@SportTourId as varchar(4)) + ' and Tour = ''' + @Tour + ''' ' + @Where + '),

cte2 as (SELECT ''' + @Equip3 + ''' as Equipment, cte1.[PGASeason]
      ,cte1.[BRAND]
      ,COUNT(*) as BrandTotalUse
	  ,COUNT(*) * 1.0 / sum(COUNT(*)) over (partition by cte1.[PGASeason]) as BrandTotalUsePercent
      ,COUNT(distinct PlayerName) as BrandUniquePlayerUse
	  ,COUNT(distinct PlayerName) * 1.0 / sum(COUNT(distinct PlayerName)) over(partition by cte1.[PGASeason]) as BrandUniquePlayerUsePercent
      ,sum([Official Money]) as MoneyWon
	  ,sum([Official Money]) * 1.0 / sum(sum([Official Money])) over (partition by cte1.[PGASeason]) as MoneyWonPercent
	  ,count(distinct DSRankTop10) / 10.0 as DSRankTop10
	  ,count(distinct DSRankTop25)  / 25.0 as DSRankTop25
	  ,count(distinct DSRank26to50)  / 25.0 as DSRank26to50
	  ,count(distinct DSRank51to100)  / 50.0 as DSRank51to100
	  ,count(distinct DSRank101to150)  / 50.0 as DSRank101to150
	  ,count(distinct DSRank151to200)  / 50.0 as DSRank151to200
	  ,count(distinct DSRank201Plus)  / Nullif((select count(distinct DSRank201Plus) from cte1), 0) as DSRank201Plus
	  ,count(TournamentsTop10) as TournamentsTop10
	  ,count(TournamentsWon) as TournamentsWon
	  ,count(TournamentsTop10) / (10.0 * YearlyEvents) as TournamentsTop10Percent
	  ,count(TournamentsWon) * 1.0 / YearlyEvents as TournamentsWonPercent
FROM cte1
inner join (select count(distinct TournamentId) as YearlyEvents, PGASeason from [TV].[TVAudit] where Tour = ''' + @Tour + ''' group by PGASeason) t on cte1.PGASeason = t.PGASeason
group by cte1.[PGASeason], cte1.[BRAND], YearlyEvents)



insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)
 
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''BrandTotalUse'' as Header,  BrandTotalUse as UserData FROM cte2 where BrandTotalUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''BrandTotalUsePercent'' as Header,  BrandTotalUsePercent as UserData FROM cte2 where BrandTotalUsePercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''BrandUniquePlayerUse'' as Header,  BrandUniquePlayerUse as UserData FROM cte2 where BrandUniquePlayerUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''BrandUniquePlayerUsePercent'' as Header,  BrandUniquePlayerUsePercent as UserData FROM cte2 where BrandUniquePlayerUsePercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''MoneyWon'' as Header,  MoneyWon as UserData FROM cte2 where MoneyWon > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''MoneyYTDPercent'' as Header,  MoneyWonPercent as UserData FROM cte2 where MoneyWonPercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSRankTop10'' as Header,  DSRankTop10 as UserData FROM cte2 where DSRankTop10 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSRankTop25'' as Header,  DSRankTop25 as UserData FROM cte2 where DSRankTop25 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSRank26to50'' as Header,  DSRank26to50 as UserData FROM cte2 where DSRank26to50 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSRank51to100'' as Header,  DSRank51to100 as UserData FROM cte2 where DSRank51to100 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSRank101to150'' as Header,  DSRank101to150 as UserData FROM cte2 where DSRank101to150 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSRank151to200'' as Header,  DSRank151to200 as UserData FROM cte2 where DSRank151to200 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSRank201Plus'' as Header,  DSRank201Plus as UserData FROM cte2 where DSRank201Plus > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''TournamentsTop10'' as Header,  TournamentsTop10 as UserData FROM cte2 where TournamentsTop10 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''TournamentsWon'' as Header,  TournamentsWon as UserData FROM cte2 where TournamentsWon > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''TournamentsTop10Percent'' as Header,  TournamentsTop10Percent as UserData FROM cte2 where TournamentsTop10Percent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''TournamentsWonPercent'' as Header,  TournamentsWonPercent as UserData FROM cte2 where TournamentsWonPercent > 0




;with cte1 as (select * from (select ''' + @Equip3 + ''' as Equipment, PGASeason, BRAND, DSPoints, DSPointsPercent / 100.0 as DSPointsPercent 
				FROM [MoneyBall].[WebsiteData6] where [SportTourId] = ' + cast(@SportTourId as varchar(4)) + ' and PGASeason = ' + cast(@PGASeason as varchar(4)) + ') a 
				where brand in (select distinct Brand from MoneyBall.WebsiteDataPlayerTourEquipment where [SportTourId] = ' + cast(@SportTourId as varchar(4)) + ' and PGASeason = ' + cast(@PGASeason as varchar(4)) + '))

insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)

Select Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSPoints'' as Header, DSPoints as UserData from cte1 where DSPoints > 0 union all
Select Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSPointsPercent'' as Header, DSPointsPercent as UserData from cte1 where DSPoints > 0


;with cte1 as (select ''' + @Equip3 + ''' as Equipment, PGASeason, BRAND, Sum(DSPoints) * 1.0 / sum(sum(DSPoints)) over(Partition by PGASeason) as DSPointsPercent 
				FROM [MoneyBall].[WebsiteData6] where PGASeason = ' + cast(@PGASeason as varchar(4)) + ' and [SportTourId] = ' + cast(@SportTourId as varchar(4)) + ' and
				brand in (select distinct Brand from MoneyBall.WebsiteDataPlayerTourEquipment
							where [SportTourId] = ' + cast(@SportTourId as varchar(4)) + ' and PGASeason = ' + cast(@PGASeason as varchar(4)) + ' and Equipment = ''' + @Equip3 + ''')
				group by [PGASeason], [BRAND])

insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)
Select Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSPointsEquipmentPercent'' as Header, DSPointsPercent as UserData from cte1'


--Majors----------------------------------------------------------------

set @sqltext2 = '

;with cte1 as (select b.PGASeason, b.PLAYERNAME, case when b.brand = ''FOOT Joy'' then ''FOOTJOY'' else b.Brand end as brand, ms.[Official Money],
				case when ms.[Finish Position] between 1 and 10 then ms.[Finish Position] else null end as TournamentsTop10,
				case when ms.[Finish Position] = 1 then 1 else null end as TournamentsWon
				from [DARRELL_MASTER].[dbo].[' + @Equip1 + '] b 
				inner join [DARRELL_MASTER].Money.TourMoneyStats ms
				on b.PLAYERNAME = ms.[PLAYER NAME] and b.TournamentId = ms.TournamentId
				left outer join [MoneyBall].[PlayerRank] pr on
				b.PLAYERNAME = pr.PlayerName and b.PGASeason = pr.PGASeason
				Where b.PGASeason = ' + cast(@PGASeason as varchar(4)) + ' and pr.SportTourId = ' + cast(@SportTourId as varchar(4)) + ' and Tour = ''' + @Tour + ''' ' + @Where + ' and SID in (26,351,353,355)),

cte2 as (SELECT ''' + @Equip3 + ''' as Equipment, cte1.[PGASeason]
      ,cte1.[BRAND]
      ,COUNT(*) as BrandTotalUse
	  ,COUNT(*) * 1.0 / sum(COUNT(*)) over (partition by cte1.[PGASeason]) as BrandTotalUsePercent
      ,COUNT(distinct PlayerName) as BrandUniquePlayerUse
	  ,COUNT(distinct PlayerName) * 1.0 / sum(COUNT(distinct PlayerName)) over(partition by cte1.[PGASeason]) as BrandUniquePlayerUsePercent
      ,sum([Official Money]) as MoneyWon
	  ,sum([Official Money]) * 1.0 / sum(sum([Official Money])) over (partition by cte1.[PGASeason]) as MoneyWonPercent
	  ,count(TournamentsTop10) as TournamentsTop10
	  ,count(TournamentsWon) as TournamentsWon
	  ,count(TournamentsTop10) / (10.0 * YearlyEvents) as TournamentsTop10Percent
	  ,count(TournamentsWon) * 1.0 / YearlyEvents as TournamentsWonPercent
FROM cte1
inner join (select count(distinct TournamentId) as YearlyEvents, PGASeason from [TV].[TVAudit] where Tour = ''' + @Tour + ''' and TntNid  in (26,351,353,355) group by PGASeason) t on cte1.PGASeason = t.PGASeason
group by cte1.[PGASeason], cte1.[BRAND], YearlyEvents)



insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)
 
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''BrandTotalUse'' as Header,  BrandTotalUse as UserData FROM cte2 where BrandTotalUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''BrandTotalUsePercent'' as Header,  BrandTotalUsePercent as UserData FROM cte2 where BrandTotalUsePercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''BrandUniquePlayerUse'' as Header,  BrandUniquePlayerUse as UserData FROM cte2 where BrandUniquePlayerUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''BrandUniquePlayerUsePercent'' as Header,  BrandUniquePlayerUsePercent as UserData FROM cte2 where BrandUniquePlayerUsePercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''MoneyWon'' as Header,  MoneyWon as UserData FROM cte2 where MoneyWon > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''MoneyWonPercent'' as Header,  MoneyWonPercent as UserData FROM cte2 where MoneyWonPercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''TournamentsTop10'' as Header,  TournamentsTop10 as UserData FROM cte2 where TournamentsTop10 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''TournamentsWon'' as Header,  TournamentsWon as UserData FROM cte2 where TournamentsWon > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''TournamentsTop10Percent'' as Header,  TournamentsTop10Percent as UserData FROM cte2 where TournamentsTop10Percent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''TournamentsWonPercent'' as Header,  TournamentsWonPercent as UserData FROM cte2 where TournamentsWonPercent > 0

;with cte1 as (select * from (select ''' + @Equip3 + ''' as Equipment, PGASeason, BRAND, DSPoints, DSPointsPercent / 100.0 as DSPointsPercent 
				FROM [MoneyBall].[WebsiteData6] where [SportTourId] = 58 and PGASeason = ' + cast(@PGASeason as varchar(4)) + ') a 
				where brand in (select distinct Brand from MoneyBall.WebsiteDataPlayerTourEquipment where [SportTourId] = 58 and PGASeason = ' + cast(@PGASeason as varchar(4)) + '))

insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)

Select Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''DSPoints'' as Header, DSPoints as UserData from cte1 where DSPoints > 0 union all
Select Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''DSPointsPercent'' as Header, DSPointsPercent as UserData from cte1 where DSPoints > 0



;with cte1 as (select ''' + @Equip3 + ''' as Equipment, PGASeason, BRAND, Sum(DSPoints) * 1.0 / sum(sum(DSPoints)) over(Partition by PGASeason) as DSPointsPercent 
				FROM [MoneyBall].[WebsiteData6] where PGASeason = ' + cast(@PGASeason as varchar(4)) + ' and [SportTourId] = 58 and
				brand in (select distinct Brand from MoneyBall.WebsiteDataPlayerTourEquipment
							where [SportTourId] = 58 and PGASeason = ' + cast(@PGASeason as varchar(4)) + ' and Equipment = ''' + @Equip3 + ''')
				group by [PGASeason], [BRAND])

insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)
Select Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''DSPointsEquipmentPercent'' as Header, DSPointsPercent as UserData from cte1'



--Amateurs-----------------------------------------------------------

set @sqltext3 = '

--NCAAMensChamp

;with cte1 as (select year([first Day]) as PGASeason, b.PLAYERNAME, case when b.brand = ''FOOT Joy'' then ''FOOTJOY'' else b.Brand end as brand
				from [DARRELL_MASTER].[dbo].[' + @Equip1 + '] b 
				Where year([first Day]) = ' + cast(@PGASeason as varchar(4)) + ' ' + @Where + ' and SID = 423),

cte2 as (SELECT ''' + @Equip3 + ''' as Equipment, cte1.[PGASeason]
      ,cte1.[BRAND]
      ,COUNT(*) as BrandTotalUse
	  ,COUNT(*) * 1.0 / sum(COUNT(*)) over (partition by cte1.[PGASeason]) as BrandTotalUsePercent
      ,COUNT(distinct PlayerName) as BrandUniquePlayerUse
	  ,COUNT(distinct PlayerName) * 1.0 / sum(COUNT(distinct PlayerName)) over(partition by cte1.[PGASeason]) as BrandUniquePlayerUsePercent
FROM cte1
group by cte1.[PGASeason], cte1.[BRAND])



insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)
 
SELECT Equipment, [PGASeason], [BRAND], ''NCAA'' as DataBlock, ''BrandTotalUse'' as Header,  BrandTotalUse as UserData FROM cte2 where BrandTotalUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''NCAA'' as DataBlock, ''BrandTotalUsePercent'' as Header,  BrandTotalUsePercent as UserData FROM cte2 where BrandTotalUsePercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''NCAA'' as DataBlock, ''BrandUniquePlayerUse'' as Header,  BrandUniquePlayerUse as UserData FROM cte2 where BrandUniquePlayerUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''NCAA'' as DataBlock, ''BrandUniquePlayerUsePercent'' as Header,  BrandUniquePlayerUsePercent as UserData FROM cte2 where BrandUniquePlayerUsePercent > 0



--US Am

;with cte1 as (select year([first Day]) as PGASeason, b.PLAYERNAME, case when b.brand = ''FOOT Joy'' then ''FOOTJOY'' else b.Brand end as brand
				from [DARRELL_MASTER].[dbo].[' + @Equip1 + '] b 
				Where year([first Day]) = ' + cast(@PGASeason as varchar(4)) + ' ' + @Where + ' and SID in (415,411,418,316,414,995,374)),

cte2 as (SELECT ''' + @Equip3 + ''' as Equipment, cte1.[PGASeason]
      ,cte1.[BRAND]
      ,COUNT(*) as BrandTotalUse
	  ,COUNT(*) * 1.0 / sum(COUNT(*)) over (partition by cte1.[PGASeason]) as BrandTotalUsePercent
      ,COUNT(distinct PlayerName) as BrandUniquePlayerUse
	  ,COUNT(distinct PlayerName) * 1.0 / sum(COUNT(distinct PlayerName)) over(partition by cte1.[PGASeason]) as BrandUniquePlayerUsePercent
FROM cte1
group by cte1.[PGASeason], cte1.[BRAND])



insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)
 
SELECT Equipment, [PGASeason], [BRAND], ''Amateur'' as DataBlock, ''BrandTotalUse'' as Header,  BrandTotalUse as UserData FROM cte2 where BrandTotalUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Amateur'' as DataBlock, ''BrandTotalUsePercent'' as Header,  BrandTotalUsePercent as UserData FROM cte2 where BrandTotalUsePercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Amateur'' as DataBlock, ''BrandUniquePlayerUse'' as Header,  BrandUniquePlayerUse as UserData FROM cte2 where BrandUniquePlayerUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Amateur'' as DataBlock, ''BrandUniquePlayerUsePercent'' as Header,  BrandUniquePlayerUsePercent as UserData FROM cte2 where BrandUniquePlayerUsePercent > 0



--Junior Am

;with cte1 as (select year([first Day]) as PGASeason, b.PLAYERNAME, case when b.brand = ''FOOT Joy'' then ''FOOTJOY'' else b.Brand end as brand
				from [DARRELL_MASTER].[dbo].[' + @Equip1 + '] b 
				Where year([first Day]) = ' + cast(@PGASeason as varchar(4)) + ' ' + @Where + ' and SID in (412, 413)),

cte2 as (SELECT ''' + @Equip3 + ''' as Equipment, cte1.[PGASeason]
      ,cte1.[BRAND]
      ,COUNT(*) as BrandTotalUse
	  ,COUNT(*) * 1.0 / sum(COUNT(*)) over (partition by cte1.[PGASeason]) as BrandTotalUsePercent
      ,COUNT(distinct PlayerName) as BrandUniquePlayerUse
	  ,COUNT(distinct PlayerName) * 1.0 / sum(COUNT(distinct PlayerName)) over(partition by cte1.[PGASeason]) as BrandUniquePlayerUsePercent
FROM cte1
group by cte1.[PGASeason], cte1.[BRAND])



insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)
 
SELECT Equipment, [PGASeason], [BRAND], ''JRAmateur'' as DataBlock, ''BrandTotalUse'' as Header,  BrandTotalUse as UserData FROM cte2 where BrandTotalUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''JRAmateur'' as DataBlock, ''BrandTotalUsePercent'' as Header,  BrandTotalUsePercent as UserData FROM cte2 where BrandTotalUsePercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''JRAmateur'' as DataBlock, ''BrandUniquePlayerUse'' as Header,  BrandUniquePlayerUse as UserData FROM cte2 where BrandUniquePlayerUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''JRAmateur'' as DataBlock, ''BrandUniquePlayerUsePercent'' as Header,  BrandUniquePlayerUsePercent as UserData FROM cte2 where BrandUniquePlayerUsePercent > 0
'

------------US Consumer

Set @Sqltext4 = 
'
;with ctebody as (
SELECT p.YEAR, [BRAND],
COUNT(*) as BrandTotal, ' 
if @Equip1 = 'Ball' 
	set @sqltext4 = @sqltext4 + ' CAST(NULL AS INTEGER) ' 
else 
	set @sqltext4 = @sqltext4 + ' sum(case when b.Years < 2 then 1 else 0 end) ' 

set @sqltext4 = @sqltext4 + ' as CountNew,
sum(case when p.HANDICAP < 6 then 1 else 0 end) as h1,
sum(case when p.HANDICAP between 6 and 10 then 1 else 0 end) as h2,
sum(case when p.HANDICAP between 11 and 20 then 1 else 0 end) as h3,
sum(case when p.HANDICAP > 20 then 1 else 0 end) as h4,
sum(case when p.HANDICAP is null then 1 else 0 end) as h5,
sum(case when p.AGE between 1 and 2 then 1 else 0 end) as age1,
sum(case when p.AGE between 3 and 4 then 1 else 0 end) as age2,
sum(case when p.AGE > 4 then 1 else 0 end) as age3

FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equip2) + ' b
inner join Consumer.PlayerProfile p 
on b.PlayerProfileId = p.PlayerProfileId
where not brand is null and p.COUNTRY = ''USA'' and p.YEAR = ' + cast(@PGASeason as varchar(4)) + ' '
+ [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equip2) + '
group by [YEAR], Brand
),

cteTotals as (
select [YEAR], SUM(BrandTotal) as TotalCount,
SUM(CountNew) as AllNewTotal,
SUM(h1) as h1,
SUM(h2) as h2,
SUM(h3) as h3,
SUM(h4) as h4,
SUM(age1) as age1,
SUM(age2) as age2,
SUM(age3) as age3
from ctebody
group by [YEAR]),


cteFinal as (
select ''' + @Equip3 + ''' as Equipment, b.[YEAR], b.Brand, 
	b.BrandTotal * 1.0 / t.TotalCount as BrandPercent,
	b.CountNew * 1.0 / t.AllNewTotal as BrandNewPercent,
	b.h1 * 1.0 / t.h1 as h1,
	b.h2 * 1.0 / t.h2 as h2,
	b.h3 * 1.0 / t.h3 as h3,
	b.h4 * 1.0 / t.h4 as h4,
	b.age1 * 1.0 / t.age1 as age1,
	b.age2 * 1.0 / t.age2 as age2,
	b.age3 * 1.0 / t.age3 as age3
	from ctebody b
	inner join cteTotals t on b.[YEAR] = t.[YEAR]
	inner join (select distinct PGASeason, Brand from [MoneyBall].[WebsiteData14]) a on b.[YEAR] = a.PGASeason and b.Brand = a.brand)
	
	
	insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)

	
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentAll'' as Header, BrandPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentAllNew'' as Header, BrandNewPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentHandicap0to5'' as Header, h1 as UserData from cteFinal where h1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentHandicap6to10'' as Header, h2 as UserData from cteFinal where h2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentHandicap11to20'' as Header, h3 as UserData from cteFinal where h3 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentHandicap21Plus'' as Header, h4 as UserData from cteFinal where h4 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentAgeUnder30'' as Header, age1 as UserData from cteFinal where age1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentAge30to49'' as Header, age2 as UserData from cteFinal where age2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentAge50Plus'' as Header, age3 as UserData from cteFinal where age3 > 0
'

------------Japan COnsumer

Set @Sqltext5 = 
'
;with ctebody as (
SELECT p.YEAR, [BRAND],
COUNT(*) as BrandTotal, ' 
if @Equip1 = 'Ball' 
	set @sqltext5 = @sqltext5 + ' CAST(NULL AS INTEGER) ' 
else 
	set @sqltext5 = @sqltext5 + ' sum(case when b.Years < 2 then 1 else 0 end) ' 

set @sqltext5 = @sqltext5 + ' as CountNew,
sum(case when p.HANDICAP < 6 then 1 else 0 end) as h1,
sum(case when p.HANDICAP between 6 and 10 then 1 else 0 end) as h2,
sum(case when p.HANDICAP between 11 and 20 then 1 else 0 end) as h3,
sum(case when p.HANDICAP > 20 then 1 else 0 end) as h4,
sum(case when p.HANDICAP is null then 1 else 0 end) as h5,
sum(case when p.AGE between 1 and 2 then 1 else 0 end) as age1,
sum(case when p.AGE between 3 and 4 then 1 else 0 end) as age2,
sum(case when p.AGE > 4 then 1 else 0 end) as age3

FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equip2) + ' b
inner join Consumer.PlayerProfile p 
on b.PlayerProfileId = p.PlayerProfileId
where not brand is null and p.COUNTRY = ''Japan'' and p.YEAR = ' + cast(@PGASeason as varchar(4)) + ' '
+ [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equip2) + '
group by [YEAR], Brand
),

cteTotals as (
select [YEAR], SUM(BrandTotal) as TotalCount,
SUM(CountNew) as AllNewTotal,
SUM(h1) as h1,
SUM(h2) as h2,
SUM(h3) as h3,
SUM(h4) as h4,
SUM(age1) as age1,
SUM(age2) as age2,
SUM(age3) as age3
from ctebody
group by [YEAR]),


cteFinal as (
select ''' + @Equip3 + ''' as Equipment, b.[YEAR], b.Brand, 
	b.BrandTotal * 1.0 / t.TotalCount as BrandPercent,
	b.CountNew * 1.0 / t.AllNewTotal as BrandNewPercent,
	b.h1 * 1.0 / t.h1 as h1,
	b.h2 * 1.0 / t.h2 as h2,
	b.h3 * 1.0 / t.h3 as h3,
	b.h4 * 1.0 / t.h4 as h4,
	b.age1 * 1.0 / t.age1 as age1,
	b.age2 * 1.0 / t.age2 as age2,
	b.age3 * 1.0 / t.age3 as age3
	from ctebody b
	inner join cteTotals t on b.[YEAR] = t.[YEAR]
	inner join (select distinct PGASeason, Brand from [MoneyBall].[WebsiteData14]) a on b.[YEAR] = a.PGASeason and b.Brand = a.brand)
	
	
	insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)

	
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentAll'' as Header, BrandPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentAllNew'' as Header, BrandNewPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentHandicap0to5'' as Header, h1 as UserData from cteFinal where h1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentHandicap6to10'' as Header, h2 as UserData from cteFinal where h2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentHandicap11to20'' as Header, h3 as UserData from cteFinal where h3 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentHandicap21Plus'' as Header, h4 as UserData from cteFinal where h4 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentAgeUnder30'' as Header, age1 as UserData from cteFinal where age1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentAge30to49'' as Header, age2 as UserData from cteFinal where age2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentAge50Plus'' as Header, age3 as UserData from cteFinal where age3 > 0
'


------------China COnsumer

Set @Sqltext6 = 
'
;with ctebody as (
SELECT p.YEAR, [BRAND],
COUNT(*) as BrandTotal, ' 
if @Equip1 = 'Ball' 
	set @sqltext6 = @sqltext6 + ' CAST(NULL AS INTEGER) ' 
else 
	set @sqltext6 = @sqltext6 + ' sum(case when b.Years < 2 then 1 else 0 end) ' 

set @sqltext6 = @sqltext6 + ' as CountNew,
sum(case when p.HANDICAP < 6 then 1 else 0 end) as h1,
sum(case when p.HANDICAP between 6 and 10 then 1 else 0 end) as h2,
sum(case when p.HANDICAP between 11 and 20 then 1 else 0 end) as h3,
sum(case when p.HANDICAP > 20 then 1 else 0 end) as h4,
sum(case when p.HANDICAP is null then 1 else 0 end) as h5,
sum(case when p.AGE between 1 and 2 then 1 else 0 end) as age1,
sum(case when p.AGE between 3 and 4 then 1 else 0 end) as age2,
sum(case when p.AGE > 4 then 1 else 0 end) as age3

FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equip2) + ' b
inner join Consumer.PlayerProfile p 
on b.PlayerProfileId = p.PlayerProfileId
where not brand is null and p.COUNTRY = ''China'' and p.YEAR = ' + cast(@PGASeason as varchar(4)) + ' '
+ [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equip2) + '
group by [YEAR], Brand
),

cteTotals as (
select [YEAR], SUM(BrandTotal) as TotalCount,
SUM(CountNew) as AllNewTotal,
SUM(h1) as h1,
SUM(h2) as h2,
SUM(h3) as h3,
SUM(h4) as h4,
SUM(age1) as age1,
SUM(age2) as age2,
SUM(age3) as age3
from ctebody
group by [YEAR]),


cteFinal as (
select ''' + @Equip3 + ''' as Equipment, b.[YEAR], b.Brand, 
	b.BrandTotal * 1.0 / t.TotalCount as BrandPercent,
	b.CountNew * 1.0 / t.AllNewTotal as BrandNewPercent,
	b.h1 * 1.0 / t.h1 as h1,
	b.h2 * 1.0 / t.h2 as h2,
	b.h3 * 1.0 / t.h3 as h3,
	b.h4 * 1.0 / t.h4 as h4,
	b.age1 * 1.0 / t.age1 as age1,
	b.age2 * 1.0 / t.age2 as age2,
	b.age3 * 1.0 / t.age3 as age3
	from ctebody b
	inner join cteTotals t on b.[YEAR] = t.[YEAR]
	inner join (select distinct PGASeason, Brand from [MoneyBall].[WebsiteData14]) a on b.[YEAR] = a.PGASeason and b.Brand = a.brand)
	
	
	insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)

	
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentAll'' as Header, BrandPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentAllNew'' as Header, BrandNewPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentHandicap0to5'' as Header, h1 as UserData from cteFinal where h1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentHandicap6to10'' as Header, h2 as UserData from cteFinal where h2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentHandicap11to20'' as Header, h3 as UserData from cteFinal where h3 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentHandicap21Plus'' as Header, h4 as UserData from cteFinal where h4 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentAgeUnder30'' as Header, age1 as UserData from cteFinal where age1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentAge30to49'' as Header, age2 as UserData from cteFinal where age2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentAge50Plus'' as Header, age3 as UserData from cteFinal where age3 > 0
'




------------SEA COnsumer

Set @Sqltext7 = 
'
;with ctebody as (
SELECT p.YEAR, [BRAND],
COUNT(*) as BrandTotal, ' 
if @Equip1 = 'Ball' 
	set @sqltext7 = @sqltext7 + ' CAST(NULL AS INTEGER) ' 
else 
	set @sqltext7 = @sqltext7 + ' sum(case when b.Years < 2 then 1 else 0 end) ' 

set @sqltext7 = @sqltext7 + ' as CountNew,
sum(case when p.HANDICAP < 6 then 1 else 0 end) as h1,
sum(case when p.HANDICAP between 6 and 10 then 1 else 0 end) as h2,
sum(case when p.HANDICAP between 11 and 20 then 1 else 0 end) as h3,
sum(case when p.HANDICAP > 20 then 1 else 0 end) as h4,
sum(case when p.HANDICAP is null then 1 else 0 end) as h5,
sum(case when p.AGE between 1 and 2 then 1 else 0 end) as age1,
sum(case when p.AGE between 3 and 4 then 1 else 0 end) as age2,
sum(case when p.AGE > 4 then 1 else 0 end) as age3

FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equip2) + ' b
inner join Consumer.PlayerProfile p 
on b.PlayerProfileId = p.PlayerProfileId
where not brand is null and p.COUNTRY in (''Singapore'',''Thailand'',''Malaysia'',''Indonesia'')  and p.YEAR = ' + cast(@PGASeason as varchar(4)) + ' '
+ [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equip2) + '
group by [YEAR], Brand
),

cteTotals as (
select [YEAR], SUM(BrandTotal) as TotalCount,
SUM(CountNew) as AllNewTotal,
SUM(h1) as h1,
SUM(h2) as h2,
SUM(h3) as h3,
SUM(h4) as h4,
SUM(age1) as age1,
SUM(age2) as age2,
SUM(age3) as age3
from ctebody
group by [YEAR]),


cteFinal as (
select ''' + @Equip3 + ''' as Equipment, b.[YEAR], b.Brand, 
	b.BrandTotal * 1.0 / t.TotalCount as BrandPercent,
	b.CountNew * 1.0 / t.AllNewTotal as BrandNewPercent,
	b.h1 * 1.0 / t.h1 as h1,
	b.h2 * 1.0 / t.h2 as h2,
	b.h3 * 1.0 / t.h3 as h3,
	b.h4 * 1.0 / t.h4 as h4,
	b.age1 * 1.0 / t.age1 as age1,
	b.age2 * 1.0 / t.age2 as age2,
	b.age3 * 1.0 / t.age3 as age3
	from ctebody b
	inner join cteTotals t on b.[YEAR] = t.[YEAR]
	inner join (select distinct PGASeason, Brand from [MoneyBall].[WebsiteData14]) a on b.[YEAR] = a.PGASeason and b.Brand = a.brand)
	
	
	insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)

	
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentAll'' as Header, BrandPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentAllNew'' as Header, BrandNewPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentHandicap0to5'' as Header, h1 as UserData from cteFinal where h1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentHandicap6to10'' as Header, h2 as UserData from cteFinal where h2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentHandicap11to20'' as Header, h3 as UserData from cteFinal where h3 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentHandicap21Plus'' as Header, h4 as UserData from cteFinal where h4 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentAgeUnder30'' as Header, age1 as UserData from cteFinal where age1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentAge30to49'' as Header, age2 as UserData from cteFinal where age2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentAge50Plus'' as Header, age3 as UserData from cteFinal where age3 > 0
'

exec (@sqltext1 + @sqltext2 + @sqltext3 + @sqltext4 + @sqltext5 + @sqltext6 + @sqltext7)






set @Equip1 = 'Putters'
set @Equip2 = 'Putter'
set @Equip3 = 'Putter'
set @Where = ' '


set @sqltext1 = '

;with cte1 as (select b.PGASeason, b.PLAYERNAME, case when b.brand = ''FOOT Joy'' then ''FOOTJOY'' else b.Brand end as brand, ms.[Official Money],
				case when pr.DSRank < 11 then b.PLAYERNAME else null end as DSRankTop10,
			    case when pr.DSRank < 26 then b.PLAYERNAME else null end as DSRankTop25,
			    case when pr.DSRank between 26 and 50 then b.PLAYERNAME else null end as DSRank26to50,
			    case when pr.DSRank between 51 and 100 then b.PLAYERNAME else null end as DSRank51to100,
			    case when pr.DSRank between 101 and 150 then b.PLAYERNAME else null end as DSRank101to150,
			    case when pr.DSRank between 151 and 200 then b.PLAYERNAME else null end as DSRank151to200,
			    case when pr.DSRank > 200 then b.PLAYERNAME else null end as DSRank201Plus,
				case when ms.[Finish Position] between 1 and 10 then ms.[Finish Position] else null end as TournamentsTop10,
				case when ms.[Finish Position] = 1 then 1 else null end as TournamentsWon
				from [DARRELL_MASTER].[dbo].[' + @Equip1 + '] b 
				inner join [DARRELL_MASTER].Money.TourMoneyStats ms
				on b.PLAYERNAME = ms.[PLAYER NAME] and b.TournamentId = ms.TournamentId
				left outer join [MoneyBall].[PlayerRank] pr on
				b.PLAYERNAME = pr.PlayerName and b.PGASeason = pr.PGASeason
				Where b.PGASeason = ' + cast(@PGASeason as varchar(4)) + ' and pr.SportTourId = ' + cast(@SportTourId as varchar(4)) + ' and Tour = ''' + @Tour + ''' ' + @Where + '),

cte2 as (SELECT ''' + @Equip3 + ''' as Equipment, cte1.[PGASeason]
      ,cte1.[BRAND]
      ,COUNT(*) as BrandTotalUse
	  ,COUNT(*) * 1.0 / sum(COUNT(*)) over (partition by cte1.[PGASeason]) as BrandTotalUsePercent
      ,COUNT(distinct PlayerName) as BrandUniquePlayerUse
	  ,COUNT(distinct PlayerName) * 1.0 / sum(COUNT(distinct PlayerName)) over(partition by cte1.[PGASeason]) as BrandUniquePlayerUsePercent
      ,sum([Official Money]) as MoneyWon
	  ,sum([Official Money]) * 1.0 / sum(sum([Official Money])) over (partition by cte1.[PGASeason]) as MoneyWonPercent
	  ,count(distinct DSRankTop10) / 10.0 as DSRankTop10
	  ,count(distinct DSRankTop25)  / 25.0 as DSRankTop25
	  ,count(distinct DSRank26to50)  / 25.0 as DSRank26to50
	  ,count(distinct DSRank51to100)  / 50.0 as DSRank51to100
	  ,count(distinct DSRank101to150)  / 50.0 as DSRank101to150
	  ,count(distinct DSRank151to200)  / 50.0 as DSRank151to200
	  ,count(distinct DSRank201Plus)  / nullif((select count(distinct DSRank201Plus) from cte1),0) as DSRank201Plus
	  ,count(TournamentsTop10) as TournamentsTop10
	  ,count(TournamentsWon) as TournamentsWon
	  ,count(TournamentsTop10) / (10.0 * YearlyEvents) as TournamentsTop10Percent
	  ,count(TournamentsWon) * 1.0 / YearlyEvents as TournamentsWonPercent
FROM cte1
inner join (select count(distinct TournamentId) as YearlyEvents, PGASeason from [TV].[TVAudit] where Tour = ''' + @Tour + ''' group by PGASeason) t on cte1.PGASeason = t.PGASeason
group by cte1.[PGASeason], cte1.[BRAND], YearlyEvents)



insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)
 
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''BrandTotalUse'' as Header,  BrandTotalUse as UserData FROM cte2 where BrandTotalUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''BrandTotalUsePercent'' as Header,  BrandTotalUsePercent as UserData FROM cte2 where BrandTotalUsePercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''BrandUniquePlayerUse'' as Header,  BrandUniquePlayerUse as UserData FROM cte2 where BrandUniquePlayerUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''BrandUniquePlayerUsePercent'' as Header,  BrandUniquePlayerUsePercent as UserData FROM cte2 where BrandUniquePlayerUsePercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''MoneyWon'' as Header,  MoneyWon as UserData FROM cte2 where MoneyWon > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''MoneyYTDPercent'' as Header,  MoneyWonPercent as UserData FROM cte2 where MoneyWonPercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSRankTop10'' as Header,  DSRankTop10 as UserData FROM cte2 where DSRankTop10 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSRankTop25'' as Header,  DSRankTop25 as UserData FROM cte2 where DSRankTop25 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSRank26to50'' as Header,  DSRank26to50 as UserData FROM cte2 where DSRank26to50 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSRank51to100'' as Header,  DSRank51to100 as UserData FROM cte2 where DSRank51to100 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSRank101to150'' as Header,  DSRank101to150 as UserData FROM cte2 where DSRank101to150 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSRank151to200'' as Header,  DSRank151to200 as UserData FROM cte2 where DSRank151to200 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSRank201Plus'' as Header,  DSRank201Plus as UserData FROM cte2 where DSRank201Plus > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''TournamentsTop10'' as Header,  TournamentsTop10 as UserData FROM cte2 where TournamentsTop10 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''TournamentsWon'' as Header,  TournamentsWon as UserData FROM cte2 where TournamentsWon > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''TournamentsTop10Percent'' as Header,  TournamentsTop10Percent as UserData FROM cte2 where TournamentsTop10Percent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Tour'' as DataBlock, ''TournamentsWonPercent'' as Header,  TournamentsWonPercent as UserData FROM cte2 where TournamentsWonPercent > 0




;with cte1 as (select * from (select ''' + @Equip3 + ''' as Equipment, PGASeason, BRAND, DSPoints, DSPointsPercent / 100.0 as DSPointsPercent 
				FROM [MoneyBall].[WebsiteData6] where [SportTourId] = ' + cast(@SportTourId as varchar(4)) + ' and PGASeason = ' + cast(@PGASeason as varchar(4)) + ') a 
				where brand in (select distinct Brand from MoneyBall.WebsiteDataPlayerTourEquipment where [SportTourId] = ' + cast(@SportTourId as varchar(4)) + ' and PGASeason = ' + cast(@PGASeason as varchar(4)) + '))

insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)

Select Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSPoints'' as Header, DSPoints as UserData from cte1 where DSPoints > 0 union all
Select Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSPointsPercent'' as Header, DSPointsPercent as UserData from cte1 where DSPoints > 0


;with cte1 as (select ''' + @Equip3 + ''' as Equipment, PGASeason, BRAND, Sum(DSPoints) * 1.0 / sum(sum(DSPoints)) over(Partition by PGASeason) as DSPointsPercent 
				FROM [MoneyBall].[WebsiteData6] where PGASeason = ' + cast(@PGASeason as varchar(4)) + ' and [SportTourId] = ' + cast(@SportTourId as varchar(4)) + ' and
				brand in (select distinct Brand from MoneyBall.WebsiteDataPlayerTourEquipment 
							where [SportTourId] = ' + cast(@SportTourId as varchar(4)) + ' and PGASeason = ' + cast(@PGASeason as varchar(4)) + ' and Equipment = ''' + @Equip3 + ''')
				group by [PGASeason], [BRAND])

insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)
Select Equipment, [PGASeason], [BRAND], ''TV'' as DataBlock, ''DSPointsEquipmentPercent'' as Header, DSPointsPercent as UserData from cte1'


--Majors----------------------------------------------------------------

set @sqltext2 = '

;with cte1 as (select b.PGASeason, b.PLAYERNAME, case when b.brand = ''FOOT Joy'' then ''FOOTJOY'' else b.Brand end as brand, ms.[Official Money],
				case when ms.[Finish Position] between 1 and 10 then ms.[Finish Position] else null end as TournamentsTop10,
				case when ms.[Finish Position] = 1 then 1 else null end as TournamentsWon
				from [DARRELL_MASTER].[dbo].[' + @Equip1 + '] b 
				inner join [DARRELL_MASTER].Money.TourMoneyStats ms
				on b.PLAYERNAME = ms.[PLAYER NAME] and b.TournamentId = ms.TournamentId
				left outer join [MoneyBall].[PlayerRank] pr on
				b.PLAYERNAME = pr.PlayerName and b.PGASeason = pr.PGASeason
				Where b.PGASeason = ' + cast(@PGASeason as varchar(4)) + ' and pr.SportTourId = ' + cast(@SportTourId as varchar(4)) + ' and Tour = ''' + @Tour + ''' ' + @Where + ' and SID in (26,351,353,355)),

cte2 as (SELECT ''' + @Equip3 + ''' as Equipment, cte1.[PGASeason]
      ,cte1.[BRAND]
      ,COUNT(*) as BrandTotalUse
	  ,COUNT(*) * 1.0 / sum(COUNT(*)) over (partition by cte1.[PGASeason]) as BrandTotalUsePercent
      ,COUNT(distinct PlayerName) as BrandUniquePlayerUse
	  ,COUNT(distinct PlayerName) * 1.0 / sum(COUNT(distinct PlayerName)) over(partition by cte1.[PGASeason]) as BrandUniquePlayerUsePercent
      ,sum([Official Money]) as MoneyWon
	  ,sum([Official Money]) * 1.0 / sum(sum([Official Money])) over (partition by cte1.[PGASeason]) as MoneyWonPercent
	  ,count(TournamentsTop10) as TournamentsTop10
	  ,count(TournamentsWon) as TournamentsWon
	  ,count(TournamentsTop10) / (10.0 * YearlyEvents) as TournamentsTop10Percent
	  ,count(TournamentsWon) * 1.0 / YearlyEvents as TournamentsWonPercent
FROM cte1
inner join (select count(distinct TournamentId) as YearlyEvents, PGASeason from [TV].[TVAudit] where Tour = ''' + @Tour + ''' and TntNid  in (26,351,353,355) group by PGASeason) t on cte1.PGASeason = t.PGASeason
group by cte1.[PGASeason], cte1.[BRAND], YearlyEvents)



insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)
 
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''BrandTotalUse'' as Header,  BrandTotalUse as UserData FROM cte2 where BrandTotalUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''BrandTotalUsePercent'' as Header,  BrandTotalUsePercent as UserData FROM cte2 where BrandTotalUsePercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''BrandUniquePlayerUse'' as Header,  BrandUniquePlayerUse as UserData FROM cte2 where BrandUniquePlayerUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''BrandUniquePlayerUsePercent'' as Header,  BrandUniquePlayerUsePercent as UserData FROM cte2 where BrandUniquePlayerUsePercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''MoneyWon'' as Header,  MoneyWon as UserData FROM cte2 where MoneyWon > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''MoneyWonPercent'' as Header,  MoneyWonPercent as UserData FROM cte2 where MoneyWonPercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''TournamentsTop10'' as Header,  TournamentsTop10 as UserData FROM cte2 where TournamentsTop10 > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''TournamentsWon'' as Header,  TournamentsWon as UserData FROM cte2 where TournamentsWon > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''TournamentsTop10Percent'' as Header,  TournamentsTop10Percent as UserData FROM cte2 where TournamentsTop10Percent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''TournamentsWonPercent'' as Header,  TournamentsWonPercent as UserData FROM cte2 where TournamentsWonPercent > 0

;with cte1 as (select * from (select ''' + @Equip3 + ''' as Equipment, PGASeason, BRAND, DSPoints, DSPointsPercent / 100.0 as DSPointsPercent 
				FROM [MoneyBall].[WebsiteData6] where [SportTourId] = 58 and PGASeason = ' + cast(@PGASeason as varchar(4)) + ') a 
				where brand in (select distinct Brand from MoneyBall.WebsiteDataPlayerTourEquipment where [SportTourId] = 58 and PGASeason = ' + cast(@PGASeason as varchar(4)) + '))

insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)

Select Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''DSPoints'' as Header, DSPoints as UserData from cte1 where DSPoints > 0 union all
Select Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''DSPointsPercent'' as Header, DSPointsPercent as UserData from cte1 where DSPoints > 0



;with cte1 as (select ''' + @Equip3 + ''' as Equipment, PGASeason, BRAND, Sum(DSPoints) * 1.0 / sum(sum(DSPoints)) over(Partition by PGASeason) as DSPointsPercent 
				FROM [MoneyBall].[WebsiteData6] where PGASeason = ' + cast(@PGASeason as varchar(4)) + ' and [SportTourId] = 58 and
				brand in (select distinct Brand from MoneyBall.WebsiteDataPlayerTourEquipment
							where [SportTourId] = 58 and PGASeason = ' + cast(@PGASeason as varchar(4)) + ' and Equipment = ''' + @Equip3 + ''')
				group by [PGASeason], [BRAND])

insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)
Select Equipment, [PGASeason], [BRAND], ''Majors'' as DataBlock, ''DSPointsEquipmentPercent'' as Header, DSPointsPercent as UserData from cte1'



--Amateurs-----------------------------------------------------------

set @sqltext3 = '

--NCAAMensChamp

;with cte1 as (select year([first Day]) as PGASeason, b.PLAYERNAME, case when b.brand = ''FOOT Joy'' then ''FOOTJOY'' else b.Brand end as brand
				from [DARRELL_MASTER].[dbo].[' + @Equip1 + '] b 
				Where year([first Day]) = ' + cast(@PGASeason as varchar(4)) + ' ' + @Where + ' and SID = 423),

cte2 as (SELECT ''' + @Equip3 + ''' as Equipment, cte1.[PGASeason]
      ,cte1.[BRAND]
      ,COUNT(*) as BrandTotalUse
	  ,COUNT(*) * 1.0 / sum(COUNT(*)) over (partition by cte1.[PGASeason]) as BrandTotalUsePercent
      ,COUNT(distinct PlayerName) as BrandUniquePlayerUse
	  ,COUNT(distinct PlayerName) * 1.0 / sum(COUNT(distinct PlayerName)) over(partition by cte1.[PGASeason]) as BrandUniquePlayerUsePercent
FROM cte1
group by cte1.[PGASeason], cte1.[BRAND])



insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)
 
SELECT Equipment, [PGASeason], [BRAND], ''NCAA'' as DataBlock, ''BrandTotalUse'' as Header,  BrandTotalUse as UserData FROM cte2 where BrandTotalUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''NCAA'' as DataBlock, ''BrandTotalUsePercent'' as Header,  BrandTotalUsePercent as UserData FROM cte2 where BrandTotalUsePercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''NCAA'' as DataBlock, ''BrandUniquePlayerUse'' as Header,  BrandUniquePlayerUse as UserData FROM cte2 where BrandUniquePlayerUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''NCAA'' as DataBlock, ''BrandUniquePlayerUsePercent'' as Header,  BrandUniquePlayerUsePercent as UserData FROM cte2 where BrandUniquePlayerUsePercent > 0



--US Am

;with cte1 as (select year([first Day]) as PGASeason, b.PLAYERNAME, case when b.brand = ''FOOT Joy'' then ''FOOTJOY'' else b.Brand end as brand
				from [DARRELL_MASTER].[dbo].[' + @Equip1 + '] b 
				Where year([first Day]) = ' + cast(@PGASeason as varchar(4)) + ' ' + @Where + ' and SID in (415,411,418,316,414,995,374)),

cte2 as (SELECT ''' + @Equip3 + ''' as Equipment, cte1.[PGASeason]
      ,cte1.[BRAND]
      ,COUNT(*) as BrandTotalUse
	  ,COUNT(*) * 1.0 / sum(COUNT(*)) over (partition by cte1.[PGASeason]) as BrandTotalUsePercent
      ,COUNT(distinct PlayerName) as BrandUniquePlayerUse
	  ,COUNT(distinct PlayerName) * 1.0 / sum(COUNT(distinct PlayerName)) over(partition by cte1.[PGASeason]) as BrandUniquePlayerUsePercent
FROM cte1
group by cte1.[PGASeason], cte1.[BRAND])



insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)
 
SELECT Equipment, [PGASeason], [BRAND], ''Amateur'' as DataBlock, ''BrandTotalUse'' as Header,  BrandTotalUse as UserData FROM cte2 where BrandTotalUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Amateur'' as DataBlock, ''BrandTotalUsePercent'' as Header,  BrandTotalUsePercent as UserData FROM cte2 where BrandTotalUsePercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Amateur'' as DataBlock, ''BrandUniquePlayerUse'' as Header,  BrandUniquePlayerUse as UserData FROM cte2 where BrandUniquePlayerUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''Amateur'' as DataBlock, ''BrandUniquePlayerUsePercent'' as Header,  BrandUniquePlayerUsePercent as UserData FROM cte2 where BrandUniquePlayerUsePercent > 0



--Junior Am

;with cte1 as (select year([first Day]) as PGASeason, b.PLAYERNAME, case when b.brand = ''FOOT Joy'' then ''FOOTJOY'' else b.Brand end as brand
				from [DARRELL_MASTER].[dbo].[' + @Equip1 + '] b 
				Where year([first Day]) = ' + cast(@PGASeason as varchar(4)) + ' ' + @Where + ' and SID in (412, 413)),

cte2 as (SELECT ''' + @Equip3 + ''' as Equipment, cte1.[PGASeason]
      ,cte1.[BRAND]
      ,COUNT(*) as BrandTotalUse
	  ,COUNT(*) * 1.0 / sum(COUNT(*)) over (partition by cte1.[PGASeason]) as BrandTotalUsePercent
      ,COUNT(distinct PlayerName) as BrandUniquePlayerUse
	  ,COUNT(distinct PlayerName) * 1.0 / sum(COUNT(distinct PlayerName)) over(partition by cte1.[PGASeason]) as BrandUniquePlayerUsePercent
FROM cte1
group by cte1.[PGASeason], cte1.[BRAND])



insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)
 
SELECT Equipment, [PGASeason], [BRAND], ''JRAmateur'' as DataBlock, ''BrandTotalUse'' as Header,  BrandTotalUse as UserData FROM cte2 where BrandTotalUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''JRAmateur'' as DataBlock, ''BrandTotalUsePercent'' as Header,  BrandTotalUsePercent as UserData FROM cte2 where BrandTotalUsePercent > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''JRAmateur'' as DataBlock, ''BrandUniquePlayerUse'' as Header,  BrandUniquePlayerUse as UserData FROM cte2 where BrandUniquePlayerUse > 0 union all
SELECT Equipment, [PGASeason], [BRAND], ''JRAmateur'' as DataBlock, ''BrandUniquePlayerUsePercent'' as Header,  BrandUniquePlayerUsePercent as UserData FROM cte2 where BrandUniquePlayerUsePercent > 0
'

------------US Consumer

Set @Sqltext4 = 
'
;with ctebody as (
SELECT p.YEAR, [BRAND],
COUNT(*) as BrandTotal, ' 
if @Equip1 = 'Ball' 
	set @sqltext4 = @sqltext4 + ' CAST(NULL AS INTEGER) ' 
else 
	set @sqltext4 = @sqltext4 + ' sum(case when b.Years < 2 then 1 else 0 end) ' 

set @sqltext4 = @sqltext4 + ' as CountNew,
sum(case when p.HANDICAP < 6 then 1 else 0 end) as h1,
sum(case when p.HANDICAP between 6 and 10 then 1 else 0 end) as h2,
sum(case when p.HANDICAP between 11 and 20 then 1 else 0 end) as h3,
sum(case when p.HANDICAP > 20 then 1 else 0 end) as h4,
sum(case when p.HANDICAP is null then 1 else 0 end) as h5,
sum(case when p.AGE between 1 and 2 then 1 else 0 end) as age1,
sum(case when p.AGE between 3 and 4 then 1 else 0 end) as age2,
sum(case when p.AGE > 4 then 1 else 0 end) as age3

FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equip2) + ' b
inner join Consumer.PlayerProfile p 
on b.PlayerProfileId = p.PlayerProfileId
where not brand is null and p.COUNTRY = ''USA'' and p.YEAR = ' + cast(@PGASeason as varchar(4)) + ' '
+ [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equip2) + '
group by [YEAR], Brand
),

cteTotals as (
select [YEAR], SUM(BrandTotal) as TotalCount,
SUM(CountNew) as AllNewTotal,
SUM(h1) as h1,
SUM(h2) as h2,
SUM(h3) as h3,
SUM(h4) as h4,
SUM(age1) as age1,
SUM(age2) as age2,
SUM(age3) as age3
from ctebody
group by [YEAR]),


cteFinal as (
select ''' + @Equip3 + ''' as Equipment, b.[YEAR], b.Brand, 
	b.BrandTotal * 1.0 / t.TotalCount as BrandPercent,
	b.CountNew * 1.0 / t.AllNewTotal as BrandNewPercent,
	b.h1 * 1.0 / t.h1 as h1,
	b.h2 * 1.0 / t.h2 as h2,
	b.h3 * 1.0 / t.h3 as h3,
	b.h4 * 1.0 / t.h4 as h4,
	b.age1 * 1.0 / t.age1 as age1,
	b.age2 * 1.0 / t.age2 as age2,
	b.age3 * 1.0 / t.age3 as age3
	from ctebody b
	inner join cteTotals t on b.[YEAR] = t.[YEAR]
	inner join (select distinct PGASeason, Brand from [MoneyBall].[WebsiteData14]) a on b.[YEAR] = a.PGASeason and b.Brand = a.brand)
	
	
	insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)

	
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentAll'' as Header, BrandPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentAllNew'' as Header, BrandNewPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentHandicap0to5'' as Header, h1 as UserData from cteFinal where h1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentHandicap6to10'' as Header, h2 as UserData from cteFinal where h2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentHandicap11to20'' as Header, h3 as UserData from cteFinal where h3 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentHandicap21Plus'' as Header, h4 as UserData from cteFinal where h4 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentAgeUnder30'' as Header, age1 as UserData from cteFinal where age1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentAge30to49'' as Header, age2 as UserData from cteFinal where age2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerUSA'' as DataBlock, ''PercentAge50Plus'' as Header, age3 as UserData from cteFinal where age3 > 0
'

------------Japan COnsumer

Set @Sqltext5 = 
'
;with ctebody as (
SELECT p.YEAR, [BRAND],
COUNT(*) as BrandTotal, ' 
if @Equip1 = 'Ball' 
	set @sqltext5 = @sqltext5 + ' CAST(NULL AS INTEGER) ' 
else 
	set @sqltext5 = @sqltext5 + ' sum(case when b.Years < 2 then 1 else 0 end) ' 

set @sqltext5 = @sqltext5 + ' as CountNew,
sum(case when p.HANDICAP < 6 then 1 else 0 end) as h1,
sum(case when p.HANDICAP between 6 and 10 then 1 else 0 end) as h2,
sum(case when p.HANDICAP between 11 and 20 then 1 else 0 end) as h3,
sum(case when p.HANDICAP > 20 then 1 else 0 end) as h4,
sum(case when p.HANDICAP is null then 1 else 0 end) as h5,
sum(case when p.AGE between 1 and 2 then 1 else 0 end) as age1,
sum(case when p.AGE between 3 and 4 then 1 else 0 end) as age2,
sum(case when p.AGE > 4 then 1 else 0 end) as age3

FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equip2) + ' b
inner join Consumer.PlayerProfile p 
on b.PlayerProfileId = p.PlayerProfileId
where not brand is null and p.COUNTRY = ''Japan'' and p.YEAR = ' + cast(@PGASeason as varchar(4)) + ' '
+ [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equip2) + '
group by [YEAR], Brand
),

cteTotals as (
select [YEAR], SUM(BrandTotal) as TotalCount,
SUM(CountNew) as AllNewTotal,
SUM(h1) as h1,
SUM(h2) as h2,
SUM(h3) as h3,
SUM(h4) as h4,
SUM(age1) as age1,
SUM(age2) as age2,
SUM(age3) as age3
from ctebody
group by [YEAR]),


cteFinal as (
select ''' + @Equip3 + ''' as Equipment, b.[YEAR], b.Brand, 
	b.BrandTotal * 1.0 / t.TotalCount as BrandPercent,
	b.CountNew * 1.0 / t.AllNewTotal as BrandNewPercent,
	b.h1 * 1.0 / t.h1 as h1,
	b.h2 * 1.0 / t.h2 as h2,
	b.h3 * 1.0 / t.h3 as h3,
	b.h4 * 1.0 / t.h4 as h4,
	b.age1 * 1.0 / t.age1 as age1,
	b.age2 * 1.0 / t.age2 as age2,
	b.age3 * 1.0 / t.age3 as age3
	from ctebody b
	inner join cteTotals t on b.[YEAR] = t.[YEAR]
	inner join (select distinct PGASeason, Brand from [MoneyBall].[WebsiteData14]) a on b.[YEAR] = a.PGASeason and b.Brand = a.brand)
	
	
	insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)

	
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentAll'' as Header, BrandPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentAllNew'' as Header, BrandNewPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentHandicap0to5'' as Header, h1 as UserData from cteFinal where h1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentHandicap6to10'' as Header, h2 as UserData from cteFinal where h2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentHandicap11to20'' as Header, h3 as UserData from cteFinal where h3 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentHandicap21Plus'' as Header, h4 as UserData from cteFinal where h4 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentAgeUnder30'' as Header, age1 as UserData from cteFinal where age1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentAge30to49'' as Header, age2 as UserData from cteFinal where age2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerJapan'' as DataBlock, ''PercentAge50Plus'' as Header, age3 as UserData from cteFinal where age3 > 0
'


------------China COnsumer

Set @Sqltext6 = 
'
;with ctebody as (
SELECT p.YEAR, [BRAND],
COUNT(*) as BrandTotal, ' 
if @Equip1 = 'Ball' 
	set @sqltext6 = @sqltext6 + ' CAST(NULL AS INTEGER) ' 
else 
	set @sqltext6 = @sqltext6 + ' sum(case when b.Years < 2 then 1 else 0 end) ' 

set @sqltext6 = @sqltext6 + ' as CountNew,
sum(case when p.HANDICAP < 6 then 1 else 0 end) as h1,
sum(case when p.HANDICAP between 6 and 10 then 1 else 0 end) as h2,
sum(case when p.HANDICAP between 11 and 20 then 1 else 0 end) as h3,
sum(case when p.HANDICAP > 20 then 1 else 0 end) as h4,
sum(case when p.HANDICAP is null then 1 else 0 end) as h5,
sum(case when p.AGE between 1 and 2 then 1 else 0 end) as age1,
sum(case when p.AGE between 3 and 4 then 1 else 0 end) as age2,
sum(case when p.AGE > 4 then 1 else 0 end) as age3

FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equip2) + ' b
inner join Consumer.PlayerProfile p 
on b.PlayerProfileId = p.PlayerProfileId
where not brand is null and p.COUNTRY = ''China'' and p.YEAR = ' + cast(@PGASeason as varchar(4)) + ' '
+ [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equip2) + '
group by [YEAR], Brand
),

cteTotals as (
select [YEAR], SUM(BrandTotal) as TotalCount,
SUM(CountNew) as AllNewTotal,
SUM(h1) as h1,
SUM(h2) as h2,
SUM(h3) as h3,
SUM(h4) as h4,
SUM(age1) as age1,
SUM(age2) as age2,
SUM(age3) as age3
from ctebody
group by [YEAR]),


cteFinal as (
select ''' + @Equip3 + ''' as Equipment, b.[YEAR], b.Brand, 
	b.BrandTotal * 1.0 / t.TotalCount as BrandPercent,
	b.CountNew * 1.0 / t.AllNewTotal as BrandNewPercent,
	b.h1 * 1.0 / t.h1 as h1,
	b.h2 * 1.0 / t.h2 as h2,
	b.h3 * 1.0 / t.h3 as h3,
	b.h4 * 1.0 / t.h4 as h4,
	b.age1 * 1.0 / t.age1 as age1,
	b.age2 * 1.0 / t.age2 as age2,
	b.age3 * 1.0 / t.age3 as age3
	from ctebody b
	inner join cteTotals t on b.[YEAR] = t.[YEAR]
	inner join (select distinct PGASeason, Brand from [MoneyBall].[WebsiteData14]) a on b.[YEAR] = a.PGASeason and b.Brand = a.brand)
	
	
	insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)

	
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentAll'' as Header, BrandPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentAllNew'' as Header, BrandNewPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentHandicap0to5'' as Header, h1 as UserData from cteFinal where h1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentHandicap6to10'' as Header, h2 as UserData from cteFinal where h2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentHandicap11to20'' as Header, h3 as UserData from cteFinal where h3 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentHandicap21Plus'' as Header, h4 as UserData from cteFinal where h4 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentAgeUnder30'' as Header, age1 as UserData from cteFinal where age1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentAge30to49'' as Header, age2 as UserData from cteFinal where age2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerChina'' as DataBlock, ''PercentAge50Plus'' as Header, age3 as UserData from cteFinal where age3 > 0
'




------------SEA COnsumer

Set @Sqltext7 = 
'
;with ctebody as (
SELECT p.YEAR, [BRAND],
COUNT(*) as BrandTotal, ' 
if @Equip1 = 'Ball' 
	set @sqltext7 = @sqltext7 + ' CAST(NULL AS INTEGER) ' 
else 
	set @sqltext7 = @sqltext7 + ' sum(case when b.Years < 2 then 1 else 0 end) ' 

set @sqltext7 = @sqltext7 + ' as CountNew,
sum(case when p.HANDICAP < 6 then 1 else 0 end) as h1,
sum(case when p.HANDICAP between 6 and 10 then 1 else 0 end) as h2,
sum(case when p.HANDICAP between 11 and 20 then 1 else 0 end) as h3,
sum(case when p.HANDICAP > 20 then 1 else 0 end) as h4,
sum(case when p.HANDICAP is null then 1 else 0 end) as h5,
sum(case when p.AGE between 1 and 2 then 1 else 0 end) as age1,
sum(case when p.AGE between 3 and 4 then 1 else 0 end) as age2,
sum(case when p.AGE > 4 then 1 else 0 end) as age3

FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equip2) + ' b
inner join Consumer.PlayerProfile p 
on b.PlayerProfileId = p.PlayerProfileId
where not brand is null and p.COUNTRY in (''Singapore'',''Thailand'',''Malaysia'',''Indonesia'')  and p.YEAR = ' + cast(@PGASeason as varchar(4)) + ' '
+ [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equip2) + '
group by [YEAR], Brand
),

cteTotals as (
select [YEAR], SUM(BrandTotal) as TotalCount,
SUM(CountNew) as AllNewTotal,
SUM(h1) as h1,
SUM(h2) as h2,
SUM(h3) as h3,
SUM(h4) as h4,
SUM(age1) as age1,
SUM(age2) as age2,
SUM(age3) as age3
from ctebody
group by [YEAR]),


cteFinal as (
select ''' + @Equip3 + ''' as Equipment, b.[YEAR], b.Brand, 
	b.BrandTotal * 1.0 / t.TotalCount as BrandPercent,
	b.CountNew * 1.0 / t.AllNewTotal as BrandNewPercent,
	b.h1 * 1.0 / t.h1 as h1,
	b.h2 * 1.0 / t.h2 as h2,
	b.h3 * 1.0 / t.h3 as h3,
	b.h4 * 1.0 / t.h4 as h4,
	b.age1 * 1.0 / t.age1 as age1,
	b.age2 * 1.0 / t.age2 as age2,
	b.age3 * 1.0 / t.age3 as age3
	from ctebody b
	inner join cteTotals t on b.[YEAR] = t.[YEAR]
	inner join (select distinct PGASeason, Brand from [MoneyBall].[WebsiteData14]) a on b.[YEAR] = a.PGASeason and b.Brand = a.brand)
	
	
	insert into [MoneyBall].[WebsiteData14] (Equipment, [PGASeason], [BRAND], DataBlock, Header, UserData)

	
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentAll'' as Header, BrandPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentAllNew'' as Header, BrandNewPercent as UserData from cteFinal where BrandPercent > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentHandicap0to5'' as Header, h1 as UserData from cteFinal where h1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentHandicap6to10'' as Header, h2 as UserData from cteFinal where h2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentHandicap11to20'' as Header, h3 as UserData from cteFinal where h3 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentHandicap21Plus'' as Header, h4 as UserData from cteFinal where h4 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentAgeUnder30'' as Header, age1 as UserData from cteFinal where age1 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentAge30to49'' as Header, age2 as UserData from cteFinal where age2 > 0 union all
select Equipment, [YEAR] as PGASeason, Brand, ''ConsumerSEA'' as DataBlock, ''PercentAge50Plus'' as Header, age3 as UserData from cteFinal where age3 > 0
'

exec (@sqltext1 + @sqltext2 + @sqltext3 + @sqltext4 + @sqltext5 + @sqltext6 + @sqltext7)

end

Print 'Finished WebsiteData14';
end  -- WebsiteData14
GO
