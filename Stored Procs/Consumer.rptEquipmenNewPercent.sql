DROP PROCEDURE IF EXISTS [Consumer].[rptEquipmenNewPercent];
GO

Create procedure [Consumer].[rptEquipmenNewPercent]
@Country varchar(20),
@Equipment varchar(20),
@Year as varchar(500)

as
begin

set nocount on;

declare @sql as nvarchar(max)

Declare @get_column_names_only bit = 0
if @get_column_names_only = 1
SELECT 2014 as [YEAR], 1 AS [SEASON], 'b' as [BRAND], 'z' AS BrandCount, 'c' AS NewBrandCount

Set @sql = 'SELECT [YEAR], [SEASON], [BRAND], 
		Count(*) as BrandCount,
		sum(case when years < 2 then 1 else 0 end) as NewBrandCount
  FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' eq
  inner join Consumer.PlayerProfile p
  on p.PlayerProfileId = eq.PlayerProfileId 
  where COUNTRY = ''' + @Country + ''' and BRAND is not null and (' + @Year + ') ' +
  [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment) +
  ' group by [YEAR],  SEASON, [BRAND];'

print @sql

execute sp_executesql @sql;

  
end
GO
