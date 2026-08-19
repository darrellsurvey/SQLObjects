IF OBJECT_ID('OptOut.LevelBrand_Get') IS NOT NULL
    DROP PROCEDURE [OptOut].[LevelBrand_Get];
GO

CREATE procedure [OptOut].[LevelBrand_Get]
@PlayerName varchar(100), 
@Season integer

as
begin

--exec [OptOut].[LevelBrand_Get] 'WOODS, TIGER', 2020

;with cteAll as(
select distinct 'Ball' as Equipment, BRAND, model from dbo.[ball] a where PGASeason = @Season and PLAYERNAME = @PlayerName and TOUR = 'PGA'  union all
select distinct 'Iron' as Equipment, BRAND, model from dbo.irons a where PGASeason = @Season and PLAYERNAME = @PlayerName and TOUR = 'PGA'  union all
select distinct 'Wedge' as Equipment, BRAND, model from dbo.Wedges a where PGASeason = @Season and PLAYERNAME = @PlayerName and TOUR = 'PGA'  union all
select Distinct 'Wood' as Equipment, BRAND, model from dbo.[woods] a where PGASeason = @Season and PLAYERNAME = @PlayerName and TOUR = 'PGA'  union all
select distinct 'Putter' as Equipment, BRAND, model from dbo.[Putters] a where PGASeason = @Season and PLAYERNAME = @PlayerName and TOUR = 'PGA'  union all
select distinct 'Glove' as Equipment, BRAND, model from dbo.Gloves a where PGASeason = @Season and PLAYERNAME = @PlayerName and TOUR = 'PGA'  union all
select distinct 'Bag' as Equipment, BRAND, model from dbo.Bag a where PGASeason = @Season and PLAYERNAME = @PlayerName and TOUR = 'PGA'  union all
select distinct 'Shoe' as Equipment, BRAND, model from dbo.Shoes a where PGASeason = @Season and PLAYERNAME = @PlayerName and TOUR = 'PGA'  union all					
select Distinct 'Headgear' as Equipment, BRAND, model from dbo.Headgear a where PGASeason = @Season and PLAYERNAME = @PlayerName and TOUR = 'PGA'  union all
select distinct 'Shirt' as Equipment, BRAND, model from dbo.Shirts a where PGASeason = @Season and PLAYERNAME = @PlayerName and TOUR = 'PGA'  union all
select distinct 'Shaft' Equipment, BRAND, model from dbo.Shafts a where PGASeason = @Season and PLAYERNAME = @PlayerName and TOUR = 'PGA'  union all
select distinct 'Grip' as Equipment, BRAND, model from dbo.Grips a where PGASeason = @Season and PLAYERNAME = @PlayerName and TOUR = 'PGA')

select distinct a.Brand, case when b.brand is null then 0 else 1 end as isOptIn, COALESCE(SetBy, 'P') SetBy from cteall a
left join (select Brand, SetBy from OptOut.Settings WHERE PlayerName = @PlayerName and Season = @Season and Model is NULL) b
on a.brand = b.brand
order by brand

end
GO
