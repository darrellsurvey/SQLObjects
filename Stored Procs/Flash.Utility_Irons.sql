IF OBJECT_ID('Flash.Utility_Irons') IS NOT NULL
    DROP PROCEDURE [Flash].[Utility_Irons];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Flash].[Utility_Irons]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



SELECT a.PLAYERNAME, CATEGORY, EXTRA, b.CLUBCODE AS IRONCLUBCODE, DCLUBCODE AS DIRONCLUBCODE, ISNULL(c."Mfgr Abbrev", c."Mfgr Descr") AS IRONBRAND, DBRANDCODE AS DIRONBRANDCODE,
ISNULL(d."Model Abbrev", d."Model Descr") AS IRONMODEL, DMODELCODE AS DIRONMODELCODE

FROM (

SELECT PLAYERNAME, SID, "First Day" FROM input.iron WHERE "First Day" = @FIRSTDAY AND SID = @SID GROUP BY PLAYERNAME, SID, "First Day") a  
LEFT OUTER JOIN (SELECT * FROM input.iron WHERE "First Day" = @FIRSTDAY AND SID = @SID AND CLUBCODE LIKE '%^%') b
ON a.PLAYERNAME = b.PLAYERNAME

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] c ON b.BRAND = c."Mfgr Descr"
LEFT OUTER JOIN LKP.[Model Codes and Descr] d ON b.MODEL = d."Model Descr"
LEFT OUTER JOIN Player_Master.PLAYERNAMES g on a.PLAYERNAME = g.PLAYERNAME and a.SID = g.SID AND a."First Day" = g.FIRSTDAY 

--no where--these fields will be null for players with no hybrids
ORDER BY EXTRA, a.PLAYERNAME, b."PKey"


END
GO
