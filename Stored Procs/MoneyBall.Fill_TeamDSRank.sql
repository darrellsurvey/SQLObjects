DROP PROCEDURE IF EXISTS [MoneyBall].[Fill_TeamDSRank];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 12/7/2023
-- Description:	Fill TeamDSRank Table
-- =============================================

CREATE procedure [MoneyBall].[Fill_TeamDSRank]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint
)
AS
begin

--exec [MoneyBall].[Fill_TeamDSRank] 'NCAA GOLF', 2024, 6
--exec [MoneyBall].[Fill_TeamDSRank] 'TGL', 2026, 61
--exec [MoneyBall].[Fill_TeamDSRank] 'LIV', 2025, 56

Delete from [MoneyBall].TeamDSRank where PGASeason = @PGASeason and SportTourId = @SportTourId


insert into [MoneyBall].TeamDSRank 
	(Team
      ,PGASeason
      ,PGASeasonRank
      ,PGASeasonRankNoTie
      ,DSPoints
	  ,DSM
	  ,SportTourId)

select Team, 
		PGASeason,
		RANK() over(partition by tv.PGAseason order by SUM(DSPoints) desc) as rn,
		RANK() over(partition by tv.PGAseason order by SUM(DSPoints) desc, Team asc) as rnnoties,
		round(SUM(DSPoints), 0),
		round(SUM(DSMoney), 0),
		@SportTourId
from tv.TVAudit tv
inner join [Money].[TourMoneyStats] m  on tv.TournamentId = m.TournamentId and tv.PlayerName = m.[PLAYER NAME]
where tv.PGASeason = @PGASeason and not DSPoints is null and tour = @tour and team is not null
group by Team, tv.PGASeason



end
GO
