DROP PROCEDURE IF EXISTS [MoneyBall].[Fill_WebsiteDataPlayer7];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	Fill table MoneyBall.WebsiteDataPlayer7
-- =============================================

CREATE procedure [MoneyBall].[Fill_WebsiteDataPlayer7]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS
Begin -- WebsiteDataPlayer7
Print 'Start WebsiteDataPlayer7'
	
delete from MoneyBall.WebsiteDataPlayer7 where PGASeason = @PGASeason and SportTourId = @SportTourId

;with cte as (
SELECT w1.PlayerName, 
	   w1.PGASeason,
	   trn as EventsPerSeason,
	   TournamentsPlayed,
	   rn as EventsPlayerOnTV,
	   rn*1.0/TournamentsPlayed as TVExposure,
	   TournamentsWon,
	   TournamentsTop5,
	   TournamentsTop10,  
	   TournamentsMadeCut,
	   TournamentsMadeCut * 1.00 / TournamentsPlayed  as PercentMadeCut,
	   TournamentsPlayed * 1.0 / trn as TournamentParticipation,
	   w1.DSRank,
	   WorldRank, 
	   PGARank, 
	   w1.MoneyWon,
	   MoneyYTDPercent / 100.0 as MoneyYTDPercent,
	   DSPointsYTDPercent / 100.0 as DSPointsYTDPercent,
	   DSPoints, 
	   DSM, 
	   TFDSPoints, 
	   SSDSPoints,
	   TFDSPoints * 1.0 / rn as AvgTFDSPoints, 
	   SSDSPoints * 1.0 / rn as AvgSSDSPoints,
	   EventPointsAvg,
	   case when coalesce(DSPoints, 0) = 0 then NULL else SSDSPoints * 1.0 / DSPoints end as PortionOfEventTDueToSS,
	   DSPoints * 1.0 / rn as EventAvgDSPoints,
	   [ROUND 1],[ROUND 2],[ROUND 3],[ROUND 4], 
	   TotalScore * 1.0 / nullif(TotalHolesPlayed,0) as AvgScorePerHolePlayed,
	   [Total Score] as AverageScore,
	   AvgDrivingAccuracy,
	   AvgDrivingDistance,
	   TotalGreensInReg,
	   AvgPuttingAvg,
	   TotalGreensInRegPutts,
	   TotalFwysPlayed,
	   TotalFwysHit,
	   TotalSandSaves,
	   TotalEagles,
	   TotalBirdies,
	   TotalHolesPlayed,
	   TotalEagles * 1.0 / nullif(TotalHolesPlayed,0) as AvgEaglePercent,
	   TotalBirdies * 1.0 / nullif(TotalHolesPlayed,0) as AvgBirdiePercent
	      
FROM MoneyBall.WebsiteDataPlayer1 w1
left outer join (select pgaseason, playername, COUNT(distinct tournamentid) as rn, sum(case when [ROUND] in (1, 2) then DSPoints else 0 end) as TFDSPoints,	sum(case when [ROUND] in (3, 4) then DSPoints else 0 end) as SSDSPoints 
					from TV.TVAudit 
					--where IsUsedInCalculations = 1 and PGASeason = @PGASeason  and tour = @Tour 
					where IsUsedInCalculations = 1 and PGASeason = @PGASeason and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and TntNid in (26,351,353,355)))
					group by pgaseason, playername) a 
	on w1.PGASeason = a.PGASeason and w1.PlayerName = a.PlayerName 
left outer join (select pgaseason, COUNT(distinct tournamentid) as trn 
					from TV.TVAudit 
					--where PGASeason = @PGASeason and tour = @Tour 
					where PGASeason = @PGASeason and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and TntNid in (26,351,353,355))) 
					group by pgaseason) b 
	on w1.PGASeason = b.PGASeason
