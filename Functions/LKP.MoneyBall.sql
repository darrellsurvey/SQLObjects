DROP FUNCTION IF EXISTS [LKP].[MoneyBall];
GO

CREATE Function [LKP].[MoneyBall]
(@Year integer,
 @Tour varchar(50),
 @Brand varchar(50),
 @Brand1 varchar(50))
RETURNS Table
AS
RETURN
(

/* by Alex Roytman 2/4/2014
returns player counts in buckets for @year and @brand
returns yearTVtime for @brand
returns consumer total for @year and @brand
returns consumer total for @year and @brand1 to be used for comparison to @brand consumer numbers
*/


with CTE_PlayerList as (SELECT distinct Year(b.[FIRST DAY]) as YearPlayed, b.PLAYERNAME
				FROM [DARRELL_MASTER].[dbo].[Bag] b
				where b.TOUR = @Tour and Year(b.[FIRST DAY]) = @year and b.BRAND = @Brand
				group by Year(b.[FIRST DAY]), b.PLAYERNAME
				union
				SELECT Year(h.[FIRST DAY]) as YearPlayed, h.PLAYERNAME
				FROM [DARRELL_MASTER].[dbo].[headgear] h
				where h.TOUR = @Tour and Year(h.[FIRST DAY]) = @year and h.BRAND = @Brand
				group by Year(h.[FIRST DAY]), h.PLAYERNAME),

CTE_TV as (SELECT YEAR(tntFirstDay) as YearPlayed, Sum([Duration]) YearTVTime
			FROM [DARRELL_MASTER].[TV].[TVAudit] tv
			where tv.TOUR = @Tour and year(tv.tntFirstDay) = @year and tv.BRAND = @Brand
			Group By YEAR(tntFirstDay)),

CTE_ConsumerPrep as (
select [YEAR], form, [BRAND], 1 as BrandTotal 
from [DARRELL_MASTER].[Consumer].[Bag] where [YEAR] = cast(@Year as CHAR(4)) + '3'
union 
select [YEAR], form, [BRAND], 1 as BrandTotal 
from [DARRELL_MASTER].[Consumer].[Ball] where [YEAR] = cast(@Year as CHAR(4)) + '3'
union 
select [YEAR], form, [BRAND], 1 as BrandTotal 
from [DARRELL_MASTER].[Consumer].[Iron] where [YEAR] = cast(@Year as CHAR(4)) + '3'
union 
select [yEAR], form, [BRAND], 1 as BrandTotal 
from [DARRELL_MASTER].[Consumer].[Putter] where [YEAR] = cast(@Year as CHAR(4)) + '3'
union 
select [YEAR], form, [BRAND], 1 as BrandTotal 
from [DARRELL_MASTER].[Consumer].[Wedge] where [YEAR] = cast(@Year as CHAR(4)) + '3'
union 
select [YEAR], form, [BRAND], 1 as BrandTotal 
from [DARRELL_MASTER].[Consumer].[Wood] where [YEAR] = cast(@Year as CHAR(4)) + '3'),


CTE_Consumer as (
select left([YEAR],4) as YearPlayed, brand, 
cast(sum(BrandTotal) * 100.0 / (select COUNT(*) from Consumer.PlayerProfile where [YEAR] = cast(@Year as CHAR(4)) + '3') as decimal(18,1)) as ConsumerNew
from cte_ConsumerPrep a
group by [YEAR], brand),


cte_YearTotals as (select YearPlayed, 
						  YearRank, 
						  PLAYERNAME, 
						  TotalPoints 
				   from [Player_Master].[PlayerDSRank] 
				   where YearPlayed = @year),

cte_Totals as (select cte_YearTotals.YearPlayed, cte_YearTotals.YearRank, 
				SUM(cte_YearTotals.TotalPoints) over (PARTITION by cte_YearTotals.YearPlayed) as NielsenPoints 
				from CTE_PlayerList 
					inner join cte_YearTotals on 
					CTE_PlayerList.PLAYERNAME = cte_YearTotals.[PLAYERNAME] and 					
					CTE_PlayerList.YearPlayed = cte_YearTotals.YearPlayed)

select t.yearplayed,
	   SUM(case when t.YearRank between 1 and 10 then 1 else 0 end) as Top1,
	   SUM(case when t.YearRank between 11 and 30 then 1 else 0 end) as Top2,
	   SUM(case when t.YearRank between 31 and 50 then 1 else 0 end) as Top3,
	   SUM(case when t.YearRank between 51 and 100 then 1 else 0 end) as Top4,
	   COUNT(*) as TotalPlayersWithTV,
   	   (select COUNT(*) from CTE_PlayerList where CTE_PlayerList.YearPlayed = t.YearPlayed) as TotalPlayers,
	   NielsenPoints,
	   CTE_TV.YearTVTime,
	   CTE_Consumer.ConsumerNew as BrandConsumerTotal,
	   CTE_Consumer.Brand as BrandConsumerBrand,
	   CTE_ConsumerMax.ConsumerNew as Brand1ConsumerTotal 
	   from cte_Totals t
	   left outer join CTE_TV on t.YearPlayed = CTE_TV.YearPlayed 
	   left outer join CTE_Consumer on t.YearPlayed = CTE_Consumer.YearPlayed and CTE_Consumer.BRAND = @Brand 
	   left outer join CTE_Consumer as CTE_ConsumerMax on t.YearPlayed = CTE_ConsumerMax.YearPlayed and CTE_ConsumerMax.Brand = @Brand1
	   group by t.yearplayed, 
				CTE_TV.YearTVTime,
				CTE_Consumer.ConsumerNew,
				CTE_Consumer.BRAND,
				CTE_ConsumerMax.ConsumerNew, 
				NielsenPoints 
				


)
GO
