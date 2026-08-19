IF OBJECT_ID('Search.Items_Get') IS NOT NULL
    DROP PROCEDURE [Search].[Items_Get];
GO

CREATE PROCEDURE [Search].[Items_Get]
	@COMPANY nvarchar(50),
	@loginid nvarchar(50) = '',
	@year int,
	@TournamentSID int,
	@Equipment nvarchar(20),
	@ReportType nvarchar(10)
AS
begin

	SET NOCOUNT ON;
	
Declare @get_column_names_only bit = 0
if @get_column_names_only = 1
select 'a' as [ListItem]


DECLARE @query AS nvarchar(MAX)


if @ReportType = 'BRAND' SET @query = 'Select distinct BRAND as Brand'  					
if @ReportType = 'MODEL' SET @query = 'Select distinct BRAND + '' - '' + MODEL as [Model]'
if @ReportType = 'PLAYER' SET @query = 'Select distinct PLAYERNAME as Player'


SET @query = @query + '	FROM '


DECLARE @EquipCase AS nvarchar(MAX)
exec [Search].[EquipmentTableCase] @Equipment, @EquipCase OUT
DECLARE @WhereCase AS nvarchar(MAX)			
exec [Search].[EquipmentWhereCase] @Equipment, @WhereCase OUT

  
SET @query = @query + @EquipCase + @WhereCase + '
         year([FIRST DAY]) = ' + cast(@Year as nvarchar(4)) + ' 
	     and [SID] = ' + cast(@TournamentSID as nvarchar(3)) + ' 
		 group by '

if @ReportType = 'BRAND' SET @query = @query + ' BRAND order by Brand' 					
if @ReportType = 'MODEL' SET @query = @query + ' BRAND, MODEL order by Model '
if @ReportType = 'PLAYER' SET @query = @query + 'PLAYERNAME order by PLAYERNAME'
  

if @ReportType = 'MODEL' and (@Equipment = 'BAG' or 
								@Equipment = 'GLOVE' or
								@Equipment = 'SHOE' or
								@Equipment = 'HEADGEAR') 
				SET @query = 'Select distinct [Model] from dbo.bag where 2=1'

exec(@query)

Print(@query) 

END
GO
