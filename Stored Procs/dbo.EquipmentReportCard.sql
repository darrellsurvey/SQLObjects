DROP PROCEDURE IF EXISTS [dbo].[EquipmentReportCard];
GO

--execute [dbo].[EquipmentReportCard] 'Ball', 2019

CREATE PROCEDURE [dbo].[EquipmentReportCard]
(@Equipment as nvarchar(50),
 @Year as int)
AS
BEGIN


Declare @get_column_names_only bit = 0
if @get_column_names_only = 1
select 'a' as TOUR, 'b' as PlayYear, 'c' as BRAND, 'd' as BrandCount, 'd' as YearTourCount,
		'f' as BrandRank, 'g' as TourSort
		

DECLARE @EquipCase AS nvarchar(MAX)
exec [Search].[EquipmentTableCase] @Equipment, @EquipCase OUT
DECLARE @WhereCase AS nvarchar(MAX)			
exec [Search].[EquipmentWhereCase] @Equipment, @WhereCase OUT
DECLARE @query AS nvarchar(MAX)

SET @query = '	;with cte1 as (SELECT [TOUR]
      ,Year([FIRST DAY]) as PlayYear
      ,[BRAND]
      ,COUNT([BRAND]) as BrandCount
      ,sum(COUNT([BRAND])) over(partition by [TOUR],Year([FIRST DAY])) as YearTourCount
      ,Rank() over(partition by [TOUR],Year([FIRST DAY]) order by COUNT([BRAND]) desc) as BrandRank,
case TOUR when ''PGA'' then 1 
		 when ''WEB.COM'' then 2 
		 when ''CHAMPIONS'' then 3 					 
		 when ''LPGA'' then 4 
		 when ''JGTO'' then 5 
		 when ''JLPGA'' then 6 
		 when ''CANADA'' then 7 
		 when ''LATINOAMERICA'' then 8 
		 when ''AMATEUR'' then 9 
		 else 10 end as TourSort
  FROM '

SET @query = @query + @EquipCase + @WhereCase +  
  
  ' 1 = 1 
    group by [TOUR],Year([FIRST DAY]),[BRAND])

	select a.* from cte1 a inner join (select Brand, Tour from cte1 where PlayYear = ' + cast(@Year as varchar(4)) + ' and BrandRank < 8) b
	on a.Brand = b.Brand and a.Tour = b.Tour
    order by TourSort, PlayYear desc,BrandCount desc'


print @query

exec(@query)
    
END
GO
