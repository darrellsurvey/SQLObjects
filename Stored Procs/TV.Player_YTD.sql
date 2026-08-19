DROP PROCEDURE IF EXISTS [TV].[Player_YTD];
GO

CREATE PROCEDURE [TV].[Player_YTD]
(@Year int,
 @Tour nvarchar(50))
AS
BEGIN

declare @SumTotal as integer
select @SumTotal = sum([Duration]) from [DARRELL_MASTER].[TV].[TVAudit] where YEAR([TntFirstDay]) = @year and [Tour] = @Tour

SELECT rank() over (ORDER BY sum([Duration]) DESC) AS [Rank],
		[PlayerName], 
		sum([Duration]) as PlayerSum,
		sum([Duration]) * 100.0 / @SumTotal as PlayerPercent,
		count([Duration]) as PlayerUses
  FROM [DARRELL_MASTER].[TV].[TVAudit]
  where YEAR([TntFirstDay]) = @year and [Tour] = @Tour
  group by PlayerName
  order by PlayerPercent desc



END
GO
