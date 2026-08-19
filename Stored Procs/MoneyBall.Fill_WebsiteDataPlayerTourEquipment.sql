DROP PROCEDURE IF EXISTS [MoneyBall].[Fill_WebsiteDataPlayerTourEquipment];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	
-- =============================================

CREATE procedure [MoneyBall].[Fill_WebsiteDataPlayerTourEquipment]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS
Begin -- WebsiteDataPlayerTourEquipment
Print 'Start WebsiteDataPlayerTourEquipment'

delete from MoneyBall.WebsiteDataPlayerTourEquipment where PGASeason = @PGASeason and SportTourId = @SportTourId

if @SportTourId = 8 -- or @SportTourId = 56
	begin
		insert into MoneyBall.WebsiteDataPlayerTourEquipment
		(PGASeason, LineNum, Equipment, PlayerName, ClubNumber, Brand, Model, ModelTotal, TournamentsPlayed, SportTourId)

		select PGASeason, 1, Equip as Equipment, PlayerName, NULL, Brand, nullif(Model, '') as Model, COUNT(*) as ModelTotal, NULL as TournamentsPlayed, @SportTourId as SportTourId from 
		(select distinct PGASeason, Equip, PlayerName, Brand, Model, tournamentid as SportTourId 
			from TV.TVAudit
		where PGASeason = @PGASeason and [tntFirstDay] < @LastFullTournamentEnd and Tour = @Tour) a
		group by PGASeason, Equip, PlayerName, Brand, Model
	end
else
	begin

;with cte_ball as(select PGASeason, 1 as linenum, 'Ball' as Equip, rtrim(a.PLAYERNAME) as PLAYERNAME, NULL as clubnumber, BRAND, model
					from dbo.[ball] a where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and tournamentid <> 7583 and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))),

cte_Iron as (select PGASeason, rank() over(partition by a.playername, [first day] order by pkey) as linenum,  
					'Iron' as Equip, rtrim(a.PLAYERNAME) as PLAYERNAME, rtrim(ltrim([CLUB NUMBER])) as clubnumber, BRAND, model
					from dbo.irons a where rtrim(ltrim([CLUB NUMBER])) not like '%^' and  PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and tournamentid <> 7583 and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))),

cte_Utility as (select PGASeason, rank() over(partition by a.playername, [first day] order by pkey) as linenum,  
					'Utility Iron' as Equip, rtrim(a.PLAYERNAME) as PLAYERNAME, rtrim(ltrim([CLUB NUMBER])) as clubnumber, BRAND, model
					from dbo.irons a where rtrim(ltrim([CLUB NUMBER])) like '%^' and  PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and tournamentid <> 7583 and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))),

cte_driver as (select PGASeason, rank() over(partition by a.playername, [first day] order by pkey) as linenum,
					'Driver' as Equip, rtrim(a.PLAYERNAME) as PLAYERNAME, Null as clubnumber, BRAND, model
					from dbo.[woods] a where ISDRIVER = 1 and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and tournamentid <> 7583 and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))),

cte_fw as (select PGASeason, rank() over(partition by a.playername, [first day] order by pkey) as linenum,
					'FW' as Equip, rtrim(a.PLAYERNAME) as PLAYERNAME, [Club number] as clubnumber, BRAND, model
					from dbo.[woods] a where ISDRIVER = 0 and [CLUB NUMBER] <> 'Hybrid' and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and tournamentid <> 7583 and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))),

cte_hybrid as (select PGASeason, rank() over(partition by a.playername, [first day] order by pkey) as linenum,
					'Hybrid' as Equip, rtrim(a.PLAYERNAME) as PLAYERNAME, Null as clubnumber, BRAND, model
					from dbo.[woods] a where [CLUB NUMBER] = 'Hybrid' and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and tournamentid <> 7583 and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))),

cte_putter as (select PGASeason, rank() over(partition by a.playername, [first day] order by pkey) as linenum, 
					'Putter' as Equip, rtrim(a.PLAYERNAME) as PLAYERNAME, NULL as clubnumber, BRAND, model
					from dbo.[Putters] a where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and tournamentid <> 7583 and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))),

cte_wedge as (select PGASeason, rank() over(partition by a.playername, [first day] order by pkey) as linenum, 
					'Wedge' as Equip, rtrim(a.PLAYERNAME) as PLAYERNAME, ltrim(rtrim([Club number])) as clubnumber, BRAND, model
					from dbo.Wedges a where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and tournamentid <> 7583 and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))),
					
cte_glove as (select PGASeason, 1 as linenum, 'Glove' as Equip, rtrim(a.PLAYERNAME) as PLAYERNAME, NULL as clubnumber, BRAND, model
					from dbo.Gloves a where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and tournamentid <> 7583 and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))),

cte_bag as (select PGASeason, 1 as linenum, 'Bag' as Equip, rtrim(a.PLAYERNAME) as PLAYERNAME, NULL as clubnumber, BRAND, model
					from dbo.Bag a where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and tournamentid <> 7583 and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))),
					
cte_shoe as (select PGASeason, 1 as linenum, 'Shoe' as Equip, rtrim(a.PLAYERNAME) as PLAYERNAME, NULL as clubnumber, BRAND, model
					from dbo.Shoes a where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and tournamentid <> 7583 and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))),					
										
cte_headgear as (select PGASeason, 1 as linenum, 'Headgear' as Equip, rtrim(a.PLAYERNAME) as PLAYERNAME, NULL as clubnumber, BRAND, model
					from dbo.Headgear a where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and tournamentid <> 7583 and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))),
					
