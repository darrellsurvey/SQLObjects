DROP PROCEDURE IF EXISTS [Consumer].[TopBrands];
GO

CREATE procedure [Consumer].[TopBrands]
(@year as smallint,
 @country as varchar(20),
 @season as tinyint = 3,
 @Equip as varchar(20),
 @top as tinyint = 5,
 @CategoryQuery as varchar(50))

as
begin
set nocount on;

	Declare @get_column_names_only bit = 0
	if @get_column_names_only = 1 select 1 as r, 'b' as Brand, 'c' as BrandTotal
 
	declare @query as varchar(1000)

	set @query = 'select * from (
					Select RANK() over (order by count(e.brand) desc) as r,
					e.BRAND, 
					COUNT(e.brand) * 100.0 / sum(COUNT(e.brand)) over () as BrandTotal 
					from ' + Consumer.equipmenttablecase(@equip) + ' e
					inner join Consumer.PlayerProfile p
					on e.PlayerProfileId = p.PlayerProfileId 
					where BRAND is not null and
						  p.[COUNTRY] = ''' + @country + ''' and 
						  p.[YEAR] = ' + cast(@year as CHAR(4)) + ' and 
						  p.[SEASON] = ' + cast(@season as CHAR(1)) + 
						  consumer.EquipmentWhereCase(@equip) + ' '+ @CategoryQuery + '
					group by brand) a
					where r <= ' + cast(@top as CHAR(4))
print(@query)					 
execute(@query);

end;
GO
