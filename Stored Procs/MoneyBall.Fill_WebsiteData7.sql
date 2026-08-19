DROP PROCEDURE IF EXISTS [MoneyBall].[Fill_WebsiteData7];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	
-- =============================================

CREATE procedure [MoneyBall].[Fill_WebsiteData7]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS
Begin -- WebsiteData7
Print 'Start WebsiteData7'

delete from MoneyBall.WebsiteData7 where PGASeason = @PGASeason and SportTourId = @SportTourId


insert into [MoneyBall].[WebsiteData7]
(Equipment,[BrandTournamentRank],[BrandTournamentPercent], [BrandTournamentTotal],[Brand],[PGASeason],[FirstDay],[TournamentId],[TournamentName], SportTourId, BrandTournamentEquipmentRank)

select *, RANK () over(partition by tournamentid, Brand order by  BrandPercent desc) as BrandTournamentEquipmentRank
from (
select 'Ball' as Equipment, RANK() over(partition by tournamentid order by  COUNT(brand) desc) as BrandTournamentRank,  
COUNT(brand)*100.0 / sum(COUNT(brand)) over (partition by tournamentid) as BrandPercent,
COUNT(brand) as BrandTotal, BRAND, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME], @SportTourId  as SportTourId
from dbo.Ball where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME]
union all
select 'Bag' as Equipment, RANK() over(partition by tournamentid order by  COUNT(brand) desc) as BrandTournamentRank,  
COUNT(brand)*100.0 / sum(COUNT(brand)) over (partition by tournamentid) as BrandPercent,
COUNT(brand) as BrandTotal, BRAND, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME], @SportTourId as SportTourId 
from dbo.Bag where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME]
union all
select 'Glove' as Equipment, RANK() over(partition by tournamentid order by  COUNT(brand) desc) as BrandTournamentRank,
COUNT(brand)*100.0 / sum(COUNT(brand)) over (partition by tournamentid) as BrandPercent,
COUNT(brand) as BrandTotal, BRAND, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME], @SportTourId  as SportTourId
from dbo.Gloves where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME]
union all
select 'Headgear' as Equipment, RANK() over(partition by tournamentid order by case when brand = 'VARIOUS' then 0 else COUNT(brand) end desc) as BrandTournamentRank,
COUNT(brand)*100.0 / sum(COUNT(brand)) over (partition by tournamentid) as BrandPercent,
COUNT(brand) as BrandTotal, BRAND, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME], @SportTourId  as SportTourId
from dbo.Headgear where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME]
union all
select 'CaddieHeadgear' as Equipment, RANK() over(partition by tournamentid order by case when brand = 'VARIOUS' then 0 else COUNT(brand) end desc) as BrandTournamentRank,
COUNT(brand)*100.0 / sum(COUNT(brand)) over (partition by tournamentid) as BrandPercent,
COUNT(brand) as BrandTotal, BRAND, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME], @SportTourId  as SportTourId
from (select case when brand like 'VALSPAR%' then 'VALSPAR' else brand end as Brand, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME] 
			from dbo.CaddieHeadgear
			where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME]) z 
		group by BRAND, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME]
