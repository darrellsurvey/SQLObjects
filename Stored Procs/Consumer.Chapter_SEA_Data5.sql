IF OBJECT_ID('Consumer.Chapter_SEA_Data5') IS NOT NULL
    DROP PROCEDURE [Consumer].[Chapter_SEA_Data5];
GO

CREATE procedure [Consumer].[Chapter_SEA_Data5]
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
SELECT 'a' as Purchase, 1 as BrandPurchTotal, 'a' as BRAND, 1 as PurchTotal,  2 as BrandTotal
end


if not(@Equipment = 'Headgear' or @Equipment = 'Shirt')
begin

set @sqltext = '

;with cte_1 as (select Purchase, isnull(BRAND, ''All Others'') as BRAND 
from  ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' b
inner join consumer.playerprofile p on b.playerprofileid = p.playerprofileid
where p.YEAR = ' + cast(@Year as varchar(4)) + ' 
		and SEASON = ' + cast(@Season as CHAR(1)) + '
		and COUNTRY in (''' + @Country + ''')
		--and not Brand is null
		and not (Purchase is null)
		' + [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment) + ' '

if not(@Equipment = 'Ball' or @Equipment = 'Headgear' or @Equipment = 'Shirt')
begin
	set @sqltext = @sqltext + ' and years < 2 '
end 

 set @sqltext = @sqltext + ')

select * from ( 
select Purchase, Brand, COUNT(Brand) as BrandPurchTotal,
sum(count(Brand)) over (partition by Purchase) as PurchTotal,
sum(count(Brand)) over (partition by Brand) as BrandTotal
from cte_1  
group by Purchase, Brand
) a ;'


--) a where brand not in (' + Consumer.BrandExceptionCase() + ');'

end
else
begin 
	set @sqltext = 'select NULL'
end

print @sqltext
exec (@sqltext)


end
GO
