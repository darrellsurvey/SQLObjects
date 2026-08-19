DROP PROCEDURE IF EXISTS [Search].[Report_ByTournament_All];
GO

CREATE PROCEDURE [Search].[Report_ByTournament_All]
(@Year as int,
 @TournamentSID as int,
 @Equipment as nvarchar(50),
 @ReportType as nvarchar(10))
AS
BEGIN


Declare @get_column_names_only bit = 0
if @get_column_names_only = 1
select 'a' as Tour, 'b' as Brand, 'c' as [SumMoney],'d' as Uses, 'e' as [AvgMoney], 
		'f' as [AvgDriveAcc], 'g' as [AvgDriveDist]


Declare @Join as nvarchar(MAX) = ' LEFT OUTER JOIN [Money].[TourMoneyStats] mm
											ON bb.[TournamentId] = mm.[TournamentId]
												and bb.PLAYERNAME = mm.[PLAYER NAME] '

		
DECLARE @query AS nvarchar(MAX)

SET @query = 'SELECT '

if @ReportType = 'BRAND' SET @query = @query + ' bb.[Tour], bb.Brand '
if @ReportType = 'MODEL' SET @query = @query + ' bb.Brand as Tour, bb.model as Brand '  					
if @ReportType = 'PLAYER' SET @query = @query + 'rtrim(bb.PLAYERNAME) as Tour, bb.Brand  + '' - '' + bb.model as Brand'  					

					
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
  
SET @query = @query + @EquipCase + @Join + @WhereCase +  'year([FIRST DAY]) = ' + cast(@Year as nvarchar(4)) + ' 
  and [SID] = ' + cast(@TournamentSID as nvarchar(3)) + '
  group by bb.[Tour], bb.Brand'
 
 if @ReportType = 'BRAND' SET @query = @query + ' order by bb.BRAND'
 if @ReportType = 'MODEL' SET @query = @query + ', bb.model order by bb.BRAND, bb.MODEL'
 if @ReportType = 'PLAYER' SET @query = @query + ', bb.model, bb.PLAYERNAME order by bb.PLAYERNAME, bb.BRAND, bb.MODEL' 


print @query

exec(@query)

    
END
GO
