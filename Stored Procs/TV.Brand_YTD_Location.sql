IF OBJECT_ID('TV.Brand_YTD_Location') IS NOT NULL
    DROP PROCEDURE [TV].[Brand_YTD_Location];
GO

CREATE PROCEDURE [TV].[Brand_YTD_Location]
(@Year int,
 @Tour nvarchar(50))
AS
BEGIN

select (t.sd*100/t.BT)as BrandEquipPercent, 
		t.Brand,
		t.equip,
		t.BT
from (		

SELECT sum(a.[Duration]) as SD, BT, Equip,a.[Brand]
  FROM [DARRELL_MASTER].[TV].[TVAudit] a
inner join 
	(SELECT top 35 sum([Duration]) as BT, brand FROM [DARRELL_MASTER].[TV].[TVAudit] where YEAR([TntFirstDay]) = @year and [Tour] = @Tour group by Brand order by BT desc) b
  on b.Brand=a.brand
  group by a.Brand, Equip, bt) as t
  where (t.sd*100/t.BT) >1
  order by BT desc, BrandEquipPercent desc
  
  
     
END
GO
