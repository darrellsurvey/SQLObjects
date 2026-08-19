DROP PROCEDURE IF EXISTS [MoneyBall].[Fill_AddNewWeek];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	Weekly new data update
-- =============================================

CREATE procedure [MoneyBall].[Fill_AddNewWeek]
(
	@Tour varchar(25),
	@SportTourId tinyint,
	@PGASeason integer,
	@PGASeasonNotFull int,
	@LastFullTournamentBegins date,
	@LastFullTournamentEnd date
)
AS
Begin

--exec [MoneyBall].[Fill_AddNewWeek] 'PGA', 1, 2026, 2026, '20260519', '20260531'
--exec [MoneyBall].[Fill_AddNewWeek] 'TGL', 61, 2026, 2026, '20260125', '20260127'
--exec [MoneyBall].[Fill_AddNewWeek] 'PGA', 58, 2026, 2026, '20260512', '20260524'
--exec [MoneyBall].[Fill_AddNewWeek] 'LIV', 56, 2025, 2025, '20250915', '20251030'

exec [MoneyBall].[Fill_PrepareAndCleanUp] @Tour, @PGASeason, @SportTourId; Print '1'   -- no money calc
exec [MoneyBall].[Fill_CalculateDSPoints] @Tour, @PGASeason, @SportTourId, @LastFullTournamentBegins; Print '2'  -- added money calc and add to TVAudit table



exec [MoneyBall].[Fill_BrandDSRank] @Tour, @PGASeason, @SportTourId; Print '3' --Money done
exec [MoneyBall].[Fill_PlayerDSRank] @Tour, @PGASeason, @SportTourId; Print '4' --Money done
exec [MoneyBall].[Fill_PlayerRank] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '5'
exec [MoneyBall].[Fill_PlayerDSPointsWithEstimate] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '6' -- added just DSM
exec [MoneyBall].[Fill_WebsiteData1] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '7' -- added just DSM
exec [MoneyBall].[Fill_WebsiteData2] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '8'  --1 line per tournament, event info, Zurich 2 winner fix-- added just DSM
exec [MoneyBall].[Fill_WebsiteData3] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '9'	-- added just DSM
exec [MoneyBall].[Fill_WebsiteData4] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '10' -- added just DSM
exec [MoneyBall].[Fill_WebsiteData4a] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '11' -- added just DSM
exec [MoneyBall].[Fill_WebsiteData5] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '12' -- added just DSM
exec [MoneyBall].[Fill_WebsiteDataPlayer1] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd, @PGASeasonNotFull; Print '13'  -- added just DSM
exec [MoneyBall].[Fill_WebsiteDataPlayer2] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '14'  -- added just DSM
exec [MoneyBall].[Fill_WebsiteDataPlayer3] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '15'  -- added just DSM
exec [MoneyBall].[Fill_WebsiteDataPlayer4] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '16'  -- added just DSM
exec [MoneyBall].[Fill_WebsiteDataPlayer4Caddie] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '17' -- added just DSM
exec [MoneyBall].[Fill_WebsiteDataPlayer5] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '18'
exec [MoneyBall].[Fill_WebsiteDataPlayer6] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '19'  -- added just DSM
exec [MoneyBall].[Fill_WebsiteDataPlayer7] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '20'  -- added just DSM
exec [MoneyBall].[Fill_WebsiteDataPlayer7Total] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '20.3'  -- added just DSM
exec [MoneyBall].[Fill_WebsiteDataPlayer7TotalNoReplays] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '20.6'  -- added just DSM
exec [MoneyBall].[Fill_WebsiteDataPlayer8] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '21'  -- added just DSM
exec [MoneyBall].[Fill_WebsiteDataPlayerTourEquipment] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '22'
exec [MoneyBall].[Fill_WebsiteData6] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd, @PGASeasonNotFull; Print '23' -- added just DSM
exec [MoneyBall].[Fill_WebsiteData7] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '24'
exec [MoneyBall].[Fill_WebsiteData7a] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '25'
exec [MoneyBall].[Fill_WebsiteData8] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '26'
exec [MoneyBall].[Fill_WebsiteData8a] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '27'
exec [MoneyBall].[Fill_WebsiteData9] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '28' -- buckets, probably obsolete
exec [MoneyBall].[Fill_WebsiteData10] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '29' -- buckets, probably obsolete
exec [MoneyBall].[Fill_WebsiteData11] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '30'  -- added just DSM
exec [MoneyBall].[Fill_WebsiteData12] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '31'  -- added just DSM
exec [MoneyBall].[Fill_WebsiteData13] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '32'  -- added just DSM
exec [MoneyBall].[Fill_WebsiteData14] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '33'   --this is the one with Executive report???
exec [MoneyBall].[Fill_WebsiteDataPlayer9] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '34'
exec [MoneyBall].[Fill_WebsiteDataPlayer9Caddie] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '35'
exec [MoneyBall].[Fill_WebsiteDataPlayer10] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '36' -- added just DSM
exec [MoneyBall].[Fill_WebsiteDataPlayer10Caddie] @Tour, @PGASeason, @SportTourId, @LastFullTournamentEnd; Print '37' -- added just DSM


begin tran
update [MoneyBall].[WebsiteData3] set brand = 'FOOTJOY' where brand = 'FOOT JOY'
update [MoneyBall].[WebsiteData4] set brand = 'FOOTJOY' where brand = 'FOOT JOY'
update [MoneyBall].[WebsiteData5] set brand = 'FOOTJOY' where brand = 'FOOT JOY'
update [MoneyBall].[WebsiteData6] set brand = 'FOOTJOY' where brand = 'FOOT JOY'
update [MoneyBall].[WebsiteData7] set brand = 'FOOTJOY' where brand = 'FOOT JOY'
update [MoneyBall].[WebsiteData8] set brand = 'FOOTJOY' where brand = 'FOOT JOY'
update [MoneyBall].[WebsiteData8a] set brand = 'FOOTJOY' where brand = 'FOOT JOY'
update [MoneyBall].[WebsiteData9] set brand = 'FOOTJOY' where brand = 'FOOT JOY'
update [MoneyBall].[WebsiteData10] set brand = 'FOOTJOY' where brand = 'FOOT JOY'
update [MoneyBall].[WebsiteData11] set brand = 'FOOTJOY' where brand = 'FOOT JOY'
update [MoneyBall].[WebsiteData12] set brand = 'FOOTJOY' where brand = 'FOOT JOY'
update [MoneyBall].[WebsiteData13] set brand = 'FOOTJOY' where brand = 'FOOT JOY'
update [MoneyBall].[WebsiteData14] set brand = 'FOOTJOY' where brand = 'FOOT JOY'
update [MoneyBall].[WebsiteDataPlayer4] set brand = 'FOOTJOY' where brand = 'FOOT JOY'
update [MoneyBall].[WebsiteDataPlayer9] set brand = 'FOOTJOY' where brand = 'FOOT JOY'
update [MoneyBall].[WebsiteDataPlayer9Caddie] set brand = 'FOOTJOY' where brand = 'FOOT JOY'
update [MoneyBall].[WebsiteDataPlayer10] set brand = 'FOOTJOY' where brand = 'FOOT JOY'
update [MoneyBall].[WebsiteDataPlayer10Caddie] set brand = 'FOOTJOY' where brand = 'FOOT JOY'
update [MoneyBall].[WebsiteDataPlayerTourEquipment] set brand = 'FOOTJOY' where brand = 'FOOT JOY'
commit tran


end  -- WebsiteDataPlayer10
GO
