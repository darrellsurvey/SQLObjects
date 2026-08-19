IF OBJECT_ID('OptOut.Selection_Get') IS NOT NULL
    DROP PROCEDURE [OptOut].[Selection_Get];
GO

CREATE procedure [OptOut].[Selection_Get]
@user varchar(100),
@PlayerName varchar(100), 
@Season integer

as
begin

--  exec [OptOut].[Selection_Get] 'alex', 'WOODS, TIGER', 2024

IF OBJECT_ID('tempdb..#Results') IS NOT NULL
    DROP TABLE #Results

CREATE TABLE #Results
(
    SelectionLevel tinyint,
	isOptIn int,
	isCurrent bit,
	Player varchar(100),
	Brand varchar(100),
	Equipment varchar(100),
	Model varchar(100),
	SetByUserId int,
	SetBy varchar(100) default 'P',
	AddedOn datetime
)

--declare @HasRecords bit
--SELECT @HasRecords = CASE 
--                        WHEN EXISTS (SELECT 1 FROM optout.Selection WHERE Season = @Season and PLAYERNAME = @PlayerName) 
--                        THEN 1 
--                        ELSE 0 
--                     END;


--if @HasRecords = 1
--	begin 
--		Insert into #Results (SelectionLevel,
--			isOptIn,
--			isCurrent,
--			Player,
--			Brand,
--			Equipment,
--			Model,
--			SetByUserId,
--			SetBy,
--			AddedOn
--			)

--		select SelectionLevel, isOptIn, 0 as isCurrent, PlayerName, brand, Equipment, model, SetByUserId, SetBy, addedOn 
--		from optout.Selection where Season = @Season and PLAYERNAME = @PlayerName
--	end
--else
--	begin
		Insert into #Results (SelectionLevel, isOptIn, isCurrent, Player, Brand, Equipment, Model)
		select distinct 4, 0, 1, PLAYERNAME, BRAND, 'Ball' as Equipment, model from dbo.[ball] a where PGASeason = @Season and PLAYERNAME = @PlayerName and model <> '-' union all
		select distinct 4, 0, 1, PLAYERNAME, BRAND, 'Iron' as Equipment, model from dbo.irons a where PGASeason = @Season and PLAYERNAME = @PlayerName and model <> '-' union all
		select distinct 4, 0, 1, PLAYERNAME, BRAND, 'Wedge' as Equipment, model from dbo.Wedges a where PGASeason = @Season and PLAYERNAME = @PlayerName and model <> '-' union all
		select Distinct 4, 0, 1, PLAYERNAME, BRAND, 'Wood' as Equipment, model from dbo.[woods] a where PGASeason = @Season and PLAYERNAME = @PlayerName and model <> '-' union all
		select distinct 4, 0, 1, PLAYERNAME, BRAND, 'Putter' as Equipment, model from dbo.[Putters] a where PGASeason = @Season and PLAYERNAME = @PlayerName and model <> '-' union
		select distinct 4, 0, 1, PLAYERNAME, BRAND, 'Shaft' Equipment, model from dbo.Shafts a where PGASeason = @Season and PLAYERNAME = @PlayerName and model <> '-' union all
		select distinct 4, 0, 1, PLAYERNAME, BRAND, 'Grip' as Equipment, model from dbo.Grips a where PGASeason = @Season and PLAYERNAME = @PlayerName and model <> '-'

		Insert into #Results (SelectionLevel, isOptIn, isCurrent, Player, Brand, Equipment)
		select distinct 3, 0, 1, Player, BRAND, Equipment from #Results union all
		select distinct 3, 0, 1, PLAYERNAME, BRAND, 'Glove' as Equipment from dbo.[Gloves] a where PGASeason = @Season and PLAYERNAME = @PlayerName union all
		select distinct 3, 0, 1, PLAYERNAME, BRAND, 'Shoe' as Equipment from dbo.[Shoes] a where PGASeason = @Season and PLAYERNAME = @PlayerName union all
		select distinct 3, 0, 1, PLAYERNAME, BRAND, 'Shirt' as Equipment from dbo.[Shirts] a where PGASeason = @Season and PLAYERNAME = @PlayerName union all
		select distinct 3, 0, 1, PLAYERNAME, BRAND, 'Hat' as Equipment from dbo.[Headgear] a where PGASeason = @Season and PLAYERNAME = @PlayerName union all
		select distinct 3, 0, 1, PLAYERNAME, BRAND, 'Bag' as Equipment from dbo.[bag] a where PGASeason = @Season and PLAYERNAME = @PlayerName

		Insert into #Results (SelectionLevel, isOptIn, isCurrent, Player, Brand)
		select distinct 2, 0, 1, Player, BRAND from #Results

		Insert into #Results (SelectionLevel, isOptIn, isCurrent, Player)
		select distinct 0, 0, 1, @PlayerName from #Results

--	end
;with cte_Sponsors as (select distinct Brand from tv.TVAudit tv where PlayerName = @PlayerName and PGASeason = @Season and not exists (select distinct Brand from #Results r where r.brand = tv.brand ))
insert into #Results (SelectionLevel, isOptIn, isCurrent, Player, Brand, Equipment, Model)
Select 1,0,1,@PlayerName,Brand,NULL,NULL from cte_Sponsors


MERGE INTO optout.Selection as target
using #Results as source
	on target.PlayerName = source.Player
	and target.Season = @Season
	and coalesce(target.SelectionLevel, '') = coalesce(source.SelectionLevel, '')
	and coalesce(target.Brand, '') = coalesce(source.Brand, '')
	and coalesce(target.Equipment, '') = coalesce(source.Equipment, '')
	and coalesce(target.Model, '') = coalesce(source.Model, '')
when not matched by target then
	insert (SelectionLevel,isOptIn,PlayerName,Season,Brand,Equipment,Model,SetByUserId, SetBy)
	values (SelectionLevel,isOptIn,Player,@Season,Brand,Equipment,Model,0, 'U'); 



select SelectionId, SelectionLevel, isOptIn, PlayerName, Season, Brand, Equipment, Model, ShopifyId, coalesce(SetByUserId, 0) as SetByUserId, coalesce(SetBy, 'U') as SetBy, AddedOn 
from optout.Selection where Season = @Season and PLAYERNAME = @PlayerName
order by case when selectionlevel < 2 then selectionlevel else 999 end, Brand, Equipment, model



end
GO
