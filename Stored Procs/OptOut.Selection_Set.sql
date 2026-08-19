IF OBJECT_ID('OptOut.Selection_Set') IS NOT NULL
    DROP PROCEDURE [OptOut].[Selection_Set];
GO

CREATE procedure [OptOut].[Selection_Set]
@user varchar(100), 
@SelectionId int, 
@isOptIn bit,
@ShopifyId varchar(100)

as
begin

--exec [OptOut].[Selection_Set] 'asanchez', 2024, 25, 1

declare @PlayerName varchar(100), @Season integer, @SelectionLevel tinyint, @Brand varchar(50), @Equipment varchar(50), @Model varchar(100)

select @PlayerName = PlayerName, 
		@Season = Season,
		@SelectionLevel = SelectionLevel,
		@Brand = Brand,
		@Equipment = Equipment,
		@Model = Model
from OptOut.Selection where selectionid = @SelectionId


if @SelectionLevel = 0 
	begin 
		update OptOut.Selection Set isOptIn = @isOptIn, SetByUserId = @user, AddedOn = getdate(), ShopifyId = @ShopifyId where playername = @PlayerName and season = @Season
	end
 
if @SelectionLevel = 1 
	begin 
		update OptOut.Selection Set isOptIn = @isOptIn, SetByUserId = @user, AddedOn = getdate(), ShopifyId = @ShopifyId where playername = @PlayerName and season = @Season and brand = @Brand
	end

if @SelectionLevel = 2 
	begin 
		update OptOut.Selection Set isOptIn = @isOptIn, SetByUserId = @user, AddedOn = getdate(), ShopifyId = @ShopifyId where playername = @PlayerName and season = @Season and brand = @Brand and Equipment = @Equipment
	end

if @SelectionLevel = 3 
	begin 
		update OptOut.Selection Set isOptIn = @isOptIn, SetByUserId = @user, AddedOn = getdate(), ShopifyId = @ShopifyId where playername = @PlayerName and season = @Season and brand = @Brand and Equipment = @Equipment and Model = @Model
	end


end
GO
