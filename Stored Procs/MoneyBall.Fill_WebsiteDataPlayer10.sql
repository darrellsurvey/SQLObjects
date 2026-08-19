IF OBJECT_ID('MoneyBall.Fill_WebsiteDataPlayer10') IS NOT NULL
    DROP PROCEDURE [MoneyBall].[Fill_WebsiteDataPlayer10];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	
-- =============================================

CREATE procedure [MoneyBall].[Fill_WebsiteDataPlayer10]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS
Begin -- WebsiteDataPlayer10
Print 'Begin WebsiteDataPlayer10';

delete from MoneyBall.WebsiteDataPlayer10 where PGASeason = @PGASeason and SportTourId = @SportTourId

begin tran

insert into MoneyBall.WebsiteDataPlayer10 (PGASeason,PlayerName,TournamentId, Brand, Equipment, Placement, DSPoints, DSM, SportTourId)
select PGASeason, PlayerName, TournamentId, Brand, Equip, Placement, sum(DSPoints), sum(DSMoney), @SportTourId
from TV.TVAudit
--where PGASeason = @PGASeason and Tour = @Tour and Caddie = 0
where PGASeason = @PGASeason and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and TntNid in (26,351,353,355)))
group by PGASeason, PlayerName, TournamentId, Brand, Equip, Placement

commit tran

Print 'Finished WebsiteDataPlayer10';
end  -- WebsiteDataPlayer10
GO
