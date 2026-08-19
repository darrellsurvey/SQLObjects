DROP PROCEDURE IF EXISTS [Search].[Multi_Brand_Player_Report_TM];
GO

CREATE PROCEDURE [Search].[Multi_Brand_Player_Report_TM]
(@FirstDay as date,
 @LastDay as date,
 @Equipment as varchar(50),
 @Tour as varchar(50))
AS
BEGIN



Declare @get_column_names_only bit = 0
if @get_column_names_only = 1
select 'c' as [PLAYERNAME], 'd' as Brand, 'e' as [BrandCount]

	
DECLARE @query AS nvarchar(MAX) = 'SELECT rtrim(bb.[PLAYERNAME]) as [PLAYERNAME], bb.Brand, count(bb.brand) as [BrandCount] FROM '
		

DECLARE @EquipCase AS nvarchar(MAX)
exec [Search].[EquipmentTableCase] @Equipment, @EquipCase OUT
DECLARE @WhereCase AS nvarchar(MAX)			
exec [Search].[EquipmentWhereCase] @Equipment, @WhereCase OUT

  
SET @query = @query + @EquipCase + @WhereCase +
	' (bb.[First Day] between ''' + cast(@FirstDay as nvarchar(20)) + ''' and ''' + cast(@LastDay as nvarchar(20)) + ''')' +
	' and bb.TOUR = ''' + @Tour + '''' +
    ' GROUP BY [PLAYERNAME], Brand ' +
	' Order by bb.[PlayerName] '

print @query

exec(@query)




    
END
GO
