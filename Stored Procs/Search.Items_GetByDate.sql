DROP PROCEDURE IF EXISTS [Search].[Items_GetByDate];
GO

CREATE PROCEDURE [Search].[Items_GetByDate]
	@COMPANY nvarchar(50),
	@loginid nvarchar(50) = '',
	@Tour nvarchar(20),
	@FirstDay date,
	@LastDay date,
	@Equipment nvarchar(20),
	@ReportType nvarchar(10)
AS
begin
	SET NOCOUNT ON;
	
Declare @get_column_names_only bit = 0
if @get_column_names_only = 1
select 'a' as [ListItem]

	
DECLARE @query AS nvarchar(MAX)
			

if @ReportType = 'BRAND' SET @query = 'Select distinct RTRIM(BRAND) as Brand'  					
if @ReportType = 'MODEL' SET @query = 'Select distinct RTRIM(BRAND) + '' - '' + RTRIM(MODEL) as [Model]'
if @ReportType = 'PLAYER' SET @query = 'Select distinct RTRIM(PLAYERNAME) as Player'


SET @query = @query + '	FROM '

DECLARE @EquipCase AS nvarchar(MAX)
exec [Search].[EquipmentTableCase] @Equipment, @EquipCase OUT
DECLARE @WhereCase AS nvarchar(MAX)			
exec [Search].[EquipmentWhereCase] @Equipment, @WhereCase OUT

  
SET @query = @query + @EquipCase + @WhereCase + '
                ([FIRST DAY] between ''' + cast(@FirstDay as nvarchar(10)) + ''' and ''' + cast(@LastDay as nvarchar(10)) + ''')
				and TOUR = ''' + @Tour + '''	
				group by '

if @ReportType = 'BRAND' SET @query = @query + ' RTRIM(BRAND) order by RTRIM(Brand) ' 					
if @ReportType = 'MODEL' SET @query = @query + ' RTRIM(BRAND), RTRIM(MODEL) order by RTRIM(BRAND) + '' - '' + RTRIM(MODEL) '
if @ReportType = 'PLAYER' SET @query = @query + ' RTRIM(PLAYERNAME) order by RTRIM(PLAYERNAME) '
  
print @query

if @ReportType = 'MODEL' and (@Equipment = 'BAG' or 
								@Equipment = 'GLOVE' or
								@Equipment = 'SHOE' or
								@Equipment = 'HEADGEAR') 
				SET @query = 'Select distinct [Model] from dbo.bag where 2=1'

exec(@query)
end
GO
