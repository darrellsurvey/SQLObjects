DROP PROCEDURE IF EXISTS [TV].[Brand_YTD_DOB_1];
GO

CREATE PROCEDURE [TV].[Brand_YTD_DOB_1]
(@Year int,
 @Tour nvarchar(50))
AS
BEGIN

SELECT top 12 sum([Duration]) as BrandTime
      ,[Brand]
	  ,RANK() over(order by sum([Duration]) desc) as NumUno
  FROM [DARRELL_MASTER].[TV].[TVAudit]
  where YEAR([TntFirstDay]) = @year and [Tour] = @Tour
  group by brand 
  order by sum([Duration]) desc



end
GO
