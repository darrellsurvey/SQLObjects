DROP PROCEDURE IF EXISTS [OptOut].[Selection_GetNew_WithCompanyLoginOption];
GO

Create procedure [OptOut].[Selection_GetNew_WithCompanyLoginOption]
@user varchar(100),
@PlayerName varchar(100), 
@Season integer,
@Company varchar(50)

as
begin
SET NOCOUNT ON
--  exec [OptOut].[Selection_GetNew] 'alex', 'mcilroy, rory', 2025, NULL
--  exec [OptOut].[Selection_GetNew] 'alex', 'KIM, TOM', 2025, 'TITLEIST'

if @PlayerName = 'KIM, TOM' set @PlayerName = 'KIM, JOO HYUNG'
if @PlayerName = 'FITZPATRICK, MATT' set @PlayerName = 'FITZPATRICK, MATTHEW'


if @Company is NULL
	begin
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

		MERGE INTO optout.SelectionNew as target
		using #Results as source
			on target.PlayerName = source.Player
			--and target.Season = @Season
			and coalesce(target.SelectionLevel, '') = coalesce(source.SelectionLevel, '')
			and coalesce(target.Brand, '') = coalesce(source.Brand, '')
			and coalesce(target.Equipment, '') = coalesce(source.Equipment, '')
			and coalesce(target.Model, '') = coalesce(source.Model, '')
			and coalesce(target.ClubNumber, '') = coalesce(source.ClubNumber, '')
			and coalesce(target.Loft, '') = coalesce(source.Loft, '')
		when not matched by target then
			insert (SelectionLevel,isOptIn,isOptIn_shaft, isOptIn_grip,PlayerName,Season,Brand,Equipment,Model,Shaft,Grip,ClubNumber,Loft,SetByUserId, SetBy)
			values (SelectionLevel,isOptIn,isOptIn_shaft, isOptIn_grip,Player,1900,Brand,Equipment,Model,Shaft,Grip,ClubNumber,Loft,0, 'U')
		when matched then
			update set Season = 1900;
		
		MERGE INTO optout.SelectionNew as target
		using (select * from #Results where not Shaft is NULL) as source
			on target.PlayerName = source.Player
			and coalesce(target.SelectionLevel, '') = coalesce(source.SelectionLevel, '')
			and coalesce(target.Brand, '') = coalesce(source.Brand, '')
			and coalesce(target.Equipment, '') = coalesce(source.Equipment, '')
			and coalesce(target.Model, '') = coalesce(source.Model, '')
			and coalesce(target.ClubNumber, '') = coalesce(source.ClubNumber, '')
			and coalesce(target.Loft, '') = coalesce(source.Loft, '')
			and coalesce(target.Shaft, '') <> coalesce(source.Shaft, '')
		when matched then
			Update set Shaft = source.shaft;

		MERGE INTO optout.SelectionNew as target
		using (select * from #Results where not Grip is NULL) as source
			on target.PlayerName = source.Player
			and coalesce(target.SelectionLevel, '') = coalesce(source.SelectionLevel, '')
			and coalesce(target.Brand, '') = coalesce(source.Brand, '')
			and coalesce(target.Equipment, '') = coalesce(source.Equipment, '')
			and coalesce(target.Model, '') = coalesce(source.Model, '')
			and coalesce(target.ClubNumber, '') = coalesce(source.ClubNumber, '')
			and coalesce(target.Loft, '') = coalesce(source.Loft, '')
			and coalesce(target.Shaft, '') <> coalesce(source.Shaft, '')
		when matched then
			Update set Grip = source.Grip;


		select SelectionId, SelectionLevel, isOptIn,isOptIn_shaft, isOptIn_grip, 
		case PlayerName 
			when 'KIM, JOO HYUNG' then 'KIM, TOM'
			when 'FITZPATRICK, MATTHEW' then 'FITZPATRICK, MATT'
			else PlayerName end as PlayerName, 
		Brand, Equipment, Model, Shaft, Grip, ClubNumber, Loft,
		ShopifyId, default_link_url, player_link_url, coalesce(SetByUserId, 0) as SetByUserId, coalesce(SetBy, 'U') as SetBy, AddedOn 
		from optout.SelectionNew where PLAYERNAME = @PlayerName and Season > 0
		order by case when selectionlevel < 2 then selectionlevel else 999 end, Brand, Equipment, ClubNumber, model, Loft

		drop table #Results

	end


else
	begin
		IF OBJECT_ID('tempdb..#Results1') IS NOT NULL
		DROP TABLE #Results1		

		CREATE TABLE #Results1 (SelectionId integer, Player varchar(100))

		insert into #Results1 (SelectionId, Player)
		select s.SelectionId, s.PlayerName from [OptOut].[SelectionNew] s Inner join  
			(SELECT distinct [PlayerName], SelectionLevel, brand 
					FROM [DARRELL_MASTER].[OptOut].[SelectionNew] 
					where brand = @Company and model is null and isOptIn = 1 and Season > 0 and SelectionLevel = 1) z
			on s.PlayerName = z.PlayerName and s.SelectionLevel = z.SelectionLevel and s.Brand = z.Brand

		insert into #Results1 (SelectionId, Player)
		select s.SelectionId, s.PlayerName from [OptOut].[SelectionNew] s Inner join  
			(SELECT distinct [PlayerName], SelectionLevel, brand 
					FROM [DARRELL_MASTER].[OptOut].[SelectionNew] 
					where brand = @Company and model is null and isOptIn = 1 and Season > 0 and SelectionLevel = 2) z
			on s.PlayerName = z.PlayerName and s.SelectionLevel >= z.SelectionLevel and s.Brand = z.Brand



		insert into #Results1 (SelectionId, Player)
		select s.SelectionId, s.PlayerName from [OptOut].[SelectionNew] s Inner join  
			(SELECT distinct [PlayerName], SelectionLevel, brand, Equipment 
					FROM [DARRELL_MASTER].[OptOut].[SelectionNew] 
					where brand = @Company and model is null and isOptIn = 1 and Season > 0 and SelectionLevel = 3) z
			on s.PlayerName = z.PlayerName and s.SelectionLevel >= z.SelectionLevel and s.Brand = z.Brand and s.Equipment = z.Equipment
		where s.PlayerName not in (select Distinct Player from #Results1)

		select s.SelectionId, SelectionLevel, isOptIn,isOptIn_shaft, isOptIn_grip, PlayerName, Brand, Equipment, Model, Shaft, Grip, ClubNumber, Loft, ShopifyId, default_link_url, player_link_url, SetByUserId, SetBy, AddedOn 
		from [OptOut].[SelectionNew] s inner join #Results1 r on s.SelectionId = r.SelectionId
		where Season > 0
		order by PlayerName, case when selectionlevel < 2 then selectionlevel else 999 end, Brand, Equipment, ClubNumber, model, Loft
	
		drop table #Results1

	end






end




-- select * from optout.selection
GO
