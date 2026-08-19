DROP PROCEDURE IF EXISTS [MoneyBall].[Fill_WebsiteDataPlayer8];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	
-- =============================================

CREATE procedure [MoneyBall].[Fill_WebsiteDataPlayer8]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS
Begin -- WebsiteDataPlayer8
Print 'Start WebsiteDataPlayer8'

delete from MoneyBall.WebsiteDataPlayer8 where PGASeason = @PGASeason and SportTourId = @SportTourId


insert into MoneyBall.WebsiteDataPlayer8 (PGASeason,PlayerName,TournamentId, RoundNumber, Equipment, DSPoints, DSM, DSPercent)
select PGASeason, PlayerName, TournamentId, Round, Equip, sum(DSPoints), sum(DSMoney), sum(DSPoints) *1.0 / sum(sum(DSPoints)) over(partition by Tournamentid, playername, round)
from TV.TVAudit
--where PGASeason = @PGASeason and Tour = @Tour
where PGASeason = @PGASeason and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and TntNid in (26,351,353,355)))
group by PGASeason, PlayerName, TournamentId, Round, Equip
	
	
Print 'Finished WebsiteDataPlayer8'; 
end  -- WebsiteDataPlayer8
GO
