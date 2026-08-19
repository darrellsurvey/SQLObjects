DROP PROCEDURE IF EXISTS [Consumer].[Chapter_Data_Region];
GO

CREATE procedure [Consumer].[Chapter_Data_Region]
(@Equipment varchar(20),
@Country varchar(20),
@Year smallint,
@Season tinyint,
@YearsBack tinyint)

as
begin
set nocount on;

declare @sqlNew1text as varchar(3000)
declare @sqlNew2text as varchar(3000)
declare @sqlMaintext as varchar(max)


if 2 = 1
begin
SELECT 'a' as DataType, 
		1 as Region, 
		'1' AS RegionName, 
		2014 as [Year], 
		'b' as Brand,
		1 AS BrandCount, 
		1 as TotalCount,
		1 as BrandRank,
		1 as RegionRank,
		1 as SampleSize,
		1 as BrandSampleSize,
		1 as OverallRank,
		1 as TotalBrandPercent
end

set @sqlNew1text = '
cte_PP_New as (
SELECT [BRAND]
      ,[YEARS]
      ,p.*
      ,r.RegionName
  FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' q
  inner join Consumer.PlayerProfile p on q.PlayerProfileId = p.PlayerProfileId 
  inner join Consumer.Region r on p.region = r.regionnumber 
  inner join consumer.Country c on r.countryid = c.countryid and c.country = ''' + @Country + '''
  where p.YEAR between ' + cast(@Year - @YearsBack + 1 as varchar(4)) + ' and ' + cast(@Year as varchar(4)) + '
         and p.COUNTRY = ''' + @Country + ''' 
         and SEASON = ' + cast(@Season as varchar(1)) + '  
         and YEARS < 2
         ' + [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment) + '), '

 
set @sqlNew2text = '  
select ''New'' as DataType, region, RegionName,  [YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], region) as TotalCount
FROM cte_PP_new where Brand is not null 
Group by [YEAR], region, RegionName, Brand  '

-------------------------------------------------------


if not(@Equipment = 'Ball' or @Equipment = 'Headgear' or @Equipment = 'Shirt') -- or @Equipment = 'Bag')
begin
	set @sqlMaintext = '
		; with cte_PP_Total as (
		SELECT [BRAND]
      ,[YEARS]
      ,p.*
      ,r.RegionName
  FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' q
  inner join Consumer.PlayerProfile p on q.PlayerProfileId = p.PlayerProfileId 
  inner join Consumer.Region r on p.region = r.regionnumber 
  inner join consumer.Country c on r.countryid = c.countryid and c.country = ''' + @Country + '''
  where p.YEAR between ' + cast(@Year - @YearsBack + 1 as varchar(4)) + ' and ' + cast(@Year as varchar(4)) + '
         and p.COUNTRY = ''' + @Country + ''' 
         and SEASON = ' + cast(@Season as varchar(1)) + '  
         ' + [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment) + '), '

	set @sqlMaintext = @sqlMaintext + @sqlNew1text
end
else
begin
	set @sqlMaintext = '
		; with cte_PP_Total as (
		SELECT [BRAND]
			,0 as [YEARS]
			,p.*
      ,r.RegionName
  FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' q
  inner join Consumer.PlayerProfile p on q.PlayerProfileId = p.PlayerProfileId 
  inner join Consumer.Region r on p.region = r.regionnumber 
  inner join consumer.Country c on r.countryid = c.countryid and c.country = ''' + @Country + '''
  where p.YEAR between ' + cast(@Year - @YearsBack + 1 as varchar(4)) + ' and ' + cast(@Year as varchar(4)) + '
         and p.COUNTRY = ''' + @Country + ''' 
         and SEASON = ' + cast(@Season as varchar(1)) + '  
         ' + [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment) + '), '
end



set @sqlMaintext = @sqlMaintext + ' cte_data as ( 
select ''Total'' as DataType, region, RegionName,  [YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], region) as TotalCount
FROM cte_PP_Total where Brand is not null 
Group by [YEAR], region, RegionName, Brand  ' 


if not(@Equipment = 'Ball' or @Equipment = 'Headgear' or @Equipment = 'Shirt') -- or @Equipment = 'Bag')
begin
	set @sqlMaintext = @sqlMaintext + ' union all ' + @sqlNew2text
end


set @sqlMaintext = @sqlMaintext + '),


cte_prefinaldata as (
select cd1.*, 
sum(BrandCount) over (Partition by cd1.DataType, cd1.[year]) as SampleSize,
sum(BrandCount) over (Partition by cd1.DataType, cd1.[year], cd1.Brand) as BrandSampleSize
from cte_data cd1),

cte_finaldata as (
select cd1.*, BrandSampleSize * 100.0 / SampleSize as TotalBrandPercent
from cte_prefinaldata cd1)


select cd1.DataType, cd1.Region, cd1.RegionName, cd1.Year, cd1.Brand, cd1.BrandCount, cd1.TotalCount, cd1.SampleSize, cd1.BrandSampleSize,
RANK() over (Partition by cd1.DataType, cd1.[year], cd1.region order by cd1.BrandCount desc) as BrandRank,
RANK() over (Partition by cd1.DataType, cd1.[year], cd1.Brand order by cd1.BrandCount*100.0/cd1.totalcount desc) as RegionRank,
OverallRank,
a.TotalBrandPercent
from cte_finaldata cd1
inner join (
	select [year], brand, RANK() over (partition by [year] order by TotalBrandPercent desc, Brand) as OverallRank, TotalBrandPercent
	from cte_finaldata where datatype = '''

if not(@Equipment = 'Ball' or @Equipment = 'Bag' or @Equipment = 'Headgear' or @Equipment = 'Shirt')
begin
	set @sqlMaintext = @sqlMaintext + 'Total'
end
else
begin
	set @sqlMaintext = @sqlMaintext + 'Total'
end


set @sqlMaintext = @sqlMaintext + '''
	      and BRAND not in (''All Other'',
							''All Others'',
							''Use Any'', 
							''Don`t Know'',
							''Don`t Have'',
							''None'',
							''Club Crest'', 
							''Custom'', 
							''Any'',
							''Component'',
							''All Others/Don`t Know'',
							''Keep Same Brand & Model'')
	group by DataType, [year], brand, TotalBrandPercent) a
on cd1.[YEAR] = a.[YEAR] and cd1.BRAND = a.BRAND
order by DataType asc, [YEAR] desc, region asc, BrandRank asc ;' 


print @sqlMaintext
exec (@sqlMaintext)

end
GO
