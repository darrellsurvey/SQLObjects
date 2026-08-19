DROP PROCEDURE IF EXISTS [Consumer].[Chapter_Data2];
GO

CREATE procedure [Consumer].[Chapter_Data2]
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

--exec [Consumer].[Chapter_Data2] 'Putter', 'Korea', 2024,4,16


if 2 = 1
begin
SELECT 'a' as DataType, 
		2014 as [Year], 
		1 as sort, 
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
  where p.YEAR between ' + cast(@Year - @YearsBack as varchar(4)) + ' and ' + cast(@Year as varchar(4)) + '
         and COUNTRY in (''' + @Country + ''')  
         and SEASON = ' + cast(@Season as varchar(1)) + '  
         and YEARS < 2
         ' + [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment) + '), '

 
set @sqlNew2text = '  
select ''New'' as DataType, ''Total'' as DemoGroup, 1 as DemoSubGroup,  [YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR]) as TotalCount
FROM cte_PP_new where Brand is not null Group by [YEAR], Brand

union all

select ''New'' as DataType, ''Sex'' as DemoGroup, Sex as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], sex) as TotalCount
FROM cte_PP_new where Brand is not null and Sex is not null
Group by [YEAR], Brand, sex

union all

select ''New'' as DataType, ''Age'' as DemoGroup, Age as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], Age) as TotalCount
FROM
(select year, brand, age
	 --case when Age = 1 then 2
	 --case when Age = 6 then 5
	 --Else Age
	 --end as Age
from cte_PP_new where Brand is not null  and Age is not null) a
Group by [YEAR], Brand, Age

union all

select ''New'' as DataType, ''Handicap'' as DemoGroup, HANDICAP as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], HANDICAP) as TotalCount
FROM 
(select year, brand, 
	case when HANDICAP < 6 then 1
	when HANDICAP between 6 and 10 then 2
	 --case when HANDICAP < 11 then 2
	 when HANDICAP between 11 and 15 then 3
	 when HANDICAP between 16 and 20 then 4
	 when HANDICAP > 20 then 5
end as handicap
from cte_PP_new where Brand is not null  and HANDICAP is not null) a
Group by [YEAR], Brand, handicap 

union all

select ''New'' as DataType, ''Frequency'' as DemoGroup, OFTEN_PLAY as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], OFTEN_PLAY) as TotalCount
from 
(select year, brand, 
	 case when OFTEN_PLAY = 1 then 2
	 when OFTEN_PLAY = 2 then 1 
	 when OFTEN_PLAY = 5 then 1
	 when OFTEN_PLAY = 6 then 4
	 else OFTEN_PLAY 
end as OFTEN_PLAY
FROM cte_PP_New  where Brand is not null  and OFTEN_PLAY is not null) a
Group by [YEAR], Brand, OFTEN_PLAY

union all

select ''New'' as DataType, ''Years Of Play'' as DemoGroup, LONG_PLAYED as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], LONG_PLAYED) as TotalCount
from
(select year, brand, 
	 --case when LONG_PLAYED > 4 then 4
	 case when Long_Played = 1 then 1
	 else LONG_PLAYED
end as LONG_PLAYED
FROM cte_PP_New  where Brand is not null  and LONG_PLAYED is not null) a
Group by [YEAR], Brand, LONG_PLAYED

union all

select ''New'' as DataType, ''Course Type'' as DemoGroup, COURSE as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], COURSE) as TotalCount
FROM cte_PP_New  where Brand is not null  and COURSE is not null
Group by [YEAR], Brand, COURSE  '

-------------------------------------------------------


if not(@Equipment = 'Ball' or @Equipment = 'Headgear' or @Equipment = 'Shirt' or @Equipment = 'Glove') -- or @Equipment = 'Bag')
begin
	set @sqlMaintext = '
		; with cte_PP_Total as (
		SELECT [BRAND]
			,[YEARS]
			,p.*
		FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' q
		inner join Consumer.PlayerProfile p on q.PlayerProfileId = p.PlayerProfileId 
		where p.YEAR between ' + cast(@Year - @YearsBack as varchar(4)) + ' and ' + cast(@Year as varchar(4)) + '
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
			,0 as [YEARS]
			,p.*
		FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' q
		inner join Consumer.PlayerProfile p on q.PlayerProfileId = p.PlayerProfileId 
		where p.YEAR between ' + cast(@Year - @YearsBack as varchar(4)) + ' and ' + cast(@Year as varchar(4)) + '
			and COUNTRY in (''' + @Country + ''') 
			and SEASON = ' + cast(@Season as varchar(1)) + ' 
		' + [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment) + '), '
end



set @sqlMaintext = @sqlMaintext + ' cte_pre_data as ( 
select ''Total'' as DataType, ''Total'' as DemoGroup, 1 as DemoSubGroup,  [YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR]) as TotalCount
FROM cte_PP_Total where Brand is not null Group by [YEAR], Brand

union all

select ''Total'' as DataType, ''Sex'' as DemoGroup, Sex as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], sex) as TotalCount
FROM cte_PP_Total  where Brand is not null and Sex is not null
Group by [YEAR], Brand, sex

union all

