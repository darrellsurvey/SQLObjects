IF OBJECT_ID('Consumer.Exec1') IS NOT NULL
    DROP PROCEDURE [Consumer].[Exec1];
GO

CREATE procedure [Consumer].[Exec1]
(@Country varchar(15),
@Year int,
@Season tinyint,
@YearsBack tinyint)

as 
Begin

--exec [Consumer].[Exec1] 'USA', 2019,3,4

;with cte_form as (select PlayerProfileId, [YEAR] from Consumer.PlayerProfile
where COUNTRY = @Country and 
[YEAR] between @Year - @YearsBack + 1 and @year and Season = @Season),

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
		inner join Consumer.PlayerProfile on cte_all.PlayerProfileId = Consumer.PlayerProfile.PlayerProfileId)
		
select [Year], BRAND, 
			COUNT(*) * 100.0 / (select COUNT(*) from cte_form z where z.[YEAR] = q.[YEAR]) as BrandPercent,
			SUM(case when HANDICAP < 6 then 1 else 0 end) as Handi1,
			SUM(case when HANDICAP between 6 and 10 then 1 else 0 end) as Handi2,
			SUM(case when HANDICAP between 11 and 15 then 1 else 0 end) as Handi3,
			SUM(case when HANDICAP between 16 and 20 then 1 else 0 end) as Handi4,
			SUM(case when HANDICAP > 20 then 1 else 0 end) as Handi5,
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
							'Any')
		group by [Year], Brand
		order by [year] desc,BrandPercent desc
		
end
GO
