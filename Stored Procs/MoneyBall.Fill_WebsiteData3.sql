IF OBJECT_ID('MoneyBall.Fill_WebsiteData3') IS NOT NULL
    DROP PROCEDURE [MoneyBall].[Fill_WebsiteData3];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	Fill table MoneyBall.WebsiteData3
-- =============================================

CREATE procedure [MoneyBall].[Fill_WebsiteData3]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS

Begin -- WebsiteData3
Print 'Start WebsiteData3'

delete from MoneyBall.WebsiteData3 where PGASeason = @PGASeason and SportTourId = @SportTourId


;with cte1 as (
select case when [ROUND] = 1 then DSPoints else 0 end as [ROUND 1],
		case when [ROUND] = 2 then DSPoints else 0 end as [ROUND 2],
		case when [ROUND] = 3 then DSPoints else 0 end as [ROUND 3],
		case when [ROUND] = 4 then DSPoints else 0 end as [ROUND 4],
		case when [ROUND] = 5 then DSPoints else 0 end as [ROUND 5],
		case when [Equip] = 'Shirt' then DSPoints else 0 end as [Shirt],
		case when [Equip] = 'Shoes' then DSPoints else 0 end as [Shoes],
		case when [Equip] = 'Headgear' then DSPoints else 0 end as [Headgear],
		case when [Equip] = 'Bag' then DSPoints else 0 end as [Bag],
		DSPoints,
		DSMoney,
		t.TournamentId,
		t.PGASeason,
		t.[TOURNAMENT NAME] as [TournamentName],
		t.[FIRST DAY] as [FirstDay], 
		tv.Brand
from tv.tvaudit tv
inner join Player_Master.TOURNAMENTS_TABLE t
on tv.TournamentId = t.TournamentId 
--where TOUR = @Tour and t.PGASeason = @PGASeason and t.[FIRST DAY] < @LastFullTournamentEnd)
where t.PGASeason = @PGASeason and t.[FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and TntNid in (26,351,353,355))))



insert into MoneyBall.WebsiteData3 (TournamentId,
									PGASeason,
									TournamentName,
									FirstDay,
									Brand,
									BrandRank,
									[Round1DS],
									[Round2DS],
									[Round3DS],
									[Round4DS],
									[Round5DS],
									TotalDS,
									DSM,
									TFDSTotal,
									SSDSTotal,
									SSProportion,
									Shirt,
									Shoes,
									Headgear,
									Bag,
									SportTourId)

select TournamentId,PGASeason,[TournamentName],[FirstDay],Brand,
		RANK() over(Partition by TournamentId order by sum(DSPoints) desc),
		sum([ROUND 1]),
		sum([ROUND 2]),
		sum([ROUND 3]),
		sum([ROUND 4]),
		sum([ROUND 5]),
		sum(DSPoints) as TotalDS,
		sum(DSMoney) as DSM,
		sum([ROUND 1]) + sum([ROUND 2]) as TFTotal,
		sum([ROUND 3]) + sum([ROUND 4]) + sum([ROUND 5]) as SSTotal,
		(sum([ROUND 3]) + sum([ROUND 4]) + sum([ROUND 5]))*100.0 / sum(DSPoints) as SSProportion,
SUM(Shirt) *100.0/ sum(DSPoints) as Shirt,
SUM(Shoes) *100.0/ sum(DSPoints) as Shoes,
SUM(Headgear) *100.0/ sum(DSPoints) as Headgear,
SUM(Bag) *100.0/ sum(DSPoints) as Bag,
@SportTourId
from cte1
group by TournamentId,PGASeason,[TournamentName],[FirstDay],Brand




;with cte_z as (
select TournamentId, Brand, Playername,
RANK() over (partition by TournamentId, Brand order by sum(DSPoints) desc) as BrandRank
from tv.tvaudit
--where TOUR = @Tour and PGASeason = @PGASeason and not DSPoints is null
where PGASeason = @PGASeason and not DSPoints is null and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and TntNid in (26,351,353,355)))
group by TournamentId, Brand, Playername)


update z set PlayerMostContributed = PlayerName
from [darrell_master].[MoneyBall].[WebsiteData3] z inner join (select * from cte_z where BrandRank = 1) a 
on z.TournamentId = a.TournamentId and z.Brand = a.brand

Print 'Finished WebsiteData3';  
end  -- WebsiteData3
GO
