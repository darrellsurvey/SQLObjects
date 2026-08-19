DROP PROCEDURE IF EXISTS [CR_Reports].[Drivers];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CR_Reports].[Drivers]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


SELECT c."Name" AS PLAYERNAME, CATEGORY, EXTRA, "Wood Club Code" AS WOODCLUBCODE, DCLUBCODE, ISNULL(a."Mfgr Abbrev", a."Mfgr Descr") AS WOODBRAND, DBRANDCODE,
ISNULL(b."Model Abbrev", b."Model Descr") AS WOODMODEL, DMODELCODE, ISNULL(e."Size Abbrev", e."Size Descr") AS WOODSIZE, DSIZECODE, ISNULL(f."Matl Abbrev", f.[Matl Descr]) AS WOODMATL, DMATERIAL FROM
--min pkey offsets new vs old, in the new it's just where pkey = 1
(SELECT "Name", MIN("PKey") AS PKEY , "Survey ID", "First Day" FROM [Player_Master].[Wood Detail] WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID GROUP BY "Name", "Survey ID", "First Day") c
LEFT OUTER JOIN
(SELECT * FROM [Player_Master].[Wood Detail] WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID) d
ON c.PKEY = d."PKey" AND c."Name" = d."Name"
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a ON "Wood Brand Code" = a."Mfgr Code"
LEFT OUTER JOIN LKP.[Model Codes and Descr] b ON "Wood Model Code" = b."Model Code"
LEFT OUTER JOIN LKP.[Size Codes and Description] e ON "Wood Size Code" = e."Size Code"
LEFT OUTER JOIN LKP.[Material Codes and Descript] f ON [Wood Mat'l Code] = f."Matl Code"
LEFT OUTER JOIN Player_Master.PLAYERNAMES g on c."Name" = g.PLAYERNAME and c."Survey ID" = g.SID AND c."First Day" = g.FIRSTDAY 
WHERE c."First Day" = @FIRSTDAY AND c."Survey ID" = @SID 
ORDER BY EXTRA, c."Name" ASC


END
GO
