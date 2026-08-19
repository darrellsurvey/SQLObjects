DROP PROCEDURE IF EXISTS [dbo].[Brand_SeriesList];
GO

-- =============================================
-- Author:		Colin
-- Create date: 12-1-2011
-- Description:	Retrieves a list of all model and corresponding series designations for a given brand
-- =============================================
CREATE PROCEDURE [dbo].[Brand_SeriesList] 
	-- Add the parameters for the stored procedure here
	@Brand nvarchar(50) = ''
	 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 

		a.[Model Code],
		a.[INDEX],
		b.[Type]
      ,[Model Descr]
      ,COALESCE([Model Lvl1], ' ') AS 'Series'
    
  FROM [DARRELL_MASTER].[LKP].[Model Codes and Descr] a
  INNER JOIN [DARRELL_MASTER].dbo.Brand_Model_List b ON a.[Model Code] = b.[Model Code]
  INNER JOIN [DARRELL_MASTER].LKP.[Manufacturer Codes and Desc] c ON b.[Brand Code] = c.[Mfgr Code]
  
  WHERE c.[Mfgr Descr]= @brand AND a.[active_flag] = 1 AND a.[Model Code] <> '-' 
  ORDER BY [type], [Model Descr]
END
GO
