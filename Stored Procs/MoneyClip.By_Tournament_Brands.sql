IF OBJECT_ID('MoneyClip.By_Tournament_Brands') IS NOT NULL
    DROP PROCEDURE [MoneyClip].[By_Tournament_Brands];
GO

CREATE PROCEDURE [MoneyClip].[By_Tournament_Brands]
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
select 'z' as [Tour], 'a' as [First Day], 'b' as [Tournament Name], 'c' as [Brand],
		1 as [BrandCount], 1 as TournamentTotal, 1 as rn, 1 as rnAll		
		

DECLARE @query AS varchar(MAX)
SET @query = '
select [TOUR],[FIRST DAY],[Tournament Name],[BRAND],BrandCount,TournamentTotal,
		 rank() over (partition by [Tournament Name] order by BrandCount desc) as rn,
		 dense_rank() over (order by BrandTotal desc) as rnAll

from (
select distinct [TOUR],
		[FIRST DAY],
		[Tournament Name],
		[BRAND], 
		Count([Brand]) over (partition by [TOUR],[FIRST DAY],[Tournament Name],[BRAND]) as [BrandCount], 
		Count([Brand]) over (partition by [Tournament Name]) as TournamentTotal, 
		Count([Brand]) over (partition by [Brand]) as BrandTotal
from '


DECLARE @EquipCase AS nvarchar(MAX)
DECLARE @WhereCase AS nvarchar(MAX)
			
exec [Search].[EquipmentTableCase] @Equipment, @EquipCase OUT
exec [Search].[EquipmentWhereCase] @Equipment, @WhereCase OUT
  
SET @query = @query + @EquipCase + @WhereCase +
  '[FIRST DAY] between ''' + cast(@FirstDay as varchar(20)) + ''' and ''' + cast(@LastDay as varchar(20)) + '''
  and [TOUR] in (' + @tour + ')
  ) a'

print(@query)  
exec(@query)
  
    
END
GO
