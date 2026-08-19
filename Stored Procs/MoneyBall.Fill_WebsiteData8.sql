DROP PROCEDURE IF EXISTS [MoneyBall].[Fill_WebsiteData8];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	
-- =============================================

CREATE procedure [MoneyBall].[Fill_WebsiteData8]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS
Begin -- WebsiteData8
Print 'Start WebsiteData8'

delete from MoneyBall.WebsiteData8 where PGASeason = @PGASeason and SportTourId = @SportTourId


insert into [MoneyBall].[WebsiteData8]
(Equipment,[BrandEquipmentRank], BrandEquipmentPercent, [BrandEquipmentTotal],[Brand],[PGASeason],SportTourId)

select a.Equipment, 
		RANK() over(partition by PGASeason, Equipment order by  BrandEquipmentTotal desc) as [BrandEquipmentRank],
		BrandEquipmentPercent,
		[BrandEquipmentTotal],
		[Brand],
		[PGASeason],
		@SportTourId
from (

select 'Ball' as Equipment,  
COUNT(brand)*100.0 / sum(COUNT(brand)) over (partition by PGASeason) as BrandEquipmentPercent,
COUNT(brand) as BrandEquipmentTotal, BRAND, PGASeason
from dbo.Ball where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, PGASeason
union all
select 'Bag' as Equipment,  
COUNT(brand)*100.0 / sum(COUNT(brand)) over (partition by PGASeason) as BrandEquipmentPercent,
COUNT(brand) as BrandEquipmentTotal, BRAND, PGASeason
from dbo.Bag where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, PGASeason
union all
select 'Glove' as Equipment,
COUNT(brand)*100.0 / sum(COUNT(brand)) over (partition by PGASeason) as BrandEquipmentPercent,
COUNT(brand) as BrandEquipmentTotal, BRAND, PGASeason
from dbo.Gloves where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, PGASeason
union all
select 'Headgear' as Equipment,
COUNT(brand)*100.0 / sum(COUNT(brand)) over (partition by PGASeason) as BrandEquipmentPercent,
COUNT(brand) as BrandEquipmentTotal, BRAND, PGASeason
from dbo.Headgear where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, PGASeason
union all
select 'Shirt' as Equipment,
COUNT(brand)*100.0 / sum(COUNT(brand)) over (partition by PGASeason) as BrandEquipmentPercent,
COUNT(brand) as BrandEquipmentTotal, BRAND, PGASeason
from dbo.Shirts where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, PGASeason
union all
select 'Iron' as Equipment,
COUNT(brand)*100.0 / sum(COUNT(brand)) over (partition by PGASeason) as BrandEquipmentPercent,
COUNT(brand) as BrandEquipmentTotal, BRAND, PGASeason
from dbo.Irons where isset = 1 and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, PGASeason 
union all
select 'Putter' as Equipment, 
COUNT(brand)*100.0 / sum(COUNT(brand)) over (partition by PGASeason) as BrandPBrandEquipmentPercentercent,
COUNT(brand) as BrandEquipmentTotal, BRAND, PGASeason
from dbo.Putters where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, PGASeason
union all
select 'Shoe' as Equipment,  
COUNT(brand)*100.0 / sum(COUNT(brand)) over (partition by PGASeason) as BrandEquipmentPercent,
COUNT(brand) as BrandEquipmentTotal, BRAND, PGASeason
from dbo.Shoes where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, PGASeason
union all
select 'Driver' as Equipment,  
COUNT(brand)*100.0 / sum(COUNT(brand)) over (partition by PGASeason) as BrandEquipmentPercent,
COUNT(brand) as BrandEquipmentTotal, BRAND, PGASeason
from dbo.Woods where isdriver = 1 and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, PGASeason
union all
select 'Hybrid' as Equipment,  
COUNT(brand)*100.0 / sum(COUNT(brand)) over (partition by PGASeason) as BrandEquipmentPercent,
COUNT(brand) as BrandEquipmentTotal, BRAND, PGASeason
from dbo.Woods where [CLUB NUMBER] = 'HYBRID' and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, PGASeason
union all
select 'Fairway Wood' as Equipment,  
COUNT(brand)*100.0 / sum(COUNT(brand)) over (partition by PGASeason) as BrandEquipmentPercent,
COUNT(brand) as BrandEquipmentTotal, BRAND, PGASeason
from dbo.Woods where [CLUB NUMBER] <> 'HYBRID' and ISDRIVER = 0 and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, PGASeason
union all
select 'Wedge' as Equipment,  
COUNT(brand)*100.0 / sum(COUNT(brand)) over (partition by PGASeason) as BrandEquipmentPercent,
COUNT(brand) as BrandEquipmentTotal, BRAND, PGASeason
from dbo.Wedges where  PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, PGASeason) a
where a.BRAND not in ('VARIOUS', 'CUSTOM', 'UNSPECIFIED', 'NONE')


update [MoneyBall].[WebsiteData8] set BrandEquipmentRankWithTie = BrandEquipmentRank where PGASeason = @PGASeason and SportTourId = @SportTourId
update [MoneyBall].[WebsiteData8] set Brand = 'FOOTJOY' where Brand = 'FOOT JOY'

update a
set BrandEquipmentRankWithTie = 'T' + BrandEquipmentRankWithTie 
from [MoneyBall].[WebsiteData8] a inner join (
select PGASeason, Equipment, BrandEquipmentRank, COUNT(*) as rn 
from [MoneyBall].[WebsiteData8]
where SportTourId = @SportTourId
group by PGASeason, Equipment, BrandEquipmentRank
having COUNT(*) > 1) b
on a.PGASeason = b.PGASeason and a.Equipment = b.Equipment and a.BrandEquipmentRank = b.BrandEquipmentRank  and a.SportTourId = @SportTourId
where a.PGASeason = @PGASeason and a.SportTourId = @SportTourId

Print 'Finished WebsiteData8'; 
end -- WebsiteData8
GO
