DROP PROCEDURE IF EXISTS [Consumer].[rptEquipmenAge_Overview];
GO

CREATE procedure [Consumer].[rptEquipmenAge_Overview]
@Country varchar(20),
@Year as varchar(500)

as
begin

set nocount on;

declare @sql as nvarchar(max)

Declare @get_column_names_only bit = 0
if @get_column_names_only = 1
SELECT 2014 as [YEAR], 1 AS [SEASON], 'b' as [Equip], 'z' AS AveAge, 's' as Sort

Set @sql = 'select p.[year], Season, ''Hybrid'' as Equip, AVG(eq.years*1.0) as AveAge, 5 as Sort
  FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase('Wood - Hybrid') + ' eq
  inner join Consumer.PlayerProfile p on p.PlayerProfileId = eq.PlayerProfileId 
  where COUNTRY = ''' + @Country + ''' and BRAND is not null and (' + @Year + ') ' +
  [DARRELL_MASTER].Consumer.EquipmentWhereCase('Wood - Hybrid') + ' group by [YEAR],  SEASON
  union all
  select p.[year], Season, ''Driver'' as Equip, AVG(eq.years*1.0)  as AveAge, 3 as Sort
  FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase('Wood - Driver') + ' eq
  inner join Consumer.PlayerProfile p on p.PlayerProfileId = eq.PlayerProfileId 
  where COUNTRY = ''' + @Country + ''' and BRAND is not null and (' + @Year + ') ' +
  [DARRELL_MASTER].Consumer.EquipmentWhereCase('Wood - Driver') + ' group by [YEAR],  SEASON
  union all
  select p.[year], Season, ''Iron'' as Equip, AVG(eq.years*1.0)  as AveAge, 1 as Sort
  FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase('Iron') + ' eq
  inner join Consumer.PlayerProfile p on p.PlayerProfileId = eq.PlayerProfileId 
  where COUNTRY = ''' + @Country + ''' and BRAND is not null and (' + @Year + ') ' +
  [DARRELL_MASTER].Consumer.EquipmentWhereCase('Iron') + ' group by [YEAR],  SEASON
  union all
  select p.[year], Season, ''Putter'' as Equip, AVG(eq.years*1.0)  as AveAge, 2 as Sort
  FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase('Putter') + ' eq
  inner join Consumer.PlayerProfile p on p.PlayerProfileId = eq.PlayerProfileId 
  where COUNTRY = ''' + @Country + ''' and BRAND is not null and (' + @Year + ') ' +
  [DARRELL_MASTER].Consumer.EquipmentWhereCase('Putter') + ' group by [YEAR],  SEASON
  union all
  select p.[year], Season, ''Fairway Wd'' as Equip, AVG(eq.years*1.0)  as AveAge, 4 as Sort
  FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase('Wood - Fairway') + ' eq
  inner join Consumer.PlayerProfile p on p.PlayerProfileId = eq.PlayerProfileId 
  where COUNTRY = ''' + @Country + ''' and BRAND is not null and (' + @Year + ') ' +
  [DARRELL_MASTER].Consumer.EquipmentWhereCase('Wood - Fairway') + ' group by [YEAR],  SEASON'

print @sql

execute sp_executesql @sql;

  
end
GO
