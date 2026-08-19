IF OBJECT_ID('MoneyBall.Fill_WebsiteData2') IS NOT NULL
    DROP PROCEDURE [MoneyBall].[Fill_WebsiteData2];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	Fill table MoneyBall.WebsiteData2
-- =============================================

CREATE procedure [MoneyBall].[Fill_WebsiteData2]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS
Begin -- WebsiteData2
Print 'Start WebsiteData2'

--exec [MoneyBall].[Fill_WebsiteData2] 'PGA', 2025, 1, '20251231'

delete from MoneyBall.WebsiteData2 where PGASeason = @PGASeason and SportTourId = @SportTourId


;with dsp as (
select tv.pgaseason, tv.tournamentid, tt.SID, sum(dspoints) as DSPoints, sum(DSMoney) as DSMoney,
				rank() over (partition by tv.PGASeason order by sum(dspoints) desc) as EventRank
				from tv.TVAudit tv
				inner join [Player_Master].[TOURNAMENTS_TABLE] tt on tv.TournamentId = tt.TournamentId
				--where tour= @Tour and tv.PGASeason between @PGASeason - 1 and @PGASeason
				where tv.PGASeason between @PGASeason - 1 and @PGASeason and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and TntNid in (26,351,353,355)))
				group by tv.PGASeason, tv.TournamentId, tt.SID),



dspy as (select a1.*, a2.dspoints as DSPointsYear1 from dsp as a1 left join dsp as a2 on a1.PGASeason = a2.PGASeason + 1 and a1.sid = a2.sid
				where a1.pgaseason = @PGASeason),

cte1 as (
SELECT tt.[TournamentId]
	  ,tt.PGASeason 
      ,[TYPE] as Tour
      ,[TOURNAMENT NAME] as TournamentName
      ,[Club]
      ,[Location]
      ,[FIRST DAY] as FirstDay
      ,[LAST DAY] as LastDay
      ,m.[PLAYER NAME] as Winner
      ,w.PlayerName as DSPWinner
      ,s.Purse
      ,tt.SID as SurveyId
	  ,DSPoints
	  ,DSMoney
	  ,DSPointsYear1
	  ,EventRank
	  ,@SportTourId as SportTourId
  FROM [DARRELL_MASTER].[Player_Master].[TOURNAMENTS_TABLE] tt
  left outer Join (select * from Money.TourMoneyStats where [Finish Position] = 1) m on tt.TournamentId = m.TournamentId 
  left outer Join (select SUM([Official Money]) as Purse, TournamentId from Money.TourMoneyStats group by TournamentId) s on tt.TournamentId = s.TournamentId 
  inner join dspy on tt.TournamentId = dspy.TournamentId
  left outer join (select [Tournamentid], [PlayerName] from 
						(SELECT [Tournamentid], [PlayerName], rank() over(partition by [Tournamentid] order by [TotalDS] desc) as rn
							FROM [DARRELL_MASTER].[MoneyBall].[WebsiteData1] 
							where [TotalDS] > 0  and PGASeason = @PGASeason and SportTourId = @SportTourId) a 
					where rn = 1) w on tt.TournamentId = w.TournamentId 
    --where TYPE = @Tour and tt.PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd
	where tt.PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TYPE = @Tour) or (@Sporttourid = 58 and tt.SID in (26,351,353,355)))
  )
  
  
  
  insert into MoneyBall.WebsiteData2 (Tournamentid,PGASeason,Tour,TournamentName,Club,Location,FirstDay,LastDay,Winner,DSPWinner,Purse,SurveyId,DSPoints,DSM,DSPointsYear1,EventRank,SportTourId)
  select * from cte1 order by FirstDay 
  

declare @Row1 as integer, @Row2 as integer
declare @Names as varchar(100)

if @PGASeason = 2026
	begin
		select top 1 @Row1 = WebsiteDataId2 FROM MoneyBall.WebsiteData2 where tournamentid = 9459 order by WebsiteDataId2 asc
		select top 1 @Row2 = WebsiteDataId2 FROM MoneyBall.WebsiteData2 where tournamentid = 9459 order by WebsiteDataId2 desc
		set @Names = 'FITZPATRICK, MATTHEW; FITZPATRICK, ALEX'
		update MoneyBall.WebsiteData2 set Winner = @Names where WebsiteDataId2 = @Row1
		delete from MoneyBall.WebsiteData2 where WebsiteDataId2 = @Row2
	end

