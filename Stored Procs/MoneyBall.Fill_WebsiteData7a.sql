IF OBJECT_ID('MoneyBall.Fill_WebsiteData7a') IS NOT NULL
    DROP PROCEDURE [MoneyBall].[Fill_WebsiteData7a];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	
-- =============================================

CREATE procedure [MoneyBall].[Fill_WebsiteData7a]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS
Begin -- WebsiteData7A
Print 'Start WebsiteData7A'

delete from MoneyBall.WebsiteData7A where PGASeason = @PGASeason and SportTourId = @SportTourId


insert into [MoneyBall].[WebsiteData7A]
(Equipment,[ModelTournamentRank],[ModelTournamentPercent], [ModelTournamentTotal],[Brand],Model,[PGASeason],[FirstDay],[TournamentId],[TournamentName], SportTourId)

select 'Ball' as Equipment, RANK() over(partition by tournamentid order by  COUNT(brand) desc) as ModelTournamentRank,  
COUNT(brand)*1.0 / sum(COUNT(brand)) over (partition by tournamentid) as ModelPercent,
COUNT(brand) as ModelTotal, BRAND, Model, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME], @SportTourId 
from dbo.Ball where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, Model, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME]
union all
select 'Bag' as Equipment, RANK() over(partition by tournamentid order by  COUNT(brand) desc) as ModelTournamentRank,  
COUNT(brand)*1.0 / sum(COUNT(brand)) over (partition by tournamentid) as ModelPercent,
COUNT(brand) as ModelTotal, BRAND, Model, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME], @SportTourId 
from dbo.Bag where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, Model, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME]
union all
select 'Glove' as Equipment, RANK() over(partition by tournamentid order by  COUNT(brand) desc) as ModelTournamentRank,
COUNT(brand)*1.0 / sum(COUNT(brand)) over (partition by tournamentid) as ModelPercent,
COUNT(brand) as ModelTotal, BRAND, Model, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME], @SportTourId 
from dbo.Gloves where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, Model, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME]
union all
select 'Headgear' as Equipment, RANK() over(partition by tournamentid order by  COUNT(brand) desc) as ModelTournamentRank,
COUNT(brand)*1.0 / sum(COUNT(brand)) over (partition by tournamentid) as ModelPercent,
COUNT(brand) as ModelTotal, BRAND, Model, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME] , @SportTourId
from dbo.Headgear where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, Model, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME]
union all
select 'Shirt' as Equipment, RANK() over(partition by tournamentid order by  COUNT(brand) desc) as ModelTournamentRank,
COUNT(brand)*1.0 / sum(COUNT(brand)) over (partition by tournamentid) as ModelPercent,
COUNT(brand) as ModelTotal, BRAND, Model, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME], @SportTourId 
from dbo.Shirts where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, Model, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME]
union all
select 'Iron' as Equipment, RANK() over(partition by tournamentid order by  COUNT(brand) desc) as ModelTournamentRank,
COUNT(brand)*1.0 / sum(COUNT(brand)) over (partition by tournamentid) as ModelPercent,
COUNT(brand) as ModelTotal, BRAND, Model, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME], @SportTourId 
from dbo.Irons where isset = 1 and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, Model, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME]
union all
select 'Putter' as Equipment, RANK() over(partition by tournamentid order by  COUNT(brand) desc) as ModelTournamentRank, 
COUNT(brand)*1.0 / sum(COUNT(brand)) over (partition by tournamentid) as ModelPercent,
COUNT(brand) as ModelTotal, BRAND, Model, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME], @SportTourId 
from dbo.Putters where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, Model, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME]
union all
select 'Shoe' as Equipment, RANK() over(partition by tournamentid order by  COUNT(brand) desc) as ModelTournamentRank,  
COUNT(brand)*1.0 / sum(COUNT(brand)) over (partition by tournamentid) as ModelPercent,
COUNT(brand) as ModelTotal, BRAND, Model, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME] , @SportTourId
from dbo.Shoes where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, Model, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME]
union all
select 'Driver' as Equipment, RANK() over(partition by tournamentid order by  COUNT(brand) desc) as ModelTournamentRank,  
COUNT(brand)*1.0 / sum(COUNT(brand)) over (partition by tournamentid) as ModelPercent,
COUNT(brand) as ModelTotal, BRAND, Model, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME] , @SportTourId
from dbo.Woods where isdriver = 1 and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, Model, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME]
union all
select 'Hybrid' as Equipment, RANK() over(partition by tournamentid order by  COUNT(brand) desc) as ModelTournamentRank,  
COUNT(brand)*1.0 / sum(COUNT(brand)) over (partition by tournamentid) as ModelPercent,
COUNT(brand) as ModelTotal, BRAND, Model, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME], @SportTourId 
from dbo.Woods where [CLUB NUMBER] = 'HYBRID' and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, Model, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME]
union all
select 'Fairway Wood' as Equipment, RANK() over(partition by tournamentid order by  COUNT(brand) desc) as ModelTournamentRank,  
COUNT(brand)*1.0 / sum(COUNT(brand)) over (partition by tournamentid) as ModelPercent,
COUNT(brand) as ModelTotal, BRAND, Model, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME], @SportTourId 
from dbo.Woods where [CLUB NUMBER] <> 'HYBRID' and ISDRIVER = 0 and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, Model, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME]
union all
select 'Wedge' as Equipment, RANK() over(partition by tournamentid order by  COUNT(brand) desc) as ModelTournamentRank,  
COUNT(brand)*1.0 / sum(COUNT(brand)) over (partition by tournamentid) as ModelPercent,
COUNT(brand) as ModelTotal, BRAND, Model, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME] , @SportTourId
from dbo.Wedges where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) group by BRAND, Model, PGASeason, [FIRST DAY], TournamentId, [TOURNAMENT NAME]




update [MoneyBall].[WebsiteData7A] set ModelTournamentRankWithTie = ModelTournamentRank where PGASeason = @PGASeason  and SportTourId = @SportTourId


update a
set ModelTournamentRankWithTie = 'T' + ModelTournamentRankWithTie 
from [MoneyBall].[WebsiteData7A] a inner join (
select TournamentId, Equipment, ModelTournamentRank, COUNT(*) as rn 
from [MoneyBall].[WebsiteData7A]
where SportTourId = @SportTourId
group by TournamentId, Equipment, ModelTournamentRank
having COUNT(*) > 1) b
on a.TournamentId = b.TournamentId and a.Equipment = b.Equipment and a.ModelTournamentRank = b.ModelTournamentRank and a.SportTourId = @SportTourId
where PGASeason = @PGASeason  and a.SportTourId = @SportTourId

Print 'Finished WebsiteData7A'; 
end -- WebsiteData7A
GO
