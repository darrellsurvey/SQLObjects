DROP PROCEDURE IF EXISTS [dbo].[EventData - USGA];
GO

CREATE PROCEDURE [dbo].[EventData - USGA]
	@User varchar(100) = '',
	@Company varchar(100) = '',
	@TournamentId int

AS

BEGIN
    SET NOCOUNT ON

	--exec [dbo].[EventData - USGA] 'x', 'y', 8916

;with cte_results as (
select 'Ball' as Equipment,   rtrim(PLAYERNAME) as PlayerName, [TOURNAMENT NAME] as TournamentName, [FIRST DAY] as FirstDay,    1 as LineNumber,            '' as ClubNumber, BRAND, model, '' as Loft from dbo.[ball] Where TournamentId = @TournamentId
union all
select 'Iron' as Equipment,   rtrim(PLAYERNAME) as PlayerName, [TOURNAMENT NAME] as TournamentName, [FIRST DAY] as FirstDay, pkey as LineNumber, [CLUB NUMBER] as ClubNumber, BRAND, model, '' as Loft from dbo.[Irons] Where TournamentId = @TournamentId
union all
select 'Putter' as Equipment, rtrim(PLAYERNAME) as PlayerName, [TOURNAMENT NAME] as TournamentName, [FIRST DAY] as FirstDay, pkey as LineNumber,            '' as ClubNumber, BRAND, model, '' as Loft from dbo.[Putters] Where TournamentId = @TournamentId 
union all
select 'Wood' as Equipment,   rtrim(PLAYERNAME) as PlayerName, [TOURNAMENT NAME] as TournamentName, [FIRST DAY] as FirstDay, pkey as LineNumber, [CLUB NUMBER] as ClubNumber, BRAND, model, SIZE as Loft from dbo.[Woods] Where TournamentId = @TournamentId
union all
select 'Wedge' as Equipment,  rtrim(PLAYERNAME) as PlayerName, [TOURNAMENT NAME] as TournamentName, [FIRST DAY] as FirstDay, pkey as LineNumber, [CLUB NUMBER] as ClubNumber, BRAND, model, SIZE as Loft from dbo.Wedges Where TournamentId = @TournamentId)

Select FirstDay, 
	   TournamentName, 
	   SUBSTRING(PlayerName, 1, CHARINDEX(',', PlayerName) - 1) AS LastName,     
       SUBSTRING(PlayerName,
                 CHARINDEX(',', PlayerName) + 2,
                 LEN(PlayerName) - CHARINDEX(',', PlayerName)) AS FirstName,
	   Equipment,
	   LineNumber,
	   ClubNumber, 
	   Brand, 
	   Model, 
	   Loft 
from cte_results 
order by FirstDay, TournamentName, PlayerName, Equipment, LineNumber

END
GO
