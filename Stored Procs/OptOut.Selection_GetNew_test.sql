IF OBJECT_ID('OptOut.Selection_GetNew_test') IS NOT NULL
    DROP PROCEDURE [OptOut].[Selection_GetNew_test];
GO

CREATE procedure [OptOut].[Selection_GetNew_test]
@user varchar(100),
@PlayerName varchar(100), 
@Season integer

as
begin
SET NOCOUNT ON
--  exec [OptOut].[Selection_GetNew] 'alex', 'YOUNG, CAMERON', 2025
--  exec [OptOut].[Selection_GetNew] 'alex', 'KIM, TOM', 2025

IF OBJECT_ID('tempdb..#Results') IS NOT NULL
    DROP TABLE #Results

CREATE TABLE #Results
(
    SelectionLevel tinyint,
	isOptIn int,
	isOptIn_shaft int,
	isOptIn_grip int,
	isCurrent bit,
	Player varchar(100),
	Brand varchar(100),
	Equipment varchar(100),
	Model varchar(100),
	Shaft varchar(1000) NULL,
	Grip varchar(1000) NULL,
	ClubNumber varchar(10) NULL,
	Loft varchar(10) NULL,
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


if @PlayerName = 'KIM, TOM' set @PlayerName = 'KIM, JOO HYUNG'
if @PlayerName = 'FITZPATRICK, MATT' set @PlayerName = 'FITZPATRICK, MATTHEW'

--print @PlayerName

		declare @ThisPlayerMostRecentFirstDay as datetime = (select top 1 [FIRST DAY] from dbo.ball where PLAYERNAME = @PlayerName order by cast([FIRST DAY] as datetime) desc)

		Insert into #Results (SelectionLevel, isOptIn, isCurrent, Player, Brand, Equipment, Model, Shaft, Grip, ClubNumber, Loft)
		
		select distinct 4, 0, 1, PLAYERNAME, BRAND, 'Ball' as Equipment, model, NULL, NULL, NULL, NULL 
		from dbo.[ball] a 
			where PLAYERNAME = @PlayerName and a.[FIRST DAY] = @ThisPlayerMostRecentFirstDay --and model <> '-'
		union all

		select distinct 4, 0, 1, a.PLAYERNAME, a.BRAND, 'Iron' as Equipment, a.model, b.BRAND + ', ' + b.MODEL + ', ' + b.FLEX + ', ' + b.MATERIAL as Shaft,
			c.BRAND + ', ' + c.MODEL + ', ' + c.MATERIAL as Grip, a.[CLUB NUMBER] as ClubNumber, NULL as Loft
		from dbo.irons a 
		left outer join dbo.Shafts b on a.[CLUB NUMBER] = b.[CLUB NUMBER] and a.PLAYERNAME = b.PLAYERNAME and a.[FIRST DAY] = b.[FIRST DAY] and b.EQUIPMENT = 'IRON' and a.PKey = b.pkey
		left outer join dbo.Grips c on a.[CLUB NUMBER] = c.[CLUB NUMBER] and a.PLAYERNAME = c.PLAYERNAME and a.[FIRST DAY] = c.[FIRST DAY] and c.EQUIPMENT = 'IRON' and a.PKey = c.pkey
			where a.PLAYERNAME = @PlayerName and a.[FIRST DAY] = @ThisPlayerMostRecentFirstDay -- and a.model <> '-'
		union all
		
		select distinct 4, 0, 1, a.PLAYERNAME, a.BRAND, 'Wedge' as Equipment, a.model, b.BRAND + ', ' + b.MODEL + ', ' + b.FLEX + ', ' + b.MATERIAL as Shaft,
			c.BRAND + ', ' + c.MODEL + ', ' + c.MATERIAL as Grip, a.[CLUB NUMBER] as ClubNumber, a.SIZE as Loft
		from dbo.Wedges a 
		left outer join dbo.Shafts b on a.[CLUB NUMBER] = b.[CLUB NUMBER] and a.PLAYERNAME = b.PLAYERNAME and a.[FIRST DAY] = b.[FIRST DAY] and b.EQUIPMENT = 'WEDG' and a.PKey = b.pkey
		left outer join dbo.Grips c on a.[CLUB NUMBER] = c.[CLUB NUMBER] and a.PLAYERNAME = c.PLAYERNAME and a.[FIRST DAY] = c.[FIRST DAY] and c.EQUIPMENT = 'WEDG' and a.PKey = c.pkey
			where a.PLAYERNAME = @PlayerName and a.[FIRST DAY] = @ThisPlayerMostRecentFirstDay --and a.model <> '-'
		union all

		select distinct 4, 0, 1, a.PLAYERNAME, a.BRAND, 'Wood' as Equipment, a.model, b.BRAND + ', ' + b.MODEL + ', ' + b.FLEX + ', ' + b.MATERIAL as Shaft,
			c.BRAND + ', ' + c.MODEL + ', ' + c.MATERIAL as Grip, a.[CLUB NUMBER] as ClubNumber, a.SIZE as Loft
		from dbo.Woods a 
		left outer join dbo.Shafts b on a.[CLUB NUMBER] = b.[CLUB NUMBER] and a.PLAYERNAME = b.PLAYERNAME and a.[FIRST DAY] = b.[FIRST DAY] and b.EQUIPMENT = 'WOOD' and a.PKey = b.pkey
		left outer join dbo.Grips c on a.[CLUB NUMBER] = c.[CLUB NUMBER] and a.PLAYERNAME = c.PLAYERNAME and a.[FIRST DAY] = c.[FIRST DAY] and c.EQUIPMENT = 'WOOD' and a.PKey = c.pkey
			where a.PLAYERNAME = @PlayerName and a.[FIRST DAY] = @ThisPlayerMostRecentFirstDay -- and a.model <> '-'
		union all
		
		select distinct 4, 0, 1, a.PLAYERNAME, a.BRAND, 'Putter' as Equipment, a.model, b.BRAND + ', ' + b.MODEL + ', ' + b.FLEX + ', ' + b.MATERIAL as Shaft,
			c.BRAND + ', ' + c.MODEL + ', ' + c.MATERIAL as Grip, NULL, NULL
		from dbo.Putters a 
		left outer join dbo.Shafts b on a.PLAYERNAME = b.PLAYERNAME and a.[FIRST DAY] = b.[FIRST DAY] and b.EQUIPMENT = 'PUTT' and a.PKey = b.pkey
		left outer join dbo.Grips c on a.PLAYERNAME = c.PLAYERNAME and a.[FIRST DAY] = c.[FIRST DAY] and c.EQUIPMENT = 'PUTT' and a.PKey = c.pkey
			where a.PLAYERNAME = @PlayerName and a.[FIRST DAY] = @ThisPlayerMostRecentFirstDay -- and a.model <> '-'
		


		Insert into #Results (SelectionLevel, isOptIn, isCurrent, Player, Brand, Equipment)
		select 3 as SelectionLevel, 0 as isOptIn, 1 as isCurrent, @PlayerName, Brand, Equipment from (
			select distinct BRAND, Equipment from #Results union all
			select distinct BRAND, 'Glove' as Equipment from dbo.[Gloves] a where PLAYERNAME = @PlayerName and a.[FIRST DAY] = @ThisPlayerMostRecentFirstDay union all
			select distinct BRAND, 'Shoe' as Equipment from dbo.[Shoes] a where PLAYERNAME = @PlayerName and a.[FIRST DAY] = @ThisPlayerMostRecentFirstDay union all
			select distinct BRAND, 'Shirt' as Equipment from dbo.[Shirts] a where PLAYERNAME = @PlayerName and a.[FIRST DAY] = @ThisPlayerMostRecentFirstDay union all
			select distinct BRAND, 'Hat' as Equipment from dbo.[Headgear] a where PLAYERNAME = @PlayerName and a.[FIRST DAY] = @ThisPlayerMostRecentFirstDay union all
			select distinct BRAND, 'Bag' as Equipment from dbo.[bag] a where PLAYERNAME = @PlayerName and a.[FIRST DAY] = @ThisPlayerMostRecentFirstDay) a
		where not Brand in ('VARIOUS', 'COLLEGE AFFILIATION', 'NONE')

		Insert into #Results (SelectionLevel, isOptIn, isCurrent, Player, Brand)
		select distinct 2, 0, 1, Player, BRAND from #Results

		Insert into #Results (SelectionLevel, isOptIn, isCurrent, Player)
		select distinct 0, 0, 1, @PlayerName from #Results


--	end
;with cte_Sponsors as (select distinct Brand 
							from tv.TVAudit tv 
							where PlayerName = @PlayerName 
									and tv.TntFirstDay > dateadd(mm,-12,GETDATE())
									and caddie = 0
									and ReplayOther = 0
									and Equip in ('Shirt', 'Bag', 'Headgear', 'Towell')
									and not Brand in ('VARIOUS', 'COLLEGE AFFILIATION', 'NONE')
									and not exists (select distinct Brand from #Results r where r.brand = case when tv.brand ='FOOT JOY' then 'FOOTJOY' else tv.brand end))

insert into #Results (SelectionLevel, isOptIn, isCurrent, Player, Brand, Equipment, Model)
Select 1,0,1,@PlayerName,Brand,NULL,NULL from cte_Sponsors

Update #Results set brand = 'FOOTJOY' where Brand = 'FOOT JOY' 
--Update #Results set Player = 'KIM, TOM' where Player = 'KIM, JOO HYUNG'
--Update #Results set Player = 'FITZPATRICK, MATT' where Player = 'FITZPATRICK, MATTHEW'

Update optout.SelectionNew set Season = 0 where PlayerName = @PlayerName
--select * from #Results


select case when target.PlayerName = source.Player
	--and target.Season = @Season
	and coalesce(target.SelectionLevel, '') = coalesce(source.SelectionLevel, '')
	and coalesce(target.Brand, '') = coalesce(source.Brand, '')
	and coalesce(target.Equipment, '') = coalesce(source.Equipment, '')
	and coalesce(target.Model, '') = coalesce(source.Model, '')
	and coalesce(target.ClubNumber, '') = coalesce(source.ClubNumber, '')
	and coalesce(target.Loft, '') = coalesce(source.Loft, '') then 1 else 0 end as matched, *
from #Results source
full outer join optout.SelectionNew target
	on target.PlayerName = source.Player
	--and target.Season = @Season
	and coalesce(target.SelectionLevel, '') = coalesce(source.SelectionLevel, '')
	and coalesce(target.Brand, '') = coalesce(source.Brand, '')
	and coalesce(target.Equipment, '') = coalesce(source.Equipment, '')
	and coalesce(target.Model, '') = coalesce(source.Model, '')
	and coalesce(target.ClubNumber, '') = coalesce(source.ClubNumber, '')
	and coalesce(target.Loft, '') = coalesce(source.Loft, '')
where coalesce(target.playername, @PlayerName) = @PlayerName

	order by target.season desc, target.equipment, target.model


drop table #Results


end




-- select * from optout.selection
GO
