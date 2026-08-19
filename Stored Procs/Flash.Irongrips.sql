DROP PROCEDURE IF EXISTS [Flash].[Irongrips];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Flash].[Irongrips]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


SELECT a.PLAYERNAME, CATEGORY, EXTRA, b.GRIPCLUBCODE AS IRONCLUBCODE, DCLUBCODE, 
--IRON info
ISNULL(f."Mfgr Abbrev", f."Mfgr Descr") AS IRONBRAND, a.DBRANDCODE AS DIRONBRAND,
h."Model Descr" AS IRONMODEL, a.DMODELCODE AS DIRONMODEL,
ISNULL(i."Matl Abbrev", i."Matl Descr") AS IRONMATL, a.DMATERIAL AS DIRONMATERIAL,
ISNULL(k."Size Abbrev", k."Size Descr") AS IRONSIZE, a.DSIZECODE AS DIRONSIZE,
--GRIP info
b.GRIPCLUBCODE AS GRIPCLUBCODE, DCLUBCODE, 
ISNULL(e."Mfgr Abbrev", e."Mfgr Descr") AS GRIPMFGR, DMFGRCODE,
ISNULL(c."Mfgr Abbrev", c."Mfgr Descr") AS GRIPBRAND, b.DBRANDCODE,
d."Model Descr" AS GRIPMODEL, b.DMODELCODE,
ISNULL(j."Matl Abbrev", j."Matl Descr") AS GRIPMATL, b.DMATERIAL

FROM (
SELECT "PKey", PLAYERNAME, SID, "First Day", BRAND, DBRANDCODE, MODEL, DMODELCODE, SIZE, DSIZECODE, MATERIAL, DMATERIAL
FROM input.IRON
WHERE "First Day" = @FIRSTDAY AND SID = @SID
GROUP BY "PKey", PLAYERNAME, SID, "First Day", BRAND, DBRANDCODE, MODEL, DMODELCODE, SIZE, DSIZECODE, MATERIAL, DMATERIAL) a


LEFT OUTER JOIN (SELECT *,
pkey - ((select MIN(pkey) FROM input.GRIP WHERE "First Day" = @FIRSTDAY AND SID = @SID AND GRIPEQUIPTYPE = 'IRON') - 
(select MIN(pkey) FROM input.IRON WHERE "First Day" = @FIRSTDAY AND SID = @SID))
AS PKEYOFFSET
FROM input.GRIP WHERE "First Day" = @FIRSTDAY AND SID = @SID AND GRIPEQUIPTYPE = 'IRON') b
ON a.PKey = PKEYOFFSET and a.PLAYERNAME = b.PLAYERNAME
--GRIP joins
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] e ON b.GRIPMFGR = e."Mfgr Descr"
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] c ON b.GRIPBRAND = c."Mfgr Descr"
LEFT OUTER JOIN LKP.[Model Codes and Descr] d ON b.GRIPMODEL = d."Model Descr"
LEFT OUTER JOIN LKP.[Material Codes and Descript] j ON b.GRIPMATL = j."Matl Descr"
--IRON joins
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] f ON a.BRAND = f."Mfgr Descr"
LEFT OUTER JOIN LKP.[Model Codes and Descr] h ON a.MODEL = h."Model Descr"
LEFT OUTER JOIN LKP.[Material Codes and Descript] i ON a.MATERIAL = i."Matl Descr"
LEFT OUTER JOIN LKP.[Size Codes and Description] k on a.SIZE = k.[Size Code]

LEFT OUTER JOIN Player_Master.PLAYERNAMES g on a.PLAYERNAME = g.PLAYERNAME and a.SID = g.SID AND a."First Day" = g.FIRSTDAY 


--no where--these fields will be null for players with no hybrids
ORDER BY EXTRA, a.PLAYERNAME, b."PKey"



END
GO
