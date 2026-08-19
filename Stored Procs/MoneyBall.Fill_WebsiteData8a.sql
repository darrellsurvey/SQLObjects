DROP PROCEDURE IF EXISTS [MoneyBall].[Fill_WebsiteData8a];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	
-- =============================================

CREATE procedure [MoneyBall].[Fill_WebsiteData8a]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS
Begin -- WebsiteData8a
Print 'Start WebsiteData8a'

delete from MoneyBall.WebsiteData8a where PGASeason = @PGASeason and SportTourId = @SportTourId
	
insert into [DARRELL_MASTER].[MoneyBall].[WebsiteData8A]

SELECT [PGASeason],[Equipment],[Brand],[BrandEquipmentRank], [BrandEquipmentRankWithTie],[BrandEquipmentTotal],[BrandEquipmentPercent], SportTourId
	  FROM [DARRELL_MASTER].[MoneyBall].[WebsiteData8]  where BrandEquipmentRank < 6 and PGASeason = @PGASeason and SportTourId = @SportTourId
union all
SELECT [PGASeason],[Equipment],'ALL OTHER',NULL,NULL,sum([BrandEquipmentTotal]),NULL, SportTourId
	  FROM [DARRELL_MASTER].[MoneyBall].[WebsiteData8] where BrandEquipmentRank > 5  and PGASeason = @PGASeason and SportTourId = @SportTourId group by [PGASeason],[Equipment], SportTourId
  
    
update p
set p.[BrandEquipmentPercent] = NewPercent
from [DARRELL_MASTER].[MoneyBall].[WebsiteData8A] p 
inner join (select PGASeason, Equipment, 100-SUM(brandequipmentpercent) as NewPercent 
			from [DARRELL_MASTER].[MoneyBall].[WebsiteData8A] 
			where  SportTourId = @SportTourId
			group by PGASeason, Equipment) a 
on p.PGASeason = a.PGASeason and p.Equipment = a.Equipment and p.Brand = 'ALL OTHER' and p.PGASeason = @PGASeason and p.SportTourId = @SportTourId

Print 'Finished WebsiteData8a'; 
end  -- WebsiteData8a
GO
