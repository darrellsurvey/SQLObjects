IF OBJECT_ID('MoneyBall.Fill_WebsiteDataPlayer10Caddie') IS NOT NULL
    DROP PROCEDURE [MoneyBall].[Fill_WebsiteDataPlayer10Caddie];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	
-- =============================================

CREATE procedure [MoneyBall].[Fill_WebsiteDataPlayer10Caddie]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS
Begin -- WebsiteDataPlayer10Caddie
Print 'Begin WebsiteDataPlayer10Caddie';

delete from MoneyBall.WebsiteDataPlayer10Caddie where PGASeason = @PGASeason and SportTourId = @SportTourId

begin tran

insert into MoneyBall.WebsiteDataPlayer10Caddie (PGASeason,PlayerName,TournamentId, Brand, Equipment, Placement, DSPoints,DSM, SportTourId)
select PGASeason, PlayerName, TournamentId, Brand, Equip, Placement, sum(DSPoints),sum(DSMoney),  @SportTourId
from TV.TVAudit
where PGASeason = @PGASeason and Tour = @Tour and Caddie = 1
group by PGASeason, PlayerName, TournamentId, Brand, Equip, Placement

commit tran

Print 'Finished WebsiteDataPlayer10Caddie';
end  -- WebsiteDataPlayer10Caddie
GO