union all
select 'Shirt' as Equipment, RANK() over(partition by tournamentid order by case when brand = 'VARIOUS' then 0 else COUNT(brand) end desc) as BrandTournamentRank,
COUNT(brand)*100.0 / sum(COUNT(brand)) over (partition by tournamentid) as BrandPercent,
COUNT(brand) as BrandTotal, BRAND, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME], @SportTourId  as SportTourId
from dbo.Shirts where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME]
union all
select 'Iron' as Equipment, RANK() over(partition by tournamentid order by  COUNT(brand) desc) as BrandTournamentRank,
COUNT(brand)*100.0 / sum(COUNT(brand)) over (partition by tournamentid) as BrandPercent,
COUNT(brand) as BrandTotal, BRAND, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME], @SportTourId  as SportTourId
from dbo.Irons where isset = 1 and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME]
union all
select 'Putter' as Equipment, RANK() over(partition by tournamentid order by  COUNT(brand) desc) as BrandTournamentRank, 
COUNT(brand)*100.0 / sum(COUNT(brand)) over (partition by tournamentid) as BrandPercent,
COUNT(brand) as BrandTotal, BRAND, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME], @SportTourId as SportTourId 
from dbo.Putters where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME]
union all
select 'Shoe' as Equipment, RANK() over(partition by tournamentid order by  COUNT(brand) desc) as BrandTournamentRank,  
COUNT(brand)*100.0 / sum(COUNT(brand)) over (partition by tournamentid) as BrandPercent,
COUNT(brand) as BrandTotal, BRAND, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME], @SportTourId as SportTourId 
from dbo.Shoes where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and TOUR = @Tour group by BRAND, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME]
union all
select 'Driver' as Equipment, RANK() over(partition by tournamentid order by  COUNT(brand) desc) as BrandTournamentRank,  
COUNT(brand)*100.0 / sum(COUNT(brand)) over (partition by tournamentid) as BrandPercent,
COUNT(brand) as BrandTotal, BRAND, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME], @SportTourId as SportTourId 
from dbo.Woods where isdriver = 1 and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME]
union all
select 'Hybrid' as Equipment, RANK() over(partition by tournamentid order by  COUNT(brand) desc) as BrandTournamentRank,  
COUNT(brand)*100.0 / sum(COUNT(brand)) over (partition by tournamentid) as BrandPercent,
COUNT(brand) as BrandTotal, BRAND, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME], @SportTourId as SportTourId 
from dbo.Woods where [CLUB NUMBER] = 'HYBRID' and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME]
union all
select 'Fairway Wood' as Equipment, RANK() over(partition by tournamentid order by  COUNT(brand) desc) as BrandTournamentRank,  
COUNT(brand)*100.0 / sum(COUNT(brand)) over (partition by tournamentid) as BrandPercent,
COUNT(brand) as BrandTotal, BRAND, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME] , @SportTourId as SportTourId
from dbo.Woods where [CLUB NUMBER] <> 'HYBRID' and ISDRIVER = 0 and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME]
union all
select 'Wedge' as Equipment, RANK() over(partition by tournamentid order by  COUNT(brand) desc) as BrandTournamentRank,  
COUNT(brand)*100.0 / sum(COUNT(brand)) over (partition by tournamentid) as BrandPercent,
COUNT(brand) as BrandTotal, BRAND, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME], @SportTourId as SportTourId
from dbo.Wedges where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME]) a




update [MoneyBall].[WebsiteData7] set BrandTournamentRankWithTie = BrandTournamentRank where PGASeason = @PGASeason and SportTourId = @SportTourId 


update a
set BrandTournamentRankWithTie = 'T' + BrandTournamentRankWithTie 
from [MoneyBall].[WebsiteData7] a inner join (
select TournamentId, Equipment, BrandTournamentRank, COUNT(*) as rn 
from [MoneyBall].[WebsiteData7]
where SportTourId = @SportTourId
group by TournamentId, Equipment, BrandTournamentRank
having COUNT(*) > 1) b
on a.TournamentId = b.TournamentId and a.Equipment = b.Equipment and a.BrandTournamentRank = b.BrandTournamentRank and a.SportTourId = @SportTourId 
where PGASeason = @PGASeason and SportTourId = @SportTourId  

update [MoneyBall].[WebsiteData7] set BrandTournamentRankWithTie = NULL where PGASeason = @PGASeason and SportTourId = @SportTourId and equipment in ('Shirt', 'Headgear', 'CaddieHeadgear') and Brand = 'VARIOUS'


update [MoneyBall].[WebsiteData7] set BrandTournamentEquipmentRankWithTie = BrandTournamentEquipmentRank where PGASeason = @PGASeason and SportTourId = @SportTourId 

update a
set BrandTournamentEquipmentRankWithTie = 'T' + BrandTournamentEquipmentRankWithTie 
from [MoneyBall].[WebsiteData7] a inner join (
select TournamentId, Brand, BrandTournamentEquipmentRank, COUNT(*) as rn
from [MoneyBall].[WebsiteData7]
where SportTourId = @SportTourId 
group by TournamentId, Brand, BrandTournamentEquipmentRank
having COUNT(*) > 1) b
on a.TournamentId = b.TournamentId and a.Brand = b.Brand and a.BrandTournamentEquipmentRank = b.BrandTournamentEquipmentRank and a.SportTourId = @SportTourId 
where PGASeason = @PGASeason and SportTourId = @SportTourId 

update [MoneyBall].[WebsiteData7] set BrandTournamentEquipmentRankWithTie = NULL where PGASeason = @PGASeason and SportTourId = @SportTourId and equipment in ('Shirt', 'Headgear', 'CaddieHeadgear') and Brand = 'VARIOUS'
 
Print 'Finished WebsiteData7';  
end -- WebsiteData7
GO
