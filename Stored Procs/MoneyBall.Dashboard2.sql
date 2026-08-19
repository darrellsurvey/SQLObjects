DROP PROCEDURE IF EXISTS [MoneyBall].[Dashboard2];
GO

CREATE procedure [MoneyBall].[Dashboard2]
@Brand varchar(40),
@PGASeason integer,
@SportTourId integer

as
begin

set nocount on;

--EXEC [MoneyBall].[Dashboard2] 'callaway', 2018, 1

declare @BrandRank as smallint

SELECT @BrandRank = [DSPointsRank] FROM [darrell_master].[MoneyBall].[WebsiteData6] where Brand = @Brand and PGASeason = @PGASeason and SportTourId = @SportTourId

SELECT d3.Brand
	  ,d2.[TournamentName]
      ,d2.[FirstDay]
      ,d2.[Winner]
      ,d2.[DSPWinner]
      ,d3.TotalDS
      ,d3.BrandRank
      ,d3.PlayerMostContributed
      ,rank() over(partition by d3.Brand order by d3.TotalDS desc) as rn
FROM [darrell_master].[MoneyBall].[WebsiteData2] d2
left outer join [darrell_master].MoneyBall.WebsiteData3 d3
on d2.TournamentId = d3.TournamentId and d2.SportTourId = d3.SportTourId
where d2.PGASeason = @PGASeason and d2.SportTourId = @SportTourId and d3.Brand in (SELECT Brand 
											FROM [darrell_master].[MoneyBall].[WebsiteData6] 
											where PGASeason = @PGASeason and SportTourId = @SportTourId and [DSPointsRank] between @BrandRank - 2 and @BrandRank + 2)
order by Brand, FirstDay
  
  

end
GO
