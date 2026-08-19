DROP PROCEDURE IF EXISTS [MoneyBall].[Fill_WebsiteData5];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	Fill table MoneyBall.WebsiteData5
-- =============================================

CREATE procedure [MoneyBall].[Fill_WebsiteData5]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS
Begin -- WebsiteData5
Print 'Start WebsiteData5'

delete from MoneyBall.WebsiteData5 where PGASeason = @PGASeason and SportTourId = @SportTourId
	
;with cte_equip as (
select 'Bag' as Equipment, PGASeason, PLAYERNAME, BRAND, count(*) as BrandUse from dbo.bag where TOUR = @Tour and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd group by PGASeason, PLAYERNAME, BRAND
union all select 'Ball' as Equipment, PGASeason, PLAYERNAME, BRAND, count(*) as BrandUse from dbo.ball where TOUR = @Tour and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd group by PGASeason, PLAYERNAME, BRAND
union all select 'Gloves' as Equipment, PGASeason, PLAYERNAME, BRAND, count(*) as BrandUse from dbo.gloves where TOUR = @Tour and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd group by PGASeason, PLAYERNAME, BRAND
union all select 'Headgear' as Equipment, PGASeason, PLAYERNAME, BRAND, count(*) as BrandUse from dbo.Headgear where TOUR = @Tour and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd group by PGASeason, PLAYERNAME, BRAND
union all select 'Shoes' as Equipment, PGASeason, PLAYERNAME, BRAND, count(*) as BrandUse from dbo.Shoes where TOUR = @Tour and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd group by PGASeason, PLAYERNAME, BRAND
union all select 'Shirt' as Equipment, PGASeason, PLAYERNAME, BRAND, count(*) as BrandUse from dbo.Shirts where TOUR = @Tour and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd group by PGASeason, PLAYERNAME, BRAND
union all select Equipment, PGASeason, PLAYERNAME, BRAND, COUNT(*) as BrandUse from (select distinct 'Shafts' as Equipment, PGASeason, tournamentid, PLAYERNAME, BRAND from dbo.Shafts where TOUR = @Tour and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd) a group by Equipment, PGASeason, PLAYERNAME, BRAND  
union all select Equipment, PGASeason, PLAYERNAME, BRAND, count(*) as BrandUse from (select distinct 'Grips' as Equipment, PGASeason, tournamentid, PLAYERNAME, BRAND from dbo.Grips where TOUR = @Tour and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and equipment <> 'PUTTER' ) a group by Equipment, PGASeason, PLAYERNAME, BRAND  
union all select Equipment, PGASeason, PLAYERNAME, BRAND, count(*) as BrandUse from (select distinct 'Irons' as Equipment, PGASeason, tournamentid, PLAYERNAME, BRAND from dbo.Irons where TOUR = @Tour and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd) a group by Equipment, PGASeason, PLAYERNAME, BRAND  
union all select Equipment, PGASeason, PLAYERNAME, BRAND, count(*) as BrandUse from (select distinct 'Putters' as Equipment, PGASeason, tournamentid, PLAYERNAME, BRAND from dbo.Putters where TOUR = @Tour and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd) a group by Equipment, PGASeason, PLAYERNAME, BRAND
union all select Equipment, PGASeason, PLAYERNAME, BRAND, count(*) as BrandUse from (select distinct 'Wedges' as Equipment, PGASeason, tournamentid, PLAYERNAME, BRAND from dbo.Wedges where TOUR = @Tour and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd) a group by Equipment, PGASeason, PLAYERNAME, BRAND
union all select Equipment, PGASeason, PLAYERNAME, BRAND, count(*) as BrandUse from (select distinct 'Woods' as Equipment, PGASeason, tournamentid, PLAYERNAME, BRAND from dbo.Woods where TOUR = @Tour and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd) a group by Equipment, PGASeason, PLAYERNAME, BRAND),


cte_player as (SELECT [PGASeason],[PLAYERNAME],count(*) as TournamentsPlayed 
				FROM [DARRELL_MASTER].[dbo].[Ball] 
				--where TOUR = @Tour  and PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd 
				where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))
                group by [PGASeason],[PLAYERNAME]),


