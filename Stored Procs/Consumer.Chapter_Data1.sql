DROP PROCEDURE IF EXISTS [Consumer].[Chapter_Data1];
GO

CREATE procedure [Consumer].[Chapter_Data1]
(@Equipment varchar(20),
@Country varchar(100),
@Year smallint,
@Season tinyint,
@YearsBack tinyint)

as
begin
set nocount on

--exec [Consumer].[Chapter_Data1] 'Shoe', 'Korea', 2024, 4, 15

if 2 = 1
begin
SELECT 'a' as BRAND, 2014 as [YEAR], 'Total' AS [DataType], 1 as BrandRank, 1 AS BrandTotal, 1 as YearTotal, 1 as YearPercent, 1 as MaxY, 1 as CurrentTotalRank, 1 as CurrentNewRank --,1 as AvgPercent
end


declare @sqltext as varchar(max)

set @sqltext = ' 
SELECT [BRAND], [YEAR], ''Total'' as DataType,
COUNT(*) as [BrandTotal], 
sum(COUNT(*)) over (partition by [YEAR]) as [YearTotal],
COUNT(*)*100.0/sum(COUNT(*)) over (partition by [YEAR]) as [BrandPercent],
RANK () over (partition by [YEAR] order by COUNT(*) desc, Brand) as BrandRank
FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' q
inner join [DARRELL_MASTER].[Consumer].PlayerProfile p
on q.PlayerProfileId = p.PlayerProfileId
where p.YEAR between ' + cast(@Year - @YearsBack as varchar(4)) + ' and ' + cast(@Year as varchar(4)) + ' and
	  p.COUNTRY in (''' + @Country + ''') and 
	  p.SEASON = ' + cast(@Season as varchar(1)) + ' and not BRAND is null
	  ' + [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment) + ' 	  
group by BRAND, [year] '


if not(@Equipment = 'Ball' or @Equipment = 'Headgear' or @Equipment = 'Shirt' or @Equipment = 'Glove') -- or @Equipment = 'Bag')
begin
	set @sqltext = '
		SELECT [BRAND], [YEAR], ''New'' as DataType,
		COUNT(*) as [BrandTotal], 
		sum(COUNT(*)) over (partition by [YEAR]) as [YearTotal],
		COUNT(*)*100.0/sum(COUNT(*)) over (partition by [YEAR]) as [BrandPercent],
		RANK () over (partition by [YEAR] order by COUNT(*) desc, Brand) as BrandRank
		FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' q
		inner join [DARRELL_MASTER].[Consumer].PlayerProfile p
		on q.PlayerProfileId = p.PlayerProfileId
	    where p.YEAR between ' + cast(@Year - @YearsBack as varchar(4)) + ' and ' + cast(@Year as varchar(4)) + ' and
			p.COUNTRY in (''' + @Country + ''') and 
			p.SEASON = ' + cast(@Season as varchar(1)) + ' and not BRAND is null
			and YEARS < 2
			' + [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment) + ' 
		group by BRAND, [year]
		
		union all ' + @sqltext
end

set @sqltext = ';with cte1 as ( ' + @sqltext + ' )
		Select a.BRAND, [year], DataType,[BrandTotal], [YearTotal], RANK () over (partition by [YEAR], DataType order by a.BrandRank) as BrandRank, --AvgPercent, 
		[BrandTotal]*1.0 /[YearTotal] as YearPercent, 
		isnull(t.BrandRank,999) as CurrentTotalRank,
		isnull(n.BrandRank,999) as CurrentNewRank,
		(select ceiling(max(BrandPercent) / 5.0) * 5.0 from cte1) as MaxY
		from cte1 a 
		
		left outer join (select Brand, RANK () over (order by BrandTotal desc, Brand) as BrandRank from cte1 where DataType = ''Total'' and [year] = ' + cast(@Year as varchar(4)) + ' and BRAND not in (' + [DARRELL_MASTER].[Consumer].[BrandExceptionCase]() + ')) t on a.BRAND = t.brand
		left outer join (select Brand, RANK () over (order by BrandTotal desc, Brand) as BrandRank from cte1 where DataType = ''New'' and [year] = ' + cast(@Year as varchar(4)) + ' and BRAND not in (' + [DARRELL_MASTER].[Consumer].[BrandExceptionCase]() + ')) n on a.BRAND = n.brand
		where a.BRAND not in (' + [DARRELL_MASTER].[Consumer].[BrandExceptionCase]() + ')
		order by [year] desc, DataType, [BrandTotal] desc, BRAND;'

--inner join (select Brand, AVG(BrandPercent) as AvgPercent from cte1 group by BRAND) b on a.BRAND = b.brand

print (@sqltext)
exec (@sqltext)

end
GO