if @PGASeason = 2025
	begin
		select top 1 @Row1 = WebsiteDataId2 FROM MoneyBall.WebsiteData2 where tournamentid = 9137 order by WebsiteDataId2 asc
		select top 1 @Row2 = WebsiteDataId2 FROM MoneyBall.WebsiteData2 where tournamentid = 9137 order by WebsiteDataId2 desc
		set @Names = 'GRIFFIN, BEN; NOVAK, ANDREW'
		update MoneyBall.WebsiteData2 set Winner = @Names where WebsiteDataId2 = @Row1
		delete from MoneyBall.WebsiteData2 where WebsiteDataId2 = @Row2
	end

if @PGASeason = 2024
	begin
		select top 1 @Row1 = WebsiteDataId2 FROM MoneyBall.WebsiteData2 where tournamentid = 8830 order by WebsiteDataId2 asc
		select top 1 @Row2 = WebsiteDataId2 FROM MoneyBall.WebsiteData2 where tournamentid = 8830 order by WebsiteDataId2 desc
		set @Names = 'LOWRY, SHANE; MCILROY, RORY'
		update MoneyBall.WebsiteData2 set Winner = @Names where WebsiteDataId2 = @Row1
		delete from MoneyBall.WebsiteData2 where WebsiteDataId2 = @Row2
	end

if @PGASeason = 2023
	begin
		select top 1 @Row1 = WebsiteDataId2 FROM MoneyBall.WebsiteData2 where tournamentid = 8537 order by WebsiteDataId2 asc
		select top 1 @Row2 = WebsiteDataId2 FROM MoneyBall.WebsiteData2 where tournamentid = 8537 order by WebsiteDataId2 desc
		set @Names = 'HARDY, NICK; RILEY, DAVIS'
		update MoneyBall.WebsiteData2 set Winner = @Names where WebsiteDataId2 = @Row1
		delete from MoneyBall.WebsiteData2 where WebsiteDataId2 = @Row2
	end

if @PGASeason = 2022
	begin
		select top 1 @Row1 = WebsiteDataId2 FROM MoneyBall.WebsiteData2 where tournamentid = 8199 order by WebsiteDataId2 asc
		select top 1 @Row2 = WebsiteDataId2 FROM MoneyBall.WebsiteData2 where tournamentid = 8199 order by WebsiteDataId2 desc
		set @Names = 'CANTLAY, PATRICK; SCHAUFFELE, XANDER'
		update MoneyBall.WebsiteData2 set Winner = @Names where WebsiteDataId2 = @Row1
		delete from MoneyBall.WebsiteData2 where WebsiteDataId2 = @Row2
	end

if @PGASeason = 2021
	begin
		select top 1 @Row1 = WebsiteDataId2 FROM MoneyBall.WebsiteData2 where tournamentid = 7873 order by WebsiteDataId2 asc
		select top 1 @Row2 = WebsiteDataId2 FROM MoneyBall.WebsiteData2 where tournamentid = 7873 order by WebsiteDataId2 desc
		set @Names = 'LEISHMAN, MARC; SMITH, CAMERON'
		update MoneyBall.WebsiteData2 set Winner = @Names where WebsiteDataId2 = @Row1
		delete from MoneyBall.WebsiteData2 where WebsiteDataId2 = @Row2
	end

if @PGASeason = 2019
	begin
		select top 1 @Row1 = WebsiteDataId2 FROM MoneyBall.WebsiteData2 where tournamentid = 7273 order by WebsiteDataId2 asc
		select top 1 @Row2 = WebsiteDataId2 FROM MoneyBall.WebsiteData2 where tournamentid = 7273 order by WebsiteDataId2 desc
		set @Names = 'RAHM, JON; PALMER, RYAN'
		update MoneyBall.WebsiteData2 set Winner = @Names where WebsiteDataId2 = @Row1
		delete from MoneyBall.WebsiteData2 where WebsiteDataId2 = @Row2
	end
