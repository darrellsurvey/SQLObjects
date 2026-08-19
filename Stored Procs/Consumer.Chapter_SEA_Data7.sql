DROP PROCEDURE IF EXISTS [Consumer].[Chapter_SEA_Data7];
GO

CREATE procedure [Consumer].[Chapter_SEA_Data7]
(@Equipment varchar(20),
@Country varchar(100),
@Year smallint,
@Season tinyint,
@YearsBack tinyint)

as
begin
set nocount on;

declare @sqltext as varchar(2000)

if 2 = 1
begin
SELECT 1 as  rn, 1 as [Year], 'a' as Country,'a' as Influence, 1 as InfCount,  1 as TotalCount
end


if not(@Equipment = 'Headgear' or @Equipment = 'Shirt')
begin

set @sqltext = '
;with cte_pp as (
select p.[year], country, coalesce(INFLUENCE_SERIES, INFLUENCE) as Influence
from ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' w 
inner join Consumer.PlayerProfile p
on w.PlayerProfileId = p.PlayerProfileId 
where p.YEAR between ' + cast(@Year - @YearsBack + 1 as varchar(4)) + ' and ' + cast(@Year as varchar(4)) + ' 
		and COUNTRY in (''' + @Country + ''')
		and SEASON = ' + cast(@Season as varchar(1)) + '
		and BRAND is not null
		and not (INFLUENCE_SERIES is null and INFLUENCE is null)
		' + [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment) + ' '

if not(@Equipment = 'Ball' or @Equipment = 'Bag' or @Equipment = 'Glove')
begin
	set @sqltext = @sqltext + ' and years < 2 '
end 

 set @sqltext = @sqltext + '), 
 
cte_2 as (
select [year], country, INFLUENCE, COUNT(*) as InfCount, 
sum(COUNT(*)) over(partition by [year], country) as TotalCount
from cte_pp
group by [year], country, INFLUENCE)

select rank() over(Partition by [year], country order by InfCount desc) as rn, * from cte_2 
where INFLUENCE not in (''N.A.'', ''Doesn`t Have Today'')
'

end
else
begin 
	set @sqltext = 'select NULL'
end
     

print @sqltext
exec (@sqltext)

end
GO
