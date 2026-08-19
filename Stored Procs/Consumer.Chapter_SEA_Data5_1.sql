IF OBJECT_ID('Consumer.Chapter_SEA_Data5_1') IS NOT NULL
    DROP PROCEDURE [Consumer].[Chapter_SEA_Data5_1];
GO

CREATE procedure [Consumer].[Chapter_SEA_Data5_1]
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
SELECT 'a' as Purchase, 1 as HandicapPurchTotal, 1 as Handicap, 1 as PurchTotal,  2 as HandicapTotal
end


if not(@Equipment = 'Headgear' or @Equipment = 'Shirt')
begin

set @sqltext = '

;with cte_1 as (select Purchase, 
case when HANDICAP < 6 then 1
	 when HANDICAP between 6 and 10 then 2
	 when HANDICAP between 11 and 15 then 3
	 when HANDICAP between 16 and 20 then 4
	 when HANDICAP > 20 then 5
	 When Handicap is null then 0
end as handicap 
from  ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' b
inner join consumer.playerprofile p on b.playerprofileid = p.playerprofileid
where p.YEAR = ' + cast(@Year as varchar(4)) + ' 
		and SEASON = ' + cast(@Season as CHAR(1)) + '
		and COUNTRY in (''' + @Country + ''')
		--and not Handicap is null
		and not (Purchase is null)
		' + [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment) + ' '

if not(@Equipment = 'Ball' or @Equipment = 'Headgear' or @Equipment = 'Shirt')
begin
	set @sqltext = @sqltext + ' and years < 2 '
end 

 set @sqltext = @sqltext + ')select Purchase, Handicap, COUNT(Handicap) as HandicapPurchTotal,
sum(count(Handicap)) over (partition by Purchase) as PurchTotal,
sum(count(Handicap)) over (partition by Handicap) as HandicapTotal
from cte_1  
group by Purchase, Handicap'

end
else
begin 
	set @sqltext = 'select NULL'
end

print @sqltext
exec (@sqltext)


end
GO
