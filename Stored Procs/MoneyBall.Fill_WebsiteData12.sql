DROP PROCEDURE IF EXISTS [MoneyBall].[Fill_WebsiteData12];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	
-- =============================================

CREATE procedure [MoneyBall].[Fill_WebsiteData12]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS
Begin -- WebsiteData12
Print 'Begin WebsiteData12'	

delete from MoneyBall.WebsiteData12 where PGASeason = @PGASeason and SportTourId = @SportTourId


insert into MoneyBall.WebsiteData12 (PGASeason, Brand, Equipment, Placement, DSPoints,DSM, EquipmentPlacement, DSPercent, SportTourId)
select PGASeason, Brand, Equip, Placement, SUM(DSPoints) as DSPoints, SUM(DSMoney) as DSM, Equip + Placement, 
round(SUM(DSPoints) * 100.0 / sum(SUM(DSPoints)) over(partition by pgaseason, brand),2) as rn, @SportTourId
from TV.TVAudit 
--where TOUR = @Tour and PGASeason = @PGASeason and TntFirstDay < @LastFullTournamentEnd
where PGASeason = @PGASeason and TntFirstDay < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and TntNid in (26,351,353,355)))

group by PGASeason, Brand, Equip, Placement
order by PGASeason, Brand, Equip, Placement

begin tran
Update MoneyBall.WebsiteData12 set EquipmentPlacement = replace(EquipmentPlacement, ' - ', '') where PGASeason = @PGASeason
Update MoneyBall.WebsiteData12 set EquipmentPlacement = replace(EquipmentPlacement, ' ', '') where PGASeason = @PGASeason
Update MoneyBall.WebsiteData12 set EquipmentPlacement = replace(EquipmentPlacement, 'Unspecified', '') where PGASeason = @PGASeason
commit tran


Print 'Finished WebsiteData12';
end  -- WebsiteData12
GO
