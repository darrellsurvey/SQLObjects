DROP PROCEDURE IF EXISTS [MoneyBall].[Fill_PlayerDSPointsWithEstimate];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	Fill table MoneyBall.[PlayerDSPointsWithEstimate]
-- =============================================

CREATE procedure [MoneyBall].[Fill_PlayerDSPointsWithEstimate]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS
Begin -- PlayerDSPointsEstimate
Print 'Start PlayerDSPointsEstimate'

delete from [MoneyBall].[PlayerDSPointsWithEstimate] where PGASeason = @PGAseason and SportTourId = @SportTourId



;with cte_Final as (
select sum(SUM(DSPoints)) over(partition by Playername, PGASeason) as TotalPoints,
SUM(DSPoints) as DSPoints, SUM(DSMoney) as DSM,
PlayerName, Equip, Placement, PGASeason   
from TV.TVAudit 
--where [Caddie] = 0 and TOUR = @Tour and PGASeason between 2010 and 2016
--where [Caddie] = 0 and TOUR = @Tour and PGASeason = @PGAseason and not DSPoints is null
where [Caddie] = 0 and PGASeason = @PGAseason and not DSPoints is null and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and TntNid in (26,351,353,355)))
group by PlayerName, Equip, Placement, PGASeason 
),

 
cte_money as (
select [PLAYER NAME], [MoneyYTD], RANK() over(order by [MoneyYtd] desc) as rn, PGASeason from
(SELECT max([Money YTD]) as MoneyYTD, [PLAYER NAME], PGASeason 
FROM [DARRELL_MASTER].[money].TourMoneyStats ms INNER JOIN [DARRELL_MASTER].Player_Master.TOURNAMENTS_TABLE tt
ON ms.TournamentId = tt.TournamentId
--where [TYPE] = @Tour and PGASeason between 2010 and 2016 
--where [TYPE] = @Tour and PGASeason = @PGAseason and [FIRST DAY] < @LastFullTournamentEnd
where PGASeason = @PGAseason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and [TYPE] = @Tour) or (@Sporttourid = 58 and tt.[SID] in (26,351,353,355)))
group by [PLAYER NAME], PGASeason) a)


INSERT INTO [DARRELL_MASTER].[MoneyBall].[PlayerDSPointsWithEstimate]
           ([PlayerName]
           ,PGASeason 
           ,PGASeasonDSPoints
		   ,PGARank
		   ,MoneyYTD
           ,[Equipment]
           ,[Placement]
           ,[DSPoints]
		   ,DSM
           ,[DSPointsEstimate]
		   ,SportTourId)
select cte_Final.PlayerName, 
		cte_Final.PGAseason, 
		TotalPoints,
		rn, 
		MoneyYTD,
		Equip, 
		Placement, 
		cte_Final.DSPoints,DSM, 
		0,
		@SportTourId
from cte_Final
left outer join cte_money on cte_Final.PlayerName = cte_money.[PLAYER NAME] and cte_Final.PGASeason = cte_money.PGASeason  
--where not rn is null
order by rn, Equip, Placement  


--Estimate Part 2
Update [DARRELL_MASTER].[MoneyBall].[PlayerDSPointsWithEstimate] set [Placement] = 'Unspecified' where Placement is null
Update [DARRELL_MASTER].[MoneyBall].[PlayerDSPointsWithEstimate] set [Placement] = 'Unspecified' where Placement = ''

;with cte_Field as (select * from MoneyBall.PlayerDSPointsWithEstimate where PGASeason  = @PGASeason and SportTourId = @SportTourId),

cte_Constant as (
select Equipment, Placement, sum(DSPoints)*1.0 / 
	(select sum(DSPoints) 
	from cte_Field inse 
	where inse.Placement = 'Front' and inse.Equipment = 'Headgear' and PlayerName in 
					(select PlayerName from cte_Field intwo 
						where intwo.Placement = ee.Placement and intwo.Equipment = ee.Equipment)) as Constant
from cte_Field ee
group by Equipment, Placement)



INSERT INTO [DARRELL_MASTER].[MoneyBall].[PlayerDSPointsWithEstimate]
           ([PlayerName]
           ,PGASeason
           ,PGASeasonDSPoints
           ,[PGARank]
           ,[MoneyYTD]
           ,[Equipment]
           ,[Placement]
           ,[DSPoints]
           ,[DSPointsEstimate]
		   ,SportTourId)   
     select 
			[PlayerName]
           ,@PGASeason
           ,PGASeasonDSPoints
           ,[PGARank]
           ,[MoneyYTD]
           ,'Headgear'
           ,'Front'
           ,[DSPoints]
           ,1
		   ,@SportTourId
     from (
   
select PlayerName, e.Equipment, e.Placement, c.Constant, e.PGARank, e.PGASeasonDSPoints, e.MoneyYTD,
dspoints *1.0 / c.Constant as [DSPoints],
ROW_NUMBER() over(partition by PlayerName order by dspoints desc, c.Constant desc) as rn
from cte_Field e
inner join cte_Constant c on e.Equipment = c.Equipment and e.Placement = c.Placement 
where PlayerName not in (select PlayerName from cte_Field where Placement = 'Front' and Equipment = 'Headgear')
) a where a.rn = 1



--Estimate Part 3

;with cte_Field as (select e.PlayerName, e.PGASeason , e.PGASeasonDSPoints, e.PGARank, e.MoneyYTD, e.Equipment, isnull(Placement, 'Unspecified') as Placement, e.DSPoints    
					from MoneyBall.PlayerDSPointsWithEstimate e where PGASeason = @PGASeason and SportTourId = @SportTourId),

cte_Constant as (
select Equipment, Placement, sum(DSPoints)*1.0 / 
	(select sum(DSPoints) 
	from cte_Field inse 
	where inse.Placement = 'Front' and inse.Equipment = 'Headgear' and PlayerName in 
					(select PlayerName from cte_Field intwo 
						where intwo.Placement = ee.Placement and intwo.Equipment = ee.Equipment)) as Constant
from cte_Field ee
group by Equipment, Placement),


cte_names as (
select distinct PlayerName, c.Equipment, c.Placement, c.Constant, e.PGARank, e.PGASeasonDSPoints, e.MoneyYTD,
(select DSPoints from cte_Field insone
	where insone.PlayerName = e.PlayerName and insone.Placement = 'Front' and insone.Equipment = 'Headgear') as TotalHeadgearPoints
from cte_Field e
cross apply cte_Constant c),


cte_final as (
select n.*, cast(round(TotalHeadgearPoints * Constant,0) as integer) as DSPoints from cte_names n
left outer join 
	(select PlayerName, Equipment, Placement, DSPoints  
	from cte_Field) e
on e.PlayerName = n.PlayerName and e.Equipment = n.Equipment and e.Placement = n.Placement 
where DSPoints is null)




INSERT INTO [DARRELL_MASTER].[MoneyBall].[PlayerDSPointsWithEstimate]
           ([PlayerName]
           ,PGASeason 
           ,PGASeasonDSPoints
           ,[PGARank]
           ,[MoneyYTD]
           ,[Equipment]
           ,[Placement]
           ,[DSPoints]
           ,[DSPointsEstimate]
		   ,SportTourId)   
     select 
			[PlayerName]
           ,@PGASeason
           ,PGASeasonDSPoints
           ,[PGARank]
           ,[MoneyYTD]
           ,[Equipment]
           ,[Placement]
           ,[DSPoints]
           ,1
		   ,@SportTourId
     from cte_final
order by PlayerName 


end -- PlayerDSPointsEstimate
GO
