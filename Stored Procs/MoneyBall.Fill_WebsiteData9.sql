DROP PROCEDURE IF EXISTS [MoneyBall].[Fill_WebsiteData9];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	
-- =============================================

CREATE procedure [MoneyBall].[Fill_WebsiteData9]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS
Begin -- WebsiteData9
Print 'Start WebsiteData9'

delete from MoneyBall.WebsiteData9 where PGASeason = @PGASeason and SportTourId = @SportTourId

;with cte_1 as (SELECT d5.[PGASeason]
      ,d5.[Brand]
      ,d5.[PlayerName]
      ,m.OfficialMoneyYTD 
      ,m.PGARank
      ,d5.PlayerToBrandContributionDSPoint as TotalDSPoints 
      ,m.Bucket 
  FROM [DARRELL_MASTER].[MoneyBall].[WebsiteData5] as d5
  inner join (SELECT [PlayerName],[PGASeason],OfficialMoneyYTD,[PGARank]
      ,isnull(TotalDSPoints, 0) as TotalDSPoints
      ,case when [PGARank] < 26 then 'Top 25'
			when [PGARank] between 26 and 50 then '26 - 50'
			when [PGARank] between 51 and 100 then '51 - 100'
			when [PGARank] between 101 and 200 then '101 - 200'
			when [PGARank] > 200 OR pgarank IS null then '201+'
		end as Bucket
  FROM [DARRELL_MASTER].[MoneyBall].[PlayerRank]
  where SportTourId = @SportTourId) m
  on d5.PGASeason = m.PGASeason and d5.PlayerName = m.PlayerName and d5.SportTourId = @SportTourId
  where d5.PGASeason = @PGASeason and d5.SportTourId = @SportTourId),
  
  cte_2 as
  (select pgaseason, bucket, brand, SUM(OfficialMoneyYTD) as Earnings, isnull(SUM(TotalDSPoints), 0) as DS30
  from cte_1
  group by pgaseason, bucket, brand),
  
  
  cte_3 as  
  (select *
  , RANK() over(partition by pgaseason, bucket order by Earnings desc) as rn
  , SUM(ds30) over(partition by pgaseason) as YearDS30
  , SUM(ds30) over(partition by pgaseason, bucket) as BucketDS30
  , SUM(ds30) over(partition by pgaseason, Brand) as BrandDS30
  from cte_2 )
  
  
  insert into MoneyBall.WebsiteData9 (PGASeason, Bucket, Brand, DSPoints, MoneyWon, MoneyWonRank, Variance, NormalizedVariance, SportTourId)
  select PGASeason, Bucket, Brand, DS30 as DSPoints, Earnings as MoneyWon, rn as MoneyWonRank
  --,BucketDS30*100.0/YearDS30 as BucketPercent
  --,DS30*100.0/BrandDS30 as BrandPercent
  ,(DS30*100.0/BrandDS30)*100.0 / (BucketDS30*100.0/YearDS30)-100 as OriginalVariance
  , case when (DS30*100.0/BrandDS30)*100.0 / (BucketDS30*100.0/YearDS30)-100 < -100 then -100 
		 when (DS30*100.0/BrandDS30)*100.0 / (BucketDS30*100.0/YearDS30)-100 > 100 then 100 
		 else (DS30*100.0/BrandDS30)*100.0 / (BucketDS30*100.0/YearDS30)-100  end NormalizedVariance
  ,@SportTourId
  from cte_3
  where Brandds30 > 0 
  union
  select PGASeason, Bucket, Brand, DS30 as DSPoints, Earnings as MoneyWon, rn as MoneyWonRank, null as OriginalVariance, Null as NormalizedVariance, @SportTourId
  from cte_3
  where Brandds30 = 0 
  order by pgaseason, bucket, rn


Print 'Finished WebsiteData9'; 
end  -- WebsiteData9
GO
