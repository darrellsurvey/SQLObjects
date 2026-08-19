DROP PROCEDURE IF EXISTS [Consumer].[Chapter_Data_Model1];
GO

CREATE procedure [Consumer].[Chapter_Data_Model1]
(@Equipment varchar(20),
@Country varchar(100),
@Year smallint,
@Season tinyint,
@YearsBack tinyint)

as
begin
set nocount on

--exec [Consumer].[Chapter_Data_Model1] 'Wood - Driver', 'Thailand', 2023, 2, 6

if 2 = 1
begin
SELECT 'a' as BRAND, 2014 as [YEAR], 'Total' AS [DataType], 
'a' as Series, 1 as SeriesTotal, 1 as SeriesRank,
1 as BrandRank, 1 AS BrandTotal, 'a' as isVisible

end


declare @sqltext as varchar(3000)

set @sqltext = ' 
SELECT [BRAND], [YEAR], ''Total'' as DataType, COALESCE(SERIES, MODEL, '''') as SERIES,
COUNT(*) as [SeriesTotal], 
sum(COUNT(*)) over (partition by [YEAR], brand) as [BrandTotal]
FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' q
inner join [DARRELL_MASTER].[Consumer].PlayerProfile p
on q.PlayerProfileId = p.PlayerProfileId
where p.YEAR between ' + cast(@Year - @YearsBack + 1 as varchar(4)) + ' and ' + cast(@Year as varchar(4)) + ' and
	  p.COUNTRY in (''' + @Country + ''') and 
	  p.SEASON = ' + cast(@Season as varchar(1)) + ' and not BRAND is null
	  ' + [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment) + ' 	  
group by BRAND, [year] , COALESCE(SERIES, MODEL, '''') '


if not(@Equipment = 'Ball' or @Equipment = 'Headgear' or @Equipment = 'Headgear' or @Equipment = 'Shirt')
begin
	set @sqltext = '
		SELECT [BRAND], [YEAR], ''New'' as DataType, COALESCE(SERIES, MODEL, '''') as SERIES,
		COUNT(*) as [SeriesTotal], 
		sum(COUNT(*)) over (partition by [YEAR], brand) as [BrandTotal]
		FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' q
		inner join [DARRELL_MASTER].[Consumer].PlayerProfile p
		on q.PlayerProfileId = p.PlayerProfileId
	    where p.YEAR between ' + cast(@Year - @YearsBack + 1 as varchar(4)) + ' and ' + cast(@Year as varchar(4)) + ' and
			p.COUNTRY in (''' + @Country + ''') and 
			p.SEASON = ' + cast(@Season as varchar(1)) + ' and not BRAND is null
			and YEARS < 2
			' + [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment) + ' 
		group by BRAND, [year], COALESCE(SERIES, MODEL, '''')  
		
		union all ' + @sqltext
end

set @sqltext = ';with cte1 as ( ' + @sqltext + ' ),

		cte2 as (
		Select BRAND,cte1.SERIES, [year], DataType, [SeriesTotal], [BrandTotal],
		RANK () over (partition by [YEAR], DataType, Brand order by [SeriesTotal] desc) as SeriesRank,
		DENSE_RANK () over (partition by [YEAR], DataType order by [BrandTotal] desc) as BrandRank
		from cte1
		where BRAND not in (' + [DARRELL_MASTER].[Consumer].[BrandExceptionCase]() + '))
		
		
		Select cte2.*, a.brand as isVisible
		from cte2
		left outer join (select distinct datatype, [year], brand, Series from cte2 where SeriesRank <=5) a
		on cte2.Series = a.series and cte2.brand = a.brand and cte2.datatype = a.datatype and cte2.[Year] = a.[Year]
		order by [year] desc, DataType, [BrandTotal] desc, cte2.BRAND, [SeriesTotal] desc, cte2.SERIES;'



print (@sqltext)
exec (@sqltext)

end
GO
