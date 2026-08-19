IF OBJECT_ID('Search.Report_All') IS NOT NULL
    DROP PROCEDURE [Search].[Report_All];
GO

CREATE PROCEDURE [Search].[Report_All]
(@FirstDay as date,
 @lastDay as date,
 @Tour as nvarchar(MAX),
 @Equipment as nvarchar(50),
 @ReportType as nvarchar(10),
 @UserName as nvarchar(50))
AS
BEGIN

DECLARE @Temp AS nvarchar(15) = ''
declare @UserLever as int

select @UserLever = [view_lvl]
FROM [DARRELL_MASTER].[Billing].[user_levels]
where [username] = @UserName and [tour] = @Tour and [year] = year(@lastDay)

if @UserLever = 1 Set @Temp = ' bb.[Series] '
if @UserLever = 0 Set @Temp = ' bb.model '
if @Equipment = 'Shoe' or @Equipment = 'Bag' or @Equipment = 'Glove' or @Equipment = 'Headgear' set @Temp = ' '

 
Declare @get_column_names_only bit = 0
if @get_column_names_only = 1
select 'a' as Tour, 'b' as Brand, 'c' as [SumMoney],'d' as Uses, 'e' as [AvgMoney], 
		'f' as [AvgDriveAcc], 'g' as [AvgDriveDist]


Declare @Join as nvarchar(MAX) = ' LEFT OUTER JOIN [Money].TourMoneyStats mm
											ON bb.[TournamentId] = mm.[TournamentId]
												AND bb.PLAYERNAME = mm.[PLAYER NAME] '

		
DECLARE @query AS nvarchar(MAX)


SET @query = 'SELECT '

if @ReportType = 'PLAYER' SET @query = @query + 'rtrim(bb.PLAYERNAME) as Tour, bb.Brand '  					
else SET @query = @query + ' bb.[Tour], bb.Brand '

 					
if (@ReportType = 'MODEL' or @ReportType = 'PLAYER') and @Temp <> ' ' SET @query = @query + '+ '' - '' + ' + @Temp + ' as Brand '  
					
SET @query = @query + ', Sum(mm.[Official Money]) as [SumMoney]
					, COUNT(bb.brand) as Uses
					, AVG(mm.[Official Money]) as [AvgMoney]
					, AVG(mm.[Driving Accuracy]) as [AvgDriveAcc]
					, AVG(mm.[Driving Distance]) as [AvgDriveDist]
			   FROM '


DECLARE @EquipCase AS nvarchar(MAX)
exec [Search].[EquipmentTableCase] @Equipment, @EquipCase OUT
DECLARE @WhereCase AS nvarchar(MAX)			
exec [Search].[EquipmentWhereCase] @Equipment, @WhereCase OUT
  
SET @query = @query + @EquipCase + @Join + @WhereCase +
  ' [FIRST DAY] between ''' + cast(@FirstDay as nvarchar(20)) + ''' and ''' + cast(@LastDay as nvarchar(20)) + '''
  and [TOUR] = ''' + @tour + '''
  group by bb.[Tour], bb.Brand'
  
  
 
 if @ReportType = 'BRAND' SET @query = @query + ' order by bb.BRAND'
 if @ReportType = 'MODEL' and @Temp <> ' ' SET @query = @query + ', ' + @Temp + ' order by bb.BRAND, ' + @Temp
 if @ReportType = 'MODEL' and @Temp = ' ' SET @query = @query + ' order by bb.BRAND'
 if @ReportType = 'PLAYER' and @Temp <> ' ' SET @query = @query + ', ' + @Temp + ', bb.PLAYERNAME order by bb.PLAYERNAME, bb.BRAND, ' + @Temp
 if @ReportType = 'PLAYER' and @Temp = ' ' SET @query = @query + ', bb.PLAYERNAME order by bb.PLAYERNAME, bb.BRAND'

print @query

exec(@query)
    
END
GO
