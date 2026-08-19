DROP PROCEDURE IF EXISTS [Consumer].[Chapter_SEA_Data2];
GO

CREATE procedure [Consumer].[Chapter_SEA_Data2]
(@Equipment varchar(20),
@Country varchar(100),
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
		2014 as [Year], 
		1 as sort, 
		'a' as Country,
		'Total' AS demogroup, 
		1 as DemoSubGroup,
		'a' as DemoSubGroupText,
		'b' as Brand,
		1 AS BrandCount, 
		1 as TotalCount,
		1 as BrandRank
end

set @sqlNew1text = '
cte_PP_New as (
SELECT [BRAND]
      ,[YEARS]
      ,p.*
  FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' q
  inner join Consumer.PlayerProfile p on q.PlayerProfileId = p.PlayerProfileId 
  where p.YEAR between ' + cast(@Year - @YearsBack + 1 as varchar(4)) + ' and ' + cast(@Year as varchar(4)) + '
         and COUNTRY in (''' + @Country + ''')  
         and SEASON = ' + cast(@Season as varchar(1)) + '  
         and YEARS < 2
         ' + [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment) + '), '

 
set @sqlNew2text = '  
select ''New'' as DataType, ''Total'' as DemoGroup, 1 as DemoSubGroup,  [YEAR], COUNTRY , Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], COUNTRY) as TotalCount
FROM cte_PP_new where Brand is not null Group by [YEAR], COUNTRY , Brand

union all

select ''New'' as DataType, ''Sex'' as DemoGroup, Sex as DemoSubGroup,[YEAR], COUNTRY, Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], COUNTRY, sex) as TotalCount
FROM cte_PP_new where Brand is not null and Sex is not null
Group by [YEAR], COUNTRY, Brand, sex

union all

select ''New'' as DataType, ''Age'' as DemoGroup, Age as DemoSubGroup,[YEAR], COUNTRY, Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], COUNTRY, Age) as TotalCount
FROM cte_PP_new where Brand is not null  and Age is not null
Group by [YEAR], COUNTRY, Brand, Age

union all

select ''New'' as DataType, ''Handicap'' as DemoGroup, HANDICAP as DemoSubGroup,[YEAR], COUNTRY, Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], COUNTRY, HANDICAP) as TotalCount
FROM 
(select year, COUNTRY, brand, 
	 case when HANDICAP < 6 then 1
	 when HANDICAP between 6 and 10 then 2
	 when HANDICAP between 11 and 15 then 3
	 when HANDICAP between 16 and 20 then 4
	 when HANDICAP > 20 then 5
end as handicap
from cte_PP_new where Brand is not null  and HANDICAP is not null) a
Group by [YEAR], COUNTRY, Brand, handicap 

union all

select ''New'' as DataType, ''Frequency'' as DemoGroup, 
case when OFTEN_PLAY = 1 then 2
	 when OFTEN_PLAY = 2 then 1 
	 when OFTEN_PLAY = 5 then 1
	 when OFTEN_PLAY = 6 then 4
	 else OFTEN_PLAY end as DemoSubGroup,[YEAR], COUNTRY, Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], COUNTRY, OFTEN_PLAY) as TotalCount
FROM cte_PP_new where Brand is not null  and OFTEN_PLAY is not null
Group by [YEAR], COUNTRY, Brand, OFTEN_PLAY

union all

select ''New'' as DataType, ''YearsOfPlay'' as DemoGroup, LONG_PLAYED as DemoSubGroup,[YEAR], COUNTRY, Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], COUNTRY, LONG_PLAYED) as TotalCount
FROM cte_PP_New  where Brand is not null  and LONG_PLAYED is not null
Group by [YEAR], COUNTRY, Brand, LONG_PLAYED

union all

select ''New'' as DataType, ''CourseType'' as DemoGroup, COURSE as DemoSubGroup,[YEAR], COUNTRY, Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], COUNTRY, COURSE) as TotalCount
FROM cte_PP_New  where Brand is not null  and COURSE is not null
Group by [YEAR], COUNTRY, Brand, COURSE  '

-------------------------------------------------------


if not(@Equipment = 'Ball' or @Equipment = 'Headgear' or @Equipment = 'Shirt' or @Equipment = 'Bag' or @Equipment = 'Glove')
begin
	set @sqlMaintext = '
		; with cte_PP_Total as (
		SELECT [BRAND]
			,[YEARS]
			,p.*
		FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' q
		inner join Consumer.PlayerProfile p on q.PlayerProfileId = p.PlayerProfileId 
		where p.YEAR between ' + cast(@Year - @YearsBack + 1 as varchar(4)) + ' and ' + cast(@Year as varchar(4)) + '
			and COUNTRY in (''' + @Country + ''')  
			and SEASON = ' + cast(@Season as varchar(1)) + ' 
		' + [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment) + '), '

	set @sqlMaintext = @sqlMaintext + @sqlNew1text
end
else
begin
	set @sqlMaintext = '
		; with cte_PP_Total as (
		SELECT [BRAND]
			, COUNTRY
			,0 as [YEARS]
			,p.*
		FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' q
		inner join Consumer.PlayerProfile p on q.PlayerProfileId = p.PlayerProfileId 
		where p.YEAR between ' + cast(@Year - @YearsBack + 1 as varchar(4)) + ' and ' + cast(@Year as varchar(4)) + '
			and COUNTRY in (''' + @Country + ''') 
			and SEASON = ' + cast(@Season as varchar(1)) + ' 
		' + [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment) + '), '
