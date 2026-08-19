DROP PROCEDURE IF EXISTS [MoneyBall].[Marketplace];
GO

CREATE procedure [MoneyBall].[Marketplace]
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
SELECT [PlayerName],[Brand],EquipmentPlacement,[DSPoints],0 as IsEstimate, RANK() over(PARTITION by [PlayerName],[Equipment],[Placement] order by [DSPoints] desc) as brandRank
  FROM [darrell_master].[MoneyBall].[WebsiteDataPlayer4]
  where PGASeason = @PGASeason
union all
SELECT [PlayerName],NULL,EquipmentPlacement,[DSPoints],1 as [IsEstimate], 99 as brandRank
  FROM [darrell_master].[MoneyBall].[WebsiteDataPlayer3]  
  where PGASeason = @PGASeason and IsEstimate = 1),
  
cte2 as (
select a.PlayerName, a.EquipmentPlacement, 
sum(a.DSPoints) as DSPoints, IsEstimate, SUM(a.DSPoints * @TVCost*2) as TVAdCost, count(a.Brand) as CountOfBrands, b.Brand,
p1.DSPoints as TotalDS, p1.DSRank, p1.MoneyWon,
case when @CompanyPlayersExist > 0 then cp.PlayerName else bp.PlayerName end as CompanyPlayer
from cte1 a
left join (select PlayerName, EquipmentPlacement, Brand from cte1 where brandRank = 1) b
on a.PlayerName = b.PlayerName and a.EquipmentPlacement = b.EquipmentPlacement
left join MoneyBall.WebsiteDataPlayer1 p1 on a.PlayerName = p1.PlayerName and p1.PGASeason = @PGASeason
left join (select PlayerName from MoneyBall.CompanyPlayerContract where Company = @Company and PGASeason = @PGASeason) as cp on a.PlayerName = cp.PlayerName 
left join (select PlayerName from MoneyBall.WebsiteData5 where Brand = @Company and PGASeason = @PGASeason) as bp on a.PlayerName = bp.PlayerName
group by a.PlayerName, a.EquipmentPlacement, IsEstimate, b.Brand, p1.DSPoints, p1.DSRank, p1.MoneyWon, 
case when @CompanyPlayersExist > 0 then cp.PlayerName else bp.PlayerName end),
  
cte3 as (  
select case when CompanyPlayer is null then 0 else 1 end CompanyPlayer,
PlayerName,
EquipmentPlacement,
DSRank,
MoneyWon,
'<p class="Brand">' + isnull(Brand, '') + case when CountOfBrands = 0 then '' else '(' + cast(CountOfBrands as varchar(2)) + ')' end + '</p>
<p class="DSPoints">' + case when IsEstimate = 0 then cast(DSPoints as varchar(30)) else '' end + '</p>
<p class="DSPointEstimate">' + case when IsEstimate = 1 then cast(DSPoints as varchar(30)) else '' end + '</p>
<p class="TVAdCost">' + cast(TVAdCost as varchar(30)) + '</p>' as CellData
from cte2  
where EquipmentPlacement in ('BagBody', 'HeadgearBack', 'HeadgearFront', 'HeadgearLeftSide', 'HeadgearRightSide', 'ShirtBack', 'ShirtFront', 'Shoes'))


select CompanyPlayer, PlayerName, DSRank, MoneyWon, [BagBody], [HeadgearBack], [HeadgearFront], [HeadgearLeftSide], [HeadgearRightSide], [ShirtBack], [ShirtFront], [Shoes]
from cte3
pivot (min(CellData) for EquipmentPlacement in ([BagBody], [HeadgearBack], [HeadgearFront], [HeadgearLeftSide], [HeadgearRightSide], [ShirtBack], [ShirtFront], [Shoes])) p
  


end
GO
