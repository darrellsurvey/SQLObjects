DROP PROCEDURE IF EXISTS [Consumer].[rptEquipmentAge];
GO

CREATE procedure [Consumer].[rptEquipmentAge]
@Country varchar(20),
@Equipment varchar(20),
@Year as varchar(500)

as
begin

set nocount on;

declare @sql as nvarchar(max)

Declare @get_column_names_only bit = 0
if @get_column_names_only = 1
SELECT '0' as sort, 2014 as [YEAR], 1 AS [SEASON], 'b' as [BRAND], 'z' AS BrandCount, 'c' AS AverageBrandAge, 'c' AS AverageAllAge

Set @sql = 'SELECT DISTINCT ''1'' as sort, [YEAR], [SEASON], ''All Brands'' as[BRAND], 
		Count(*) as BrandCount,
		AVG(YEARS*1.0) as AverageBrandAge, 
		AVG(YEARS*1.0) as AverageAllAge
  FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' eq
  inner join Consumer.PlayerProfile p
  on p.PlayerProfileId = eq.PlayerProfileId 
  where COUNTRY = ''' + @Country + ''' and BRAND is not null and (' + @Year + ') ' 
   + [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment) + 'group by [YEAR],  SEASON 
union all
 SELECT DISTINCT ''2'' as sort, [YEAR], [SEASON], [BRAND], 
		Count(*) over (partition by [YEAR],  SEASON, [BRAND])as BrandCount,
		AVG(YEARS*1.0) over (partition by [YEAR],  SEASON, [BRAND])as AverageBrandAge, 
		AVG(YEARS*1.0) over (partition by [YEAR],  SEASON) as AverageAllAge
  FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' eq
  inner join Consumer.PlayerProfile p
  on p.PlayerProfileId = eq.PlayerProfileId 
  where COUNTRY = ''' + @Country + ''' and BRAND is not null and (' + @Year + ') ' 
  
  Set @sql = @sql + [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment);

print @sql

execute sp_executesql @sql;

  
end
GO
