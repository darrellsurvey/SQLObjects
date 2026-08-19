DROP PROCEDURE IF EXISTS [TV].[Player_YTD_By_Day];
GO

CREATE PROCEDURE [TV].[Player_YTD_By_Day]
(@Year int,
 @Tour nvarchar(50))
AS
BEGIN

SELECT top 35 [playername], 
		Sum(case when datepart(dw,[RoundDate]) in (4,5) then [Duration] else 0 end) * 100
			/ (Select Sum([Duration]) from [DARRELL_MASTER].[TV].[TVAudit]
				 where datepart(dw,[RoundDate]) in (4,5) and  YEAR([TntFirstDay]) = @year and [Tour] = @Tour) as 'Thursday',

		Sum(case when datepart(dw,[RoundDate]) = 6 then [Duration] else 0 end) * 100
			/ (Select Sum([Duration]) from [DARRELL_MASTER].[TV].[TVAudit]
				 where datepart(dw,[RoundDate]) = 6 and  YEAR([TntFirstDay]) = @year and [Tour] = @Tour) as 'Friday',

		Sum(case when datepart(dw,[RoundDate]) = 7 then [Duration] else 0 end) * 100
			/ (Select Sum([Duration]) from [DARRELL_MASTER].[TV].[TVAudit]
				 where datepart(dw,[RoundDate]) = 7 and  YEAR([TntFirstDay]) = @year and [Tour] = @Tour) as 'Saturday',

		Sum(case when datepart(dw,[RoundDate]) in (1,2) then [Duration] else 0 end) * 100
			/ (Select Sum([Duration]) from [DARRELL_MASTER].[TV].[TVAudit]
				 where datepart(dw,[RoundDate]) in (1,2) and  YEAR([TntFirstDay]) = @year and [Tour] = @Tour) as 'Sunday',
		
		Sum([Duration]) * 100
			/ (Select Sum([Duration]) from [DARRELL_MASTER].[TV].[TVAudit] Where YEAR([TntFirstDay]) = @year and [Tour] = @Tour)as 'Total'
  FROM [DARRELL_MASTER].[TV].[TVAudit]
  where YEAR([TntFirstDay]) = @year and [Tour] = @Tour
  group by [playername]
  order by Total desc
    
END
GO
