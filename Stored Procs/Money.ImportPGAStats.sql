DROP PROCEDURE IF EXISTS [Money].[ImportPGAStats];
GO

-- =============================================
-- Author:		Alex
-- Create date: 1/2/2013
-- Description:	Import Text Files with Stats and Money from PGAtour.com
-- ==========================================
CREATE PROCEDURE [Money].[ImportPGAStats]
	(@FileName nvarchar(50))


AS
begin
	SET NOCOUNT ON;
	
	DECLARE @TournamentID INT;
	DECLARE @FD Date;
	DECLARE @query AS nvarchar(MAX)

	Delete from [Money].[ImportPGATemp]
	
	
/*  does not work off the network drive
	set @query = 'bulk insert [Money].[ImportPGATemp] from ''H:\Data\Performance Stats\2013 Raw Data\' 
				+ right('0' + cast(MONTH(Getdate()) as varchar), 2) + '-' 
				+ right('0' + cast(DAY(GetDate()) as varchar), 2) + '-' 
				+ SUBSTRING(cast(year(getdate()) as varchar),3,2) + '\'
				+ @FileName 
				+ '.txt'' with (fieldterminator = '';'', rowterminator = ''\n'')'
*/
	
	
	set @query = 'bulk insert [Money].[ImportPGATemp] from ''C:\Users\AlexR\Documents\' + @FileName + 
					'.txt'' with (fieldterminator = '';'', rowterminator = ''\n'')'
	
    exec(@query)

	select distinct @TournamentID = tt.tournamentid, 
					@FD = [FIRST DAY] 
	from Player_Master.TOURNAMENTS_TABLE tt
	inner join [Money].[ImportPGATemp] m on
					m.[TOURNAMENT NAME] = tt.[TOURNAMENT NAME] and 
					m.[Last Day] = tt.[LAST DAY]
					
	UPDATE [ImportPGATemp] SET [Official Money] = 0 WHERE [Finish Position] = 'CUT'


	--set @TournamentID = 88888
	
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
      ,UPPER([Last Name] + ', ' + [First Name])
      ,[Tour Ranking]
      ,[Money YTD]
      ,case when ltrim([Finish Position]) like 'T%' then 'T'
			else NULL end
	  ,case when not (ltrim([Finish Position]) like 'T%' or ISNUMERIC([Finish Position]) = 1) then [Finish Position]
			else NULL end
      ,case when ltrim([Finish Position]) like 'T%' then SUBSTRING(ltrim([Finish Position]), 2, 100)
			when ISNUMERIC(ltrim([Finish Position])) = 1 then [Finish Position]
			else NULL end
      ,[Round 1]
      ,[Round 2]
      ,[Round 3]
      ,[Round 4]
      ,[Round 5]
      ,[Total Score]
      ,[Official Money]
      ,case when not ([Total Fwys Played] IS null OR [Total Fwys Played] = 0)
			then Round([Total Fwys Hit] / [Total Fwys Played] * 100, 4)
			else NULL
			end
      ,case when not ([Total Drives] IS null OR [Total Drives] = 0)
			then Round([Total Driving Distance] / [Total Drives], 4)
			else NULL
			end
	  ,case when not ([Holes Played] IS null OR [Holes Played] = 0)
			then Round([Total GIRs] / [Holes Played] * 100,4)
			else NULL
			end
	  ,case when not ([Total GIRs] IS null OR [Total GIRs] = 0)
			then Round([Total GIR Putts] / [Total GIRs], 4)
			else NULL
			end      
	  ,case when not ([Total Traps Hit] IS null OR [Total Traps Hit] = 0)
			then Round([Total Sand Saves] / [Total Traps Hit] * 100, 4)
			else NULL
			end
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
      ,[Holes Played]
   	  from [Money].[ImportPGATemp]


update [DARRELL_MASTER].[Money].[TourMoneyStats]
set [PLAYER NAME] = REPLACE([PLAYER NAME], '''', '`')
where [PLAYER NAME] like '%''%'


print(@query)

update [DARRELL_MASTER].[Money].[TourMoneyStats]
set [PLAYER NAME] = e.[Database Name]
from [DARRELL_MASTER].[Money].[TourMoneyStats] m
inner join   [DARRELL_MASTER].[Player_Master].[Playernames_Exceptions] e
on m.[PLAYER NAME] = e.[Original Name]



;with CTE_m as (SELECT m.[PLAYER NAME]
					FROM [DARRELL_MASTER].[Money].[TourMoneyStats] m
					where m.TournamentId = @TournamentID),
CTE_n as (select PLAYERNAME from [DARRELL_MASTER].[Player_Master].[All] n
				inner join DARRELL_MASTER.Player_Master.TOURNAMENTS_TABLE t
				on n.SID = t.SID and n.[FIRST DAY] = t.[FIRST DAY]
				where t.TournamentId = @TournamentID)

SELECT CTE_m.*, CTE_n.*
  FROM CTE_m full outer join CTE_n
  on [PLAYER NAME] = PLAYERNAME
  where [PLAYER NAME] is null or PLAYERNAME is null


end
GO
