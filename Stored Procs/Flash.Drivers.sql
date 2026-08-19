IF OBJECT_ID('Flash.Drivers') IS NOT NULL
    DROP PROCEDURE [Flash].[Drivers];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Flash].[Drivers]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


SELECT c.PLAYERNAME, CATEGORY, EXTRA, CLUBCODE AS WOODCLUBCODE, DCLUBCODE, ISNULL(a."Mfgr Abbrev", a."Mfgr Descr") AS WOODBRAND, DBRANDCODE,
ISNULL(b."Model Abbrev", b."Model Descr") AS WOODMODEL, DMODELCODE, ISNULL(e."Size Abbrev", e."Size Descr") AS WOODSIZE, DSIZECODE, ISNULL(f."Matl Abbrev", f.[Matl Descr]) AS WOODMATL, DMATERIAL FROM
--min pkey offsets new vs old, in the new it's just where pkey = 1
Input.wood c
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a ON BRAND = a."Mfgr Descr"
LEFT OUTER JOIN LKP.[Model Codes and Descr] b ON MODEL = b."Model Descr"
LEFT OUTER JOIN LKP.[Size Codes and Description] e ON SIZE = e."Size Descr"
LEFT OUTER JOIN LKP.[Material Codes and Descript] f ON MATERIAL = f."Matl Descr"
LEFT OUTER JOIN Player_Master.PLAYERNAMES g on c.PLAYERNAME = g.PLAYERNAME and c.SID = g.SID AND c."First Day" = g.FIRSTDAY 
WHERE c."First Day" = @FIRSTDAY AND c.SID = @SID 
ORDER BY EXTRA, c.PLAYERNAME ASC


END
GO
