DROP PROCEDURE IF EXISTS [dbo].[EventData];
GO

CREATE PROCEDURE [dbo].[EventData]
	@User varchar(100) = '',
	@Company varchar(100) = ''

AS

BEGIN
    SET NOCOUNT ON

	--exec [dbo].[EventData]

IF OBJECT_ID('tempdb..#CurrentEvents') IS NOT NULL
    DROP TABLE #CurrentEvents

	CREATE TABLE #CurrentEvents
		(TournamentId int)

		insert into #CurrentEvents
		SELECT [TournamentId] FROM [DARRELL_MASTER].[dbo].[TournamentsThisWeek] 
			where [ISFLASH] = 0 and tournamentid in (select distinct tournamentid from [Billing].[AllOrdersYTD] where Company = 'Titleist' and year = YEAR(GETDATE()) and [FIRST DAY] > dateadd(day, -8, getdate()))


IF OBJECT_ID('tempdb..#PreviousEventPlayed') IS NOT NULL
    DROP TABLE #PreviousEventPlayed

	CREATE TABLE #PreviousEventPlayed
(
    PlayerName varchar(50),
	TournamentId int
)


Insert into #PreviousEventPlayed 
select PlayerName, tournamentid from (
select b.PlayerName, tournamentid, rank() over(partition by b.PlayerName order by [first day] desc) as rn from dbo.[ball] b inner join 
(select PlayerName from dbo.[ball] where tournamentid in (select * from #CurrentEvents)) n on b.PLAYERNAME = n.PlayerName and [FIRST DAY] > dateadd(year, -3,getdate())) a
where a.rn = 2


--select * from #PreviousEventPlayed


IF OBJECT_ID('tempdb..#Results') IS NOT NULL
    DROP TABLE #Results

CREATE TABLE #Results
(   Equipment varchar(150),
    PlayerName varchar(150),
	TournamentName varchar(150),
	FirstDay date,
	LineNumber int,
    CurrentClubNumber varchar(10),
	CurrentBrand varchar(50),
	CurrentModel varchar(50),
	CurrentDegree varchar(50),
	LastClubNumber varchar(10),
	LastBrand varchar(50),
	LastModel varchar(50),
	LastDegree varchar(50))


insert into #Results (Equipment, PlayerName, TournamentName, FirstDay, LineNumber) 
select Equipment, rtrim(b.PLAYERNAME), b.[TOURNAMENT NAME] as TournamentName, b.[FIRST DAY] as FirstDay, LineNumber
from dbo.[ball] b inner join #CurrentEvents a on a.TournamentId = b.TournamentId
cross join (select 1 as LineNumber union all select 2 as LineNumber union all select 3 as LineNumber union all select 4 as LineNumber union all select 5 as LineNumber union all select 6 as LineNumber) q
cross join (select 'Iron - Set' as Equipment union all 
			select 'Iron - Not Set' as Equipment union all 
			select 'Iron - Utility' as Equipment union all 
			select 'Putter' as Equipment union all 
			select 'Wood - Driver' as Equipment union all 
			select 'Wood - Fairway' as Equipment union all 
			select 'Wood - Hybrid' as Equipment union all 
			select 'Wedge' as Equipment) z

--select * from #Results

--ball
insert into #Results (Equipment, PlayerName, TournamentName, FirstDay, CurrentClubNumber, CurrentBrand, CurrentModel, CurrentDegree) 
select 'Ball', rtrim(b.PLAYERNAME), b.[TOURNAMENT NAME] as TournamentName, b.[FIRST DAY] as FirstDay, NULL, BRAND, model, '' from dbo.[ball] b inner join #CurrentEvents a on a.TournamentId = b.TournamentId

Update r
set r.LastClubNumber = z.ClubNumber, r.LastBrand = z.BRAND, r.LastModel = z.MODEL, r.LastDegree = z.degree 
from #Results r inner join (select 'Ball' as Equipment, rtrim(b.PLAYERNAME) as PlayerName, NULL as ClubNumber, BRAND, model, '' as Degree from dbo.[ball] b inner join #PreviousEventPlayed a on a.TournamentId = b.TournamentId and a.PlayerName = b.PLAYERNAME) z
on r.PlayerName = z.playername and r.Equipment = z.Equipment


--glove
insert into #Results (Equipment, PlayerName, TournamentName, FirstDay, CurrentClubNumber, CurrentBrand, CurrentModel, CurrentDegree) 
select 'Glove', rtrim(b.PLAYERNAME), b.[TOURNAMENT NAME] as TournamentName, b.[FIRST DAY] as FirstDay, NULL, BRAND, model, '' from dbo.[Gloves] b inner join #CurrentEvents a on a.TournamentId = b.TournamentId

Update r
set r.LastClubNumber = z.ClubNumber, r.LastBrand = z.BRAND, r.LastModel = z.MODEL, r.LastDegree = z.degree 
from #Results r inner join (select 'Glove' as Equipment, rtrim(b.PLAYERNAME) as PlayerName, NULL as ClubNumber, BRAND, model, '' as Degree from dbo.[Gloves] b inner join #PreviousEventPlayed a on a.TournamentId = b.TournamentId and a.PlayerName = b.PLAYERNAME) z
on r.PlayerName = z.playername and r.Equipment = z.Equipment


--Shoe
insert into #Results (Equipment, PlayerName, TournamentName, FirstDay, CurrentClubNumber, CurrentBrand, CurrentModel, CurrentDegree) 
select 'Shoe', rtrim(b.PLAYERNAME), b.[TOURNAMENT NAME] as TournamentName, b.[FIRST DAY] as FirstDay, NULL, BRAND, model, '' from dbo.Shoes b inner join #CurrentEvents a on a.TournamentId = b.TournamentId

Update r
set r.LastClubNumber = z.ClubNumber, r.LastBrand = z.BRAND, r.LastModel = z.MODEL, r.LastDegree = z.degree 
from #Results r inner join (select 'Shoe' as Equipment, rtrim(b.PLAYERNAME) as PlayerName, NULL as ClubNumber, BRAND, model, '' as Degree from dbo.Shoes b inner join #PreviousEventPlayed a on a.TournamentId = b.TournamentId and a.PlayerName = b.PLAYERNAME) z
on r.PlayerName = z.playername and r.Equipment = z.Equipment


--Iron Set
Update r
set r.CurrentClubNumber = z.ClubNumber, r.CurrentBrand = z.BRAND, r.CurrentModel = z.MODEL, r.CurrentDegree = z.degree 
from #Results r inner join (select 'Iron - Set' as Equipment, rtrim(b.PLAYERNAME) as PlayerName, pkey, b.[CLUB NUMBER] as ClubNumber, BRAND, model, '' as Degree 
from dbo.[Irons] b inner join #CurrentEvents a on a.TournamentId = b.TournamentId where isset = 1) z
on r.PlayerName = z.playername and r.Equipment = z.Equipment and r.LineNumber = z.PKey

Update r
set r.LastClubNumber = z.ClubNumber, r.LastBrand = z.BRAND, r.LastModel = z.MODEL, r.LastDegree = z.degree 
from #Results r inner join (select 'Iron - Set' as Equipment, rtrim(b.PLAYERNAME) as PlayerName, pkey, b.[CLUB NUMBER] as ClubNumber, BRAND, model, '' as Degree 
from dbo.[Irons] b inner join #PreviousEventPlayed a on a.TournamentId = b.TournamentId and a.PlayerName = b.PLAYERNAME where isset = 1) z
on r.PlayerName = z.playername and r.Equipment = z.Equipment and r.LineNumber = z.PKey


--Iron - Not Set
Update r
set r.CurrentClubNumber = z.ClubNumber, r.CurrentBrand = z.BRAND, r.CurrentModel = z.MODEL, r.CurrentDegree = z.degree 
from #Results r inner join (select 'Iron - Not Set' as Equipment, rtrim(b.PLAYERNAME) as PlayerName, pkey, b.[CLUB NUMBER] as ClubNumber, BRAND, model, '' as Degree 
from dbo.[Irons] b inner join #CurrentEvents a on a.TournamentId = b.TournamentId where isset = 0 and not b.[CLUB NUMBER] like '%^%') z
on r.PlayerName = z.playername and r.Equipment = z.Equipment and r.LineNumber = z.PKey

Update r
set r.LastClubNumber = z.ClubNumber, r.LastBrand = z.BRAND, r.LastModel = z.MODEL, r.LastDegree = z.degree 
from #Results r inner join (select 'Iron - Not Set' as Equipment, rtrim(b.PLAYERNAME) as PlayerName, pkey, b.[CLUB NUMBER] as ClubNumber, BRAND, model, '' as Degree 
from dbo.[Irons] b inner join #PreviousEventPlayed a on a.TournamentId = b.TournamentId and a.PlayerName = b.PLAYERNAME where isset = 0 and not b.[CLUB NUMBER] like '%^%') z
on r.PlayerName = z.playername and r.Equipment = z.Equipment and r.LineNumber = z.PKey


--Utility Iron
Update r
set r.CurrentClubNumber = z.ClubNumber, r.CurrentBrand = z.BRAND, r.CurrentModel = z.MODEL, r.CurrentDegree = z.degree 
from #Results r inner join (select 'Iron - Utility' as Equipment, rtrim(b.PLAYERNAME) as PlayerName, pkey, b.[CLUB NUMBER] as ClubNumber, BRAND, model, '' as Degree 
from dbo.[Irons] b inner join #CurrentEvents a on a.TournamentId = b.TournamentId where isset = 0 and b.[CLUB NUMBER] like '%^%') z
on r.PlayerName = z.playername and r.Equipment = z.Equipment and r.LineNumber = z.PKey

Update r
set r.LastClubNumber = z.ClubNumber, r.LastBrand = z.BRAND, r.LastModel = z.MODEL, r.LastDegree = z.degree 
from #Results r inner join (select 'Iron - Utility' as Equipment, rtrim(b.PLAYERNAME) as PlayerName, pkey, b.[CLUB NUMBER] as ClubNumber, BRAND, model, '' as Degree 
from dbo.[Irons] b inner join #PreviousEventPlayed a on a.TournamentId = b.TournamentId and a.PlayerName = b.PLAYERNAME where isset = 0 and b.[CLUB NUMBER] like '%^%') z
on r.PlayerName = z.playername and r.Equipment = z.Equipment and r.LineNumber = z.PKey

--Putter
Update r
set r.CurrentClubNumber = z.ClubNumber, r.CurrentBrand = z.BRAND, r.CurrentModel = z.MODEL, r.CurrentDegree = z.degree 
from #Results r inner join (select 'Putter' as Equipment, rtrim(b.PLAYERNAME) as PlayerName, pkey, NULL as ClubNumber, BRAND, model, '' as Degree 
from dbo.[Putters] b inner join #CurrentEvents a on a.TournamentId = b.TournamentId) z
on r.PlayerName = z.playername and r.Equipment = z.Equipment and r.LineNumber = z.PKey

Update r
set r.LastClubNumber = z.ClubNumber, r.LastBrand = z.BRAND, r.LastModel = z.MODEL, r.LastDegree = z.degree 
from #Results r inner join (select 'Putter' as Equipment, rtrim(b.PLAYERNAME) as PlayerName, pkey, NULL as ClubNumber, BRAND, model, '' as Degree 
from dbo.[Putters] b inner join #PreviousEventPlayed a on a.TournamentId = b.TournamentId and a.PlayerName = b.PLAYERNAME) z
on r.PlayerName = z.playername and r.Equipment = z.Equipment and r.LineNumber = z.PKey

--Wood - Driver
Update r
set r.CurrentClubNumber = z.ClubNumber, r.CurrentBrand = z.BRAND, r.CurrentModel = z.MODEL, r.CurrentDegree = z.degree 
from #Results r inner join (select 'Wood - Driver' as Equipment, rtrim(b.PLAYERNAME) as PlayerName, pkey, b.[CLUB NUMBER] as ClubNumber, BRAND, model, b.SIZE as Degree 
from dbo.[Woods] b inner join #CurrentEvents a on a.TournamentId = b.TournamentId where isdriver = 1) z
on r.PlayerName = z.playername and r.Equipment = z.Equipment and r.LineNumber = z.PKey

Update r
set r.LastClubNumber = z.ClubNumber, r.LastBrand = z.BRAND, r.LastModel = z.MODEL, r.LastDegree = z.degree 
from #Results r inner join (select 'Wood - Driver' as Equipment, rtrim(b.PLAYERNAME) as PlayerName, pkey, b.[CLUB NUMBER] as ClubNumber, BRAND, model, b.SIZE as Degree 
from dbo.[Woods] b inner join #PreviousEventPlayed a on a.TournamentId = b.TournamentId and a.PlayerName = b.PLAYERNAME where isdriver = 1) z
on r.PlayerName = z.playername and r.Equipment = z.Equipment and r.LineNumber = z.PKey


--Wood - Fairway
Update r
set r.CurrentClubNumber = z.ClubNumber, r.CurrentBrand = z.BRAND, r.CurrentModel = z.MODEL, r.CurrentDegree = z.degree 
from #Results r inner join (select 'Wood - Fairway' as Equipment, rtrim(b.PLAYERNAME) as PlayerName, pkey, b.[CLUB NUMBER] as ClubNumber, BRAND, model, b.SIZE as Degree 
from dbo.[Woods] b inner join #CurrentEvents a on a.TournamentId = b.TournamentId where ISDRIVER = 0 and not b.[CLUB NUMBER] like '%HYB%') z
on r.PlayerName = z.playername and r.Equipment = z.Equipment and r.LineNumber = z.PKey

Update r
set r.LastClubNumber = z.ClubNumber, r.LastBrand = z.BRAND, r.LastModel = z.MODEL, r.LastDegree = z.degree 
from #Results r inner join (select 'Wood - Fairway' as Equipment, rtrim(b.PLAYERNAME) as PlayerName, pkey, b.[CLUB NUMBER] as ClubNumber, BRAND, model, b.SIZE as Degree 
from dbo.[Woods] b inner join #PreviousEventPlayed a on a.TournamentId = b.TournamentId and a.PlayerName = b.PLAYERNAME where isdriver = 0 and not b.[CLUB NUMBER] like '%HYB%') z
on r.PlayerName = z.playername and r.Equipment = z.Equipment and r.LineNumber = z.PKey


--Wood - Hybrid
Update r
set r.CurrentClubNumber = z.ClubNumber, r.CurrentBrand = z.BRAND, r.CurrentModel = z.MODEL, r.CurrentDegree = z.degree 
from #Results r inner join (select 'Wood - Hybrid' as Equipment, rtrim(b.PLAYERNAME) as PlayerName, pkey, b.[CLUB NUMBER] as ClubNumber, BRAND, model, b.SIZE as Degree 
from dbo.Woods b inner join #CurrentEvents a on a.TournamentId = b.TournamentId where isdriver = 0 and b.[CLUB NUMBER] like '%HYB%') z
on r.PlayerName = z.playername and r.Equipment = z.Equipment and r.LineNumber = z.PKey

Update r
set r.LastClubNumber = z.ClubNumber, r.LastBrand = z.BRAND, r.LastModel = z.MODEL, r.LastDegree = z.degree 
from #Results r inner join (select 'Wood - Hybrid' as Equipment, rtrim(b.PLAYERNAME) as PlayerName, pkey, b.[CLUB NUMBER] as ClubNumber, BRAND, model, b.SIZE as Degree 
from dbo.Woods b inner join #PreviousEventPlayed a on a.TournamentId = b.TournamentId and a.PlayerName = b.PLAYERNAME where isdriver = 0 and b.[CLUB NUMBER] like '%HYB%') z
on r.PlayerName = z.playername and r.Equipment = z.Equipment and r.LineNumber = z.PKey


--Wedge
Update r
set r.CurrentClubNumber = z.ClubNumber, r.CurrentBrand = z.BRAND, r.CurrentModel = z.MODEL, r.CurrentDegree = z.degree 
from #Results r inner join (select 'Wedge' as Equipment, rtrim(b.PLAYERNAME) as PlayerName, pkey, b.[CLUB NUMBER] as ClubNumber, BRAND, model, b.SIZE as Degree 
from dbo.Wedges b inner join #CurrentEvents a on a.TournamentId = b.TournamentId) z
on r.PlayerName = z.playername and r.Equipment = z.Equipment and r.LineNumber = z.PKey

Update r
set r.LastClubNumber = z.ClubNumber, r.LastBrand = z.BRAND, r.LastModel = z.MODEL, r.LastDegree = z.degree 
from #Results r inner join (select 'Wedge' as Equipment, rtrim(b.PLAYERNAME) as PlayerName, pkey, b.[CLUB NUMBER] as ClubNumber, BRAND, model, b.SIZE as Degree 
from dbo.Wedges b inner join #PreviousEventPlayed a on a.TournamentId = b.TournamentId and a.PlayerName = b.PLAYERNAME) z
on r.PlayerName = z.playername and r.Equipment = z.Equipment and r.LineNumber = z.PKey


--Select        FirstDay as [Event.Date], 
--		TournamentName as [Event.Name], 
--		    PlayerName as [Event.Player], 
--					Equipment  as [Player.Equipment], 
--						CurrentClubNumber as [Equipment.CurrentClubNumber], 
--						     CurrentBrand as [Equipment.CurrentBrand], 
--						     CurrentModel as [Equipment.CurrentModel], 
--							CurrentDegree as [Equipment.CurrentDegree], 
--						   LastClubNumber as [Equipment.PreviousClubNumber], 
--						        LastBrand as [Equipment.PreviousBrand], 
--								LastModel as [Equipment.PreviousModel], 
--							   LastDegree as [Equipment.PreviousDegree]
Select FirstDay, TournamentName, PlayerName, Equipment, CurrentClubNumber, CurrentBrand, CurrentModel, CurrentDegree, LastClubNumber as PreviousClubNumber, LastBrand as PreviousBrand, LastModel as PreviousModel, LastDegree as PreviousDegree
from #Results 
where Playername in (select Distinct Playername from #PreviousEventPlayed) and
	  (coalesce(CurrentClubNumber,'') <> coalesce(LastClubNumber,'') or CurrentBrand <> LastBrand or CurrentModel <> LastModel or CurrentDegree <> LastDegree) and
	  (CurrentBrand in ('Titleist', 'Foot Joy') or LastBrand in ('Titleist', 'Foot Joy'))
order by FirstDay, TournamentName, PlayerName, Equipment, LineNumber
--for XML auto, root('Events')

END
GO
