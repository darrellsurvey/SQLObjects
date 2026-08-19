DROP PROCEDURE IF EXISTS [TV].[Brand_YTD];
GO

CREATE PROCEDURE [TV].[Brand_YTD]
(@Year int,
 @Tour nvarchar(50))
AS
BEGIN

declare @SumTotal as integer
select @SumTotal = sum([Duration]) from [DARRELL_MASTER].[TV].[TVAudit] where YEAR([TntFirstDay]) = @year and [Tour] = @Tour

SELECT rank() over (ORDER BY sum([Duration]) DESC) AS [Rank],
		[Brand], 
		sum([Duration]) as BrandSum,
		sum([Duration]) * 100 / @SumTotal as BrandPercent,
		count([Duration]) as BrandUses
  FROM [DARRELL_MASTER].[TV].[TVAudit]
  where YEAR([TntFirstDay]) = @year and [Tour] = @Tour
  group by Brand
  order by BrandPercent desc

    
END
GO