cte_shirt as (select PGASeason, 1 as linenum, 'Shirt' as Equip, rtrim(a.PLAYERNAME) as PLAYERNAME, NULL as clubnumber, BRAND, model
					from dbo.Shirts a where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and tournamentid <> 7583 and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))),					

cte_CaddieHat as (select PGASeason, 1 as linenum, 'CaddieHeadgear' as Equip, rtrim(a.PLAYERNAME) as PLAYERNAME, NULL as clubnumber, BRAND, model
					from dbo.CaddieHeadgear a where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and tournamentid <> 7583 and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))),

cte_Towel as (select PGASeason, 1 as linenum, 'Towel' as Equip, rtrim(a.PLAYERNAME) as PLAYERNAME, NULL as clubnumber, BRAND, model
					from dbo.Towel a where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and tournamentid <> 7583 and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))))




insert into MoneyBall.WebsiteDataPlayerTourEquipment
(PGASeason, LineNum, Equipment, PlayerName, ClubNumber, Brand, Model, ModelTotal, SportTourId, TournamentsPlayed)
select a.*, d1.TournamentsPlayed from (
select PGASeason, LineNum, Equip as Equipment, PlayerName, ClubNumber, Brand, Model, COUNT(Model) as ModelTotal, @SportTourId as SportTourId from cte_ball group by PGASeason, LineNum, Equip, PlayerName, ClubNumber, Brand, Model union all
select PGASeason, LineNum, Equip as Equipment, PlayerName, ClubNumber, Brand, Model, COUNT(Model) as ModelTotal, @SportTourId as SportTourId from cte_iron group by PGASeason, LineNum, Equip, PlayerName, ClubNumber, Brand, Model union all
select PGASeason, LineNum, Equip as Equipment, PlayerName, ClubNumber, Brand, Model, COUNT(Model) as ModelTotal, @SportTourId as SportTourId from cte_utility group by PGASeason, LineNum, Equip, PlayerName, ClubNumber, Brand, Model union all
select PGASeason, LineNum, Equip as Equipment, PlayerName, ClubNumber, Brand, Model, COUNT(Model) as ModelTotal, @SportTourId as SportTourId from cte_driver group by PGASeason, LineNum, Equip, PlayerName, ClubNumber, Brand, Model union all
select PGASeason, LineNum, Equip as Equipment, PlayerName, ClubNumber, Brand, Model, COUNT(Model) as ModelTotal, @SportTourId as SportTourId from cte_fw group by PGASeason, LineNum, Equip, PlayerName, ClubNumber, Brand, Model union all
select PGASeason, LineNum, Equip as Equipment, PlayerName, ClubNumber, Brand, Model, COUNT(Model) as ModelTotal, @SportTourId as SportTourId from cte_hybrid group by PGASeason, LineNum, Equip, PlayerName, ClubNumber, Brand, Model union all
select PGASeason, LineNum, Equip as Equipment, PlayerName, ClubNumber, Brand, Model, COUNT(Model) as ModelTotal, @SportTourId as SportTourId from cte_putter group by PGASeason, LineNum, Equip, PlayerName, ClubNumber, Brand, Model union all
select PGASeason, LineNum, Equip as Equipment, PlayerName, ClubNumber, Brand, Model, COUNT(Model) as ModelTotal, @SportTourId as SportTourId from cte_bag group by PGASeason, LineNum, Equip, PlayerName, ClubNumber, Brand, Model union all
select PGASeason, LineNum, Equip as Equipment, PlayerName, ClubNumber, Brand, Model, COUNT(Model) as ModelTotal, @SportTourId as SportTourId from cte_glove group by PGASeason, LineNum, Equip, PlayerName, ClubNumber, Brand, Model union all
select PGASeason, LineNum, Equip as Equipment, PlayerName, ClubNumber, Brand, Model, COUNT(Model) as ModelTotal, @SportTourId as SportTourId from cte_shoe group by PGASeason, LineNum, Equip, PlayerName, ClubNumber, Brand, Model union all
select PGASeason, LineNum, Equip as Equipment, PlayerName, ClubNumber, Brand, Model, COUNT(Model) as ModelTotal, @SportTourId as SportTourId from cte_headgear group by PGASeason, LineNum, Equip, PlayerName, ClubNumber, Brand, Model union all
select PGASeason, LineNum, Equip as Equipment, PlayerName, ClubNumber, Brand, Model, COUNT(Model) as ModelTotal, @SportTourId as SportTourId from cte_shirt group by PGASeason, LineNum, Equip, PlayerName, ClubNumber, Brand, Model union all
select PGASeason, LineNum, Equip as Equipment, PlayerName, ClubNumber, Brand, Model, COUNT(Model) as ModelTotal, @SportTourId as SportTourId from cte_CaddieHat group by PGASeason, LineNum, Equip, PlayerName, ClubNumber, Brand, Model union all
select PGASeason, LineNum, Equip as Equipment, PlayerName, ClubNumber, Brand, Model, COUNT(Model) as ModelTotal, @SportTourId as SportTourId from cte_Towel group by PGASeason, LineNum, Equip, PlayerName, ClubNumber, Brand, Model union all
select PGASeason, LineNum, Equip as Equipment, PlayerName, ClubNumber, Brand, Model, COUNT(Model) as ModelTotal, @SportTourId as SportTourId from cte_wedge group by PGASeason, LineNum, Equip, PlayerName, ClubNumber, Brand, Model) a
inner join [darrell_master].[MoneyBall].[WebsiteDataPlayer1] as d1 on a.PGASeason = d1.PGASeason and a.PLAYERNAME = d1.PlayerName and d1.SportTourId = a.SportTourId
	
	end


Print 'Finished WebsiteDataPlayerTourEquipment'; 
end -- WebsiteDataPlayerTourEquipment
GO
