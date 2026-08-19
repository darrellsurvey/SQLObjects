IF OBJECT_ID('MoneyClip.Multi-Tour Counts') IS NOT NULL
    DROP PROCEDURE [MoneyClip].[Multi-Tour Counts];
GO

CREATE PROCEDURE [MoneyClip].[Multi-Tour Counts]
(@FirstDay as date,
 @lastDay as date,
 @Tour as nvarchar(MAX),
 @Equipment as nvarchar(50))
AS
BEGIN

Declare @tourSort nvarchar(MAX) = @tour
set @tour = '''' + replace(@tour, ', ', ''',''') + ''''

Declare @get_column_names_only bit = 0
if @get_column_names_only = 1
select 'a' as BRAND, 'b' as PGA, 'c' as [WEB.COM],
		'd' as NATIONWIDE, 'q' as KORNFERRY, 'e' as CHAMPIONS, 'f' as LPGA,
		'g' as JGTO, 'h' as JLPGA, 'i' as CLPGA, 'j' as OTHER, 'k' AMATEUR, 'l' as ONEASIA,
		'm' as [BUY.COM], 'n' as JGA, 'o' as CANADA, 'p' as LATINOAMERICA
		
		

DECLARE @query AS varchar(MAX)
SET @query = '
select [Brand],
	sum(case when [TOUR] = ''PGA'' then 1 else 0 end) as ''PGA'',
	SUM(case when [TOUR] = ''WEB.COM'' then 1 else 0 end) as ''WEB.COM'',
	sum(case when [TOUR] = ''NATIONWIDE'' then 1 else 0 end) as ''NATIONWIDE'',
	sum(case when [TOUR] = ''KORN FERRY'' then 1 else 0 end) as ''KORNFERRY'',
	SUM(case when [TOUR] = ''CHAMPIONS'' then 1 else 0 end) as ''CHAMPIONS'',
	sum(case when [TOUR] = ''LPGA'' then 1 else 0 end) as ''LPGA'',
	sum(case when [TOUR] = ''JGTO'' then 1 else 0 end) as ''JGTO'',
	sum(case when [TOUR] = ''JLPGA'' then 1 else 0 end) as ''JLPGA'',
	sum(case when [TOUR] = ''CLPGA'' then 1 else 0 end) as ''CLPGA'',
	sum(case when [TOUR] = ''OTHER'' then 1 else 0 end) as ''OTHER'',
	sum(case when [TOUR] = ''AMATEUR'' then 1 else 0 end) as ''AMATEUR'',
	sum(case when [TOUR] = ''ONEASIA'' then 1 else 0 end) as ''ONEASIA'',
	sum(case when [TOUR] = ''BUY.COM'' then 1 else 0 end) as ''BUY.COM'',
	sum(case when [TOUR] = ''CANADA'' then 1 else 0 end) as ''CANADA'',
	sum(case when [TOUR] = ''LATINOAMERICA'' then 1 else 0 end) as ''LATINOAMERICA'',
	sum(case when [TOUR] = ''JGA'' then 1 else 0 end) as ''JGA''
	
from (SELECT [TOUR],[FIRST DAY],[BRAND] FROM '


DECLARE @EquipCase AS nvarchar(MAX)
DECLARE @WhereCase AS nvarchar(MAX)
			
exec [Search].[EquipmentTableCase] @Equipment, @EquipCase OUT
exec [Search].[EquipmentWhereCase] @Equipment, @WhereCase OUT
  
SET @query = @query + @EquipCase + @WhereCase +
  '[FIRST DAY] between ''' + cast(@FirstDay as varchar(20)) + ''' and ''' + cast(@LastDay as varchar(20)) + '''
  and [TOUR] in (' + @tour + ')) a
  group by 	[BRAND]
  order by '

if CHARINDEX(',', @tourSort) > 0 
	SET @query = @query + '[Brand] ASC'
else
	SET @query = @query + '[' + @tourSort + '] DESC'
	
print @query  
exec(@query)
  
    
END
GO
