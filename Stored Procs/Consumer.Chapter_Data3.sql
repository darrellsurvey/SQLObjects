DROP PROCEDURE IF EXISTS [Consumer].[Chapter_Data3];
GO

CREATE procedure [Consumer].[Chapter_Data3]
(@Equipment varchar(20),
@Country varchar(100),
@Year smallint,
@Season tinyint,
@YearsBack tinyint)

as
begin
set nocount on;


--exec [Consumer].[Chapter_Data3] 'Woods - Driver', 'Korea', 2024, 4, 14

declare @sqlNew1text as varchar(max)
declare @sqlNew2text as varchar(max)
declare @sqlMaintext as varchar(max)


if 2 = 1
begin
SELECT 'a' as DataType, 
		1 as sort, 
		'Total' AS demogroup, 
		1 as DemoSubGroup,
		'a' as DemoSubGroupText,
		'b' as Brand,
		1 AS PrevYear, 
		1 as NowYear,
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
select ''New'' as DataType, 1 as sort, ''Total'' as DemoGroup, 1 as DemoSubGroup,  [YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR]) as TotalCount
FROM cte_PP_new where Brand is not null Group by [YEAR], Brand

union all

select ''New'' as DataType, 2 as sort, ''Sex'' as DemoGroup, Sex as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], sex) as TotalCount
FROM cte_PP_new where Brand is not null and Sex is not null
Group by [YEAR], Brand, sex

union all

select ''New'' as DataType, 3 as sort, ''Age'' as DemoGroup, Age as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], Age) as TotalCount
FROM
(select year, brand, age
	 --case when Age = 1 then 2
	 --when Age = 6 then 5
	 --case when Age = 6 then 5
	 --Else Age
	 --end as Age
from cte_PP_new where Brand is not null  and Age is not null) a
Group by [YEAR], Brand, Age


union all

select ''New'' as DataType, 4 as sort, ''Handicap'' as DemoGroup, HANDICAP as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], HANDICAP) as TotalCount
FROM 
(select year, brand, 
	 --case when HANDICAP < 11 then 2
	 case when HANDICAP < 6 then 1
	 when HANDICAP between 6 and 10 then 2
	 when HANDICAP between 11 and 15 then 3
	 when HANDICAP between 16 and 20 then 4
	 when HANDICAP > 20 then 5
end as handicap
from cte_PP_new where Brand is not null  and HANDICAP is not null) a
Group by [YEAR], Brand, handicap 

union all

select ''New'' as DataType, 5 as sort, ''Frequency'' as DemoGroup, OFTEN_PLAY as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], OFTEN_PLAY) as TotalCount
FROM
(select year, brand, 
	 case when OFTEN_PLAY = 1 then 2
	 when OFTEN_PLAY = 2 then 1 
	 when OFTEN_PLAY = 5 then 1
	 when OFTEN_PLAY = 6 then 4
	 else OFTEN_PLAY end as OFTEN_PLAY
FROM cte_PP_new where Brand is not null  and OFTEN_PLAY is not null) a
Group by [YEAR], Brand, OFTEN_PLAY

union all

select ''New'' as DataType, 6 as sort, ''Years Of Play'' as DemoGroup, LONG_PLAYED as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], LONG_PLAYED) as TotalCount
FROM cte_PP_New  where Brand is not null  and LONG_PLAYED is not null
Group by [YEAR], Brand, LONG_PLAYED

union all

select ''New'' as DataType, 7 as sort, ''Course Type'' as DemoGroup, COURSE as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], COURSE) as TotalCount
FROM cte_PP_New  where Brand is not null  and COURSE is not null
Group by [YEAR], Brand, COURSE '

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


set @sqlMaintext = @sqlMaintext + ' cte_data as ( 
select ''Total'' as DataType, 1 as sort, ''Total'' as DemoGroup, 1 as DemoSubGroup,  [YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR]) as TotalCount
FROM cte_PP_Total where Brand is not null Group by [YEAR], Brand

