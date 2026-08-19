DROP PROCEDURE IF EXISTS [MoneyBall].[Fill_WebsiteDataPlayer7TotalNoReplays];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 07/28/2025
-- Description:	Fill table MoneyBall.WebsiteDataPlayer7TotalNoReplays
-- =============================================

CREATE procedure [MoneyBall].[Fill_WebsiteDataPlayer7TotalNoReplays]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS
Begin -- WebsiteDataPlayer7TotalNoReplays
Print 'Start WebsiteDataPlayer7TotalNoReplays'

--exec [MoneyBall].[Fill_WebsiteDataPlayer7TotalNoReplays] 'PGA', 2024,1,'20250728'
	
delete from MoneyBall.WebsiteDataPlayer7TotalNoReplays where PGASeason = @PGASeason and SportTourId = @SportTourId

;with cte as (
SELECT w1.PlayerName, 
	   w1.PGASeason,
	   rn as EventsPlayerOnTV,
	   w1.DSRank,
	   w1.DSPointsYTDPercent,
	   w1.DSpoints, 
	   w1.DSM, 
	   TFDSPoints, 
	   SSDSPoints,
	   TFDSPoints * 1.0 / nullif(rn,0) as AvgTFDSPoints, 
	   SSDSPoints * 1.0 / nullif(rn,0) as AvgSSDSPoints,
	   case when coalesce(DSPoints, 0) = 0 then NULL else SSDSPoints * 1.0 / DSPoints end as PortionOfEventTDueToSS,
	   DSPoints * 1.0 / nullif(rn,0) as EventAvgDSPoints
FROM (select tour, pgaseason, PlayerName, 
			rank() over(partition by tour, pgaseason order by sum(DSpoints) desc) as DSRank, 
			sum(DSpoints) *1.0 / sum(sum(DSpoints)) over (partition by tour, pgaseason) as DSPointsYTDPercent,
			sum(DSpoints) as DSpoints, sum(dsmoney) as DSM 
		from [TV].[TVAudit] 
		where pgaseason = @PGASeason and tour = @Tour and Caddie = 0 and ReplayOther = 0
		group by tour, pgaseason,PlayerName) w1

left outer join (select pgaseason, playername, COUNT(distinct tournamentid) as rn, sum(case when [ROUND] in (1, 2) then DSPoints else 0 end) as TFDSPoints,	sum(case when [ROUND] in (3, 4) then DSPoints else 0 end) as SSDSPoints 
					from TV.TVAudit 
					where PGASeason = @PGASeason  and tour = @Tour and Caddie = 0 and ReplayOther = 0
					group by pgaseason, playername) a 
	on w1.PGASeason = a.PGASeason and w1.PlayerName = a.PlayerName 

)


Insert into MoneyBall.WebsiteDataPlayer7TotalNoReplays (PlayerName, PGASeason, Header, UserData, SportTourId)


Select PlayerName, PGASeason, 'EventsPlayerOnTV' as Header, EventsPlayerOnTV as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'DSRank' as Header, DSRank as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'DSPoints' as Header, DSPoints as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'DSMoney' as Header, DSM as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'DSPointsPercent' as Header, DSPointsYTDPercent as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'TFDSPoints' as Header, TFDSPoints as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'SSDSPoints' as Header, SSDSPoints as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'AvgTFDSPoints' as Header, AvgTFDSPoints as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'AvgSSDSPoints' as Header, AvgSSDSPoints as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'PortionOfEventTDueToSS' as Header, PortionOfEventTDueToSS as UserData, @SportTourId from cte union all
Select PlayerName, PGASeason, 'EventAvgDSPoints' as Header, EventAvgDSPoints as UserData, @SportTourId from cte



Print 'Finished WebsiteDataPlayer7TotalNoReplays'; 
end  -- WebsiteDataPlayer7TotalNoReplays
GO
