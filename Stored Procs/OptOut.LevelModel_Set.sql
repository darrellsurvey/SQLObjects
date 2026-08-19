DROP PROCEDURE IF EXISTS [OptOut].[LevelModel_Set];
GO

CREATE procedure [OptOut].[LevelModel_Set]
@user varchar(100), 
@Season integer,
@PlayerName varchar(50), 
@Brand varchar(100),
@Equipment varchar(50),
@Model varchar(100),
@isOptIn bit

as
begin

--exec [OptOut].[LevelModel_Set] 'asanchez', 2024, 'WOODS, TIGER', 'NIKE', 'BALL', 'TOUR AD VF6', 1

	update OptOut.Selection
	Set isOptIn = @isOptIn, SetByUserId = @user, AddedOn = getdate()
	where playername = @PlayerName and season = @Season and brand = @Brand and Equipment = @Equipment and Model = @Model

end
GO
