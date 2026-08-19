IF OBJECT_ID('MoneyBall.Dashboard3') IS NOT NULL
    DROP PROCEDURE [MoneyBall].[Dashboard3];
GO

CREATE procedure [MoneyBall].[Dashboard3]
@Brand varchar(40),
@PGASeason integer,
@SportTourId integer

as
begin

set nocount on;

--EXEC [MoneyBall].[Dashboard3] 'parsons', 2017

;with cteList as (SELECT [Equipment],[Brand],[BrandEquipmentRank],[BrandEquipmentTotal],[BrandEquipmentPercent] 
					from [darrell_master].[MoneyBall].[WebsiteData8] 
					where PGASeason = @PGASeason and SportTourId = @SportTourId)

select l1.*, l2.Brand as CompBrand
, l2.BrandEquipmentRank as CompBrandEquipmentRank
, l2.BrandEquipmentTotal as CompBrandEquipmentTotal
, l2.BrandEquipmentPercent as CompBrandEquipmentPercent
, l1.BrandEquipmentTotal - l2.BrandEquipmentTotal as CountDiff 
from cteList l1
left outer join cteList l2
on l1.BrandEquipmentRank = l2.BrandEquipmentRank +1 and l1.Equipment = l2.Equipment
where l1.brand = @Brand
  

end
GO
