IF OBJECT_ID('Consumer.Brands_Get') IS NOT NULL
    DROP PROCEDURE [Consumer].[Brands_Get];
GO

CREATE PROCEDURE [Consumer].[Brands_Get]
	@Equip nvarchar(20),
	@Country nvarchar(20),
	@Year as integer
AS
begin
	SET NOCOUNT ON;
	declare @SQLText as nvarchar(2000)
	
set @SQLText = 'Select ''All Brands'' as Brand, 0 as sort
				Union All 
				Select distinct Brand, 1 as sort from ' + Consumer.EquipmentTableCase(@Equip) + ' z
				inner join Darrell_Master.Consumer.PlayerProfile p 
				on z.PlayerProfileId = p.PlayerProfileId 
				WHERE ' + Consumer.EquipmentWhereCase(@Equip) + ' 
				p.Country = ''' + @Country + ''' and [Year] = ' + cast(@Year as varchar(4)) + ' 
				and Brand not in (' + Consumer.BrandExceptionCase() + ')
				order by sort, Brand '
print @SQLText
exec(@SQLText)				

end
GO
