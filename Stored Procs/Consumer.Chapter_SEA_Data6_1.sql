DROP PROCEDURE IF EXISTS [Consumer].[Chapter_SEA_Data6_1];
GO

CREATE procedure [Consumer].[Chapter_SEA_Data6_1]
(@Equipment varchar(20),
@Country varchar(100),
@Year smallint,
@Season tinyint)

as
begin
set nocount on;


declare @sqltext as varchar(2000)

if 2 = 1
begin
SELECT 'a' as Influence, 1 as HandicapInfTotal, 1 as Handicap, 1 as InfTotal,  2 as HandicapTotal
end


if not(@Equipment = 'Headgear' or @Equipment = 'Shirt')
begin

set @sqltext = '

;with cte_1 as (select 
case when coalesce(INFLUENCE_SERIES, INFLUENCE) = ''N.A.'' then ''Other'' else coalesce(INFLUENCE_SERIES, INFLUENCE) end  as Influence, 
case when HANDICAP < 6 then 1
	 when HANDICAP between 6 and 10 then 2
	 when HANDICAP between 11 and 15 then 3
	 when HANDICAP between 16 and 20 then 4
	 when HANDICAP > 20 then 5
	 when Handicap is null then 0
end as handicap 
from  ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' b
inner join consumer.playerprofile p on b.playerprofileid = p.playerprofileid
where p.YEAR = ' + cast(@Year as varchar(4)) + ' 
		and SEASON = ' + cast(@Season as CHAR(1)) + ' 
		and COUNTRY in (''' + @Country + ''')
		--and not Handicap is null
		and not (INFLUENCE_SERIES is null and INFLUENCE is null)
		--and INFLUENCE_SERIES <> ''N.A.''
		' + [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment) + ' '

if not(@Equipment = 'Ball' or @Equipment = 'Headgear' or @Equipment = 'Shirt')
begin
	set @sqltext = @sqltext + ' and years < 2 '
end 

 set @sqltext = @sqltext + ')
 select Influence, Handicap, 
COUNT(HANDICAP) as HandicapInfTotal,
sum(count(HANDICAP)) over (partition by Influence) as InfTotal,
sum(count(HANDICAP)) over (partition by HANDICAP) as HandicapTotal
from cte_1  
group by Influence, Handicap

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
