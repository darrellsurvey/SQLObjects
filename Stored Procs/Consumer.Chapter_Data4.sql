DROP PROCEDURE IF EXISTS [Consumer].[Chapter_Data4];
GO

CREATE procedure [Consumer].[Chapter_Data4]
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
SELECT 'a' as PURCHASE, 
		1 as PurchCount, 
		1 as TotalCount
end

if not(@Equipment = 'Headgear')
begin



set @sqltext = '
select w.PURCHASE, COUNT(PURCHASE) as PurchCount, 
sum(COUNT(PURCHASE)) over() as TotalCount
from ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' w 
inner join Consumer.PlayerProfile p
on w.PlayerProfileId = p.PlayerProfileId 
where p.YEAR = ' + cast(@Year as varchar(4)) + ' 
		and SEASON = ' + cast(@Season as varchar(1)) + '
		and COUNTRY in (''' + @Country + ''')
		and not Brand is null
		and not purchase is null
		' + [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment) + ' '
		
if not(@Equipment = 'Ball' or @Equipment = 'Headgear' or @Equipment = 'Shirt' or @Equipment = 'Glove' or @Equipment = 'Bag')
begin
	set @sqltext = @sqltext + ' and years < 2 '
end

		
set @sqltext = @sqltext + ' group by PURCHASE order by PurchCount desc '
  
end
else
begin 
	set @sqltext = 'select NULL'
end  
         

print @sqltext
exec (@sqltext)

end
GO
