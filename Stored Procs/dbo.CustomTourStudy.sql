IF OBJECT_ID('dbo.CustomTourStudy') IS NOT NULL
    DROP PROCEDURE [dbo].[CustomTourStudy];
GO

CREATE PROCEDURE [dbo].[CustomTourStudy]
(@Year as Smallint,
 @Equipment as nvarchar(50))
AS
BEGIN

--exec [dbo].[CustomTourStudy] 2021, 'Ball'

Declare @get_column_names_only bit = 0
if @get_column_names_only = 1
select 'z' as n, 'a' as TOUR, 'b' as [TOURNAMENT NAME], 'c' as [FIRST DAY],'d' as BRAND, 1 as BrandTotal, 1 as EventTotal,
		1 as GlobalTotal, 1 as GlobalPlace
		
DECLARE @query AS nvarchar(MAX)

SET @query = '	;with cte_tournament as (
			SELECT RANK() over (Partition by tour order by COUNT([BRAND]) desc) as n,
		   [TOUR],[TOURNAMENT NAME],[FIRST DAY], [BRAND],COUNT([BRAND]) as BrandTotal,
		   SUM(COUNT([BRAND])) over (partition by tour, [TOURNAMENT NAME], [FIRST DAY] )as EventTotal FROM '


DECLARE @EquipCase AS nvarchar(MAX)
exec [Search].[EquipmentTableCase] @Equipment, @EquipCase OUT
DECLARE @WhereCase AS nvarchar(MAX)			
exec [Search].[EquipmentWhereCase] @Equipment, @WhereCase OUT
  
SET @query = @query + @EquipCase + @WhereCase +
--  ' TOUR in (''ONEASIA'', ''JLPGA'', ''JGTO'', ''CLPGA'', ''PGACHINA'') and year([FIRST DAY]) = ' + cast(@Year as varchar(4)) + '
  ' year([FIRST DAY]) = ' + cast(@Year as varchar(4)) + '
  group by [TOUR],[TOURNAMENT NAME],[FIRST DAY],[BRAND]),

cte_top as (
	SELECT RANK() over (Partition by tour order by sum(BrandTotal) desc) as n,
		   [TOUR],[BRAND],sum(BrandTotal) as BrandTotal
    FROM cte_tournament
	group by [TOUR],[BRAND])

select t.*, cte_top.BrandTotal as GlobalTotal, cte_top.n as GlobalPlace from cte_tournament t
inner join cte_top on t.TOUR = cte_top.tour and t.brand = cte_top.brand
--Where cte_top.n < 6  
order by t.TOUR, [FIRST DAY], t.n  '
  
--where cte_top.Brand = ''' + @Brand + ''' or cte_top.n < 6  

print @query

exec(@query)
    
END
GO