select ''Total'' as DataType, ''Age'' as DemoGroup, Age as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], Age) as TotalCount
from
(select year, brand, age
	 --case when Age = 1 then 2
	 --case when Age = 6 then 5
	 --Else Age
	 --end as Age
from cte_PP_Total where Brand is not null  and Age is not null) a
Group by [YEAR], Brand, Age

union all

select ''Total'' as DataType, ''Handicap'' as DemoGroup, HANDICAP as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], HANDICAP) as TotalCount
FROM 
(select year, brand, 
	 case when HANDICAP < 6 then 1
	 when HANDICAP between 6 and 10 then 2
	 --case when HANDICAP < 11 then 2
	 when HANDICAP between 11 and 15 then 3
	 when HANDICAP between 16 and 20 then 4
	 when HANDICAP > 20 then 5
end as handicap
from cte_PP_Total where Brand is not null  and HANDICAP is not null) a
Group by [YEAR], Brand, handicap 

union all

select ''Total'' as DataType, ''Frequency'' as DemoGroup, OFTEN_PLAY as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], OFTEN_PLAY) as TotalCount
from 
(select year, brand, 
	 case when OFTEN_PLAY = 1 then 2
	 when OFTEN_PLAY = 2 then 1 
	 when OFTEN_PLAY = 5 then 1
	 when OFTEN_PLAY = 6 then 4
	 else OFTEN_PLAY 
end as OFTEN_PLAY
FROM cte_PP_Total  where Brand is not null  and OFTEN_PLAY is not null) a
Group by [YEAR], Brand, OFTEN_PLAY

union all

select ''Total'' as DataType, ''Years Of Play'' as DemoGroup, LONG_PLAYED as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], LONG_PLAYED) as TotalCount
from
(select year, brand, 
	 --case when LONG_PLAYED > 4 then 4
	 case when Long_Played = 1 then 1
	 else LONG_PLAYED
end as LONG_PLAYED
FROM cte_PP_Total  where Brand is not null  and LONG_PLAYED is not null) a
Group by [YEAR], Brand, LONG_PLAYED

union all


select ''Total'' as DataType, ''Course Type'' as DemoGroup, COURSE as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], COURSE) as TotalCount
FROM cte_PP_Total where Brand is not null  and COURSE is not null
Group by [YEAR], Brand, COURSE ' 


if not(@Equipment = 'Ball' or @Equipment = 'Headgear' or @Equipment = 'Shirt' or @Equipment = 'Glove') -- or @Equipment = 'Bag')
begin
	set @sqlMaintext = @sqlMaintext + ' union all ' + @sqlNew2text
end



set @sqlMaintext = @sqlMaintext + '), 

cte_data as (select *, RANK() over (Partition by DataType, [year], DemoGroup, DemoSubGroup order by BrandCount desc, Brand) as BrandRank
					from cte_pre_data 
					where BRAND not in (' + [DARRELL_MASTER].[Consumer].[BrandExceptionCase]() + ')),


cte_AllBrands as (select distinct q.DataType, Brand, z.year
from cte_data d 
cross join (select distinct Year from cte_data) z
cross join (select ''Total'' as DataType union all Select ''New'' as DataType) q
where d.[year] = ' + cast(@Year as varchar(4)) + ' and (d.BrandRank <13 and d.DemoGroup = ''Total'')
),

----cte_AllBrands as (select distinct DataType, Brand, z.year
----from cte_data d 
----cross join (select distinct Year from cte_data) z
---- where d.[year] = ' + cast(@Year as varchar(4)) + ' and ((d.BrandRank <13 and d.DemoGroup = ''Total'') or (d.BrandRank <6 and d.DemoGroup <> ''Total''))
------group by DataType, Brand
----),

cte_AllPossible as (
select DataType, [Year], sort, z.DemoGroup, z.DemoSubGroup, DemoSubGroupText, Brand, NULL as BrandCount ,NULL as TotalCount
from cte_AllBrands d cross join (select DemoGroup, DemoSubGroup, '
if @Country = 'USA' 
	begin set @sqlMaintext = @sqlMaintext + ' case when DemoSubGroupText = ''Golf Course'' then ''Private Course''
												   when DemoSubGroupText = ''Driving Range'' then ''Public Course''
													else DemoSubGroupText end as ' 
end
set @sqlMaintext = @sqlMaintext + ' DemoSubGroupText, sort from Consumer.Header) z)




select p.DataType, p.[YEAR], sort, p.DemoGroup, p.DemoSubGroup, DemoSubGroupText, p.BRAND,
coalesce(p.brandcount, z.brandcount) as BrandCount,
coalesce(p.totalcount, z.totalcount) as TotalCount,
coalesce(BrandRank,999) as BrandRank
from cte_AllPossible p
left outer join 
(select DataType, [Year], demogroup, DemoSubGroup,
Brand, BrandCount, TotalCount, BrandRank
from cte_data d) z
on p.DataType = z.DataType and 
p.[YEAR] = z.[YEAR] and 
p.BRAND = z.BRAND and 
p.DemoGroup = z.DemoGroup and
p.DemoSubGroup = z.DemoSubGroup 
order by DataType desc, [YEAR] desc, sort asc, demosubgroup, BrandRank asc '


print @sqlMaintext
exec (@sqlMaintext)

end
GO
