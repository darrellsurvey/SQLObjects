IF OBJECT_ID('Flash.Wood_Grips') IS NOT NULL
    DROP PROCEDURE [Flash].[Wood_Grips];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Flash].[Wood_Grips]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


SELECT a.PLAYERNAME, CATEGORY, EXTRA, b.GRIPCLUBCODE AS WOODCLUBCODE, DCLUBCODE, 
--WOOD info
ISNULL(f."Mfgr Abbrev", f."Mfgr Descr") AS WOODBRAND, a.DBRANDCODE AS DWOODBRAND,
h."Model Descr" AS WOODMODEL, a.DMODELCODE AS DWOODMODEL,
ISNULL(i."Matl Abbrev", i."Matl Descr") AS WOODMATL, a.DMATERIAL AS DWOODMATERIAL,
ISNULL(k."Size Abbrev", k."Size Descr") AS WOODSIZE, a.DSIZECODE AS DWOODSIZE,
--GRIP info
b.GRIPCLUBCODE AS GRIPCLUBCODE, DCLUBCODE, 
ISNULL(e."Mfgr Abbrev", e."Mfgr Descr") AS GRIPMFGR, DMFGRCODE,
ISNULL(c."Mfgr Abbrev", c."Mfgr Descr") AS GRIPBRAND, b.DBRANDCODE,
d."Model Descr" AS GRIPMODEL, b.DMODELCODE,
ISNULL(j."Matl Abbrev", j."Matl Descr") AS GRIPMATL, b.DMATERIAL

FROM (
SELECT "PKey", PLAYERNAME, SID, "First Day", BRAND, DBRANDCODE, MODEL, DMODELCODE, SIZE, DSIZECODE, MATERIAL, DMATERIAL
FROM input.WOOD
WHERE "First Day" = @FIRSTDAY AND SID = @SID
GROUP BY "PKey", PLAYERNAME, SID, "First Day", BRAND, DBRANDCODE, MODEL, DMODELCODE, SIZE, DSIZECODE, MATERIAL, DMATERIAL) a


LEFT OUTER JOIN (SELECT *,
pkey - ((select MIN(pkey) FROM input.GRIP WHERE "First Day" = @FIRSTDAY AND SID = @SID AND GRIPEQUIPTYPE = 'WOOD') - 
(select MIN(pkey) FROM input.WOOD WHERE "First Day" = @FIRSTDAY AND SID = @SID))
AS PKEYOFFSET
FROM input.GRIP WHERE "First Day" = @FIRSTDAY AND SID = @SID AND GRIPEQUIPTYPE = 'WOOD') b
ON a.PKey = PKEYOFFSET and a.PLAYERNAME = b.PLAYERNAME
--GRIP joins
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] e ON b.GRIPMFGR = e."Mfgr Descr"
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] c ON b.GRIPBRAND = c."Mfgr Descr"
LEFT OUTER JOIN LKP.[Model Codes and Descr] d ON b.GRIPMODEL = d."Model Descr"
LEFT OUTER JOIN LKP.[Material Codes and Descript] j ON b.GRIPMATL = j."Matl Descr"
--WOOD joins
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] f ON a.BRAND = f."Mfgr Descr"
LEFT OUTER JOIN LKP.[Model Codes and Descr] h ON a.MODEL = h."Model Descr"
LEFT OUTER JOIN LKP.[Material Codes and Descript] i ON a.MATERIAL = i."Matl Descr"
LEFT OUTER JOIN LKP.[Size Codes and Description] k on a.SIZE = k.[Size Code]

LEFT OUTER JOIN Player_Master.PLAYERNAMES g on a.PLAYERNAME = g.PLAYERNAME and a.SID = g.SID AND a."First Day" = g.FIRSTDAY 


--no where--these fields will be null for players with no hybrids
ORDER BY EXTRA, a.PLAYERNAME, b."PKey"


END
GO
