DROP PROCEDURE IF EXISTS [dbo].[Taylor_QTR_report_No_Money];
GO

CREATE PROCEDURE [dbo].[Taylor_QTR_report_No_Money]
(@FirstDay as date,
 @LastDay as date)
AS
BEGIN

;with CTE_NameList as (select * from [Player_Master].[Company Players] where ContractYear = year(@FirstDay)),

CTE_EquipData as (
	select [TOUR], [Tournament Name], [FIRST DAY], [PLAYERNAME], [brand],'BALL' as Equip 
		from dbo.Ball 
		where dbo.Ball.[FIRST DAY] between @FirstDay and @LastDay
	union all
	select distinct [TOUR], [Tournament Name], [FIRST DAY], [PLAYERNAME], [brand],'IRON' as Equip 
		from dbo.Irons
		where dbo.Irons.[FIRST DAY] between @FirstDay and @LastDay and ISSET = 1
		group by [TOUR], [Tournament Name], [FIRST DAY], [PLAYERNAME], [brand]
	union all
	select [TOUR], [Tournament Name], [FIRST DAY], [PLAYERNAME], [brand],'DRIVER' as Equip 
		from dbo.WOODS
		where dbo.WOODS.[FIRST DAY] between @FirstDay and @LastDay 	and ISDRIVER = 1
	union all
	select [TOUR], [Tournament Name], [FIRST DAY], [PLAYERNAME], [brand],'SHOES' as Equip 
		from dbo.Shoes
		where dbo.Shoes.[FIRST DAY] between @FirstDay and @LastDay),

CTE_EquipDataFiltered as (select * 
							from CTE_EquipData eq
							inner join CTE_NameList cp
								on eq.PLAYERNAME = cp.PLAYER),

CTE_Tournaments	as (select 	tt.TYPE, 
							tt.[TOURNAMENT NAME], 
							tt.[FIRST DAY],
							case when LOCATION like '%, CA' or LOCATION like '%, CALIFORNIA' then 1 else 0 end as [State]
					from [DARRELL_MASTER].[Player_Master].[TOURNAMENTS_TABLE] tt
					where year([FIRST DAY]) = year(@FirstDay)),

CTE_Player as (select [PLAYERNAME] as [PLAYER NAME], 
						TOUR, 
						count([PLAYERNAME]) as YTD 
				from dbo.Ball b
				inner join CTE_NameList cp
				on b.PLAYERNAME = cp.PLAYER 
				where year(b.[FIRST DAY]) = year(@FirstDay)
				group by PLAYERNAME, tour) 						


SELECT eq.TOUR as [Tour Code]
      ,eq.[Tournament Name]
      ,eq.[FIRST DAY] as [First Date]
      ,ytd.[PLAYER NAME]
      ,ytd.YTD
  	  ,'1' as Rounds
      ,eq.BRAND
      ,eq.Equip
      ,ca.[State]
  
  FROM CTE_Player ytd
  Inner join CTE_EquipDataFiltered eq on ytd.[PLAYER NAME] = eq.PLAYERNAME and ytd.TOUR = eq.TOUR
  Inner join CTE_Tournaments ca on eq.[TOURNAMENT NAME] = ca.[TOURNAMENT NAME] and eq.[FIRST DAY] = ca.[FIRST DAY]

where ytd.TOUR in ('CLPGA', 'JLPGA','KGT', 'ONEASIA', 'AMATEUR', 'OTHER')


order by ytd.[PLAYER NAME]



    
END
GO
