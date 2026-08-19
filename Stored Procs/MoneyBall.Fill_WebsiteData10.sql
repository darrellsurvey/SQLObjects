DROP PROCEDURE IF EXISTS [MoneyBall].[Fill_WebsiteData10];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	
-- =============================================

CREATE procedure [MoneyBall].[Fill_WebsiteData10]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS
Begin -- WebsiteData10
Print 'Start WebsiteData10'
	
delete from MoneyBall.WebsiteData10 where PGASeason = @PGASeason and SportTourId = @SportTourId


;with cte_1 as (
SELECT d5.[PGASeason]
      ,[Brand]
      ,d5.[PlayerName]
      ,pr.OfficialMoneyYTD 
      ,pr.PGARank
      ,pr.trend
      ,case when [PGARank] < 26 then 'Top 25'
			when [PGARank] between 26 and 50 then '26 - 50'
			when [PGARank] between 51 and 100 then '51 - 100'
			when [PGARank] between 101 and 200 then '101 - 200'
			when [PGARank] > 200 OR pgarank IS null then '201+'
		end as Bucket
      ,[PlayerToBrandContributionDSPoint]
      ,[PlayerToBrandContributionRank],
      pr.TotalDSPoints 
  FROM [DARRELL_MASTER].[MoneyBall].[WebsiteData5] d5
  inner join [DARRELL_MASTER].[MoneyBall].[PlayerRank] pr on d5.PlayerName = pr.PlayerName and d5.PGASeason = pr.PGAseason and d5.SportTourId = pr.SportTourId
  where d5.PGASeason = @PGASeason and d5.SportTourId = @SportTourId),
  
 cte_2 as (select *, 
AVG([PlayerToBrandContributionDSPoint]) over(partition by PGASeason, Bucket) as AverageDSPoints,
sum([PlayerToBrandContributionDSPoint]) over(partition by PGASeason, Bucket) as BucketDSPoints,
sum([PlayerToBrandContributionDSPoint]) over(partition by PGASeason, PlayerName) as PlayerDSPointsTotal
from cte_1),


cte_3 as (
select [PGASeason]
      ,[Brand]
      ,[PlayerName]
      ,OfficialMoneyYTD as MoneyWon
      ,[PGARank]
      ,Bucket
      ,trend
      ,PlayerDSPointsTotal as DSPointsPlayerTotal
      ,TotalDSPoints as DSPointsPlayerFiltered
      ,[PlayerToBrandContributionDSPoint] as DSPoints
	  ,round((([PlayerToBrandContributionDSPoint]*100.0/ BucketDSPoints) - (AverageDSPoints *100.0 / BucketDSPoints)) * (4/(AverageDSPoints *100.0 / BucketDSPoints)) , 2) as Variance
from cte_2)


insert into [DARRELL_MASTER].[MoneyBall].[WebsiteData10] ([PGASeason],[Brand],[PlayerName],[MoneyWon],[PGARank],[Bucket],[Trend],DSPointsPlayerTotal, DSPointsPlayerFiltered, [DSPoints],[Variance],[NormalizedVariance], SportTourId)
select *, 
	case when [Variance] > 5 then 100 
	     when [Variance] < 0 then round(Variance * 25.0,0)
		 when [Variance] >= 0 then round(Variance * 20.0,0)
		 end as NormalizedVariance, @SportTourId
	
from cte_3
order by cte_3.PGASeason, cte_3.PlayerName 

update [MoneyBall].[WebsiteData10] set PlayerName = ltrim(rtrim(PlayerName))

Print 'Finished WebsiteData10'; 
end  -- WebsiteData10
GO
