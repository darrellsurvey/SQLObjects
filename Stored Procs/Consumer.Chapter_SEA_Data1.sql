IF OBJECT_ID('Consumer.Chapter_SEA_Data1') IS NOT NULL
    DROP PROCEDURE [Consumer].[Chapter_SEA_Data1];
GO

CREATE procedure [Consumer].[Chapter_SEA_Data1]
(@Equipment varchar(20),
@Year smallint,
@YearsBack tinyint)

as
begin
set nocount on

--exec [Consumer].[Chapter_SEA_Data1] 'Ball', 2019,4

if 2 = 1
begin
SELECT 'a' as Country, 1 as countrysort, 'a' as BRAND, 2014 as [YEAR], 'Total' AS [DataType], 1 as BrandRank, 1 AS BrandTotal, 1 as YearTotal, 1 as BrandRankSEA
end


declare @sqltext as varchar(3000)

set @sqltext = ' 
SELECT COUNTRY, [BRAND], [YEAR], ''Total'' as DataType,
COUNT(*) as [BrandTotal], 
sum(COUNT(*)) over (partition by country, [YEAR]) as [YearTotal]
FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' q
inner join [DARRELL_MASTER].[Consumer].PlayerProfile p
on q.PlayerProfileId = p.PlayerProfileId
where p.YEAR between ' + cast(@Year - @YearsBack + 1 as varchar(4)) + ' and ' + cast(@Year as varchar(4)) + ' and
	  p.COUNTRY in (''Thailand'', ''Malaysia'', ''Singapore'', ''Indonesia'') and not BRAND is null
	  ' + [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment) + ' 	  
group by Country, BRAND, [year] '


if not(@Equipment = 'Ball' or @Equipment = 'Headgear' or @Equipment = 'Shirt' or @Equipment = 'Bag' or @Equipment = 'Glove')
begin
	set @sqltext = '
		SELECT COUNTRY, [BRAND], [YEAR], ''New'' as DataType,
		COUNT(*) as [BrandTotal], 
		sum(COUNT(*)) over (partition by country, [YEAR]) as [YearTotal]
		FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' q
		inner join [DARRELL_MASTER].[Consumer].PlayerProfile p
		on q.PlayerProfileId = p.PlayerProfileId
	    where p.YEAR between ' + cast(@Year - @YearsBack + 1 as varchar(4)) + ' and ' + cast(@Year as varchar(4)) + ' and
			p.COUNTRY in (''Thailand'', ''Malaysia'', ''Singapore'', ''Indonesia'') and not BRAND is null
			and YEARS < 2
			' + [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment) + ' 
		group by country, BRAND, [year]
		
		union all ' + @sqltext
end

set @sqltext = ';with cte1 as ( ' + @sqltext + ' ),

cte2 as (Select COUNTRY,
             case when country = ''Thailand'' then 1
                  when country = ''Malaysia'' then 2
                  when country = ''Singapore'' then 3
                  else 4 end as countrysort, 
        BRAND, [year], DataType,[BrandTotal], [YearTotal], 
		RANK () over (partition by country, [YEAR], DataType order by [BrandTotal] desc) as BrandRank
	   	from cte1
	   	where BRAND not in (' + [DARRELL_MASTER].[Consumer].[BrandExceptionCase]() + '))
	   	
select a.*, b.BrandRankSEA from cte2 a inner join 
(Select BRAND, [year], DataType, RANK () over (partition by [YEAR], DataType order by sum([BrandTotal]) desc) as BrandRankSEA 
from cte2 where [year] = ' + cast(@Year as varchar(4)) + ' group by BRAND, [year], DataType) b
on a.BRAND = b.BRAND and a.DataType = b.DataType 
order by [year] desc, DataType, BrandRankSEA, [BrandTotal] desc, BRAND;'



print (@sqltext)
exec (@sqltext)

end
GO
