IF OBJECT_ID('TV.Brand_YTD_DOB') IS NOT NULL
    DROP PROCEDURE [TV].[Brand_YTD_DOB];
GO

CREATE PROCEDURE [TV].[Brand_YTD_DOB]
(@Year int,
 @Tour nvarchar(50))
AS
BEGIN


select p.*, b.BrandTime
from 
(SELECT sum([Duration]) as PlayerTime
      ,[PlayerName]
      ,[Brand]
      ,RANK() over(partition by brand order by sum([Duration]) desc) as NumUno
  FROM [DARRELL_MASTER].[TV].[TVAudit]
  where YEAR([TntFirstDay]) = @year and [Tour] = @Tour
  group by PlayerName, brand) P
inner join   
(SELECT top 12 sum([Duration]) as BrandTime
      ,[Brand]
  FROM [DARRELL_MASTER].[TV].[TVAudit]
  where YEAR([TntFirstDay]) = @year and [Tour] = @Tour
  group by brand order by sum([Duration]) desc) B

on p.Brand= b.Brand
 
where NumUno < 11
order by BrandTime desc, NumUno

end
GO
