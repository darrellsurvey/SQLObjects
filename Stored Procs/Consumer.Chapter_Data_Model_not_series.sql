DROP PROCEDURE IF EXISTS [Consumer].[Chapter_Data_Model_not_series];
GO

create procedure [Consumer].[Chapter_Data_Model_not_series]
(@Equipment varchar(20),
@Country varchar(100),
@Year smallint,
@Season tinyint,
@Brand varchar(30))

as
begin
set nocount on;

--exec [Consumer].[Chapter_Data_Model_not_series] 'Wood - Driver', 'Thailand', 2019, 2, 'Taylormade'

declare @sqlMaintext as varchar(max)
declare @text1 as varchar(1000)

if 2 = 1
begin
SELECT  'a' as DataType, 
		2014 as [Year], 
		1 as sort, 
		'Total' AS demogroup, 
		1 as DemoSubGroup,
		'a' as DemoSubGroupText,
		'b' as Brand,
		'c' as Model,
		1 AS ModelCount, 
		1 AS BrandCount, 
		1 as TotalCount,
		1 as ModelRank
		
end

--and Brand = ''' + @Brand + ''' 

set @text1 = ' [YEARS], p.*
		FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' q
		inner join Consumer.PlayerProfile p on q.PlayerProfileId = p.PlayerProfileId 
		where p.YEAR = ' + cast(@Year as varchar(4)) + ' 
			and COUNTRY in (''' + @Country + ''')  
			and SEASON = ' + cast(@Season as varchar(1)) + ' 
			
		' + [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment)


set @sqlMaintext = '; with cte_PP_Total as (SELECT Brand, Model, '

if @Equipment = 'Ball' or @Equipment = 'Headgear' or @Equipment = 'Shirt' 
	set @sqlMaintext = @sqlMaintext + '0 as '
	
set @sqlMaintext = @sqlMaintext + @text1 + '), '

if not (@Equipment = 'Ball' or @Equipment = 'Headgear' or @Equipment = 'Shirt') 
	set @sqlMaintext = @sqlMaintext + ' cte_PP_New as (SELECT Brand, Model, ' + @text1 +
		     ' and YEARS < 2), '


set @sqlMaintext = @sqlMaintext + ' cte_data as (' + [DARRELL_MASTER].[Consumer].[DemographicCase_Model]('Total') 


if not(@Equipment = 'Ball' or @Equipment = 'Headgear' or @Equipment = 'Shirt')
	set @sqlMaintext = @sqlMaintext + ' union all ' + [DARRELL_MASTER].[Consumer].[DemographicCase_Model]('New') 



set @sqlMaintext = @sqlMaintext + '), 

cte_AllBrands as (select distinct DataType, Brand, model, z.year
from cte_data
cross join (select distinct Year from cte_data) z
where cte_data.brand = ''' + @Brand + '''
--group by DataType, Brand
),

cte_AllPossible as (
select DataType, [Year], sort, z.DemoGroup, z.DemoSubGroup, DemoSubGroupText, Brand, Model,  NULL as ModelCount, NULL as BrandCount ,NULL as TotalCount
from cte_AllBrands d cross join (select * from Consumer.Header) z),


cte_2 as (
select p.DataType, p.[YEAR], sort, p.DemoGroup, p.DemoSubGroup, DemoSubGroupText, p.BRAND, p.Model,
coalesce(p.Modelcount, z.Modelcount) as ModelCount,
coalesce(p.brandcount, z.brandcount) as BrandCount,
coalesce(p.totalcount, z.totalcount) as TotalCount
from cte_AllPossible p
left outer join 
(select DataType, [Year], demogroup, DemoSubGroup,
Brand, model, modelcount, BrandCount, TotalCount
from cte_data d) z
on p.DataType = z.DataType and 
p.[YEAR] = z.[YEAR] and 
p.BRAND = z.BRAND and 
p.Model = z.Model and 
p.DemoGroup = z.DemoGroup and
p.DemoSubGroup = z.DemoSubGroup )



select *, RANK() over (Partition by DataType, [year], brand, sort, DemoSubGroup order by ModelCount desc) as ModelRank
from cte_2
where not model is null
order by DataType desc, [YEAR] desc, sort asc, DemoSubGroup asc, ModelRank asc, model asc '

--where BRAND not in (' + [DARRELL_MASTER].[Consumer].[BrandExceptionCase]() + ')

print @sqlMaintext
exec (@sqlMaintext)

end
GO
