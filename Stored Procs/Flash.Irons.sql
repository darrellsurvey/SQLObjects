IF OBJECT_ID('Flash.Irons') IS NOT NULL
    DROP PROCEDURE [Flash].[Irons];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Flash].[Irons]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


SELECT c.PLAYERNAME, CATEGORY, EXTRA, CLUBCODE, DCLUBCODE, ISNULL(a.[Mfgr Abbrev], a.[Mfgr Descr]) AS BRAND, DBRANDCODE,
ISNULL(b.[Model Abbrev], b.[Model Descr]) AS MODEL, DMODELCODE

FROM input.iron c
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a ON BRAND = a.[Mfgr Descr]
LEFT OUTER JOIN LKP.[Model Codes and Descr] b ON MODEL = b.[Model Descr]
LEFT OUTER JOIN Player_Master.PLAYERNAMES g on c.PLAYERNAME = g.PLAYERNAME and c.SID = g.SID AND c.[First Day] = g.FIRSTDAY 

WHERE [First Day] = @FIRSTDAY AND c.SID = @SID 

--GROUP BY [Name], CATEGORY, [Iron Club Code], a.[Mfgr Descr], b.[Model Descr]
ORDER BY EXTRA, c.PLAYERNAME ASC, c.PKey


END
GO
