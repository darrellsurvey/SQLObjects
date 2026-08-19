DROP PROCEDURE IF EXISTS [OptOut].[Selection_SetNew];
GO

CREATE procedure [OptOut].[Selection_SetNew]
@user varchar(100), 
@usertype varchar(5),
@SelectionId int, 
@isOptIn bit,
@shaftOrGrip varchar(100) = ''   -- 'shaft' or 'grip'

as
begin

--exec [OptOut].[Selection_Set] 'asanchez', 2024, 25, 1

declare @PlayerName varchar(100), @Season integer, @SelectionLevel tinyint, @Brand varchar(50), @Equipment varchar(50), @Model varchar(100), @ClubNumber varchar(100)

select @PlayerName = PlayerName, 
		@Season = Season,
		@SelectionLevel = SelectionLevel,
		@Brand = Brand,
		@Equipment = Equipment,
		@Model = Model,
		@ClubNumber = ClubNumber
from OptOut.SelectionNew where selectionid = @SelectionId


if @SelectionLevel = 0 
	begin 
		update OptOut.SelectionNew Set isOptIn = @isOptIn, SetByUserId = @user, SetBy = @usertype, AddedOn = getdate() where playername = @PlayerName and season = @Season
	end
 
if @SelectionLevel = 1
	begin 
		update OptOut.SelectionNew Set isOptIn = @isOptIn, SetByUserId = @user, SetBy = @usertype, AddedOn = getdate() where playername = @PlayerName and season = @Season and brand = @Brand
	end

if @SelectionLevel = 2 
	begin 
		update OptOut.SelectionNew Set isOptIn = @isOptIn, SetByUserId = @user, SetBy = @usertype, AddedOn = getdate() where playername = @PlayerName and season = @Season and brand = @Brand
	end

if @SelectionLevel = 3 
	begin 
		update OptOut.SelectionNew Set isOptIn = @isOptIn, SetByUserId = @user, SetBy = @usertype, AddedOn = getdate() where playername = @PlayerName and season = @Season and brand = @Brand and Equipment = @Equipment
	end

if @SelectionLevel = 4 
	begin 
		if @shaftOrGrip = '' 
			update OptOut.SelectionNew Set isOptIn = @isOptIn, SetByUserId = @user, SetBy = @usertype, AddedOn = getdate() where playername = @PlayerName and season = @Season and brand = @Brand and Equipment = @Equipment and Model = @Model and coalesce(ClubNumber, '') = coalesce(@ClubNumber, '')
		if LOWER(@shaftOrGrip) = 'shaft' 
			update OptOut.SelectionNew Set isOptIn_shaft = @isOptIn, SetByUserId = @user, SetBy = @usertype, AddedOn = getdate() where playername = @PlayerName and season = @Season and brand = @Brand and Equipment = @Equipment and Model = @Model and coalesce(ClubNumber, '') = coalesce(@ClubNumber, '')
		if LOWER(@shaftOrGrip) = 'grip' 
			update OptOut.SelectionNew Set isOptIn_grip = @isOptIn, SetByUserId = @user, SetBy = @usertype, AddedOn = getdate() where playername = @PlayerName and season = @Season and brand = @Brand and Equipment = @Equipment and Model = @Model and coalesce(ClubNumber, '') = coalesce(@ClubNumber, '')
	end


end



-- select * from OptOut.SelectionNew

-- update OptOut.SelectionNew set isOptIn_shaft = 1, isOptIn_grip = 1

-- exec [OptOut].[Selection_SetNew] 40 , 206, 1


--PlayerName	Season	SelectionLevel	Brand	Equipment	Model
--THOMAS, JUSTIN	2025	3	TITLEIST	Bag	NULL



-- select * from OptOut.SelectionNew where playername = 'THOMAS, JUSTIN' and season = 2025 and brand = 'TITLEIST' and Equipment = 'Bag' and Model is NULL



-- select * from OptOut.SelectionNew where selectionid = 22837
-- select * from OptOut.SelectionNew where selectionid = 22825
GO
