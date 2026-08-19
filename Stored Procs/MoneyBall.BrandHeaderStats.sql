DROP PROCEDURE IF EXISTS [MoneyBall].[BrandHeaderStats];
GO

CREATE procedure [MoneyBall].[BrandHeaderStats]
@Company varchar(20),
@Year integer

as

set nocount on;
with cte_BrandRank as (
SELECT Brand, [YearPlayed],[YearRank],[TotalPoints] 
	FROM [DARRELL_MASTER].[MoneyBall].[BrandDSRank] 
	where Brand = @Company),
    
cte_BrandPlayer as (  
SELECT count(distinct [PlayerName]) as PlayerCount, [TournamentYear]
  FROM [DARRELL_MASTER].[MoneyBall].[PlayerTVTime]
  where TVTimeBrandShirt = @Company or TVTimeBrandHat = @Company or TVTimeBrandBag = @Company
  group by [TournamentYear])
  
select Brand, [YearPlayed], [YearRank],[TotalPoints],PlayerCount
from cte_BrandRank br
inner join cte_BrandPlayer bp on br.YearPlayed = bp.TournamentYear
order by YearPlayed desc
GO