left outer join (SELECT PGASeason, [PLAYER NAME],
						sum(case when not [Finish Position] IS NULL then 1 else 0 end) as TournamentsMadeCut, 
						sum(case when [Finish Position] < 6 then 1 else 0 end) as TournamentsTop5, 
						SUM(isnull(ms.[Holes Played], 0)) as TotalHolesPlayed,
						SUM(isnull(ms.[Total Score], 0)) as TotalScore,
						avg(ms.[Driving Accuracy]) as AvgDrivingAccuracy,
						AVG(ms.[Driving Distance]) as AvgDrivingDistance,
						SUM(isnull(ms.[Total GIRs], 0)) as TotalGreensInReg,
						AVG(ms.[Putting Avg]) as AvgPuttingAvg,
						SUM(isnull(ms.[Total GIR Putts], 0)) as TotalGreensInRegPutts,
						SUM(isnull(ms.[Total Fwys Played], 0)) as TotalFwysPlayed,
						SUM(isnull(ms.[Total Fwys Hit], 0)) as TotalFwysHit,
						SUM(isnull(ms.[Total Sand Saves], 0)) as TotalSandSaves,
						SUM(isnull(ms.[Total Eagles], 0)) as TotalEagles,
						SUM(isnull(ms.[Total Birdies], 0)) as TotalBirdies,
						avg(cast(ms.[ROUND 1] as decimal(5,2))) as [ROUND 1],
						avg(cast(ms.[ROUND 2] as decimal(5,2))) as [ROUND 2],
						avg(cast(ms.[ROUND 3] as decimal(5,2))) as [ROUND 3],
						avg(cast(ms.[ROUND 4] as decimal(5,2))) as [ROUND 4],
						avg(cast(ms.[Total Score] as decimal(5,2))) as [Total Score]
					FROM [DARRELL_MASTER].[money].TourMoneyStats ms
					INNER JOIN [DARRELL_MASTER].Player_Master.TOURNAMENTS_TABLE tt ON ms.TournamentId = tt.TournamentId
					--where [TYPE] = @Tour and PGASeason = @PGASeason and tt.[FIRST DAY] < @LastFullTournamentEnd
					where PGASeason = @PGASeason and tt.[FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and tt.TYPE = @Tour) or (@Sporttourid = 58 and tt.SID in (26,351,353,355)))
					group by PGASeason,[PLAYER NAME]) c
	on w1.PGASeason = c.PGASeason  and w1.playername = c.[PLAYER NAME]
where (TotalHolesPlayed > 0 or SportTourId = @SportTourId) and w1.PGASeason = @PGASeason and w1.SportTourId = @SportTourId)
--where TotalHolesPlayed > 0 and w1.PGASeason = @PGASeason and w1.SportTourId = @SportTourId)



Insert into MoneyBall.WebsiteDataPlayer7 (PlayerName, PGASeason, Header, UserData, SportTourId)

Select PlayerName, PGASeason, 'EventsPerSeason' as Header, EventsPerSeason as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'TournamentsPlayed' as Header, TournamentsPlayed as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'EventsPlayerOnTV' as Header, EventsPlayerOnTV as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'TVExposure' as Header, TVExposure as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'TournamentsWon' as Header, TournamentsWon as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'TournamentsTop5' as Header, TournamentsTop5 as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'TournamentsTop10' as Header, TournamentsTop10 as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'TournamentsMadeCut' as Header, TournamentsMadeCut as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'PercentMadeCut' as Header, PercentMadeCut as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'TournamentParticipation' as Header, TournamentParticipation as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'DSRank' as Header, DSRank as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'WorldRank' as Header, WorldRank as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'PGARank' as Header, PGARank as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'MoneyWon' as Header, MoneyWon as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'MoneyWonPercent' as Header, MoneyYTDPercent as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'DSPoints' as Header, DSPoints as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'DSMoney' as Header, DSM as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'DSPointsPercent' as Header, DSPointsYTDPercent as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'TFDSPoints' as Header, TFDSPoints as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'SSDSPoints' as Header, SSDSPoints as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'AvgTFDSPoints' as Header, AvgTFDSPoints as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'AvgSSDSPoints' as Header, AvgSSDSPoints as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'EventPointsAvg' as Header, EventPointsAvg as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'PortionOfEventTDueToSS' as Header, PortionOfEventTDueToSS as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'EventAvgDSPoints' as Header, EventAvgDSPoints as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'Round1' as Header, [ROUND 1] as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'Round2' as Header, [ROUND 2] as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'Round3' as Header, [ROUND 3] as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'Round4' as Header, [ROUND 4] as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'AvgScorePerHolePlayed' as Header, AvgScorePerHolePlayed as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'AverageScore' as Header, AverageScore as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'AvgDrivingAccuracy' as Header, AvgDrivingAccuracy as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'AvgDrivingDistance' as Header, AvgDrivingDistance as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'TotalGreensInReg' as Header, TotalGreensInReg as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'AvgPuttingAvg' as Header, AvgPuttingAvg as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'TotalGreensInRegPutts' as Header, TotalGreensInRegPutts as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'TotalFwysPlayed' as Header, TotalFwysPlayed as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'TotalFwysHit' as Header, TotalFwysHit as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'TotalSandSaves' as Header, TotalSandSaves as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'TotalEagles' as Header, TotalEagles as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'TotalBirdies' as Header, TotalBirdies as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'TotalHolesPlayed' as Header, TotalHolesPlayed as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'AvgEaglePercent' as Header, AvgEaglePercent as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'AvgBirdiePercent' as Header, AvgBirdiePercent as UserData, @SportTourId from cte



Print 'Finished WebsiteDataPlayer7'; 
end  -- WebsiteDataPlayer7
GO
