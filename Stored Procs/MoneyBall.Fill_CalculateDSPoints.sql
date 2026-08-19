IF OBJECT_ID('MoneyBall.Fill_CalculateDSPoints') IS NOT NULL
    DROP PROCEDURE [MoneyBall].[Fill_CalculateDSPoints];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 03/26/2025
-- Description:	Calculate DSPoints
-- =============================================

CREATE procedure [MoneyBall].[Fill_CalculateDSPoints]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@BeforeLastFullTournamentbegins date
)
AS
Begin 
Print 'Start Fill_CalculateDSPoints';


--exec [MoneyBall].[Fill_CalculateDSPoints] 'PGA', 2025, 1, '20250909'

----------------------------------------------
---- add PGA Seasons and TournamentID
----------------------------------------------

begin tran
update tv.tvaudit set PGASeason = @PGASeason where TntFirstDay > @beforeLastFullTournamentbegins and tour = @Tour
commit tran


----------------------------------------------------
----Update IsUsedInCalculation Flag
----------------------------------------------------


begin tran
update tv.tvaudit set IsUsedInCalculations = 0 where TOUR = @Tour and IsUsedInCalculations is null and TntFirstDay > @beforeLastFullTournamentbegins
commit tran


begin tran
;with CTE_SideHat as (SELECT rank() over (partition by playername, TVv.TntNid, tvv.RoundDate order by Sum([Duration]) desc) as RankNum,
						TVv.TntNid, tvv.RoundDate, tvv.Equip, TVv.brand, tvv.PlayerName, tvv.Placement 
			FROM [DARRELL_MASTER].[TV].[TVAudit] tvv 
			where tvv.TOUR = @Tour and Equip = 'Headgear' and Placement in ('Right Side', 'Left Side') and Caddie = 0 and TntFirstDay > @beforeLastFullTournamentbegins
			Group By TVv.TntNid, tvv.RoundDate,  tvv.Equip,tvv.Brand, tvv.PlayerName, Placement)


update tv set IsUsedInCalculations = 1 
from tv.tvaudit tv inner join CTE_SideHat zz on tv.TntNid = zz.TntNid and tv.RoundDate = zz.RoundDate and tv.Brand  = zz.Brand and
											 tv.Equip = zz.Equip and tv.PlayerName = zz.PlayerName and tv.Placement = zz.Placement
										     and Caddie = 0
where RankNum = 1
commit tran


begin tran
;with CTE_ShirtFront as (SELECT rank() over (partition by playername, TVv.TntNid, tvv.RoundDate order by Sum([Duration]) desc) as RankNum,
						TVv.TntNid, tvv.RoundDate, tvv.Equip, TVv.brand, tvv.PlayerName, tvv.Placement 
			FROM [DARRELL_MASTER].[TV].[TVAudit] tvv
			where tvv.TOUR = @Tour and	Equip = 'Shirt' and Placement = 'Front' and Caddie = 0 and TntFirstDay > @beforeLastFullTournamentbegins
			Group By TVv.TntNid, tvv.RoundDate, tvv.Equip,tvv.Brand, tvv.PlayerName, Placement)

update tv set IsUsedInCalculations = 1 
from tv.tvaudit tv inner join CTE_ShirtFront zz on tv.TntNid = zz.TntNid and tv.RoundDate = zz.RoundDate and tv.Brand  = zz.Brand and
											 tv.Equip = zz.Equip and tv.PlayerName = zz.PlayerName and tv.Placement = zz.Placement
										     and Caddie = 0
where RankNum = 1
commit tran



begin tran
;with CTE_ShirtSleeve as (SELECT rank() over (partition by playername, TVv.TntNid, tvv.RoundDate order by Sum([Duration]) desc) as RankNum,
						TVv.TntNid, tvv.RoundDate, tvv.Equip, TVv.brand, tvv.PlayerName, tvv.Placement 
			FROM [DARRELL_MASTER].[TV].[TVAudit] tvv
			where tvv.TOUR = @Tour and Equip = 'Shirt' and Placement = 'Sleeve' and Caddie = 0 and TntFirstDay > @beforeLastFullTournamentbegins
			Group By TVv.TntNid, tvv.RoundDate, tvv.Equip,tvv.Brand, tvv.PlayerName, Placement)

update tv set IsUsedInCalculations = 1 
from tv.tvaudit tv inner join CTE_ShirtSleeve zz on tv.TntNid = zz.TntNid and tv.RoundDate = zz.RoundDate and tv.Brand  = zz.Brand and
											 tv.Equip = zz.Equip and tv.PlayerName = zz.PlayerName and tv.Placement = zz.Placement
										     and Caddie = 0
where RankNum = 1			
commit tran



begin tran
update tv.tvaudit set IsUsedInCalculations = 1 where TOUR = @Tour and Equip = 'Headgear' and Placement in ('Front', 'Back') and Caddie = 0  and TntFirstDay > @beforeLastFullTournamentbegins
update tv.tvaudit set IsUsedInCalculations = 1 where TOUR = @Tour and Equip = 'Bag' and Placement = 'Body' and Caddie = 0  and TntFirstDay > @beforeLastFullTournamentbegins
commit tran


------------------------------------------------------
--Update DSPoints
------------------------------------------------------



--;with cte1 as (
--select tvauditid, sum((ROUND(duration,1) * (AverageMinutes / MinutesOfPlay2) * N.ReachProj) / 60) as DSPoints
--from tv.TVAudit a inner join [TV].[Nielsen] n
--on a.tournamentid = n.TournamentId and a.RoundDate = n.RoundDate and n.IsUsedInCalculations = 1
--where TntFirstDay > @beforeLastFullTournamentbegins and DSPoints is null
--group by tvauditid)

;with cte1 as (
select tvauditid, ROUND(duration,1) * NielsenCoefficient / 60 as DSPoints, (ROUND(duration,1) * NielsenCoefficient / 60) * 2.0 * n.AdCost as DSMoney, AdCostEstimate
from tv.TVAudit a inner join [TV].[Nielsen] n
on a.tournamentid = n.TournamentId and a.RoundDate = n.RoundDate and n.IsUsedInCalculations = 1
where TntFirstDay > @beforeLastFullTournamentbegins and DSPoints is null)

update tv
set DSPoints = cte1.DSPoints,
	DSMoney = cte1.DSMoney,
	DSMoneyIsEstimate = AdCostEstimate
from tv.TVAudit tv inner join cte1 on tv.TVAuditId = cte1.TVAuditId 



--find missing dspoints

--select COUNT(*), TntName, TournamentId, TntFirstDay, RoundDate, DATEPART(dw,RoundDate)  from tv.TVAudit 
--where DSPoints is null and TOUR = @Tour and RoundDate > '20060101'
--group by TntName, TournamentId, TntFirstDay, RoundDate , DATEPART(dw,RoundDate) 
--order by TntFirstDay 


Print 'Finished Fill_CalculateDSPoints'; 
end
GO
