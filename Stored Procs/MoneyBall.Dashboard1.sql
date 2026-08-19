IF OBJECT_ID('MoneyBall.Dashboard1') IS NOT NULL
    DROP PROCEDURE [MoneyBall].[Dashboard1];
GO

CREATE procedure [MoneyBall].[Dashboard1]
@Brand varchar(40),
@PGASeason integer

as
begin

set nocount on;

--EXEC [MoneyBall].[Dashboard1] 'parsons', 2017

;with cte as (SELECT [Brand]
      ,[MoneyWon]
      ,[MoneyWonRank]
      ,[MoneyWonPercent]
      ,[DSPoints]
      ,[DSPointsRank]
      ,[DSPointsPercent]
  FROM [DARRELL_MASTER].[MoneyBall].[WebsiteData6]
  where PGASeason = @PGASeason)
  
select a.*, 
		b.brand as MoneyComp, 
		b.MoneyWonRank as MoneyCompRank, 
		b.[MoneyWon] as MoneyCompMoney, 
		b.[MoneyWonPercent] as MoneyCompPercent, 
		a.MoneyWon - b.MoneyWon as MoneyWonDIff,
		c.Brand as DSComp, 
		c.DSPointsRank as DSCompRank, 
		c.[DSPoints] as DSCompPoints, 
		c.[DSPointsPercent] as DSCompPercent,
		a.DSPoints - c.DSPoints as DSPointsDiff
from cte a
left outer join cte b on a.MoneyWonRank = b.MoneyWonRank + 1
left outer join cte c on a.DSPointsRank = c.DSPointsRank + 1
where a.Brand = @Brand
order by a.MoneyWonRank
  
  

end
GO
