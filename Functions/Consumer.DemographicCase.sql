IF OBJECT_ID('Consumer.DemographicCase') IS NOT NULL
    DROP FUNCTION [Consumer].[DemographicCase];
GO

CREATE function [Consumer].[DemographicCase] (@DataType nvarchar(20))
returns varchar(max)
with execute as caller
as
begin
	DECLARE @query AS nvarchar(max) = '

select ''' + @DataType  + ''' as DataType, ''Total'' as DemoGroup, 1 as DemoSubGroup,  [YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR]) as TotalCount
FROM cte_PP_' + @DataType  + ' where Brand is not null Group by [YEAR], Brand

union all

select ''' + @DataType  + ''' as DataType, ''Sex'' as DemoGroup, Sex as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], sex) as TotalCount
FROM cte_PP_' + @DataType  + ' where Brand is not null and Sex is not null
Group by [YEAR], Brand, sex

union all

select ''' + @DataType  + ''' as DataType, ''Age'' as DemoGroup, Age as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], Age) as TotalCount
FROM cte_PP_' + @DataType  + ' 
where Brand is not null  and Age is not null
Group by [YEAR], Brand, Age

union all

select ''' + @DataType  + ''' as DataType, ''Handicap'' as DemoGroup, HANDICAP as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], HANDICAP) as TotalCount
FROM 
(select year, brand, 
	 case when HANDICAP < 6 then 1
	 when HANDICAP between 6 and 10 then 2
	 when HANDICAP between 11 and 15 then 3
	 when HANDICAP between 16 and 20 then 4
	 when HANDICAP > 20 then 5
end as handicap
from cte_PP_' + @DataType  + ' where Brand is not null  and HANDICAP is not null) a
Group by [YEAR], Brand, handicap 

union all

select ''' + @DataType  + ''' as DataType, ''Frequency'' as DemoGroup, OFTEN_PLAY as DemoSubGroup,[YEAR], Brand,
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
FROM cte_PP_' + @DataType  + '  where Brand is not null  and OFTEN_PLAY is not null) a
Group by [YEAR], Brand, OFTEN_PLAY

union all

select ''' + @DataType  + ''' as DataType, ''YearsOfPlay'' as DemoGroup, LONG_PLAYED as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], LONG_PLAYED) as TotalCount
FROM cte_PP_' + @DataType  + '  where Brand is not null  and LONG_PLAYED is not null
Group by [YEAR], Brand, LONG_PLAYED

union all

select ''' + @DataType  + ''' as DataType, ''CourseType'' as DemoGroup, COURSE as DemoSubGroup,[YEAR], Brand,
COUNT(Brand) as BrandCount,
SUM(count(Brand)) over (partition by [YEAR], COURSE) as TotalCount
FROM cte_PP_' + @DataType  + '  where Brand is not null  and COURSE is not null
Group by [YEAR], Brand, COURSE  '		
				
return @query
	
END;
GO
