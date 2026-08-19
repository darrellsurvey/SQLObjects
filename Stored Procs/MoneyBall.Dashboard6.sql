IF OBJECT_ID('MoneyBall.Dashboard6') IS NOT NULL
    DROP PROCEDURE [MoneyBall].[Dashboard6];
GO

CREATE procedure [MoneyBall].[Dashboard6]
@Company varchar(40),
@PGASeason integer,
@SportTourId integer

as
begin

set nocount on;

--EXEC [MoneyBall].[Dashboard6] 'NIKE', 2022, 1

SELECT [Equipment]
      ,[Brand]
      ,[BrandEquipmentRank]
      ,[BrandEquipmentTotal]
      ,[BrandEquipmentPercent]
  FROM [darrell_master].[MoneyBall].[WebsiteData8A]
  where PGASeason = @PGASeason and SportTourId = @SportTourId
  

end
GO
