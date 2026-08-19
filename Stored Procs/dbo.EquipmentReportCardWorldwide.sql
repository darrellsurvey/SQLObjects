IF OBJECT_ID('dbo.EquipmentReportCardWorldwide') IS NOT NULL
    DROP PROCEDURE [dbo].[EquipmentReportCardWorldwide];
GO

CREATE PROCEDURE [dbo].[EquipmentReportCardWorldwide]
(@Equipment as nvarchar(50),
 @YearNow as smallInt,
 @YearsBack as smallint,
 @TopBrands as smallint,
 @Tour as varchar(max))

AS
BEGIN

set @tour = '''' + replace(@tour, ', ', ''',''') + ''''

Declare @get_column_names_only bit = 0
if @get_column_names_only = 1
select 'a' as Brand, 'b' as PlayYear, 'd' as BrandTotal, 'd' as YearTotal,
		'f' as rn
		

DECLARE @EquipCase AS nvarchar(MAX)
exec [Search].[EquipmentTableCase] @Equipment, @EquipCase OUT
DECLARE @WhereCase AS nvarchar(MAX)			
exec [Search].[EquipmentWhereCase] @Equipment, @WhereCase OUT
DECLARE @query AS nvarchar(MAX)


SET @query = '	
;with cte1 as (SELECT [BRAND] as Brand, 
		YEAR([FIRST DAY]) as PlayYear, 
		count([BRAND]) as BrandTotal, 
		sum(count([BRAND])) over(partition by YEAR([FIRST DAY])) as YearTotal, 
		RANK() over(partition by YEAR([FIRST DAY]) order by count([BRAND]) desc) as rn
FROM '

SET @query = @query + @EquipCase + @WhereCase +  

' YEAR([FIRST DAY]) > ' + cast(@YearNow - @YearsBack as varchar(4)) + ' and Tour in (' + @Tour + ') 
group by  [BRAND], YEAR([FIRST DAY]))

select * from cte1 where Brand in (select Brand from cte1 where rn <= ' + cast(@TopBrands as varchar(3)) + ' and PlayYear = ' + cast(@YearNow as varchar(4)) + ') ' 

 

print @query

exec(@query)
    
END
GO
