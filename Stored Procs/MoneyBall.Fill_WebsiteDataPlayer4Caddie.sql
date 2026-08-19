IF OBJECT_ID('MoneyBall.Fill_WebsiteDataPlayer4Caddie') IS NOT NULL
    DROP PROCEDURE [MoneyBall].[Fill_WebsiteDataPlayer4Caddie];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	Fill table MoneyBall.WebsiteDataPlayer4Caddie
-- =============================================

CREATE procedure [MoneyBall].[Fill_WebsiteDataPlayer4Caddie]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS

Begin -- WebsiteDataPlayer4Caddie
Print 'Start WebsiteDataPlayer4Caddie'
	
delete from MoneyBall.WebsiteDataPlayer4Caddie where PGASeason = @PGASeason and SportTourId = @SportTourId

insert into MoneyBall.WebsiteDataPlayer4Caddie (PGASeason,PlayerName,Brand, Equipment, Placement, DSPoints, DSM, EquipmentPlacement,SportTourId)
select PGASeason, PlayerName, Brand, Equip, Placement, SUM(DSPoints) as DSPoints,SUM(DSMoney) as DSM, Equip + Placement,@SportTourId
from TV.TVAudit 
--where TOUR = @Tour and PGASeason = @PGASeason and TntFirstDay < @LastFullTournamentEnd and Caddie = 1
where PGASeason = @PGASeason and TntFirstDay < @LastFullTournamentEnd and Caddie = 1 and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and TntNid in (26,351,353,355)))
group by PGASeason, Brand, PlayerName, Equip, Placement
order by PGASeason, PlayerName, Brand, Equip, Placement

begin tran
Update MoneyBall.WebsiteDataPlayer4Caddie set EquipmentPlacement = replace(EquipmentPlacement, ' - ', '') where PGASeason = @PGASeason
Update MoneyBall.WebsiteDataPlayer4Caddie set EquipmentPlacement = replace(EquipmentPlacement, ' ', '') where PGASeason = @PGASeason
Update MoneyBall.WebsiteDataPlayer4Caddie set EquipmentPlacement = replace(EquipmentPlacement, 'Unspecified', '') where PGASeason = @PGASeason
commit tran

Print 'Finished WebsiteDataPlayer4Caddie'; 
end  -- WebsiteDataPlayer4Caddie
GO
