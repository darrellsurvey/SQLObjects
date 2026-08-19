IF OBJECT_ID('Search.Report_ByTournament_By') IS NOT NULL
    DROP PROCEDURE [Search].[Report_ByTournament_By];
GO

CREATE PROCEDURE [Search].[Report_ByTournament_By]
(@Equipment as nvarchar(50),
 @ReportType as nvarchar(10),
 @Filter as nvarchar(50),
 @TournamentSID as int,
 @Year as int)

AS
BEGIN


Declare @get_column_names_only bit = 0
if @get_column_names_only = 1
select 'a' as [Tournament Name], 'b' as [First Day], 'c' as [PLAYERNAME],
		'd' as Brand, 'x' as [Club Number], 'e' as [Official Money], 
		'f' as Place, 'h' as [Driving Accuracy], 'g' as [Driving Distance]


Declare @Join as nvarchar(MAX) = ' left outer JOIN [Money].TourMoneyStats mm
											ON bb.[TournamentId] = mm.[TournamentId]
												AND bb.PLAYERNAME = mm.[PLAYER NAME] '

		
DECLARE @query AS nvarchar(MAX)

SET @query = 'SELECT bb.[Tournament Name], bb.[First Day], rtrim(bb.[PLAYERNAME]) as [PLAYERNAME], bb.Brand + (case when isnull(bb.model,'''') <> '''' then '' - '' + bb.model else '''' end) as Brand '

if left(@Equipment,4) = 'WOOD' or 
	left(@Equipment,4) = 'SHAF' or
	left(@Equipment,4) = 'GRIP' or
	left(@Equipment,4) = 'WEDG' or
	left(@Equipment,4) = 'IRON' SET @query = @query + ', [Club Number] '
else SET @query = @query + ', '''' as [Club Number] '  					



--Used this when brand selection was different, now they are same
--if @ReportType = 'MODEL' SET @query = @query + '+ '' - '' + bb.model as Brand'  					
--if @ReportType = 'PLAYER' SET @query = @query + '+ '' - '' + bb.model as Brand' 

SET @query = @query + ', mm.[Official Money], 
			rtrim(ISNULL(mm.Tie,'''')) + rtrim(isnull(mm.Cut,'''')) + rtrim(isnull(cast(mm.[Finish Position] as nvarchar(3)),'''')) as [Place], 
			mm.[Driving Accuracy], mm.[Driving Distance] 
			FROM '
			

DECLARE @EquipCase AS nvarchar(MAX)
exec [Search].[EquipmentTableCase] @Equipment, @EquipCase OUT
DECLARE @WhereCase AS nvarchar(MAX)			
exec [Search].[EquipmentWhereCase] @Equipment, @WhereCase OUT

  
SET @query = @query + @EquipCase + @Join + @WhereCase +  'year([FIRST DAY]) = ' + cast(@Year as nvarchar(4)) + ' and [SID] = ' + cast(@TournamentSID as nvarchar(3)) + ' and '

if @ReportType = 'BRAND' SET @query = @query + ' bb.BRAND = ''' + @Filter
if @ReportType = 'MODEL' SET @query = @query + ' bb.BRAND = ''' + SUBSTRING(@Filter, 0,charindex(' - ', @Filter,0)) + '''
										 and bb.Model = ''' + SUBSTRING(@Filter, charindex(' - ', @Filter,0)+3,100) + ''
										 
if @ReportType = 'PLAYER' SET @query = @query + ' bb.[PlayerName] = ''' + @Filter
  
SET @query = @query + ''' Order by [First Day] desc, bb.[Tournament Name], bb.PLAYERNAME'

print @query

exec(@query)





 
    
END
GO
