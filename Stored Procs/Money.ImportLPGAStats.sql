IF OBJECT_ID('Money.ImportLPGAStats') IS NOT NULL
    DROP PROCEDURE [Money].[ImportLPGAStats];
GO

-- =============================================
-- Author:		Alex
-- Create date: 1/2/2013
-- Description:	Import Text Files with Stats and Money from LPGA
-- ==========================================
CREATE PROCEDURE [Money].[ImportLPGAStats]
	 --exec [Money].[ImportLPGAStats]
AS
begin
	SET NOCOUNT ON;
	
	DECLARE @FD Date;
	DECLARE @query AS nvarchar(MAX)
    Declare @TournamentID as Int, @TournamentName varchar(50)

	select distinct @TournamentID = tournamentid, 
					@FD = [FIRST DAY], 
					@TournamentName = [TOURNAMENT NAME] 
	from dbo.TournamentsThisWeek
	where [TYPE] = 'LPGA'

	UPDATE [Money].[ImportLPGATemp] SET [Official Money] = 0 WHERE [Finish Position] = 'CUT'
	UPDATE [Money].[ImportLPGATemp] SET [Finish Position] = 'W/D' WHERE [Finish Position] = 'WD'
	UPDATE [Money].[ImportLPGATemp] SET [Finish Position] = 'DQ' WHERE [Finish Position] = 'DQC'
	UPDATE [Money].[ImportLPGATemp] SET [Fairway Percent] = SUBSTRING([Fairway Percent],1,LEN([Fairway Percent])-2)
	UPDATE [Money].[ImportLPGATemp] SET [Greens Percent] = SUBSTRING([Greens Percent],1,LEN([Greens Percent])-2)


	Insert into [Money].[TourMoneyStats]
	   ([TournamentId]
      ,[PLAYER NAME]
      ,[Tour Ranking]
      ,[Money YTD]
      ,[Tie]
      ,[Cut]
      ,[Finish Position]
      ,[Round 1]
      ,[Round 2]
      ,[Round 3]
      ,[Round 4]
      ,[Round 5]
      ,[Total Score]
      ,[Official Money]
      ,[Driving Accuracy]
      ,[Driving Distance]
      ,[Greens in Reg]
      ,[Putting Avg]
      ,[Sand Save]
      ,[Total Fwys Hit]
      ,[Total Driving Distance]
      ,[Total Drives]
      ,[Total Fwys Played]
      ,[Total GIRs]
      ,[Total GIR Putts]
      ,[Total Traps Hit]
      ,[Total Sand Saves]
      ,[Total Eagles]
      ,[Total Birdies]
      ,[Holes Played])
    
	  Select @TournamentID
      ,case when CHARINDEX(' ', REVERSE(it.[PLAYER])) = 0 THEN it.[PLAYER]
			else UPPER(RIGHT(it.[PLAYER], CHARINDEX(' ', REVERSE(it.[PLAYER]))-1)+', '+ 
				 LEFT(it.[PLAYER], len(it.[PLAYER]) - CHARINDEX(' ', REVERSE(it.[PLAYER]))))
		end
      ,ity.[Rank]
      ,ity.[OfficialMoney]
      ,case when (ltrim(it.[Finish Position]) like 'T%' and ltrim(it.[Finish Position]) <> 'CUT')  then 'T' else NULL end
	  ,case when not ((ltrim(it.[Finish Position]) like 'T%' and  ltrim(it.[Finish Position]) <> 'CUT')or ISNUMERIC(it.[Finish Position]) = 1) then it.[Finish Position] else NULL end
      ,case when (ltrim(it.[Finish Position]) like 'T%' and ltrim(it.[Finish Position]) <> 'CUT') then SUBSTRING(ltrim(it.[Finish Position]),2, LEN(it.[Finish Position])-1) 
			when ISNUMERIC(it.[Finish Position]) = 1 then ltrim(it.[Finish Position])
			end
      ,[Round 1]
      ,[Round 2]
      ,[Round 3]
      ,[Round 4]
      ,NULL -- [ROUND 5]
      ,[Total Score] 
      ,[Official Money]
      ,[Fairway Percent] --[Driving Accuracy]
      ,[Driving]	--[Driving Distance]
	  ,[Greens Percent] --[Greens in Reg]
	  ,[GIR Putts]  --[Putting Avg] 
	  ,Null --[Sand Save]
	  ,[Fairways] --[Total Fwys Hit]
      ,Null --[Total Driving Distance]
      ,Null --[Total Drives]
      ,[Fairway Possible] --[Total Fwys Played]
      ,[Greens]--[Total GIRs]
      ,[Putts] --[Total GIR Putts]
      ,NULL --[Total Traps Hit]
      ,NULL --[Total Sand Saves]
      ,[Eagles]	--[Total Eagles]
      ,[Birdies] --[Total Birdies]
      ,[Greens Possible] --[Holes Played]
   	  from [Money].[ImportLPGATemp] it
   	  left outer join [Money].[ImportLPGATempYTD] ity
   		on it.Player = ity.Player

update [DARRELL_MASTER].[Money].[TourMoneyStats]
set [PLAYER NAME] = REPLACE([PLAYER NAME], '''', '`')
where [PLAYER NAME] like '%''%'



update [DARRELL_MASTER].[Money].[TourMoneyStats]
set [PLAYER NAME] = e.[Database Name]
from [DARRELL_MASTER].[Money].[TourMoneyStats] m
inner join   [DARRELL_MASTER].[Player_Master].[Playernames_Exceptions] e
on m.[PLAYER NAME] = e.[Original Name]
where m.TournamentId = @TournamentID


end
GO
