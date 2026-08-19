DROP PROCEDURE IF EXISTS [OptOut].[Selection_LinkManager_AddNewLInk];
GO

-- obsoleted but will keep around, used to populate the linkmanager table as we transitioned to a key/value lookup system for the links players/feeds
CREATE procedure [OptOut].[Selection_LinkManager_AddNewLInk]
@playername varchar(200),
@feedname varchar(200)

as
begin
SET NOCOUNT ON

CREATE TABLE #SelectionData (
    SelectionId       INT,
    SelectionLevel    TINYINT,
    isOptIn           BIT,
    isOptIn_shaft     BIT,
    isOptIn_grip      BIT,
    PlayerName        VARCHAR(100),
    Brand             VARCHAR(100),
    Equipment         VARCHAR(100),
    Model             VARCHAR(100),
    Shaft             VARCHAR(100),
    Grip              VARCHAR(100),
    ClubNumber        VARCHAR(10),
    Loft              varchar(100),
    ShopifyId         BIGINT,
    default_link_url  VARCHAR(500),
    player_link_url   VARCHAR(500),
    SetByUserId       INT,
    SetBy             VARCHAR(10),
    AddedOn           DATETIME
);

insert into #SelectionData
exec optout.selection_getNew 'Charles-Script', @playername, 2026, 1

if ((select count(*) from [OptOut].[LinkManager] where playername = @playername and feedname = @feedname) = 0)
	if (@feedname = 'whatsinmybag')
		insert into [OptOut].[LinkManager] (playername, feedname, equipment, brand, model, clubnumber, link_url, addedon, addedby)
		select PlayerName, @feedname, equipment, brand, model, clubnumber, player_link_url, getdate(), '[OptOut].[Selection_LinkManager_Helper]' from #SelectionData where player_link_url is not null and rtrim(ltrim(player_link_url)) <> '' and player_link_url not like '?%'
	else
		insert into [OptOut].[LinkManager] (playername, feedname, equipment, brand, model, clubnumber, link_url, addedon, addedby)
		select PlayerName, @feedname, equipment, brand, model, clubnumber, default_link_url, getdate(), '[OptOut].[Selection_LinkManager_Helper]' from #SelectionData	where default_link_url is not null and rtrim(ltrim(default_link_url)) <> '' and default_link_url not like '?%'

drop table #SelectionData

end
GO
