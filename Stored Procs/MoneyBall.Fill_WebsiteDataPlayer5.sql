DROP PROCEDURE IF EXISTS [MoneyBall].[Fill_WebsiteDataPlayer5];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	Fill table MoneyBall.WebsiteDataPlayer5
-- =============================================

CREATE procedure [MoneyBall].[Fill_WebsiteDataPlayer5]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS

Begin -- WebsiteDataPlayer5
Print 'Start WebsiteDataPlayer5'

delete from MoneyBall.WebsiteDataPlayer5 where PGASeason = @PGASeason and SportTourId = @SportTourId

	
	insert into [MoneyBall].[WebsiteDataPlayer5] ([TournamentId],[TYPE],[FIRST DAY],[TOURNAMENT NAME],[PLAYER NAME],[Tour Ranking],[Money YTD],[Tie],[Cut],[Finish Position],[Round 1],[Round 2],[Round 3],[Round 4],[Round 5],
	[Total Score],[Official Money],[Driving Accuracy],[Driving Distance],[Greens in Reg],[Putting Avg],[Sand Save],[Total Fwys Hit],[Total Driving Distance],[Total Drives],[Total Fwys Played],[Total GIRs],
	[Total GIR Putts],[Total Traps Hit],[Total Sand Saves],[Total Eagles],[Total Birdies],[Holes Played],[PGASeason],SportTourId)

select tt.[TournamentId],tt.[TYPE],tt.[FIRST DAY],tt.[TOURNAMENT NAME],[PLAYER NAME],[Tour Ranking],[Money YTD],[Tie],[Cut],[Finish Position],[Round 1],[Round 2],[Round 3],[Round 4],[Round 5],
	[Total Score],[Official Money],[Driving Accuracy],[Driving Distance],[Greens in Reg],[Putting Avg],[Sand Save],[Total Fwys Hit],[Total Driving Distance],[Total Drives],[Total Fwys Played],[Total GIRs],
	[Total GIR Putts],[Total Traps Hit],[Total Sand Saves],[Total Eagles],[Total Birdies],[Holes Played],tt.[PGASeason],@SportTourId
from [Money].[TourMoneyStats] m inner join [Player_Master].[TOURNAMENTS_TABLE] tt on m.TournamentId = tt.tournamentid
--where tt.PGASeason = @PGASeason and tt.[FIRST DAY] < @LastFullTournamentEnd and tt.type = @Tour
where tt.PGASeason = @PGASeason and tt.[FIRST DAY] < @LastFullTournamentEnd  and ((@Sporttourid <> 58 and tt.TYPE = @Tour) or (@Sporttourid = 58 and tt.SID in (26,351,353,355)))

if @SportTourId = 8 
begin
		insert into [MoneyBall].[WebsiteDataPlayer5] ([TournamentId],[TYPE],[FIRST DAY],[TOURNAMENT NAME],[PLAYER NAME],[Tour Ranking],[Money YTD],[Tie],[Cut],[Finish Position],[Round 1],[Round 2],[Round 3],[Round 4],[Round 5],
		[Total Score],[Official Money],[Driving Accuracy],[Driving Distance],[Greens in Reg],[Putting Avg],[Sand Save],[Total Fwys Hit],[Total Driving Distance],[Total Drives],[Total Fwys Played],[Total GIRs],
		[Total GIR Putts],[Total Traps Hit],[Total Sand Saves],[Total Eagles],[Total Birdies],[Holes Played],[PGASeason],SportTourId)

		select distinct [TournamentId],Tour as [TYPE],tntFirstDay as [FIRST DAY],tntName as [TOURNAMENT NAME],PlayerName as [PLAYER NAME],NULL as [Tour Ranking],NULL as [Money YTD],NULL as [Tie],NULL as [Cut],NULL as [Finish Position],NULL as [Round 1],
				NULL as [Round 2],NULL as [Round 3],NULL as [Round 4],NULL as [Round 5],NULL as [Total Score],NULL as [Official Money],NULL as [Driving Accuracy],NULL as [Driving Distance],NULL as [Greens in Reg],NULL as [Putting Avg],
				NULL as [Sand Save],NULL as [Total Fwys Hit],NULL as [Total Driving Distance],NULL as [Total Drives],NULL as [Total Fwys Played],NULL as [Total GIRs],NULL as [Total GIR Putts],NULL as [Total Traps Hit],NULL as [Total Sand Saves],
				NULL as [Total Eagles],NULL as [Total Birdies],NULL as [Holes Played],[PGASeason],@SportTourId
		from TV.TVAudit
		where PGASeason = @PGASeason and [tntFirstDay] < @LastFullTournamentEnd and Tour = @Tour
end

Print 'Finished WebsiteDataPlayer5'; 
end  -- WebsiteDataPlayer5
GO
