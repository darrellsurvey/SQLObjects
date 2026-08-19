IF OBJECT_ID('MoneyClip.Multi-Tour Counts_By_Model') IS NOT NULL
    DROP PROCEDURE [MoneyClip].[Multi-Tour Counts_By_Model];
GO

CREATE PROCEDURE [MoneyClip].[Multi-Tour Counts_By_Model]
(@FirstDay as date,
 @LastDay as date,
 @Tour as nvarchar(MAX),
 @Equipment as nvarchar(50),
 @Brand as nvarchar(50))
 
AS
BEGIN

Declare @tourSort nvarchar(MAX) = @tour
set @tour = '''' + replace(@tour, ', ', ''',''') + ''''

Declare @get_column_names_only bit = 0
if @get_column_names_only = 1
select 'a' as MODEL, 'b' as PGA, 'c' as [WEB.COM], 'q' as [KORN FERRY],
		'd' as NATIONWIDE, 'e' as CHAMPIONS, 'f' as LPGA,
		'g' as JGTO, 'h' as JLPGA, 'i' as CLPGA, 'j' as OTHER, 'k' AMATEUR, 'l' as ONEASIA,
		'n' as [BUY.COM], 'n' as JGA
		

DECLARE @query AS varchar(MAX)
SET @query = 'select [MODEL],
	sum(case when [TOUR] = ''PGA'' then 1 else 0 end) as ''PGA'',
	SUM(case when [TOUR] = ''WEB.COM'' then 1 else 0 end) as ''WEB.COM'',
	SUM(case when [TOUR] = ''KORN FERRY'' then 1 else 0 end) as ''KORN FERRY'',
	sum(case when [TOUR] = ''NATIONWIDE'' then 1 else 0 end) as ''NATIONWIDE'',
	SUM(case when [TOUR] = ''CHAMPIONS'' then 1 else 0 end) as ''CHAMPIONS'',
	sum(case when [TOUR] = ''LPGA'' then 1 else 0 end) as ''LPGA'',
	sum(case when [TOUR] = ''JGTO'' then 1 else 0 end) as ''JGTO'',
	sum(case when [TOUR] = ''JLPGA'' then 1 else 0 end) as ''JLPGA'',
	sum(case when [TOUR] = ''CLPGA'' then 1 else 0 end) as ''CLPGA'',
	sum(case when [TOUR] = ''OTHER'' then 1 else 0 end) as ''OTHER'',
	sum(case when [TOUR] = ''AMATEUR'' then 1 else 0 end) as ''AMATEUR'',
	sum(case when [TOUR] = ''ONEASIA'' then 1 else 0 end) as ''ONEASIA'',
	sum(case when [TOUR] = ''BUY.COM'' then 1 else 0 end) as ''BUY.COM'',
	sum(case when [TOUR] = ''JGA'' then 1 else 0 end) as ''JGA''

	
from (SELECT [TOUR],[FIRST DAY],[BRAND], [MODEL] FROM '


DECLARE @EquipCase AS nvarchar(MAX)
DECLARE @WhereCase AS nvarchar(MAX)
			
exec [Search].[EquipmentTableCase] @Equipment, @EquipCase OUT
exec [Search].[EquipmentWhereCase] @Equipment, @WhereCase OUT
  
SET @query = @query + @EquipCase + @WhereCase +
  '[FIRST DAY] between ''' + cast(@FirstDay as varchar(20)) + ''' and ''' + cast(@LastDay as varchar(20)) + '''
  and [TOUR] in (' + @tour + ') and [Brand] = ''' + @Brand + ''') a
  group by 	[MODEL]
  order by '

if CHARINDEX(',', @tourSort) > 0 
	SET @query = @query + '[MODEL] ASC'
else
	SET @query = @query + '[' + @tourSort + '] DESC, MODEL'
	
print @query
  
exec(@query)
  
    
END
GO
