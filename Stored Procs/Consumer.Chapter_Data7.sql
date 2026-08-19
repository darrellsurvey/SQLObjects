DROP PROCEDURE IF EXISTS [Consumer].[Chapter_Data7];
GO

CREATE procedure [Consumer].[Chapter_Data7]
(@Equipment varchar(20),
@Country varchar(100),
@Year smallint,
@Season tinyint)

as
begin
set nocount on;

declare @sqltext as varchar(1000)

if 2 = 1
begin
SELECT 'a' as Influence, 1 as InfCount,  1 as TotalCount
end


if not(@Equipment = 'Headgear' or @Equipment = 'Shirt')
begin

set @sqltext = '
;with cte_pp as (
select coalesce(INFLUENCE_SERIES, INFLUENCE) as Influence
from ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' w 
inner join Consumer.PlayerProfile p
on w.PlayerProfileId = p.PlayerProfileId 
where p.YEAR = ' + cast(@Year as varchar(4)) + ' 
		and COUNTRY in (''' + @Country + ''')
		and SEASON = ' + cast(@Season as varchar(1)) + '
		and BRAND is not null
		and not (INFLUENCE_SERIES is null and INFLUENCE is null)
		' + [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment) + ' '

if not(@Equipment = 'Ball')
begin
	set @sqltext = @sqltext + ' and years < 2 '
end 

 set @sqltext = @sqltext + '), 
 
cte_2 as (
select INFLUENCE, COUNT(*) as InfCount, 
sum(COUNT(*)) over() as TotalCount
from cte_pp
group by INFLUENCE)

select * from cte_2 
where INFLUENCE not in (''N.A.'', ''Doesn`t Have Today'')
order by InfCount desc'

end
else
begin 
	set @sqltext = 'select NULL'
end
     

print @sqltext
exec (@sqltext)

end
GO
