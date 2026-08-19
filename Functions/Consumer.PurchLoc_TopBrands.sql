DROP FUNCTION IF EXISTS [Consumer].[PurchLoc_TopBrands];
GO

CREATE function Consumer.[PurchLoc_TopBrands]
(@PurchaseLocation as varchar(25),
@year as Integer,
@Country as varchar(25))
returns table
as
return (


with cte_1 as (select BRAND, 
						p.[year]
from consumer.Iron b
inner join consumer.playerprofile p on b.playerprofileid = p.playerprofileid
where b.PURCHASE = @PurchaseLocation and 
		p.[year] > @year-2 and 
		[YEARS] < 2 and
		Country = @Country and
		not Brand is null and 
		not purchase is null),

cte_2 as (select BRAND, [year], 
						count(*) * 100.0 / sum(count(*)) over(partition by [Year])as InfCount
from cte_1
group by [YEAR], Brand),

cte_pivot as (select RANK() over(order by [2014] desc) as rankn, * 
from cte_2 pivot (min(InfCount) for [Year] in([2013],[2014])) as p)



select Brand,[2013],[2014], 1 as sort from cte_pivot where rankn < 6
union 
select 'All Others' as BRAND,
		sum([2013]) as [2013], 
		sum([2014]) as [2014], 
		2 as sort 
from cte_pivot where rankn >= 6
union 
select 'Sample Size' as BRAND,
		(select COUNT(*) from cte_1 where [YEAR] = @year-1) as [2013], 
		(select COUNT(*) from cte_1 where [YEAR] = @year) as [2014], 
		3 as sort 
)
GO