end



set @sqlMaintext = @sqlMaintext + ' cte_data as ( 
select ''Total'' as DataType, ''Total'' as DemoGroup, 1 as DemoSubGroup,  [YEAR], COUNTRY, Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], COUNTRY) as TotalCount
FROM cte_PP_Total where Brand is not null Group by [YEAR], COUNTRY, Brand

union all

select ''Total'' as DataType, ''Sex'' as DemoGroup, Sex as DemoSubGroup,[YEAR], COUNTRY, Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], COUNTRY, sex) as TotalCount
FROM cte_PP_Total  where Brand is not null and Sex is not null
Group by [YEAR], COUNTRY, Brand, sex

union all

select ''Total'' as DataType, ''Age'' as DemoGroup, Age as DemoSubGroup,[YEAR], COUNTRY, Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], COUNTRY, Age) as TotalCount
FROM cte_PP_Total where Brand is not null  and Age is not null
Group by [YEAR], COUNTRY, Brand, Age

union all

select ''Total'' as DataType, ''Handicap'' as DemoGroup, HANDICAP as DemoSubGroup,[YEAR], COUNTRY, Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], COUNTRY, HANDICAP) as TotalCount
FROM 
(select year, COUNTRY, brand, 
	 case when HANDICAP < 6 then 1
	 when HANDICAP between 6 and 10 then 2
	 when HANDICAP between 11 and 15 then 3
	 when HANDICAP between 16 and 20 then 4
	 when HANDICAP > 20 then 5
end as handicap
from cte_PP_Total where Brand is not null  and HANDICAP is not null) a
Group by [YEAR], COUNTRY, Brand, handicap 

union all

select ''Total'' as DataType, ''Frequency'' as DemoGroup, 
case when OFTEN_PLAY = 1 then 2
	 when OFTEN_PLAY = 2 then 1 
	 when OFTEN_PLAY = 5 then 1
	 when OFTEN_PLAY = 6 then 4
	 else OFTEN_PLAY end as DemoSubGroup,[YEAR], COUNTRY, Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], COUNTRY, OFTEN_PLAY) as TotalCount
FROM cte_PP_Total  where Brand is not null  and OFTEN_PLAY is not null
Group by [YEAR], COUNTRY, Brand, OFTEN_PLAY

union all

select ''Total'' as DataType, ''YearsOfPlay'' as DemoGroup, LONG_PLAYED as DemoSubGroup,[YEAR], COUNTRY, Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], COUNTRY, LONG_PLAYED) as TotalCount
FROM cte_PP_Total  where Brand is not null  and LONG_PLAYED is not null
Group by [YEAR], COUNTRY, Brand, LONG_PLAYED

union all


select ''Total'' as DataType, ''CourseType'' as DemoGroup, COURSE as DemoSubGroup,[YEAR], COUNTRY, Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], COUNTRY, COURSE) as TotalCount
FROM cte_PP_Total where Brand is not null  and COURSE is not null
Group by [YEAR], COUNTRY, Brand, COURSE ' 


if not(@Equipment = 'Ball' or @Equipment = 'Headgear' or @Equipment = 'Shirt' or @Equipment = 'Bag')
begin
	set @sqlMaintext = @sqlMaintext + ' union all ' + @sqlNew2text
end



set @sqlMaintext = @sqlMaintext + '), 

cte_AllBrands as (select distinct DataType, Brand, COUNTRY, z.year
from cte_data d 
cross join (select distinct Year from cte_data) z
--group by DataType, Brand
),

cte_AllPossible as (
select DataType, [Year], COUNTRY, sort, z.DemoGroup, z.DemoSubGroup, DemoSubGroupText, Brand, NULL as BrandCount ,NULL as TotalCount
from cte_AllBrands d cross join (select * from Consumer.Header) z),


cte_2 as (
select p.DataType, p.[YEAR], p.COUNTRY, sort, p.DemoGroup, p.DemoSubGroup, DemoSubGroupText, p.BRAND,
coalesce(p.brandcount, z.brandcount) as BrandCount,
coalesce(p.totalcount, z.totalcount) as TotalCount
from cte_AllPossible p
left outer join 
(select DataType, [Year], COUNTRY, demogroup, DemoSubGroup,
Brand, BrandCount, TotalCount
from cte_data d) z
on p.DataType = z.DataType and 
p.[YEAR] = z.[YEAR] and 
p.BRAND = z.BRAND and 
p.DemoGroup = z.DemoGroup and
p.DemoSubGroup = z.DemoSubGroup )



select *, RANK() over (Partition by DataType, [year], COUNTRY, sort, DemoSubGroup order by BrandCount desc) as BrandRank
from cte_2
where BRAND not in (' + [DARRELL_MASTER].[Consumer].[BrandExceptionCase]() + ')
order by DataType desc, [YEAR] desc, COUNTRY, sort asc, BrandRank asc '


print @sqlMaintext
exec (@sqlMaintext)

end
GO
