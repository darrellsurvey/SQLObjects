IF OBJECT_ID('OptOut.Settings_Get') IS NOT NULL
    DROP PROCEDURE [OptOut].[Settings_Get];
GO

Create procedure [OptOut].[Settings_Get]
@PlayerName varchar(50), 
@Season integer

as
begin

--exec [OptOut].[Settings_Get] 'WOODS, TIGER', 2023

;with cteAll as(
select distinct 'Glove' as Equipment, BRAND, model from dbo.[Gloves] a where PGASeason = @Season and PLAYERNAME = @PlayerName union all
select distinct 'Shoe' as Equipment, BRAND, model from dbo.[Shoes] a where PGASeason = @Season and PLAYERNAME = @PlayerName union all
select distinct 'Shirt' as Equipment, BRAND, model from dbo.[Shirts] a where PGASeason = @Season and PLAYERNAME = @PlayerName union all
select distinct 'Hat' as Equipment, BRAND, model from dbo.[Headgear] a where PGASeason = @Season and PLAYERNAME = @PlayerName union all
select distinct 'Bag' as Equipment, BRAND, model from dbo.[bag] a where PGASeason = @Season and PLAYERNAME = @PlayerName union all
select distinct 'Ball' as Equipment, BRAND, model from dbo.[ball] a where PGASeason = @Season and PLAYERNAME = @PlayerName union all
select distinct 'Iron' as Equipment, BRAND, model from dbo.irons a where PGASeason = @Season and PLAYERNAME = @PlayerName union all
select distinct 'Wedge' as Equipment, BRAND, model from dbo.Wedges a where PGASeason = @Season and PLAYERNAME = @PlayerName union all
select Distinct 'Wood' as Equipment, BRAND, model from dbo.[woods] a where PGASeason = @Season and PLAYERNAME = @PlayerName union all
select distinct 'Putter' as Equipment, BRAND, model from dbo.[Putters] a where PGASeason = @Season and PLAYERNAME = @PlayerName union
select distinct 'Shaft' Equipment, BRAND, model from dbo.Shafts a where PGASeason = @Season and PLAYERNAME = @PlayerName union all
select distinct 'Grip' as Equipment, BRAND, model from dbo.Grips a where PGASeason = @Season and PLAYERNAME = @PlayerName)

--select brand, model, Equipment, 1 as isOptIn from cteall
select distinct a.brand, a.model, case when b.Model is null then 0 else 1 end as isOptIn, SetBy as SetBy from cteall a
left join (select Brand, Model, SetBy from OptOut.Settings WHERE PlayerName = @PlayerName and Season = @Season and not Model is NULL) b
on a.brand = b.brand and a.Model = b.Model
order by brand, model

end
GO
