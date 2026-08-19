DROP PROCEDURE IF EXISTS [dbo].[CustomTourStudyYearly];
GO

CREATE PROCEDURE [dbo].[CustomTourStudyYearly]
(@YearFrom as Smallint,
 @YearTo as Smallint,
 @Equipment as nvarchar(50))
AS
BEGIN


Declare @get_column_names_only bit = 0
if @get_column_names_only = 1
select 'z' as RankYear, 'a' as TOUR, 1 as [Year], 'd' as BRAND, 1 as BrandTotal, 1 as YearTotal,
		1 as GlobalTotal, 1 as GlobalPlace
		
DECLARE @query AS nvarchar(MAX)

SET @query = '	with cte_years as (
			SELECT RANK() over (Partition by case when tour = ''Nationwide'' or tour = ''Web.Com'' then ''KORN FERRY'' Else tour end, year([FIRST DAY]) order by COUNT([BRAND]) desc) as RankYear,
		   case when tour = ''Nationwide'' or tour = ''Web.Com'' then ''KORN FERRY'' Else tour end as tour,year([FIRST DAY]) as [Year], [BRAND],COUNT([BRAND]) as BrandTotal,
		   SUM(COUNT([BRAND])) over (partition by case when tour = ''Nationwide'' or tour = ''Web.Com'' then ''KORN FERRY'' Else tour end, year([FIRST DAY]))as YearTotal FROM '


DECLARE @EquipCase AS nvarchar(MAX)
exec [Search].[EquipmentTableCase] @Equipment, @EquipCase OUT
DECLARE @WhereCase AS nvarchar(MAX)			
exec [Search].[EquipmentWhereCase] @Equipment, @WhereCase OUT
  
SET @query = @query + @EquipCase + @WhereCase +
  ' year([FIRST DAY]) between ' + cast(@YearFrom as varchar(4)) + ' and ' + cast(@YearTo as varchar(4)) + '
  group by case when tour = ''Nationwide'' or tour = ''Web.Com'' then ''KORN FERRY'' Else tour end,year([FIRST DAY]),[BRAND]),

cte_top as (
	SELECT RANK() over (Partition by tour order by sum(BrandTotal) desc) as n,
		   [TOUR],[BRAND],sum(BrandTotal) as BrandTotal
    FROM cte_years
	group by [TOUR],[BRAND])

select t.*, cte_top.BrandTotal as GlobalTotal, cte_top.n as GlobalPlace 
from cte_years t
inner join cte_top on t.TOUR = cte_top.tour and t.brand = cte_top.brand
Where cte_top.n < 6  
order by t.TOUR, [Year], cte_top.n   '
  
--where cte_top.Brand = ''' + @Brand + ''' or cte_top.n < 6  

print @query

exec(@query)
    
END
GO