union all

select ''Total'' as DataType, 2 as sort, ''Sex'' as DemoGroup, Sex as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], sex) as TotalCount
FROM cte_PP_Total  where Brand is not null and Sex is not null
Group by [YEAR], Brand, sex

union all

select ''Total'' as DataType, 3 as sort, ''Age'' as DemoGroup, Age as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], Age) as TotalCount
FROM
(select year, brand, age
	 --case when Age = 1 then 2
	 --case when Age = 6 then 5
	 --Else Age
	 --end as Age
from cte_PP_Total where Brand is not null  and Age is not null) a
Group by [YEAR], Brand, Age




union all

select ''Total'' as DataType, 4 as sort, ''Handicap'' as DemoGroup, HANDICAP as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], HANDICAP) as TotalCount
FROM 
(select year, brand, 
		--case when HANDICAP < 11 then 2
	 case when HANDICAP < 6 then 1
	 when HANDICAP between 6 and 10 then 2
	 when HANDICAP between 11 and 15 then 3
	 when HANDICAP between 16 and 20 then 4
	 when HANDICAP > 20 then 5
end as handicap
from cte_PP_Total where Brand is not null  and HANDICAP is not null) a
Group by [YEAR], Brand, handicap 

union all

select ''Total'' as DataType, 5 as sort, ''Frequency'' as DemoGroup, OFTEN_PLAY as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], OFTEN_PLAY) as TotalCount
FROM
(select year, brand, 
	 case when OFTEN_PLAY = 1 then 2
	 when OFTEN_PLAY = 2 then 1 
	 when OFTEN_PLAY = 5 then 1
	 when OFTEN_PLAY = 6 then 4
	 else OFTEN_PLAY end as OFTEN_PLAY
FROM cte_PP_total where Brand is not null  and OFTEN_PLAY is not null) a
Group by [YEAR], Brand, OFTEN_PLAY

union all

select ''Total'' as DataType, 6 as sort, ''Years Of Play'' as DemoGroup, LONG_PLAYED as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], LONG_PLAYED) as TotalCount
FROM cte_PP_Total where Brand is not null and LONG_PLAYED is not null
Group by [YEAR], Brand, LONG_PLAYED

union all


select ''Total'' as DataType, 7 as sort, ''Course Type'' as DemoGroup, COURSE as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], COURSE) as TotalCount
FROM cte_PP_Total where Brand is not null  and COURSE is not null
Group by [YEAR], Brand, COURSE ' 


if not(@Equipment = 'Ball' or @Equipment = 'Headgear' or @Equipment = 'Shirt' or @Equipment = 'Glove') -- or @Equipment = 'Bag')
begin
	set @sqlMaintext = @sqlMaintext + ' union all ' + @sqlNew2text
end




