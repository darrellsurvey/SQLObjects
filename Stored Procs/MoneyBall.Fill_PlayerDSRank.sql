DROP PROCEDURE IF EXISTS [MoneyBall].[Fill_PlayerDSRank];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 12/7/2016
-- Description:	Get Player ranking for a player for a given year using Nielsen data and our TV time. 
--              Bruno MoneyBall project
-- =============================================

CREATE procedure [MoneyBall].[Fill_PlayerDSRank]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint
)
AS
begin

delete from MoneyBall.PlayerDSRank where PGASeason = @PGASeason and SportTourId = @SportTourId;

;with cte_Final as (
select SUM(DSPoints) as TotalPoints, SUM(DSMoney) as DSM,
SUM(case when equip = 'Shirt' then DSPoints end) as TotalPointsShirt,
SUM(case when equip = 'Bag' then DSPoints end) as TotalPointsBag, 
SUM(case when equip = 'Headgear' then DSPoints end) as TotalPointsHat, PlayerName 
from TV.TVAudit 
Where PGASeason = @PGASeason and not DSPoints is null and IsUsedInCalculations = 1 and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and tntnid in (26,351,353,355)))
group by PlayerName)


INSERT INTO [MoneyBall].[PlayerDSRank]
           ([PlayerName]
           ,PGASeason 
           ,DSRank 
           ,DSPoints
		   ,DSM
           ,[ShirtDSPoints]
           ,[HatDSPoints]
           ,[BagDSPoints]
		   ,SportTourId)
Select Playername, 
		@PGASeason,
		rank() over (order by TotalPoints desc),
		isnull(TotalPoints, 0), 
		isnull(DSM, 0), 
		isnull(TotalPointsShirt, 0), 
		isnull(TotalPointsHat, 0), 
		isnull(TotalPointsBag, 0),
		@SportTourId
from cte_Final



update [MoneyBall].PlayerDSRank 
set Trend = 0 
where PGASeason = @PGASeason and SportTourId = @SportTourId and
PlayerName in (
select PlayerName
from [MoneyBall].PlayerDSRank
where SportTourId = @SportTourId and PGASeason between @PGASeason-3 and @PGASeason
group by PlayerName
having COUNT(playername) < 4)


;with cte_1 as (
select PlayerName, AVG(DSPoints) as avgpoints
from [MoneyBall].PlayerDSRank
where SportTourId = @SportTourId and PGASeason  between @PGASeason-3 and @PGASeason-2
group by PlayerName),

cte_2 as (
select PlayerName, AVG(DSPoints) as avgpoints
from [MoneyBall].PlayerDSRank
where SportTourId = @SportTourId and PGASeason between @PGASeason-1 and @PGASeason
group by PlayerName),


cte_f as (
select cte_1.PlayerName, 
case when cte_2.avgpoints - cte_1.avgpoints < 0 and cte_2.avgpoints - cte_1.avgpoints < cte_1.avgpoints * -0.2 then 1
when cte_2.avgpoints - cte_1.avgpoints > 0 and cte_2.avgpoints - cte_1.avgpoints > cte_1.avgpoints * 0.2 then 3
else 2 end As trend
from cte_1 inner join cte_2
on cte_1.PlayerName = cte_2.PlayerName)


update dsr
set dsr.Trend = cte_f.trend 
from [MoneyBall].PlayerDSRank dsr
inner join cte_f on dsr.playername = cte_f.playername and dsr.PGASeason = @PGASeason and dsr.SportTourId = @SportTourId
where dsr.PGASeason = @PGASeason and dsr.trend is null





end
GO
