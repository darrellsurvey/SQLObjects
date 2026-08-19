IF OBJECT_ID('TV.Week_All_Brands') IS NOT NULL
    DROP PROCEDURE [TV].[Week_All_Brands];
GO

CREATE PROCEDURE [TV].[Week_All_Brands]
(@Year int,
 @SID int)
AS
BEGIN

SELECT sum([Duration]) as RoundTotal, 
		(select sum([Duration]) 
			FROM [DARRELL_MASTER].[TV].[TVAudit] b 
			where b.brand = a.brand and 
				TntNid = @SID and 
				YEAR([TntFirstDay]) = @year) as BrandTotal
      ,[Brand]
      ,[Round]
      ,TntName
  FROM [DARRELL_MASTER].[TV].[TVAudit] a
  where TntNid = @SID and YEAR([TntFirstDay]) = @year
  group by Brand, [Round], TntName
  order by BrandTotal desc
  
END
GO
