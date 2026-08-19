IF OBJECT_ID('OptOut.LevelPlayer_Set') IS NOT NULL
    DROP PROCEDURE [OptOut].[LevelPlayer_Set];
GO

CREATE procedure [OptOut].[LevelPlayer_Set]
@user varchar(100), 
@SelectionId int, 
@isOptIn bit

as
begin

--exec [OptOut].[LevelPlayer_Set] 'asanchez', 2024, 25, 1

declare @PlayerName varchar(100)
declare @Season integer
select @PlayerName = PlayerName, @Season = Season from OptOut.Selection where selectionid = @SelectionId

	update OptOut.Selection
	Set isOptIn = @isOptIn, SetByUserId = @user, AddedOn = getdate()
	where playername = @PlayerName and season = @Season
end
GO