cte_tour as (select e.*, p.TournamentsPlayed
from cte_equip e 
inner join cte_player p on e.PGASeason = p.PGASeason and e.PLAYERNAME = p.PLAYERNAME 
where BrandUse > TournamentsPlayed * .25),



cte_1 as (
select distinct PGASeason, PlayerName, 
case when Brand = 'FOOT JOY' then 'FOOTJOY' 
     when Brand = 'AOSMITH' then 'AO SMITH' 
     when Brand = 'COLLEGE  AFFILIATION' then 'COLLEGE AFFILIATION' 
     when Brand = 'ERNEST & YOUNG' then 'ERNST & YOUNG' 
     when Brand = 'ES & H' then 'ES&H' 
     when Brand = 'GENUIN BIO-FUEL' then 'GENUINE BIO-FUEL' 
     when Brand = 'GRIP IT & RIP IT' then 'GRIP IT AND RIP IT' 
     when Brand = 'H2O SIGNAL' then 'H20 SIGNAL' 
     when Brand = 'K-LOVE' then 'K LOVE' 
     when Brand = 'MARRIOT' then 'MARRIOTT' 
     when Brand = 'MCGLADREYS' then 'MCGLADREY' 
     when Brand = 'MUTUAL OMAHA' then 'MUTUAL OF OMAHA' 
     when Brand = 'PF CHANGS' then 'P.F. CHANG`S' 
     when Brand = 'PHYCOX' then 'PHY COX'
     when Brand = 'POST BANK' then 'POSTBANK'
     when Brand = 'RUTHS CHRIS' then 'RUTH`S CHRIS'
     when Brand = 'STRAIGHTDOWN' then 'STRAIGHT DOWN'
     when Brand = 'STUBURT' then 'STUBERT'
     when Brand = 'T.P.MILLS' then 'T.P. MILLS'
     when Brand = 'TEARDROP' then 'TEAR DROP'
     when Brand = 'THE TAX CLUB' then 'THETAXCLUB'
     when Brand = 'TOP FLITE' then 'TOP-FLITE'
     when Brand = 'TRUE LYNXWARE' then 'TRUE LINKSWEAR'
else Brand end as Brand from cte_tour)



insert into MoneyBall.WebsiteData5 (PGASeason,Brand,PlayerName,PlayerToBrandContributionDSPoint,PlayerToBrandContributionRank,DSMPlayerToBrandContribution,SportTourId)
select coalesce(t.pgaseason, a.pgaseason) as PGASeason,
	   coalesce(t.Brand, a.Brand) as Brand,
	   coalesce(t.PlayerName, a.PlayerName) as PlayerName,
	   case when round(PlayerToBrandContributionDSPoint, 0) = 0 then 1 else round(PlayerToBrandContributionDSPoint, 0) end,
	   PlayerToBrandContributionRank,
	   DSMPlayerToBrandContributionDSPoint,
	   @SportTourId
 from cte_1 as t full outer join 
(select PGASeason, PlayerName, Brand, SUM(DSPoints) as PlayerToBrandContributionDSPoint, SUM(DSMoney) as DSMPlayerToBrandContributionDSPoint,
		RANK() over(partition by PGASeason, brand order by SUM(DSPoints) desc) as PlayerToBrandContributionRank
		from tv.TVAudit 
		--where TOUR = @Tour and Caddie = 0 and PGASeason = @PGASeason and Not DSPoints is null 
		where Caddie = 0 and PGASeason = @PGASeason and Not DSPoints is null and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and tntnid in (26,351,353,355)))
        group by PGASeason, brand, PlayerName) a

on t.PGASeason = a.PGASeason and t.PLAYERNAME = a.PlayerName and t.BRAND = a.Brand 
where coalesce(t.Brand, a.Brand) not in ('Custom', 'Unspecified', '-', 'CLUB CREST', 'VARIOUS')
order by PGASeason, Brand, PlayerToBrandContributionRank, PlayerName


update MoneyBall.WebsiteData5 set PlayerName = rtrim(ltrim(PlayerName)) 
 

Print 'Finished WebsiteData5'; 
end  -- WebsiteData5
GO