if @PGASeason = 2018
	begin
		select top 1 @Row1 = WebsiteDataId2 FROM MoneyBall.WebsiteData2 where tournamentid = 6714 order by WebsiteDataId2 asc
		select top 1 @Row2 = WebsiteDataId2 FROM MoneyBall.WebsiteData2 where tournamentid = 6714 order by WebsiteDataId2 desc
		set @Names = 'HORSCHEL, BILLY; PIERCY, SCOTT'
		update MoneyBall.WebsiteData2 set Winner = @Names where WebsiteDataId2 = @Row1
		delete from MoneyBall.WebsiteData2 where WebsiteDataId2 = @Row2
	end


begin tran
delete from MoneyBall.WebsiteData2 where TournamentId = 8936 and DSPointsYear1 = 21293
delete from MoneyBall.WebsiteData2 where TournamentId = 9102 and DSPointsYear1 = 45842
delete from MoneyBall.WebsiteData2 where TournamentId = 8928 and DSPointsYear1 = 31491
delete from MoneyBall.WebsiteData2 where TournamentId = 8922 and DSPointsYear1 = 38567
delete from MoneyBall.WebsiteData2 where TournamentId = 8942 and DSPointsYear1 = 25991
delete from MoneyBall.WebsiteData2 where TournamentId = 8938 and DSPointsYear1 = 22050
delete from MoneyBall.WebsiteData2 where TournamentId = 8949 and DSPointsYear1 = 27826
commit tran



--to add brend new event that has no TV stats yet

if @SportTourId = 1
	begin
		begin tran  

		;with dsp as (
		select tv.pgaseason, tv.tournamentid, tt.SID, sum(dspoints) as DSPoints,
						rank() over (partition by tv.PGASeason order by sum(dspoints) desc) as EventRank
						from tv.TVAudit tv
						inner join [Player_Master].[TOURNAMENTS_TABLE] tt on tv.TournamentId = tt.TournamentId
						where tour= @Tour and tv.PGASeason between @PGASeason - 1 and @PGASeason
						group by tv.PGASeason, tv.TournamentId, tt.SID),



		dspy as (select a1.*, a2.dspoints as DSPointsYear1 from dsp as a1 left join dsp as a2 on a1.PGASeason = a2.PGASeason + 1 and a1.sid = a2.sid
						where a1.pgaseason = @PGASeason),

		cte1 as (
		SELECT tt.[TournamentId]
			  ,tt.PGASeason 
			  ,[TYPE] as Tour
			  ,[TOURNAMENT NAME] as TournamentName
			  ,[Club]
			  ,[Location]
			  ,[FIRST DAY] as FirstDay
			  ,[LAST DAY] as LastDay
			  ,m.[PLAYER NAME] as Winner
			  ,w.PlayerName as DSPWinner
			  ,s.Purse
			  ,tt.SID as SurveyId
			  ,DSPoints
			  ,DSPointsYear1
			  ,EventRank
			  ,@SportTourId as SportTourId
		  FROM [DARRELL_MASTER].[Player_Master].[TOURNAMENTS_TABLE] tt
		  left join (select * from Money.TourMoneyStats where [Finish Position] = 1) m on tt.TournamentId = m.TournamentId 
		  left join (select SUM([Official Money]) as Purse, TournamentId from Money.TourMoneyStats group by TournamentId) s on tt.TournamentId = s.TournamentId 
		  left join dspy on tt.TournamentId = dspy.TournamentId
		  left outer join (select [Tournamentid], [PlayerName] from 
								(SELECT [Tournamentid], [PlayerName], rank() over(partition by [Tournamentid] order by [TotalDS] desc) as rn
									FROM [DARRELL_MASTER].[MoneyBall].[WebsiteData1] 
									where [TotalDS] > 0  and PGASeason = @PGASeason and SportTourId = @SportTourId) a 
							where rn = 1) w on tt.TournamentId = w.TournamentId 
			where TYPE = @Tour and tt.PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd
		  )
  

		insert into MoneyBall.WebsiteData2 (Tournamentid,PGASeason,Tour,TournamentName,Club,Location,FirstDay,LastDay,Winner,DSPWinner,Purse,SurveyId,DSPoints,DSPointsYear1,EventRank,SportTourId)
		select * from cte1 where EventRank is null order by FirstDay 
  
		commit tran  
	end

  
Print 'Finished WebsiteData2'; 
end  -- WebsiteData2
GO
