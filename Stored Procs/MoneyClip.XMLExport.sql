IF OBJECT_ID('MoneyClip.XMLExport') IS NOT NULL
    DROP PROCEDURE [MoneyClip].[XMLExport];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [MoneyClip].[XMLExport]
	-- Add the parameters for the stored procedure here
		@SID int
AS
BEGIN

declare @SurveyID as int
select @SurveyID = SID from [DARRELL_MASTER].[Player_Master].TOURNAMENTS_TABLE where TournamentId = @SID


Select a.[PLAYERNAME]
	,[CATEGORY]
	,[Tour Ranking]
    ,[Money YTD]
    ,[FinishStatus]
    ,[Place]
    ,[Official Money]
	,[Equipment]
	,[XMLType]  
	,[ClubCode]
	,[BRAND]
	,[MODEL]
	,[Type]
	,[Material]
	,[Size]
from (
SELECT [TOURNAMENTID], [TOURNAMENT NAME], [FIRST DAY], [PLAYERNAME], 'Ball' as [Equipment], 'Balls' as [XMLType]
      ,'' as ClubCode, [BRAND],[MODEL],'' as [Type], '' as [Material], '' as Size
FROM [DARRELL_MASTER].[dbo].[Ball]
where [DARRELL_MASTER].[dbo].[Ball].TournamentId = @SID
Union All 
SELECT [TOURNAMENTID], [TOURNAMENT NAME], [FIRST DAY], [PLAYERNAME], 'Driver' as [Equipment], 'Drivers' as [XMLType]
      ,[CLUB NUMBER] as ClubCode, [BRAND],[MODEL],[SIZE] as [Type], [MATERIAL] as [Material], '' as Size
FROM [DARRELL_MASTER].[dbo].[WOODS]
where [DARRELL_MASTER].[dbo].[WOODS].TournamentId = @SID
		and ISDRIVER = 1
Union All 
SELECT [TOURNAMENTID], [TOURNAMENT NAME], [FIRST DAY], [PLAYERNAME], 'FairwayWood' as [Equipment], 'FairwayWoods' as [XMLType]
      ,[CLUB NUMBER] as ClubCode, [BRAND],[MODEL],[SIZE] as [Type], [MATERIAL] as [Material], '' as Size
FROM [DARRELL_MASTER].[dbo].[WOODS]
where [DARRELL_MASTER].[dbo].[WOODS].TournamentId = @SID
		and ISDRIVER = 0 and [CLUB NUMBER] <> 'HYBRID'
Union All
SELECT [TOURNAMENTID], [TOURNAMENT NAME], [FIRST DAY], [PLAYERNAME], 'Hybrid' as [Equipment], 'Hybrids' as [XMLType]
      ,[CLUB NUMBER] as ClubCode, [BRAND],[MODEL],[SIZE] as [Type], [MATERIAL] as [Material], '' as Size
FROM [DARRELL_MASTER].[dbo].[WOODS]
where [DARRELL_MASTER].[dbo].[WOODS].TournamentId = @SID
		and [CLUB NUMBER] = 'HYBRID'
Union All
SELECT [TOURNAMENTID], [TOURNAMENT NAME], [FIRST DAY], [PLAYERNAME], 'Iron' as [Equipment], 'Irons' as [XMLType]
      ,[Club Number] as ClubCode, [BRAND],[MODEL], '' as [Type], '' as [Material], '' as Size
FROM [DARRELL_MASTER].[dbo].[Irons]
where [DARRELL_MASTER].[dbo].[Irons].TournamentId = @SID
Union All
SELECT [TOURNAMENTID], [TOURNAMENT NAME], [FIRST DAY], [PLAYERNAME], 'Putter' as [Equipment], 'Putters' as [XMLType]
      ,'' as ClubCode, [BRAND],[MODEL], '' as [Type], '' as [Material], [SIZE]
FROM [DARRELL_MASTER].[dbo].[Putters]
where [DARRELL_MASTER].[dbo].[Putters].TournamentId = @SID	
Union All
SELECT [TOURNAMENTID], [TOURNAMENT NAME], [FIRST DAY], [PLAYERNAME], 'Bag' as [Equipment], 'SoftGoods' as [XMLType]
      ,'' as ClubCode, [BRAND],'' as [MODEL], '' as [Type], '' as [Material], '' as [SIZE]
FROM [DARRELL_MASTER].[dbo].[Bag]
where [DARRELL_MASTER].[dbo].[Bag].TournamentId = @SID	
Union All
SELECT [TOURNAMENTID], [TOURNAMENT NAME], [FIRST DAY], [PLAYERNAME], 'Glove' as [Equipment], 'SoftGoods' as [XMLType]
      ,'' as ClubCode, [BRAND],'' as [MODEL], '' as [Type], '' as [Material], '' as [SIZE]
FROM [DARRELL_MASTER].[dbo].[Bag]
where [DARRELL_MASTER].[dbo].[Bag].TournamentId = @SID	
Union All
SELECT [TOURNAMENTID], [TOURNAMENT NAME], [FIRST DAY], [PLAYERNAME], 'Wedge' as [Equipment], 'Wedges' as [XMLType]
      ,[Club Number] as ClubCode, [BRAND],[MODEL], [Size]as [Type], '' as [Material], '' as [SIZE]
FROM [DARRELL_MASTER].[dbo].[Wedges]
where [DARRELL_MASTER].[dbo].[Wedges].TournamentId = @SID	) a

inner join

(SELECT [PLAYERNAME]
      ,[CATEGORY]
      ,[FIRSTDAY]
  FROM [DARRELL_MASTER].[Player_Master].[PLAYERNAMES] 
  where SID = @SurveyId) p
  on a.PLAYERNAME = p.PLAYERNAME and
	a.[FIRST DAY] = p.FIRSTDAY

left outer join

(SELECT [TournamentId]
      ,[PLAYER NAME]
      ,[Tour Ranking]
      ,[Money YTD]
      ,rtrim(ISNULL(Tie,'')) + rtrim(isnull(Cut,'')) as FinishStatus
      ,rtrim(isnull(cast([Finish Position] as nvarchar(3)),'')) as [Place]
      ,[Official Money]
  FROM [DARRELL_MASTER].[Money].TourMoneyStats) m
 
  on a.[TOURNAMENTid] = m.[Tournamentid] and
	a.PLAYERNAME = m.[PLAYER NAME]

order by a.playername, a.[XMLType], a.[equipment]
	
END
GO
