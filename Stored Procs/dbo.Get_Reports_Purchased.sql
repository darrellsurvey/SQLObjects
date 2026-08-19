IF OBJECT_ID('dbo.Get_Reports_Purchased') IS NOT NULL
    DROP PROCEDURE [dbo].[Get_Reports_Purchased];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_Reports_Purchased]
	-- Add the parameters for the stored procedure here
	@COMPANY varchar(50)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	

SELECT 
[type] AS [Tour], 
YEAR([First Day]) AS [Year],
      ([Tournament Name] + ' - ' + CONVERT(VARCHAR(10), [First Day], 101)) AS Tournament
      , [Report Name] AS [Report Name]
      , Rep_ID
  FROM [DARRELL_MASTER].[Billing].[AllOrdersYTD]
  WHERE Company = @COMPANY
  GROUP BY 
[type],
YEAR([First Day]),
([Tournament Name] + ' - ' + CONVERT(VARCHAR(10), [First Day], 101))
,[Report Name]
, Rep_ID
      ORDER BY YEAR([First Day]), [type], ([Tournament Name] + ' - ' + CONVERT(VARCHAR(10), [First Day], 101))
      , [Report Name] ASC
END
GO
