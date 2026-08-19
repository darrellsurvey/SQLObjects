DROP PROCEDURE IF EXISTS [Flash].[Woods];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Flash].[Woods]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


SELECT e.PLAYERNAME, CATEGORY, EXTRA, CLUBCODE AS WOODCLUBCODE, DCLUBCODE,
ISNULL(a."Mfgr Abbrev", a."Mfgr Descr") AS WOODBRAND, DBRANDCODE,
ISNULL(b."Model Abbrev", b."Model Descr") AS WOODMODEL, DMODELCODE,
ISNULL(c."Size Abbrev", c."Size Descr") AS WOODSIZE, DSIZECODE,
ISNULL(d."Matl Abbrev", d."Matl Descr") AS WOODMATL, DMATERIAL

FROM input.wood e
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a ON BRAND = a."Mfgr Descr"
LEFT OUTER JOIN LKP.[Model Codes and Descr] b ON MODEL = b."Model Descr"
LEFT OUTER JOIN LKP.[Size Codes and Description] c ON SIZE = "Size Descr"
LEFT OUTER JOIN LKP.[Material Codes and Descript] d ON MATERIAL = "Matl Descr"
LEFT OUTER JOIN Player_Master.PLAYERNAMES g on e.PLAYERNAME = g.PLAYERNAME and e.SID = g.SID AND e."First Day" = g.FIRSTDAY 

WHERE "First Day" = @FIRSTDAY AND e.SID = @SID 
ORDER BY EXTRA, e.PLAYERNAME, e."PKey"


END
GO
