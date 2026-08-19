DROP PROCEDURE IF EXISTS [dbo].[CompaniesOverview];
GO

-- =============================================
-- Author:		Alex
-- Create date: 8/7/2019
-- Description:	DAWebsite: Companies Page / Overview tab
-- =============================================

CREATE PROCEDURE [dbo].[CompaniesOverview]
	@user varchar(100) = '',
	@company varchar(100) = '',
	@Brand varchar(100),
	@PGASeason int,
	@SportTourId tinyint

AS

--exec [dbo].[CompaniesOverview] 'nike', 'NIKE', 'NIKE', 2020, 1

BEGIN
SET NOCOUNT ON

declare @TVcost as money
select @TVcost = TVTimeCost from [MoneyBall].[WebsiteDataTVTimeCost] where PGASeason = @PGASeason and SportTourId = @SportTourId

SELECT d6.*, @TVcost*2*d6.DSPoints as DSMoney, Media.[MediaValue] AS [CompanyImage]
,isnull([DSPoints],0) - isnull([DSPointsYear1],0) as DSPointsDifference
,(isnull([DSPoints],0) - isnull([DSPointsYear1],0)) *100.0 / [DSPointsYear1] as DSPointsDifferencePercent
FROM moneyball.[WebsiteData6] AS d6
LEFT JOIN moneyball.[WebsiteMedia] AS media ON d6.[Brand] = media.[MediaKey]
WHERE [Brand] = @Brand AND [PGASeason] = @PGASeason and SportTourId = @SportTourId


END
GO
