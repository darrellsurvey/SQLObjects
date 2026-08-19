DROP PROCEDURE IF EXISTS [Consumer].[Chapter_Data5];
GO

CREATE procedure [Consumer].[Chapter_Data5]
(@Equipment varchar(20),
@Country varchar(20),
@Year smallint,
@Season tinyint)

as
begin
set nocount on;

declare @sqltext as varchar(2000)

if 2 = 1
begin
SELECT 1 as PurchRank, 'a' as PURCHASE, 'a' as BRAND, 'a' as YearPrev,  'b' as YearNow, 1 as sort
end

if not(@Equipment = 'Headgear')
begin


set @sqltext = '

;with cte_1 as (select BRAND, p.[year], PURCHASE 
from ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' b
inner join consumer.playerprofile p on b.playerprofileid = p.playerprofileid
where p.YEAR between ' + cast(@Year - 5 as varchar(4)) + ' and ' + cast(@Year as varchar(4)) + ' 
		and SEASON = ' + cast(@Season as varchar(1)) + '
		and COUNTRY = ''' + @Country + ''' 
		and not Brand is null
		and not purchase is null
		' + [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment) + ' '

if not(@Equipment = 'Ball' or @Equipment = 'Headgear' or @Equipment = 'Shirt' or @Equipment = 'Glove' or @Equipment = 'Bag')
begin
	set @sqltext = @sqltext + ' and years < 2 '
end 

 set @sqltext = @sqltext + '), 


cte_2 as (select BRAND, [year], PURCHASE, 
				round(count(*) * 100.0 / sum(count(*)) over(partition by [Year], PURCHASE),0) as PurchCount
from cte_1
group by [YEAR], PURCHASE, Brand),

cte_pivot as (
select Row_Number() over(partition by PURCHASE order by [' + cast(@Year as varchar(4)) + '] desc) as rankn, 
BRAND, PURCHASE, 
[' + cast(@Year - 5 as varchar(4)) + '] as YearPrev,
[' + cast(@Year as varchar(4)) + '] as YearNow
from (select * from cte_2 where Brand not in (' + [DARRELL_MASTER].[Consumer].[BrandExceptionCase]() + ')) a 
pivot (min(PurchCount) for [Year] in([' + cast(@Year - 5 as varchar(4)) + '],[' + cast(@Year as varchar(4)) + '])) as p),

cte_PurchInf as (
select Rank() over(order by count(Brand) desc) as PurchRank, PURCHASE  
from cte_1
where [YEAR] = ' + cast(@Year as varchar(4)) + '
group by PURCHASE),

cte_3 as (
select PURCHASE, Brand,YearPrev,YearNow, 1 as sort from cte_pivot where rankn < 6
union all
select PURCHASE, ''All Others'' as BRAND,
		100 - sum(YearPrev) as YearPrev, 
		100 - sum(YearNow) as YearNow, 
		2 as sort 
from cte_pivot where rankn < 6
group by PURCHASE
union all
select PURCHASE, ''Sample Size'' as BRAND, 
sum(case when [YEAR] = ' + cast(@Year - 5 as varchar(4)) + ' then 1 else 0 end) as YearPrev,
sum(case when [YEAR] = ' + cast(@Year as varchar(4)) + ' then 1 else 0 end) as YearNow, 3 as sort
from cte_1
group by PURCHASE) 

select cte_3.*, PurchRank  from cte_3
inner join cte_PurchInf on cte_3.PURCHASE = cte_PurchInf.PURCHASE 
where PurchRank < 5
order by PurchRank, sort'



end
else
begin 
	set @sqltext = 'select NULL'
end



print @sqltext
exec (@sqltext)

end
GO
