DROP PROCEDURE IF EXISTS [MoneyBall].[Fill_BrandDSRank];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 12/7/2016
-- Description:	Fill BrandDSRank Table
-- =============================================

CREATE procedure [MoneyBall].[Fill_BrandDSRank]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint
)
AS
begin

Delete from [MoneyBall].BrandDSRank where PGASeason = @PGASeason and SportTourId = @SportTourId


insert into [MoneyBall].BrandDSRank 
	(Brand
      ,PGASeason
      ,PGASeasonRank
      ,PGASeasonRankNoTie
      ,DSPoints
	  ,DSM
	  ,SportTourId)

select Brand, 
		PGASeason,
		RANK() over(partition by PGAseason order by SUM(DSPoints) desc) as rn,
		RANK() over(partition by PGAseason order by SUM(DSPoints) desc, brand asc) as rnnoties,
		round(SUM(DSPoints), 0),
		round(SUM(DSMoney), 0),
		@SportTourId
from tv.TVAudit 
where PGASeason = @PGASeason and not DSPoints is null and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and tntnid in (26,351,353,355)))
group by Brand, PGASeason


end
GO
