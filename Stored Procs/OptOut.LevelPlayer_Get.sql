DROP PROCEDURE IF EXISTS [OptOut].[LevelPlayer_Get];
GO

CREATE procedure [OptOut].[LevelPlayer_Get]
@PlayerName varchar(100), 
@Season integer

as
begin

--exec [OptOut].[LevelPlayer_Get] 'WOODS, TIGER', 2024

-- uses a union, so if it returns results (in the case of player opted in) those are used, if not then the default isOptIn = 0 is used

select top 1 * from (

Select @PlayerName as PlayerName, @Season as Season, 1 as isOptIn, SetBy
from OptOut.Settings where PlayerName = @PlayerName and Season = @Season and Brand is NULL and Model is NULL
union all
Select @PlayerName as PlayerName, @Season as Season,
(SELECT count(*) FROM OptOut.Settings WHERE PlayerName = @PlayerName and Season = @Season and Brand is NULL and Model is NULL) as isOptIn, 'P' as SetBy
) combinedresults

end
GO
