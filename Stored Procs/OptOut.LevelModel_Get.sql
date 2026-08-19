IF OBJECT_ID('OptOut.LevelModel_Get') IS NOT NULL
    DROP PROCEDURE [OptOut].[LevelModel_Get];
GO

CREATE procedure [OptOut].[LevelModel_Get]
@PlayerName varchar(50), 
@Season integer

as
begin

--exec [OptOut].[LevelModel_Get] 'WOODS, TIGER', 2023

;with cteAll as(
select distinct 'Ball' as Equipment, BRAND, model from dbo.[ball] a where PGASeason = @Season and PLAYERNAME = @PlayerName and TOUR = 'PGA'  union all
select distinct 'Iron' as Equipment, BRAND, model from dbo.irons a where PGASeason = @Season and PLAYERNAME = @PlayerName and TOUR = 'PGA'  union all
select distinct 'Wedge' as Equipment, BRAND, model from dbo.Wedges a where PGASeason = @Season and PLAYERNAME = @PlayerName and TOUR = 'PGA'  union all
select Distinct 'Wood' as Equipment, BRAND, model from dbo.[woods] a where PGASeason = @Season and PLAYERNAME = @PlayerName and TOUR = 'PGA'  union all
select distinct 'Putter' as Equipment, BRAND, model from dbo.[Putters] a where PGASeason = @Season and PLAYERNAME = @PlayerName and TOUR = 'PGA'  union
select distinct 'Shaft' Equipment, BRAND, model from dbo.Shafts a where PGASeason = @Season and PLAYERNAME = @PlayerName and TOUR = 'PGA'  union all
select distinct 'Grip' as Equipment, BRAND, model from dbo.Grips a where PGASeason = @Season and PLAYERNAME = @PlayerName and TOUR = 'PGA')

--select brand, model, Equipment, 1 as isOptIn from cteall
select distinct a.brand, a.model, case when b.Model is null then 0 else 1 end as isOptIn, COALESCE(SetBy, 'P') SetBy from cteall a
left join (select Brand, Model, SetBy from OptOut.Settings WHERE PlayerName = @PlayerName and Season = @Season and not Model is NULL) b
on a.brand = b.brand and a.Model = b.Model
order by brand, model

end
GO
