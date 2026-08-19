DROP PROCEDURE IF EXISTS [MoneyBall].[Marketplace1];
GO

create procedure [MoneyBall].[Marketplace1]
@Company varchar(40),
@PGASeason integer

as
begin

set nocount on;

--EXEC [MoneyBall].[Marketplace] 'Callaway', 2018

declare @CompanyPlayersExist tinyint
declare @TVCost as money

select @CompanyPlayersExist = COUNT(*) from MoneyBall.CompanyPlayerContract where Company = @Company and PGASeason = @PGASeason
select @TVCost = TVTimeCost from [DARRELL_MASTER].MoneyBall.WebsiteDataTVTimeCost where PGASeason = @PGASeason

;with cte1 as (
SELECT [PlayerName],[Brand],[Equipment],[Placement],[DSPoints],0 as IsEstimate, RANK() over(PARTITION by [PlayerName],[Equipment],[Placement] order by [DSPoints] desc) as brandRank
  FROM [darrell_master].[MoneyBall].[WebsiteDataPlayer4]
  where PGASeason = @PGASeason
union all
SELECT [PlayerName],NULL,[Equipment],[Placement],[DSPoints],1 as [IsEstimate], 99 as brandRank
  FROM [darrell_master].[MoneyBall].[WebsiteDataPlayer3]  
  where PGASeason = @PGASeason and IsEstimate = 1)
  

select a.PlayerName, a.Equipment, a.Placement, sum(a.DSPoints) as DSPoints, IsEstimate, SUM(a.DSPoints * @TVCost*2) as TVAdCost, count(a.Brand) as CountOfBrands, b.Brand,
p1.DSPoints as TotalDS, p1.DSRank, p1.MoneyWon,
case when @CompanyPlayersExist > 0 then cp.PlayerName else bp.PlayerName end as CompanyPlayer
from cte1 a
left join (select PlayerName, Equipment, Placement, Brand from cte1 where brandRank = 1) b
on a.PlayerName = b.PlayerName and a.Placement = b.Placement and a.Equipment = b.Equipment
left join MoneyBall.WebsiteDataPlayer1 p1 on a.PlayerName = p1.PlayerName and p1.PGASeason = @PGASeason
left join (select PlayerName from MoneyBall.CompanyPlayerContract where Company = @Company and PGASeason = @PGASeason) as cp on a.PlayerName = cp.PlayerName 
left join (select PlayerName from MoneyBall.WebsiteData5 where Brand = @Company and PGASeason = @PGASeason) as bp on a.PlayerName = bp.PlayerName
group by a.PlayerName, a.Equipment, a.Placement, IsEstimate, b.Brand, p1.DSPoints, p1.DSRank, p1.MoneyWon, 
case when @CompanyPlayersExist > 0 then cp.PlayerName else bp.PlayerName end
  

end
GO
