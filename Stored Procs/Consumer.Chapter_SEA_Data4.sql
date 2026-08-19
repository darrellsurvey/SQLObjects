IF OBJECT_ID('Consumer.Chapter_SEA_Data4') IS NOT NULL
    DROP PROCEDURE [Consumer].[Chapter_SEA_Data4];
GO

CREATE procedure [Consumer].[Chapter_SEA_Data4]
(@Equipment varchar(20),
@Country varchar(100),
@Year smallint,
@YearsBack smallint,
@Season tinyint)

as
begin
set nocount on;

declare @sqltext as varchar(1000)

if 2 = 1
begin
SELECT 'a' as Country, 'a' as PURCHASE, 1 as [Year],
		1 as PurchCount, 
		1 as TotalCount
end

if not(@Equipment = 'Headgear')
begin



set @sqltext = '
select Country,[Year], w.PURCHASE, COUNT(PURCHASE) as PurchCount, 
sum(COUNT(PURCHASE)) over(partition by Country,[Year]) as TotalCount
from ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' w 
inner join Consumer.PlayerProfile p
on w.PlayerProfileId = p.PlayerProfileId 
where p.YEAR between ' + cast(@Year - @YearsBack + 1 as varchar(4)) + ' and ' + cast(@Year as varchar(4)) + ' 
		and SEASON = ' + cast(@Season as varchar(1)) + '
		and COUNTRY in (''' + @Country + ''')
		and not Brand is null
		and not purchase is null
		' + [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment) + ' '
		
if not(@Equipment = 'Ball' or @Equipment = 'Headgear' or @Equipment = 'Shirt' or @Equipment = 'Bag' or @Equipment = 'Glove')
begin
	set @sqltext = @sqltext + ' and years < 2 '
end

		
set @sqltext = @sqltext + ' group by country,[Year], PURCHASE order by country,[Year] desc, PurchCount desc '
  
end
else
begin 
	set @sqltext = 'select NULL'
end  
         

print @sqltext
exec (@sqltext)

end
GO
