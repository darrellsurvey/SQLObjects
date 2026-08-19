DROP PROCEDURE IF EXISTS [Consumer].[rptEquipmenNew_Overview];
GO

CREATE procedure [Consumer].[rptEquipmenNew_Overview]
@Country varchar(20),
@Year as varchar(500)

as
begin

set nocount on;

declare @sql as nvarchar(max)

Declare @get_column_names_only bit = 0
if @get_column_names_only = 1
SELECT 2014 as [YEAR], 1 AS [SEASON], 'b' as [Equip], 'z' AS NewPercent, 's' as Sort

Set @sql = 'select p.[year], Season, ''Hybrid'' as Equip, 
  sum(case when years < 2 then 1 else 0 end) * 100.0 / Count(*) as NewPercent, 5 as Sort
  FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase('Wood - Hybrid') + ' eq
  inner join Consumer.PlayerProfile p on p.PlayerProfileId = eq.PlayerProfileId 
  where COUNTRY = ''' + @Country + ''' and years is not null and BRAND is not null and (' + @Year + ') ' +
  [DARRELL_MASTER].Consumer.EquipmentWhereCase('Wood - Hybrid') + ' group by [YEAR],  SEASON
  union all
  select p.[year], Season, ''Driver'' as Equip, 
  sum(case when years < 2 then 1 else 0 end) * 100.0 / Count(*) as NewPercent, 3 as Sort
  FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase('Wood - Driver') + ' eq
  inner join Consumer.PlayerProfile p on p.PlayerProfileId = eq.PlayerProfileId 
  where COUNTRY = ''' + @Country + ''' and years is not null and  BRAND is not null and (' + @Year + ') ' +
  [DARRELL_MASTER].Consumer.EquipmentWhereCase('Wood - Driver') + ' group by [YEAR],  SEASON
  union all
  select p.[year], Season, ''Iron'' as Equip, 
  sum(case when years < 2 then 1 else 0 end) * 100.0 / Count(*) as NewPercent, 1 as Sort
  FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase('Iron') + ' eq
  inner join Consumer.PlayerProfile p on p.PlayerProfileId = eq.PlayerProfileId 
  where COUNTRY = ''' + @Country + ''' and years is not null and  BRAND is not null and (' + @Year + ') ' +
  [DARRELL_MASTER].Consumer.EquipmentWhereCase('Iron') + ' group by [YEAR],  SEASON
  union all
  select p.[year], Season, ''Putter'' as Equip, 
  sum(case when years < 2 then 1 else 0 end) * 100.0 / Count(*) as NewPercent, 2 as Sort
  FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase('Putter') + ' eq
  inner join Consumer.PlayerProfile p on p.PlayerProfileId = eq.PlayerProfileId 
  where COUNTRY = ''' + @Country + ''' and years is not null and  BRAND is not null and (' + @Year + ') ' +
  [DARRELL_MASTER].Consumer.EquipmentWhereCase('Putter') + ' group by [YEAR],  SEASON
  union all
  select p.[year], Season, ''Bag'' as Equip, 
  sum(case when years < 2 then 1 else 0 end) * 100.0 / Count(*) as NewPercent, 2 as Sort
  FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase('Bag') + ' eq
  inner join Consumer.PlayerProfile p on p.PlayerProfileId = eq.PlayerProfileId 
  where COUNTRY = ''' + @Country + ''' and years is not null and  BRAND is not null and (' + @Year + ') ' +
  [DARRELL_MASTER].Consumer.EquipmentWhereCase('Putter') + ' group by [YEAR],  SEASON
  union all
  select p.[year], Season, ''Fairway Wd'' as Equip, 
  sum(case when years < 2 then 1 else 0 end) * 100.0 / Count(*) as NewPercent, 4 as Sort
  FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase('Wood - Fairway') + ' eq
  inner join Consumer.PlayerProfile p on p.PlayerProfileId = eq.PlayerProfileId 
  where COUNTRY = ''' + @Country + ''' and years is not null and  BRAND is not null and (' + @Year + ') ' +
  [DARRELL_MASTER].Consumer.EquipmentWhereCase('Wood - Fairway') + ' group by [YEAR],  SEASON'

print @sql

execute sp_executesql @sql;

  
end
GO
