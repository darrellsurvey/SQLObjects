DROP PROCEDURE IF EXISTS [Billing].[Tours_CreateOnNewYear_sp];
GO

CREATE PROCEDURE Billing.Tours_CreateOnNewYear_sp
AS
BEGIN

  SET NOCOUNT ON 

  DECLARE @CurrentYear int 
  SET @CurrentYear = YEAR(GETDATE())

  INSERT INTO [LKP].[Tour]
             ([Year]
             ,[TourName]
             ,[TourMasterId]
             ,[DisplayOrder])
                
  SELECT @CurrentYear, 
         [TourName], 
         [TourMasterId],
         [DisplayOrder]
  FROM  [LKP].[TourMaster]
  WHERE [IsActive] = 1
  ORDER BY DisplayOrder 

END
GO
