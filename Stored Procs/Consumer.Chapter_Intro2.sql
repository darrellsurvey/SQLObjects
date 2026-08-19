DROP PROCEDURE IF EXISTS [Consumer].[Chapter_Intro2];
GO

CREATE procedure [Consumer].[Chapter_Intro2]
(@Country varchar(20),
@Year smallint,
@Season tinyint,
@YearsBack tinyint)

as
begin
set nocount on;

--exec [Consumer].[Chapter_Intro2] 'USA', 2019,3,4

declare @sqlMaintext as varchar(Max)


if 2 = 1
begin
SELECT	2014 as [Year], 
		1 as sort, 
		'Total' AS demogroup, 
		1 as DemoSubGroup,
		'a' as DemoSubGroupText,
		1 AS BrandCount, 
		1 as TotalCount
end

	set @sqlMaintext = '
		; with cte_PP_Total as (
		SELECT *
		FROM Consumer.PlayerProfile p
		where p.YEAR between ' + cast(@Year - @YearsBack as varchar(4)) + ' and ' + cast(@Year as varchar(4)) + '
			and COUNTRY = ''' + @Country + ''' 
			and SEASON = ' + cast(@Season as varchar(1)) + ' ), 

cte_data as (
select 1 as sort, ''Total'' as DemoGroup, 1 as DemoSubGroup,  [YEAR], 
COUNT(*) as BrandCount,
SUM(count(*)) over (partition by [YEAR]) as TotalCount
FROM cte_PP_Total Group by [YEAR]

union all
 
select 2 as sort, ''Sex'' as DemoGroup, Sex as DemoSubGroup,[YEAR],
COUNT(*) as BrandCount,
SUM(count(*)) over (partition by [YEAR]) as TotalCount
FROM cte_PP_Total  where Sex is not null
Group by [YEAR], sex

union all

select 3 as sort, ''Age'' as DemoGroup, Age as DemoSubGroup,[YEAR],
COUNT(*) as BrandCount,
SUM(count(*)) over (partition by [YEAR]) as TotalCount
FROM (select year,  
	 case when Age = 2 then 1
	 when Age = 6 then 5 
	 else Age 
	 end as Age
from cte_PP_Total where Age is not null) a 
Group by [YEAR], Age

union all

select 5 as sort, ''Handicap'' as DemoGroup, HANDICAP as DemoSubGroup,[YEAR],
COUNT(*) as BrandCount,
SUM(count(*)) over (partition by [YEAR]) as TotalCount
FROM 
(select year,  
	 case when HANDICAP < 6 then 1
	 when HANDICAP between 6 and 10 then 2
	 when HANDICAP between 11 and 15 then 3
	 when HANDICAP between 16 and 20 then 4
	 when HANDICAP > 20 then 5
end as handicap
from cte_PP_Total where HANDICAP is not null) a
Group by [YEAR], handicap 

union all

select 6 as sort, ''Frequency: Course'' as DemoGroup, OFTEN_PLAY as DemoSubGroup,[YEAR], 
COUNT(*) as BrandCount,
SUM(count(*)) over (partition by [YEAR]) as TotalCount
FROM (select year, case when OFTEN_PLAY = 1 then 2
	 when OFTEN_PLAY = 2 then 1 
	 when OFTEN_PLAY = 4 then 3
	 when OFTEN_PLAY = 5 then 1  
	 when OFTEN_PLAY = 6 then 3 
	 else OFTEN_PLAY 
	 end as OFTEN_PLAY
from cte_PP_Total where OFTEN_PLAY is not null) a
Group by [YEAR], OFTEN_PLAY

union all

select 7 as sort, ''Frequency: Range'' as DemoGroup, OFTEN_PLAY_DR as DemoSubGroup,[YEAR], 
COUNT(*) as BrandCount,
SUM(count(*)) over (partition by [YEAR]) as TotalCount
FROM (select year, case when OFTEN_PLAY_DR = 1 then 2
	 when OFTEN_PLAY_DR = 2 then 1 
	 when OFTEN_PLAY_DR = 4 then 3
	 when OFTEN_PLAY_DR = 5 then 1  
	 when OFTEN_PLAY_DR = 6 then 3 
	 else OFTEN_PLAY_DR 
	 end as OFTEN_PLAY_DR
from cte_PP_Total where OFTEN_PLAY_DR is not null) a
Group by [YEAR], OFTEN_PLAY_DR

union all

select 4 as sort, ''Years of Play'' as DemoGroup, LONG_PLAYED as DemoSubGroup,[YEAR], 
COUNT(*) as BrandCount,
SUM(count(*)) over (partition by [YEAR]) as TotalCount
FROM (select year, 
case when LONG_PLAYED = 1 then 1
	 when LONG_PLAYED = 2 then 1 
	 when LONG_PLAYED = 3 then 2
	 when LONG_PLAYED = 4 then 2  
	 when LONG_PLAYED = 5 then 3 
	 when LONG_PLAYED = 6 then 3
	 else LONG_PLAYED 
	 end as LONG_PLAYED
from cte_PP_Total where LONG_PLAYED is not null) a
Group by [YEAR], LONG_PLAYED)



select [Year], sort, demogroup, DemoSubGroup, 
case when demogroup = ''Total'' and DemoSubGroup = 1 then ''Total'' 
	 when demogroup = ''Sex'' and DemoSubGroup = 1 then ''Male'' 
	 when demogroup = ''Sex'' and DemoSubGroup = 2 then ''Female'' 
	 when demogroup = ''Age'' and DemoSubGroup = 1 then ''30 & Under'' 
	 when demogroup = ''Age'' and DemoSubGroup = 3 then ''31 - 40'' 
	 when demogroup = ''Age'' and DemoSubGroup = 4 then ''41 - 50'' 
	 when demogroup = ''Age'' and DemoSubGroup = 5 then ''51 & up '' 
	 when demogroup = ''Handicap'' and DemoSubGroup = 1 then ''5 & Under'' 
	 when demogroup = ''Handicap'' and DemoSubGroup = 2 then ''6 - 10'' 
	 when demogroup = ''Handicap'' and DemoSubGroup = 3 then ''11 - 15'' 
	 when demogroup = ''Handicap'' and DemoSubGroup = 4 then ''16 - 20'' 
	 when demogroup = ''Handicap'' and DemoSubGroup = 5 then ''20 & Over'' 
	 when demogroup = ''Frequency: Course'' and DemoSubGroup = 1 then ''> 1x week''  
	 when demogroup = ''Frequency: Course'' and DemoSubGroup = 2 then ''1x week''
	 when demogroup = ''Frequency: Course'' and DemoSubGroup = 3 then ''< 1x month'' 
	 when demogroup = ''Frequency: Range'' and DemoSubGroup = 1 then ''> 1x week''  
	 when demogroup = ''Frequency: Range'' and DemoSubGroup = 2 then ''1x week''
	 when demogroup = ''Frequency: Range'' and DemoSubGroup = 3 then ''< 1x month'' 
	 when demogroup = ''Years of Play'' and DemoSubGroup = 1 then ''5 & Under'' 
	 when demogroup = ''Years of Play'' and DemoSubGroup = 2 then ''6 - 15 years'' 
	 when demogroup = ''Years of Play'' and DemoSubGroup = 3 then ''16 & Over''

end as DemoSubGroupText,
BrandCount, TotalCount from cte_data
order by [YEAR] desc, sort asc, DemoSubGroup'


print @sqlMaintext
exec (@sqlMaintext)

end
GO
