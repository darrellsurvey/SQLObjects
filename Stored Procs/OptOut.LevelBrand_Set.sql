IF OBJECT_ID('OptOut.LevelBrand_Set') IS NOT NULL
    DROP PROCEDURE [OptOut].[LevelBrand_Set];
GO

CREATE procedure [OptOut].[LevelBrand_Set]
@user varchar(100), 
@Season integer,
@PlayerName varchar(50), 
@Brand varchar(100),
@isOptIn bit

as
begin

--exec [OptOut].[LevelBrand_Set] 'asanchez', 2024, 'WOODS, TIGER', 'NIKE', 1


--Delete from OptOut.Settings WHERE PlayerName = @PlayerName and SetBy = @SetBy and Season = @Season and Brand = @Brand
--If @isOptIn = 1
--begin
--	insert into OptOut.Settings (PlayerName, Season, SetBy, Brand)
--	values (@PlayerName, @Season, @SetBy, @Brand)
--end

	update OptOut.Selection
	Set isOptIn = @isOptIn, SetByUserId = @user, AddedOn = getdate()
	where playername = @PlayerName and season = @Season and brand = @Brand

end
GO
