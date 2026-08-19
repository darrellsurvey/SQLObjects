IF OBJECT_ID('Consumer.rptRegion') IS NOT NULL
    DROP PROCEDURE [Consumer].[rptRegion];
GO

CREATE procedure [Consumer].[rptRegion]
@Country varchar(20),
@Equipment varchar(20),
@NewNumber as bit = 1,
@TotalNumber as Bit = 1,
@Year as varchar(500),
@Model as bit = 0


as
begin

set nocount on;

declare @sql as nvarchar(max)
declare @sqlBegin as nvarchar(max)
declare @sqlNew as nvarchar(max)
declare @sqlTotal as nvarchar(max)
declare @Finalsql as nvarchar(max)

Declare @get_column_names_only bit = 0
if @get_column_names_only = 1
SELECT 2014 as [YEAR], 1 AS [SEASON], 'b' as [BRAND], 'c' AS TotalType,
	1 as Region, 
	'zz' as RegionName, 
	1 as BrandTotal

Set @sqlBegin = ';with cte_original as (SELECT [YEAR], [SEASON], '
if @Model = 1
	Set @sqlBegin = @sqlBegin + ' isnull([model], ''unspec.'')  + '' ('' + [BRAND] + '')'' as  [BRAND], region, regionname '
else
	Set @sqlBegin = @sqlBegin + ' [BRAND], region, regionname '

if not (@Equipment = 'Ball' or @Equipment = 'Headgear' or @Equipment = 'Shirt')
	Set @sqlBegin = @sqlBegin + ', YEARS '
	
Set @sqlBegin = @sqlBegin + 'FROM  ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' eq
		inner join Consumer.PlayerProfile p on p.PlayerProfileId = eq.PlayerProfileId 
		inner join Consumer.Country c       on p.COUNTRY = c.Country 
		inner join Consumer.Region r        on c.CountryId = r.CountryId  and p.REGION = r.RegionNumber 
		where p.COUNTRY = ''' + @Country + ''' and BRAND is not null and (' + @Year + ') '
		+ [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment) + ') ';

Set @sql = ''

  	
if @NewNumber = 1 
		set @sqlNew = ' SELECT [YEAR], [SEASON],  [BRAND], ''New'' AS TotalType, Region, RegionName, count(*) as BrandTotal
						from cte_original where Years < 2 
						group by [YEAR], SEASON, [BRAND], REGION, RegionName 
						union all
						SELECT [YEAR], [SEASON],  [BRAND], ''New'' AS TotalType, 0 as Region, ''All Regions'' as RegionName, count(*) as BrandTotalRegion
						from cte_original where Years < 2 	
						group by [YEAR], SEASON, [BRAND]'
if @TotalNumber = 1 
		set @sqlTotal = ' SELECT [YEAR], [SEASON],  [BRAND], ''Total'' AS TotalType, Region, RegionName, count(*) as BrandTotal
						from cte_original 
						group by [YEAR], SEASON, [BRAND], REGION, RegionName 
						union all
						SELECT [YEAR], [SEASON],  [BRAND], ''Total'' AS TotalType, 0 as Region, ''All Regions'' as RegionName, count(*) as BrandTotalRegion
						from cte_original 	
						group by [YEAR], SEASON, [BRAND]'

if @NewNumber = 1 and @TotalNumber = 1
	set @Finalsql = @sqlBegin + @sqlNew + ' union all ' + @sqlTotal
if @TotalNumber = 0    
	set @Finalsql = @sqlBegin + @sqlNew
if @NewNumber = 0  
	set @Finalsql = @sqlBegin + @sqlTotal

print @Finalsql
execute sp_executesql @Finalsql;
 
end
GO
