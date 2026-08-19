DROP PROCEDURE IF EXISTS [dbo].[Taylor_QTR_report];
GO

CREATE PROCEDURE [dbo].[Taylor_QTR_report]
(@FirstDay as date,
 @LastDay as date)
AS
BEGIN

;with CTE_NameList as (select * from [Player_Master].[Company Players] where ContractYear = year(@FirstDay)),

CTE_EquipData as (
	select [TournamentID], [PLAYERNAME], [brand],'BALL' as Equip 
		from dbo.Ball 
		where dbo.Ball.[FIRST DAY] between @FirstDay and @LastDay
	union all
	select distinct [TournamentID], [PLAYERNAME], [brand],'IRON' as Equip 
		from dbo.Irons
		where dbo.Irons.[FIRST DAY] between @FirstDay and @LastDay and ISSET = 1
		group by [TournamentID], [PLAYERNAME], [brand]
	union all
	select [TournamentID], [PLAYERNAME], [brand],'DRIVER' as Equip 
		from dbo.WOODS
		where dbo.WOODS.[FIRST DAY] between @FirstDay and @LastDay 	and ISDRIVER = 1
	union all
	select [TournamentID], [PLAYERNAME], [brand],'SHOES' as Equip 
		from dbo.Shoes
		where dbo.Shoes.[FIRST DAY] between @FirstDay and @LastDay),

CTE_EquipDataFiltered as (select * from CTE_EquipData eq
							inner join CTE_NameList cp on eq.PLAYERNAME = cp.PLAYER),

CTE_Tournaments	as (select mts.*, 
							tt.TYPE, 
							tt.[TOURNAMENT NAME], 
							tt.[FIRST DAY],
							case when LOCATION like '%, CA' or LOCATION like '%, CALIFORNIA' then 1 else 0 end as [State]
					from [DARRELL_MASTER].[Money].TourMoneyStats mts
					inner join [DARRELL_MASTER].[Player_Master].[TOURNAMENTS_TABLE] tt  
						on mts.TournamentId = tt.TournamentId
					inner join CTE_NameList cp
						on mts.[PLAYER NAME] = cp.PLAYER),
						
CTE_Player as (select [PLAYERNAME] as [PLAYER NAME], 
						TOUR, 
						count([PLAYERNAME]) as YTD 
				from dbo.Ball b
				inner join CTE_NameList cp
				on b.PLAYERNAME = cp.PLAYER 
				where year(b.[FIRST DAY]) = year(@FirstDay)
				group by PLAYERNAME, tour) 


SELECT mm.[TYPE] as [Tour Code]
      ,mm.[Tournament Name]
      ,mm.[FIRST DAY] as [First Date]
      ,ytd.[PLAYER NAME]
      --,ytd.tour
      ,ytd.YTD
      ,(case when isnull([Round 1], 0) > 0 then 1 else 0 end +
			case when isnull([Round 2], 0) > 0 then 1 else 0 end +
			case when isnull([Round 3], 0) > 0 then 1 else 0 end +
			case when isnull([Round 4], 0) > 0 then 1 else 0 end +
			case when isnull([Round 5], 0) > 0 then 1 else 0 end) as Rounds,
      eq.BRAND,
      eq.Equip,
      mm.State
  
  FROM CTE_Player ytd
  Inner join CTE_Tournaments mm on ytd.[PLAYER NAME] = mm.[PLAYER NAME] and ytd.TOUR = mm.[TYPE]
  Inner join CTE_EquipDataFiltered eq on mm.[PLAYER NAME] = eq.PLAYERNAME and mm.[TournamentID] = eq.[TournamentID]


order by ytd.[PLAYER NAME]
    
END
GO
