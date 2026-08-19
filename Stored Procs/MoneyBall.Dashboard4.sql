DROP PROCEDURE IF EXISTS [MoneyBall].[Dashboard4];
GO

CREATE procedure [MoneyBall].[Dashboard4]
@Brand varchar(40),
@PGASeason integer,
@SportTourId integer

as
begin

set nocount on;

--EXEC [MoneyBall].[Dashboard4] 'Callaway', 2018, 1

;with cte1 as (select top 5 * from (
SELECT [PlayerName] as x, sum([DSPoints]) as value, '#404040' as fill, 'normal' as state, sum([DSPoints]) as [DSPoints], sum([DSPoints]) * 100.0 / sum(sum([DSPoints])) over() as TotalDSPercent
  FROM [darrell_master].[MoneyBall].[WebsiteDataPlayer4]
  where Brand = @Brand and PGASeason = @PGASeason and SportTourId = @SportTourId
  group by [PlayerName]) as a
  order by [DSPoints] desc)


select *, [DSPoints]*100.0/(select sum([DSPoints]) from cte1) as PieDSPercent
from cte1 
order by [DSPoints] desc
  

end
GO
