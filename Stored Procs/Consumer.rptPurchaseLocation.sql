DROP PROCEDURE IF EXISTS [Consumer].[rptPurchaseLocation];
GO

CREATE procedure [Consumer].[rptPurchaseLocation]
@Country varchar(20),
@Equipment varchar(20),
@Year as varchar(500)

as
begin

set nocount on;

declare @sql as nvarchar(max)

Declare @get_column_names_only bit = 0
if @get_column_names_only = 1
SELECT 2014 as [YEAR], 1 AS [SEASON], 'b' as [BRAND], 'c' AS PurchaseLocation,
	1 as BrandLocationTotal, 1 as BrandTotal, 1 as BrandOverallTotal, 1 as BrandOverallRank, 1 as OverallTotal

Set @sql = ';with cte_original as (SELECT [YEAR], [SEASON], Brand, PURCHASE as PurchaseLocation,
		count(*) as BrandLocationTotal, 
		sum(count(*)) over(partition by [year], [season], brand) as BrandTotal
		FROM  ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' eq
		inner join Consumer.PlayerProfile p on p.PlayerProfileId = eq.PlayerProfileId 
		inner join Consumer.Country c       on p.COUNTRY = c.Country 
		inner join Consumer.Region r        on c.CountryId = r.CountryId  and p.REGION = r.RegionNumber 
		where p.COUNTRY = ''' + @Country + ''' and BRAND is not null and PURCHASE is not null 
		and (' + @Year + ') ' + [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment)
		
		if not (@Equipment = 'Ball' or @Equipment = 'Headgear' or @Equipment = 'Shirt')
			Set @sql = @sql + 'and YEARS < 2 '
		Set @sql = @sql + 'group by [YEAR], SEASON, [BRAND], PURCHASE), 
		
		
				cte_all as (SELECT [YEAR], [SEASON], Brand,	count(*) as BrandOverallTotal, 
		dense_rank() over(partition by [year], [season] order by count(*) desc, brand) as BrandOverallRank, sum(count(*)) over() as OverallTotal
		FROM   ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' eq
		inner join Consumer.PlayerProfile p on p.PlayerProfileId = eq.PlayerProfileId 
		inner join Consumer.Country c       on p.COUNTRY = c.Country 
		inner join Consumer.Region r        on c.CountryId = r.CountryId  and p.REGION = r.RegionNumber 
		where p.COUNTRY = ''' + @Country + ''' and BRAND is not null
		and (' + @Year + ') ' + [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment)
		
		if not (@Equipment = 'Ball' or @Equipment = 'Headgear' or @Equipment = 'Shirt')
			Set @sql = @sql + 'and YEARS < 2 '
		Set @sql = @sql + 'group by [YEAR], SEASON, [BRAND]) 
		
		
		
		SELECT a.[YEAR], a.[SEASON],  a.[BRAND], PurchaseLocation, BrandLocationTotal, BrandTotal,
		a.BrandOverallTotal, BrandOverallRank, OverallTotal
		from cte_all a left outer join cte_original o on o.YEAR = a.YEAR and o.SEASON = a.SEASON and o.BRAND = a.BRAND 
		WHERE a.BRAND NOT IN (' + [DARRELL_MASTER].Consumer.BrandExceptionCase() + ')'

print @sql
execute sp_executesql @sql;
 
end
GO
