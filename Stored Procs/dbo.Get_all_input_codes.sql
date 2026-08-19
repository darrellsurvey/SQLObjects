IF OBJECT_ID('dbo.Get_all_input_codes') IS NOT NULL
    DROP PROCEDURE [dbo].[Get_all_input_codes];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_all_input_codes]
	-- Add the parameters for the stored procedure here

	
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT DISTINCT(a.CODES) FROM (

SELECT UPPER([Mfgr Code]) AS CODES FROM LKP.[Manufacturer Codes and Desc]  
UNION ALL
SELECT UPPER([Matl Code]) AS CODES FROM LKP.[Material Codes and Descript] 
UNION ALL
SELECT UPPER([Model Code]) AS CODES FROM LKP.[Model Codes and Descr] 
UNION ALL
SELECT UPPER([Type Code]) AS CODES FROM LKP.[Type Codes and Description] 
UNION ALL
SELECT UPPER([Size Code]) AS CODES FROM LKP.[Size Codes and Description] 

) a ORDER BY a.CODES ASC

END
GO
