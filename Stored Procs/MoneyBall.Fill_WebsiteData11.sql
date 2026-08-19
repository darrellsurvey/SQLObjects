IF OBJECT_ID('MoneyBall.Fill_WebsiteData11') IS NOT NULL
    DROP PROCEDURE [MoneyBall].[Fill_WebsiteData11];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	
-- =============================================

CREATE procedure [MoneyBall].[Fill_WebsiteData11]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS
Begin -- WebsiteData11
Print 'Start WebsiteData11'

delete from MoneyBall.WebsiteData11 where PGASeason = @PGASeason and SportTourId = @SportTourId	

;with cte_1 as (SELECT [Brand],[PGASeason],[PGASeasonRank],[PGASeasonRankNoTie],[DSPoints],[DSM],[DSPoints] * 100.0 / SUM([DSPoints]) over(partition by [PGASeason]) as DSPointsPercent
				FROM [DARRELL_MASTER].[MoneyBall].[BrandDSRank] where SportTourId = @SportTourId),
				
cte_2 as (SELECT d5.[PGASeason],d5.[Brand],sum(m.OfficialMoneyYTD) as MoneyWon 
			FROM [DARRELL_MASTER].[MoneyBall].[WebsiteData5] as d5
				inner join [DARRELL_MASTER].[MoneyBall].[PlayerRank] m
				on d5.PGASeason = m.PGASeason and d5.PlayerName = m.PlayerName and d5.SportTourId = m.[SportTourId]
			where d5.SportTourId = @SportTourId
				group by d5.[PGASeason],d5.[Brand]),
  
cte_3 as (select cte_1.pgaseason,
				 cte_1.brand,
				 isnull(MoneyWon, 0) as MoneyWon, 
				 isnull(MoneyWon * 100.0 / nullif(SUM(MoneyWon) over(partition by cte_2.[PGASeason]),0), 0) as MoneyWonPercent, 
				 [PGASeasonRank],
				 [PGASeasonRankNoTie],
				 [DSPoints],
				 DSM,
				 DSPointsPercent
			from cte_2
			right outer join cte_1 on cte_1.PGASeason = cte_2.PGASeason and cte_1.Brand = cte_2.Brand)


insert into [MoneyBall].[WebsiteData11] 
([PGASeason],[Brand],[DSPointsRank],[DSPointsYear],[DSPointsPercent],[MoneyWon],[MoneyWonPercent],[DSPointsYear1],[DSPointsPercentYear1],[BrandCompetitior1],[DSPointsCompetitor1],
	[DSPointsPercentCompetitor1],[MoneyWonCompetitor1],[MoneyWonPercentCompetitor1],[BrandCompetitior2],[DSPointsCompetitor2],[DSPointsPercentCompetitor2],[MoneyWonCompetitor2],
	[MoneyWonPercentCompetitor2], SportTourId, [DSMYear], [DSMYear1], [DSMCompetitor1], [DSMCompetitor2])

select cte_3.PGASeason,
		cte_3.Brand, 
		cte_3.PGASeasonRank as DSPointsRank,
		cte_3.DSPoints,
		cte_3.DSPointsPercent, 
		cte_3.MoneyWon, 
		cte_3.MoneyWonPercent,
		cte_13.DSPoints as DSPointsYear1,
		cte_13.DSPointsPercent as DSPointsPercentYear1,
		cte_11.Brand, 
		cte_11.DSPoints,
		cte_11.DSPointsPercent, 
		cte_11.MoneyWon, 
		cte_11.MoneyWonPercent,
		cte_12.Brand, 
		cte_12.DSPoints,
		cte_12.DSPointsPercent,
		cte_12.MoneyWon, 
		cte_12.MoneyWonPercent,
		@SportTourId,
		cte_3.DSM,
		cte_13.DSM,
		cte_11.DSM,
		cte_12.DSM
		from cte_3
left outer join cte_3 as cte_11 on cte_3.PGASeason = cte_11.PGASeason and cte_3.[PGASeasonRankNoTie] = cte_11.[PGASeasonRankNoTie] - 1
left outer join cte_3 as cte_12 on cte_3.PGASeason = cte_12.PGASeason and cte_3.[PGASeasonRankNoTie] = cte_12.[PGASeasonRankNoTie] + 1
left outer join cte_3 as cte_13 on cte_3.PGASeason = cte_13.PGASeason + 1 and cte_3.Brand = cte_13.Brand
where cte_3.PGASeason = @PGASeason 
order by cte_3.PGASeason, DSPointsRank 


if @SportTourId = 8 
	begin
	
		insert into [MoneyBall].[WebsiteData11] 
		([PGASeason],[Brand],[DSPointsRank],[DSPointsYear],[DSPointsPercent],[MoneyWon],[MoneyWonPercent],[DSPointsYear1],[DSPointsPercentYear1],[BrandCompetitior1],[DSPointsCompetitor1],
			[DSPointsPercentCompetitor1],[MoneyWonCompetitor1],[MoneyWonPercentCompetitor1],[BrandCompetitior2],[DSPointsCompetitor2],[DSPointsPercentCompetitor2],[MoneyWonCompetitor2],
			[MoneyWonPercentCompetitor2], SportTourId)

		select PGASeason,Brand, rank() over(order by sum(DSPoints) desc) as DSPointsRank,
				Sum(DSPoints) as [DSPointsYear],
				NULL as DSPointsPercent, 
				NULL as MoneyWon, 
				NULL as MoneyWonPercent,
				NULL as DSPointsYear1,
				NULL as DSPointsPercentYear1,
				NULL as Brand, 
				NULL as DSPoints,
				NULL as DSPointsPercent, 
				NULL as MoneyWon, 
				NULL as MoneyWonPercent,
				NULL as Brand, 
				NULL as DSPoints,
				NULL as DSPointsPercent,
				NULL as MoneyWon, 
				NULL as MoneyWonPercent,
				@SportTourId
		from TV.TVAudit
		where PGASeason = @PGASeason and Tour = @Tour
		group by PGASeason,Brand
		order by DSPointsRank 
	end



Print 'Finished WebsiteData11'
end  -- WebsiteData11
GO
