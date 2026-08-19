IF OBJECT_ID('Money.ImportJGTOStats') IS NOT NULL
    DROP PROCEDURE [Money].[ImportJGTOStats];
GO

-- =============================================
-- Author:		Alex
-- Create date: 1/2/2013
-- Description:	Import Text Files with Stats and Money from PGAtour.com
-- ==========================================
CREATE PROCEDURE [Money].[ImportJGTOStats]

AS
begin
	SET NOCOUNT ON;
	
	DECLARE @query AS nvarchar(MAX)
	DECLARE @FD Date;
	Declare @TournamentID as Int, @TournamentName varchar(50)

	select distinct @TournamentID = tournamentid, 
					@FD = [FIRST DAY], 
					@TournamentName = [TOURNAMENT NAME] 
	from dbo.TournamentsThisWeek
	where [TYPE] = 'JGTO'

						
	Insert into [Money].[TourMoneyStats]
	   ([TournamentId]
      ,[PLAYER NAME]
      ,[Tie]
      ,[Cut]
      ,[Finish Position]
      ,[Official Money])
    
	  Select @TournamentID
      ,case when CHARINDEX(' ', REVERSE(t.[PLAYER NAME])) = 0 THEN UPPER(t.[PLAYER NAME])
			when CHARINDEX(',', REVERSE(t.[PLAYER NAME])) > 0 THEN UPPER(t.[PLAYER NAME])
			else UPPER(RIGHT(t.[PLAYER NAME], CHARINDEX(' ', REVERSE(t.[PLAYER NAME]))-1)+', '+ 
				 LEFT(t.[PLAYER NAME], len(t.[PLAYER NAME]) - CHARINDEX(' ', REVERSE(t.[PLAYER NAME]))))
		end
      ,t.Tie
      ,t.Cut
      ,t.[Finish Position]
      ,t.[Official Money Yen]
   	  from [Money].[ImportJGTOTemp] t



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
