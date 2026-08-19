IF OBJECT_ID('MoneyBall.Fill_NielsenRating') IS NOT NULL
    DROP PROCEDURE [MoneyBall].[Fill_NielsenRating];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 03/25/2023
-- Description:	calculate Nielsen Coeficient
-- =============================================

CREATE procedure [MoneyBall].[Fill_NielsenRating]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentBegins date
)
AS
Begin -- Fill_NielsenRating

Print 'Start Fill_NielsenRating'

update tv set SportTourId = @SportTourId,
			  IsUsedInCalculations = case when a.rn = 1 then 1 else 0 end
from TV.Nielsen tv inner join 
(select tournamentid, rounddate, count(*) as rn from TV.Nielsen where RoundDate > @LastFullTournamentBegins and sporttourid is NULL group by tournamentid, rounddate) a
on tv.tournamentid = a.tournamentid and tv.rounddate = a.rounddate
where tv.RoundDate > @LastFullTournamentBegins

begin tran
update TV.Nielsen 
set NielsenCoefficient = AverageMinutes / MinutesOfPlay2 * ReachProj
where RoundDate > @LastFullTournamentBegins and MinutesOfPlay1 > 0 and NielsenCoefficient is null --and IsUsedInCalculations = 1 
commit tran

--declare @RoundDate date = '20250311',
--		@Sporttourid tinyint = 1
begin tran
insert into TV.Nielsen ([TournamentId],[TournamentName],[OriginatorType],[TVChannel],[RoundDate],[RoundStartTime],[RoundEndTime],[MinutesOfPlay1],[MinutesOfPlay2],[ReachPercent],[ReachProj],[AverageMinutes],[WeightedIntab],[PESS],[UnifiedCount],[UE],[SportTourId],[AdCost],[AdCostEstimate],[IsUsedInCalculations],[NielsenCoefficient])
SELECT [TournamentId],[TournamentName],'COMBINED','COMBINED',[RoundDate],'00:00:00','00:00:00',
		0 as [MinutesOfPlay1], 0 as [MinutesOfPlay2], 0 as [ReachPercent], 0 as [ReachProj], 0 as [AverageMinutes], 0 as [WeightedIntab], 0 as [PESS], 0 as [UnifiedCount], 0 as [UE]
      ,[SportTourId],null as [AdCost], null as [AdCostEstimate],1
      ,sum([ReachProj] * [AverageMinutes]) * 1.0 / sum([MinutesOfPlay1]) as [NielsenCoefficient]
  FROM [DARRELL_MASTER].[TV].[Nielsen]
  where RoundDate > @LastFullTournamentBegins and IsUsedInCalculations = 0 and sporttourid = @Sporttourid and NielsenCoefficient is null
  group by [TournamentId],[TournamentName],[RoundDate], [SportTourId],[IsUsedInCalculations]  
commit tran

Print 'Finished Fill_NielsenRating'; 

end
GO
