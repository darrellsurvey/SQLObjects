DROP PROCEDURE IF EXISTS [MoneyBall].[Fill_WebsiteData4];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	Fill table MoneyBall.WebsiteData4
-- =============================================

CREATE procedure [MoneyBall].[Fill_WebsiteData4]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS
Begin -- WebsiteData4
Print 'Start WebsiteData4'

delete from MoneyBall.WebsiteData4 where PGASeason = @PGASeason and SportTourId = @SportTourId

insert into MoneyBall.WebsiteData4 (TournamentId, PGASeason, TournamentName, FirstDay, Equipment, BrandRank, Brand, TotalDS, DSM, SportTourId)

select tt.TournamentId, tt.pgaseason, tt.[TOURNAMENT NAME] as TournamentName, tt.[FIRST DAY] as FirstDay, tv.Equip as Equipment, 
RANK() over (partition by tt.TournamentId, Equip order by SUM(DSPoints) desc) as BrandRank,
Brand, SUM(DSPoints) as TotalDS, SUM(DSMoney) as DSM,@SportTourId
from tv.TVAudit tv inner join Player_Master.TOURNAMENTS_TABLE tt on tv.TournamentId = tt.TournamentId
--where TOUR = @Tour and tt.PGASeason = @PGASeason and tt.[FIRST DAY] < @LastFullTournamentEnd
where tt.PGASeason = @PGASeason and tt.[FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and TntNid in (26,351,353,355)))
group by tt.TournamentId, tt.PGASeason , tt.[Tournament Name], tt.[First Day], Brand, Equip

Print 'Finished WebsiteData4'; 
end  -- WebsiteData4
GO
