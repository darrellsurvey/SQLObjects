DROP PROCEDURE IF EXISTS [TV].[Brand_YTD_Brand_Model];
GO

/****** Script for SelectTopNRows command from SSMS  ******/
CREATE PROCEDURE [TV].[Brand_YTD_Brand_Model]
(@Year int,
 @Tour nvarchar(50))
AS
BEGIN

SELECT sum([Duration]) as ModelTime
	  ,Count([Duration]) as ModelUse
	  , (select sum(duration) from [DARRELL_MASTER].[TV].[TVAudit] 
			where brand = a.brand and YEAR([TntFirstDay]) = @Year and [TOUR] = @Tour
			group by Brand,YEAR([TntFirstDay]), [TOUR] ) as 'brandtotal'
      ,[Brand]
      ,[Model]
  FROM [DARRELL_MASTER].[TV].[TVAudit] a
  where YEAR(a.[TntFirstDay]) = @Year and a.[TOUR] = @Tour
  group by brand, model
  order by brandtotal desc, ModelTime desc
  
  
  
 END
GO
