IF OBJECT_ID('dbo.EquipmentReportCardWorldwide_TournamentCount') IS NOT NULL
    DROP PROCEDURE [dbo].[EquipmentReportCardWorldwide_TournamentCount];
GO

Create PROCEDURE [dbo].[EquipmentReportCardWorldwide_TournamentCount]
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
select 'a' as Tour, 'b' as PlayYear, 'd' as NumOfEvents
		

DECLARE @EquipCase AS nvarchar(MAX)
exec [Search].[EquipmentTableCase] @Equipment, @EquipCase OUT
DECLARE @WhereCase AS nvarchar(MAX)			
exec [Search].[EquipmentWhereCase] @Equipment, @WhereCase OUT
DECLARE @query AS nvarchar(MAX)


SET @query = '	
;with cte1 as (select distinct tournamentid, tour, YEAR([first Day]) as PlayYear 
from '

SET @query = @query + @EquipCase + @WhereCase +  

' YEAR([FIRST DAY]) > ' + cast(@YearNow - @YearsBack as varchar(4)) + ' and Tour in (' + @Tour + ')) 


SELECT Tour, PlayYear, count(tournamentid) as NumOfEvents
FROM cte1
group by Tour, PlayYear'
 
 

print @query

exec(@query)
    
END
GO
