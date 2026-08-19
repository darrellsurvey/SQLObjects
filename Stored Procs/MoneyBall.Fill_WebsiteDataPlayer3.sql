IF OBJECT_ID('MoneyBall.Fill_WebsiteDataPlayer3') IS NOT NULL
    DROP PROCEDURE [MoneyBall].[Fill_WebsiteDataPlayer3];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	Fill table MoneyBall.WebsiteDataPlayer3
-- =============================================

CREATE procedure [MoneyBall].[Fill_WebsiteDataPlayer3]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS
Begin -- WebsiteDataPlayer3
Print 'Start WebsiteDataPlayer3'

delete from MoneyBall.WebsiteDataPlayer3 where PGASeason = @PGASeason and SportTourId = @SportTourId	

insert into MoneyBall.WebsiteDataPlayer3 (PGASeason,PlayerName,Equipment,Placement,DSPoints, DSM, IsEstimate, EquipmentPlacement,SportTourId)
select PGASeason, PlayerName, Equipment, Placement, DSPoints, DSM, DSPointsEstimate, Equipment + Placement,@SportTourId from MoneyBall.PlayerDSPointsWithEstimate
where PGASeason = @PGASeason and SportTourId = @SportTourId


begin tran
Update MoneyBall.WebsiteDataPlayer3 set EquipmentPlacement = replace(EquipmentPlacement, ' - ', '') where PGASeason = @PGASeason and SportTourId = @SportTourId
Update MoneyBall.WebsiteDataPlayer3 set EquipmentPlacement = replace(EquipmentPlacement, ' ', '') where PGASeason = @PGASeason and SportTourId = @SportTourId
Update MoneyBall.WebsiteDataPlayer3 set EquipmentPlacement = replace(EquipmentPlacement, 'Unspecified', '') where PGASeason = @PGASeason and SportTourId = @SportTourId
commit tran

Print 'Finished WebsiteDataPlayer3'; 
end  -- WebsiteDataPlayer3
GO
