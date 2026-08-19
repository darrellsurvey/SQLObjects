DROP PROCEDURE IF EXISTS [dbo].[Brand_All_Equip_Counts];
GO

CREATE PROCEDURE [dbo].[Brand_All_Equip_Counts]
(@FirstDay as date,
 @LastDay as date,
 @Brand as varchar(50),
 @Sex as varchar(1))
AS
BEGIN

select [TOUR]
	  ,[PLAYERNAME]
	  ,count([TOUR]) as [USAGE]
      ,BALL
      ,IRON
      ,[UTILITY IRON]
      ,WEDGE
      ,DRIVER
      ,FW
      ,HYBRID
      ,PUTTER
      ,GLOVE
      ,SHOES
      ,HEADGEAR
      ,BAG

from 
(SELECT ball.[TOUR]
      ,ball.[PLAYERNAME]
      ,ball.[TOURNAMENT NAME]
      ,ball.BALL as BALL
      ,Iron.IRON as IRON
      ,isnull(uiron.[UTILITY IRON], 0) as [UTILITY IRON]
      ,isnull(Wedge.WEDGE, 0) as WEDGE
      ,isnull(driver.DRIVER, 0) as DRIVER
      ,isnull(fw.FW, 0) as FW
      ,isnull(hyb.hyb, 0) as HYBRID
      ,put.PUTTER as PUTTER
      ,isnull(glove.glove, 0) as GLOVE
      ,isnull(Shoes.shoes, 0) as SHOES
      ,isnull(hg.HEADGEAR, 0) as HEADGEAR
      ,isnull(Bag.bag, 0) as BAG
  
  FROM   
(select [TOUR], [TOURNAMENT NAME], [TOURNAMENTID], [SID], [PLAYERNAME], [first DAY],
	case when BRAND in ('TITLEIST', 'FOOT JOY') then 1 else 0 end as 'BALL'
	from dbo.Ball
	where dbo.Ball.[FIRST DAY] between @FirstDay and @LastDay) ball
	
inner join
(SELECT [SID]
	  ,[PLAYERNAME]
      ,[SEX]
      ,[FIRSTDAY]
  FROM [DARRELL_MASTER].[Player_Master].[PLAYERNAMES]
  where SEX = @Sex) p
  on ball.PLAYERNAME = p.PLAYERNAME
	and ball.[FIRST DAY] = p.FIRSTDAY
	and ball.SID = p.SID
	
Left outer join

(select [TOUR], [TOURNAMENTID], [PLAYERNAME], 
	sum(case when BRAND in ('TITLEIST', 'FOOT JOY') AND [Club NUMBER] not like '%-%' then 1
		 when BRAND in ('TITLEIST', 'FOOT JOY') AND [Club NUMBER] like '%-%' 
			then cast(SUBSTRING([Club NUMBER],3,1) AS int) - cast(SUBSTRING([Club NUMBER],1,1) AS int) +1
		 else 0 
		 end) as 'IRON'
	from dbo.Irons
	where dbo.Irons.[FIRST DAY] between @FirstDay and @LastDay and ISSET = 1
	group by [TOUR], [TOURNAMENTID], [PLAYERNAME]) iron
on ball.tour = iron.tour and 
	ball.[TOURNAMENTID] = iron.[TOURNAMENTID] and
	ball.[playername] = iron.[playername]

Left outer join

(select [TOUR], [TOURNAMENTID], [PLAYERNAME], 
	sum(case when BRAND in ('TITLEIST', 'FOOT JOY') AND [Club NUMBER] not like '%-%' then 1
		 when BRAND in ('TITLEIST', 'FOOT JOY') AND [Club NUMBER] like '%-%' 
			then cast(SUBSTRING([Club NUMBER],3,1) AS int) - cast(SUBSTRING([Club NUMBER],1,1) AS int) +1
		 else 0 
		 end) as 'UTILITY IRON'
	from dbo.Irons
	where dbo.Irons.[FIRST DAY] between @FirstDay and @LastDay and [Club NUMBER] like '%^%'
	group by [TOUR], [TOURNAMENTID], [PLAYERNAME]) uiron
on ball.tour = uiron.tour and 
	ball.[TOURNAMENTID] = uiron.[TOURNAMENTID] and
	ball.[playername] = uiron.[playername]
	
Left outer join

(select [TOUR], [TOURNAMENTID], [PLAYERNAME], 
	sum(case when BRAND in ('TITLEIST', 'FOOT JOY') then 1 else 0 end) as 'WEDGE'
	from dbo.Wedges
	where dbo.Wedges.[FIRST DAY] between @FirstDay and @LastDay
	group by [TOUR], [TOURNAMENTID], [PLAYERNAME]) wedge
on ball.tour = Wedge.tour and 
	ball.[TOURNAMENTID] = Wedge.[TOURNAMENTID] and
	ball.[playername] = Wedge.[playername]

Left outer join

(select [TOUR], [TOURNAMENTID], [PLAYERNAME],
	sum(case when BRAND in ('TITLEIST', 'FOOT JOY') then 1 else 0 end) as 'DRIVER'
	from dbo.WOODS
	where dbo.WOODS.[FIRST DAY] between @FirstDay and @LastDay and ISDRIVER = 1
	group by [TOUR], [TOURNAMENTID], [PLAYERNAME]) driver
on ball.tour = Driver.tour and 
	ball.[TOURNAMENTID] = driver.[TOURNAMENTID] and
	ball.[playername] = driver.[playername]

Left outer join

(select [TOUR], [TOURNAMENTID], [PLAYERNAME],
	sum(case when BRAND in ('TITLEIST', 'FOOT JOY') then 1 else 0 end) as 'FW'
	from dbo.WOODS
	where dbo.WOODS.[FIRST DAY] between @FirstDay and @LastDay and 
		ISDRIVER = 0 and 
		[Club NUMBER] <> 'HYBRID'
	group by [TOUR], [TOURNAMENTID], [PLAYERNAME]) fw
on ball.tour = fw.tour and 
	ball.[TOURNAMENTID] = fw.[TOURNAMENTID] and
	ball.[playername] = fw.[playername]

Left outer join

(select [TOUR], [TOURNAMENTID], [PLAYERNAME],
	sum(case when BRAND in ('TITLEIST', 'FOOT JOY') then 1 else 0 end) as 'HYB'
	from dbo.WOODS
	where dbo.WOODS.[FIRST DAY] between @FirstDay and @LastDay and 
		ISDRIVER = 0 and 
		[Club NUMBER] = 'HYBRID'
	group by [TOUR], [TOURNAMENTID], [PLAYERNAME]) hyb
on ball.tour = hyb.tour and 
	ball.[TOURNAMENTID] = hyb.[TOURNAMENTID] and
	ball.[playername] = hyb.[playername]

Left outer join

(select [TOUR], [TOURNAMENTID], [PLAYERNAME],
	sum(case when BRAND in ('TITLEIST', 'FOOT JOY') then 1 else 0 end) as 'putter'
	from dbo.Putters
	where dbo.Putters.[FIRST DAY] between @FirstDay and @LastDay
	group by [TOUR], [TOURNAMENTID], [PLAYERNAME]) put
on ball.tour = put.tour and 
	ball.[TOURNAMENTID] = put.[TOURNAMENTID] and
	ball.[playername] = put.[playername]

Left outer join

(select [TOUR], [TOURNAMENTID], [PLAYERNAME], 
	case when BRAND in ('TITLEIST', 'FOOT JOY') then 1 else 0 end as 'GLOVE'
	from dbo.Gloves
	where dbo.Gloves.[FIRST DAY] between @FirstDay and @LastDay) glove
on ball.tour = glove.tour and 
	ball.[TOURNAMENTID] = glove.[TOURNAMENTID] and
	ball.[playername] = glove.[playername]

Left outer join

(select [TOUR], [TOURNAMENTID], [PLAYERNAME], 
	case when BRAND in ('TITLEIST', 'FOOT JOY') then 1 else 0 end as 'SHOES'
	from dbo.Shoes
	where dbo.Shoes.[FIRST DAY] between @FirstDay and @LastDay) Shoes
on ball.tour = Shoes.tour and 
	ball.[TOURNAMENTID] = Shoes.[TOURNAMENTID] and
	ball.[playername] = Shoes.[playername]
	
Left outer join

(select [TOUR], [TOURNAMENTID], [PLAYERNAME], 
	case when BRAND in ('TITLEIST', 'FOOT JOY') then 1 else 0 end as 'HEADGEAR'
	from dbo.Headgear
	where dbo.Headgear.[FIRST DAY] between @FirstDay and @LastDay) hg
on ball.tour = hg.tour and 
	ball.[TOURNAMENTID] = hg.[TOURNAMENTID] and
	ball.[playername] = hg.[playername]

Left outer join

(select [TOUR], [TOURNAMENTID], [PLAYERNAME], 
	case when BRAND in ('TITLEIST', 'FOOT JOY') then 1 else 0 end as 'BAG'
	from dbo.Bag
	where dbo.Bag.[FIRST DAY] between @FirstDay and @LastDay) Bag
on ball.tour = Bag.tour and 
	ball.[TOURNAMENTID] = Bag.[TOURNAMENTID] and
	ball.[playername] = Bag.[playername]

where glove.glove = 1 and Shoes.shoes = 1 and ball.ball = 1) Results



group by [TOUR]
	  ,[PLAYERNAME]
      ,BALL
      ,IRON
      ,[UTILITY IRON]
      ,WEDGE
      ,DRIVER
      ,FW
      ,HYBRID
      ,PUTTER
      ,GLOVE
      ,SHOES
      ,HEADGEAR
      ,BAG
order by PLAYERNAME


    
END
GO
