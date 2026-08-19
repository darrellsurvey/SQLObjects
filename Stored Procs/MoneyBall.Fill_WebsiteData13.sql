DROP PROCEDURE IF EXISTS [MoneyBall].[Fill_WebsiteData13];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	
-- =============================================

CREATE procedure [MoneyBall].[Fill_WebsiteData13]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS
Begin -- WebsiteData13
Print 'Begin WebsiteData13';
	
delete from MoneyBall.WebsiteData13 where PGASeason = @PGASeason and SportTourId = @SportTourId

;with cte1 as (
select TournamentId, [Round], Brand, 
			sum(DSPoints) as DSPointsTotal,
			sum(DSMoney) as DSM,
			sum(case when [Equip] = 'Shirt' then DSPoints else 0 end) as DSPointsShirt, 
			sum(case when [Equip] = 'Shoes' then DSPoints else 0 end) as DSPointsShoes,
			sum(case when [Equip] = 'Headgear' then DSPoints else 0 end) as DSPointsHeadgear, 
			sum(case when [Equip] = 'Bag' then DSPoints else 0 end) as DSPointsBag
from tv.tvaudit tv 
--where TOUR = @Tour and PGASeason = @PGASeason and tv.TntFirstDay < @LastFullTournamentEnd
where PGASeason = @PGASeason and tv.TntFirstDay < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and TntNid in (26,351,353,355)))
group by TournamentId, [Round], Brand
)

insert into MoneyBall.WebsiteData13 (PGASeason,
									TournamentId,
									SurveyId,
									TournamentName,
									FirstDay,
									RoundNumber,
									Brand,
									BrandRank,
									DSPointsTotal,
									DSMTotal,
									ShirtRank,
									DSPointsShirt,
									ShoesRank,
									DSPointsShoes,
									HeadgearRank,
									DSPointsHeadgear,
									BagRank,
									DSPointsBag,
									SportTourId)

select PGASeason, cte1.TournamentId, t.SID as SurveyId, [Tournament Name] as TournamentName,[First Day] as FirstDay, [Round],
Brand,
RANK() over(Partition by cte1.TournamentId order by DSPointsTotal desc) as BrandRank,
DSPointsTotal,DSM,
case when DSPointsShirt > 0 then RANK() over(Partition by cte1.TournamentId order by DSPointsShirt desc) else NULL end as ShirtRank,
nullif(DSPointsShirt, 0) as DSPointsShirt,
case when DSPointsShoes > 0 then RANK() over(Partition by cte1.TournamentId order by DSPointsShoes desc) else NULL end as ShoesRank,
nullif(DSPointsShoes, 0) as DSPointsShoes,
case when DSPointsHeadgear > 0 then RANK() over(Partition by cte1.TournamentId order by DSPointsHeadgear desc) else NULL end as HeadgearRank,
nullif(DSPointsHeadgear, 0) as DSPointsHeadgear,
case when DSPointsBag > 0 then RANK() over(Partition by cte1.TournamentId order by DSPointsBag desc) else NULL end as BagRank,
nullif(DSPointsBag, 0) as DSPointsBag,
@SportTourId
from cte1
inner join [Player_Master].[TOURNAMENTS_TABLE] t on cte1.TournamentId = t.TournamentId
order by brandrank desc

Print 'Finished WebsiteData13';
end  -- WebsiteData13
GO
