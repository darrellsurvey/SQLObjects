IF OBJECT_ID('Consumer.Chapter_Intro5') IS NOT NULL
    DROP PROCEDURE [Consumer].[Chapter_Intro5];
GO

CREATE procedure [Consumer].[Chapter_Intro5]
(@Country varchar(15),
@Year int,
@Season tinyint,
@YearsBack tinyint)

as 
Begin

--same as [Consumer].[Chapter_Exec1] (did this 10/10/2023 when doing first consumer book after covid. not sure if i could just rename (used somewhere else), so made a copy

--exec [Consumer].[Chapter_Intor5] 'USA', 2019,3,3

;with cte_form as (select PlayerProfileId, [YEAR], 
case when HANDICAP  < 6 then 1
	 when HANDICAP  between 6 and 10 then 2
	 when HANDICAP  between 11 and 15 then 3
	 when HANDICAP  between 16 and 20 then 4
	 when HANDICAP  > 20 then 5
	 end as HANDICAP
from Consumer.PlayerProfile
where COUNTRY = @Country and 
[YEAR] between @Year - 2 and @year and Season = @Season),

cte_all as (
select PlayerProfileId, Brand from Consumer.bag where PlayerProfileId in (select PlayerProfileId from cte_form)
union 
select PlayerProfileId, Brand from Consumer.ball where PlayerProfileId in (select PlayerProfileId from cte_form)
union 
select PlayerProfileId, Brand from Consumer.glove where PlayerProfileId in (select PlayerProfileId from cte_form)
union 
select PlayerProfileId, Brand from Consumer.headgear where PlayerProfileId in (select PlayerProfileId from cte_form)
union 
select PlayerProfileId, Brand from Consumer.iron where PlayerProfileId in (select PlayerProfileId from cte_form)
union 
select PlayerProfileId, Brand from Consumer.IronShaft  where PlayerProfileId in (select PlayerProfileId from cte_form)
union 
select PlayerProfileId, Brand from Consumer.Putter where PlayerProfileId in (select PlayerProfileId from cte_form)
union 
select PlayerProfileId, Brand from Consumer.Shirt  where PlayerProfileId in (select PlayerProfileId from cte_form)
union 
select PlayerProfileId, Brand from Consumer.Shoe  where PlayerProfileId in (select PlayerProfileId from cte_form)
union 
select PlayerProfileId, Brand from Consumer.wedge where PlayerProfileId in (select PlayerProfileId from cte_form)
union 
select PlayerProfileId, Brand from Consumer.wood where PlayerProfileId in (select PlayerProfileId from cte_form)
union 
select PlayerProfileId, Brand from Consumer.WoodShaft where PlayerProfileId in (select PlayerProfileId from cte_form)),




cte_1 as (select distinct cte_all.PlayerProfileId, [Year], BRAND, HANDICAP  from cte_all
		inner join cte_form on cte_all.PlayerProfileId = cte_form.PlayerProfileId)

select * from (		
select [Year], BRAND, 
			COUNT(*) * 100.0 / (select COUNT(*) from cte_form z where z.[YEAR] = q.[YEAR]) as BrandPercent,
			SUM(case when HANDICAP = 1 then 1 else 0 end) * 100.0 / (select COUNT(*) from cte_form z where z.[YEAR] = q.[YEAR] and HANDICAP = 1) as Handi1,
			SUM(case when HANDICAP = 2 then 1 else 0 end) * 100.0 / (select COUNT(*) from cte_form z where z.[YEAR] = q.[YEAR] and HANDICAP = 2) as Handi2,
			SUM(case when HANDICAP = 3 then 1 else 0 end) * 100.0 / (select COUNT(*) from cte_form z where z.[YEAR] = q.[YEAR] and HANDICAP = 3) as Handi3,
			SUM(case when HANDICAP = 4 then 1 else 0 end) * 100.0 / (select COUNT(*) from cte_form z where z.[YEAR] = q.[YEAR] and HANDICAP = 4) as Handi4,
			SUM(case when HANDICAP = 5 then 1 else 0 end) * 100.0 / (select COUNT(*) from cte_form z where z.[YEAR] = q.[YEAR] and HANDICAP = 5) as Handi5,
			RANK() over (partition by [Year] order by COUNT(*) desc) as RankN
		from cte_1 q
		where BRAND not in ('All Other',
							'All Others',
							'Use Any', 
							'Don`t Know',
							'Don`t Have',
							'None',
							'Club Crest', 
							'Custom', 
							'STEEL', 
							'Any',
							'Component',
							'All Others/Don`t Know')
		group by [Year], Brand) a 
		where RankN < 100
		order by [year] desc,BrandPercent desc
		
end
GO
