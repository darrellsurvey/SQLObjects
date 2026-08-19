DROP PROCEDURE IF EXISTS [MoneyBall].[Dashboard5];
GO

CREATE procedure [MoneyBall].[Dashboard5]
@Brand varchar(40),
@PGASeason integer,
@SportTourId integer

as
begin

set nocount on;

--EXEC [MoneyBall].[Dashboard5] 'Nike', 2022, 1

declare @BrandRank as smallint

SELECT @BrandRank = [DSPointsRank] FROM [darrell_master].[MoneyBall].[WebsiteData6] where Brand = @Brand and PGASeason = @PGASeason and SportTourId = @SportTourId

declare @RankBefore integer = @BrandRank - 2
declare @RankAfter integer = @BrandRank + 2

if @BrandRank = 1 or @BrandRank = 2
	begin
		set @RankBefore = 1
		set @RankAfter = 5
	end

;with cte1 as (select top 5 * from (
	SELECT [Brand],[DSPoints],[DSPointsPercent]
		FROM [darrell_master].[MoneyBall].[WebsiteData6]
		where PGASeason = @PGASeason and SportTourId = @SportTourId and [DSPointsRank] between @RankBefore and @RankAfter) as a
 order by DSPoints desc)


select *, DSPoints * 100.0/(select sum(DSPoints) from cte1) as PieDSPercent
from cte1 
order by DSPoints desc
  

end
GO
