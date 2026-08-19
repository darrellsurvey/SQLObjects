IF OBJECT_ID('dbo.Multi_Brand_Player_By_SID') IS NOT NULL
    DROP PROCEDURE [dbo].[Multi_Brand_Player_By_SID];
GO

CREATE PROCEDURE [dbo].[Multi_Brand_Player_By_SID]
(@TournamentSID as int,
 @Year as int)
AS
BEGIN

declare @TournamentID as int
declare @TournamentName as varchar(50)

SELECT @TournamentID = [TournamentId], @TournamentName = [TOURNAMENT NAME]
  FROM [DARRELL_MASTER].[Player_Master].[TOURNAMENTS_TABLE]
  where [SID] = @TournamentSID and [Year] = @Year

select l.[TournamentId]
		,@TournamentName as TournamentName
	  ,l.[FIRST DAY]	  
	  ,l.TOUR
      ,l.[PLAYERNAME]
      ,l.[BRAND]
	  ,SUM(l.ClubCount) as Numbs
from 
(SELECT w.[TournamentId]
	  ,w.[FIRST DAY]
	  ,w.TOUR
      ,w.[PLAYERNAME]
      ,w.[BRAND]
	  ,count(w.[BRAND]) as ClubCount
FROM [DARRELL_MASTER].[dbo].[Woods] w
group by w.[TournamentId]
      ,w.[PLAYERNAME]
      ,w.[BRAND]
      ,w.tour
      ,w.[FIRST DAY]
having w.TournamentID = @TournamentID
   
union All

SELECT i.[TournamentId]
	  ,i.[FIRST DAY]
	  ,i.TOUR
      ,i.[PLAYERNAME]
      ,i.[BRAND]
	  ,sum(case when i.[Club NUMBER] not like '%-%' then 1
		 when [Club NUMBER] like '%-%' then cast(SUBSTRING(i.[Club NUMBER],3,1) AS int) - cast(SUBSTRING(i.[Club NUMBER],1,1) AS int) +1
		 else 0 
		 end) as ClubCount      
FROM [DARRELL_MASTER].[dbo].[Irons] i
group by i.[TournamentId]
      ,i.[PLAYERNAME]
      ,i.[BRAND]
      ,i.tour
      ,i.[FIRST DAY]
having i.TournamentID = @TournamentID

union All

SELECT g.[TournamentId]
	  ,g.[FIRST DAY]
	  ,g.TOUR
      ,g.[PLAYERNAME]
      ,g.[BRAND]
	  ,count(g.[BRAND]) as ClubCount
FROM [DARRELL_MASTER].[dbo].[Wedges] g
group by g.[TournamentId]
      ,g.[PLAYERNAME]
      ,g.[BRAND]
      ,g.tour
      ,g.[FIRST DAY]
having g.TournamentID = @TournamentID

) as l

group by l.[TournamentId]
	  ,l.[FIRST DAY]
	  ,l.TOUR
      ,l.[PLAYERNAME]
      ,l.[BRAND]
having SUM(l.ClubCount) <13


    
END
GO