set @sqlMaintext = @sqlMaintext + '), 
cte_2 as (select DataType, [Year], sort, demogroup, DemoSubGroup, 
case when demogroup = ''Total'' and DemoSubGroup = 1 then ''Total'' 
	 when demogroup = ''Sex'' and DemoSubGroup = 1 then ''Male'' 
	 when demogroup = ''Sex'' and DemoSubGroup = 2 then ''Female'' 
	 when demogroup = ''Age'' and DemoSubGroup = 1 then ''20 & Under'' 
	 when demogroup = ''Age'' and DemoSubGroup = 2 then ''21 - 30'' 
	 when demogroup = ''Age'' and DemoSubGroup = 2 then ''30 & Under'' 
	 when demogroup = ''Age'' and DemoSubGroup = 3 then ''31 - 40'' 
	 when demogroup = ''Age'' and DemoSubGroup = 4 then ''41 - 50'' 
	 --when demogroup = ''Age'' and DemoSubGroup = 5 then ''51 & Up'' 
	 when demogroup = ''Age'' and DemoSubGroup = 5 then ''51 - 60'' 
	 when demogroup = ''Age'' and DemoSubGroup = 6 then ''61 & Up'' 
	 when demogroup = ''Handicap'' and DemoSubGroup = 1 then ''5 & Under'' 
	 when demogroup = ''Handicap'' and DemoSubGroup = 2 then ''6 - 10'' 
	 --when demogroup = ''Handicap'' and DemoSubGroup = 2 then ''10 & Under'' 
	 when demogroup = ''Handicap'' and DemoSubGroup = 3 then ''11 - 15'' 
	 when demogroup = ''Handicap'' and DemoSubGroup = 4 then ''16 - 20'' 
	 when demogroup = ''Handicap'' and DemoSubGroup = 5 then ''21 & Over'' 
	 when demogroup = ''Frequency'' and DemoSubGroup = 1 then ''> 1x week''  
	 when demogroup = ''Frequency'' and DemoSubGroup = 2 then ''1x week''
	 when demogroup = ''Frequency'' and DemoSubGroup = 3 then ''1-3 month'' 
	 when demogroup = ''Frequency'' and DemoSubGroup = 4 then ''< 1x month'' 
	 when demogroup = ''Years Of Play'' and DemoSubGroup = 1 then ''1 & Under'' 
	 when demogroup = ''Years Of Play'' and DemoSubGroup = 2 then ''2 - 5 years'' 
	 when demogroup = ''Years Of Play'' and DemoSubGroup = 3 then ''6 - 10 years'' 
	 when demogroup = ''Years Of Play'' and DemoSubGroup = 4 then ''11 - 15 years'' 
	 when demogroup = ''Years Of Play'' and DemoSubGroup = 5 then ''16 - 20 years''
	 when demogroup = ''Years Of Play'' and DemoSubGroup = 6 then ''21 years & up''
	 when demogroup = ''Course Type'' and DemoSubGroup = 1 then ' 
if @Country = 'USA' 
	begin set @sqlMaintext = @sqlMaintext + '''Private Course'' when demogroup = ''Course Type'' and DemoSubGroup = 2 then ''Public Course''' end 
	else begin set @sqlMaintext = @sqlMaintext + '''Golf Course'' when demogroup = ''Course Type'' and DemoSubGroup = 2 then ''Driving Range''' end


set @sqlMaintext = @sqlMaintext + '
end as DemoSubGroupText,
Brand, BrandCount * 100.0 / TotalCount as BrandPercent  from cte_data),

cte_3 as (
select * from cte_2
pivot (sum(BrandPercent) for [Year] in ([' + cast(@Year - 5 as varchar(4)) + '],[' + cast(@Year as varchar(4)) +'])) p)


select DataType, sort, demogroup, DemoSubGroup,DemoSubGroupText, Brand,
		[' + cast(@Year - 5 as varchar(4)) + '] as PrevYear, 
		[' + cast(@Year as varchar(4)) +'] as NowYear, 
		RANK() over (Partition by DataType, sort, DemoSubGroup order by [' + cast(@Year as varchar(4)) +'] desc, brand) as BrandRank
from cte_3
where BRAND not in (' + [DARRELL_MASTER].[Consumer].[BrandExceptionCase]() + ') '


print @sqlMaintext
exec (@sqlMaintext)



/*
select ''New'' as DataType, 3 as sort, ''Age'' as DemoGroup, Age as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], Age) as TotalCount
FROM (select year, brand, 
	 case when Age = 6 then 5
	 else Age
end as Age
from cte_PP_New where Brand is not null  and Age is not null) a
Group by [YEAR], Brand, Age




select ''Total'' as DataType, 3 as sort, ''Age'' as DemoGroup, Age as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], Age) as TotalCount
FROM (select year, brand, 
	 case when Age = 6 then 5
	 else Age
end as Age
from cte_PP_Total where Brand is not null  and Age is not null) a
Group by [YEAR], Brand, Age
*/


end
GO
