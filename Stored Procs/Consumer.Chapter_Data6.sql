DROP PROCEDURE IF EXISTS [Consumer].[Chapter_Data6];
GO

CREATE procedure [Consumer].[Chapter_Data6]
(@Equipment varchar(20),
@Country varchar(20),
@Year smallint,
@Season tinyint)

as
begin
set nocount on;


declare @sqltext as varchar(3000)

if 2 = 1
begin
SELECT 1 as InfRank, 'a' as Influence, 'a' as BRAND, 'a' as YearPrev,  'b' as YearNow, 1 as sort
end


if not(@Equipment = 'Headgear' or @Equipment = 'Shirt')
begin

set @sqltext = '

;with cte_1 as (select BRAND, p.[year], coalesce(INFLUENCE_SERIES, INFLUENCE) as Influence
from ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' b
inner join consumer.playerprofile p on b.playerprofileid = p.playerprofileid
where p.YEAR between ' + cast(@Year - 5 as varchar(4)) + ' and ' + cast(@Year as varchar(4)) + ' 
		and SEASON = ' + cast(@Season as varchar(1)) + '
		and COUNTRY = ''' + @Country + ''' 
		and not Brand is null
		and not (INFLUENCE_SERIES is null and INFLUENCE is null)
		and INFLUENCE_SERIES <> ''N.A.''
		' + [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment) + ' '

if not(@Equipment = 'Ball' or @Equipment = 'Headgear' or @Equipment = 'Shirt' or @Equipment = 'Glove' or @Equipment = 'Bag')
begin
	set @sqltext = @sqltext + ' and years < 2 '
end 

 set @sqltext = @sqltext + '), 


cte_2 as (select BRAND, [year], Influence, 
				round(count(*) * 100.0 / sum(count(*)) over(partition by [Year], Influence),0) as InfCount
from cte_1
group by [YEAR], Influence, Brand),

cte_pivot as (
select Row_Number() over(partition by Influence order by [' + cast(@Year as varchar(4)) + '] desc) as rankn, 
BRAND, Influence, 
[' + cast(@Year - 5 as varchar(4)) + '] as YearPrev,
[' + cast(@Year as varchar(4)) + '] as YearNow
from (select * from cte_2 where Brand not in (' + [DARRELL_MASTER].[Consumer].[BrandExceptionCase]() + ')) a 
pivot (min(InfCount) for [Year] in([' + cast(@Year - 5 as varchar(4)) + '],[' + cast(@Year as varchar(4)) + '])) as p),

cte_PurchInf as (
select rank() over(order by count(Brand) desc) as InfRank, Influence  
from cte_1
where [YEAR] = ' + cast(@Year as varchar(4)) + '
group by Influence),

cte_3 as (
select Influence, Brand,YearPrev,YearNow, 1 as sort from cte_pivot where rankn < 6
union all
select Influence, ''All Others'' as BRAND,
		100 - sum(YearPrev) as YearPrev, 
		100 - sum(YearNow) as YearNow, 
		2 as sort 
from cte_pivot where rankn < 6
group by Influence
union all
select Influence, ''Sample Size'' as BRAND, 
sum(case when [YEAR] = ' + cast(@Year - 5 as varchar(4)) + ' then 1 else 0 end) as YearPrev,
sum(case when [YEAR] = ' + cast(@Year as varchar(4)) + ' then 1 else 0 end) as YearNow, 3 as sort
from cte_1
group by Influence) 

select cte_3.*, InfRank  from cte_3
inner join cte_PurchInf on cte_3.Influence = cte_PurchInf.Influence 
where InfRank < 5
order by InfRank, sort'

end
else
begin 
	set @sqltext = 'select NULL'
end

print @sqltext
exec (@sqltext)


end
GO
