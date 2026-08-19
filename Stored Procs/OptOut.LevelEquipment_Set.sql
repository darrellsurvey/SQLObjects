DROP PROCEDURE IF EXISTS [OptOut].[LevelEquipment_Set];
GO

Create procedure [OptOut].[LevelEquipment_Set]
@user varchar(100), 
@Season integer,
@PlayerName varchar(50), 
@Brand varchar(100),
@Equipment varchar(50),
@isOptIn bit

as
begin

--exec [OptOut].[LevelEquipment_Set] 'asanchez', 2024, 'WOODS, TIGER', 'NIKE', 'BALL', 1

	update OptOut.Selection
	Set isOptIn = @isOptIn, SetByUserId = @user, AddedOn = getdate()
	where playername = @PlayerName and season = @Season and brand = @Brand and Equipment = @Equipment

end
GO
