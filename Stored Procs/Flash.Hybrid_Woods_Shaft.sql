IF OBJECT_ID('Flash.Hybrid_Woods_Shaft') IS NOT NULL
    DROP PROCEDURE [Flash].[Hybrid_Woods_Shaft];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Flash].[Hybrid_Woods_Shaft]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



SELECT a.PLAYERNAME, CATEGORY, EXTRA,
b.SHAFTCLUBCODE AS WOODCLUBCODE, DCLUBCODE,
--woods
ISNULL(h."Mfgr Abbrev", h."Mfgr Descr") AS WOODBRAND, DWOODBRAND,
i."Model Descr" AS WOODMODEL, DWOODMODEL,
ISNULL(j."Matl Abbrev", j."Matl Descr") AS WOODMATL, DWOODMATERIAL,
ISNULL(k."Size Abbrev", k."Size Descr") AS WOODSIZE, DWOODSIZE,
--shafts
ISNULL(e."Mfgr Abbrev", e."Mfgr Descr") AS SHAFTMFGR, DMFGRCODE,
ISNULL(c."Mfgr Abbrev", c."Mfgr Descr") AS SHAFTBRAND, DBRANDCODE,
d."Model Descr" AS SHAFTMODEL, DMODELCODE,
ISNULL(f."Matl Abbrev", f."Matl Descr") AS SHAFTMATL, DMATLCODE
FROM (

SELECT "PKey", PLAYERNAME, SID, "First Day", BRAND, DBRANDCODE AS DWOODBRAND, MODEL, DMODELCODE AS DWOODMODEL, SIZE, DSIZECODE AS DWOODSIZE, MATERIAL, DMATERIAL AS DWOODMATERIAL
FROM input.wood
WHERE "First Day" = @FIRSTDAY AND SID = @SID AND CLUBCODE = 'HYB'
GROUP BY "PKey", PLAYERNAME, SID, "First Day", BRAND, DBRANDCODE, MODEL, DMODELCODE, SIZE, DSIZECODE, MATERIAL, DMATERIAL) a 

LEFT OUTER JOIN
(SELECT *,
pkey - ((select MIN(pkey) FROM input.shaft WHERE "First Day" = @FIRSTDAY AND SID = @SID AND SHAFTEQUIPTYPE = 'WOOD') - 
(select MIN(pkey) FROM input.wood WHERE "First Day" = @FIRSTDAY AND SID = @SID))
AS PKEYOFFSET
 FROM input.shaft WHERE "First Day" = @FIRSTDAY AND SID = @SID AND SHAFTCLUBCODE = 'HYB') b
ON a.PKey = PKEYOFFSET and a.PLAYERNAME = b.PLAYERNAME

--AND a."Wood Club Code" = b."Wood Club Code" AND a."Wood Brand Code" = b."Wood Brand Code" AND a."Wood Model Code" = b."Wood Model Code"
--AND a."Field01" = b."Field01" AND a."Wood Size Code" = b."Wood Size Code"


--shaft joins
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] e ON SHAFTMFGR = e."Mfgr Descr"
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] c ON SHAFTBRAND = c."Mfgr Descr"
LEFT OUTER JOIN LKP.[Model Codes and Descr] d ON SHAFTMODEL = d."Model Descr"
LEFT OUTER JOIN LKP.[Material Codes and Descript] f ON SHAFTMATL = f."Matl Descr"
--wood joins
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] h ON BRAND = h."Mfgr Descr"
LEFT OUTER JOIN LKP.[Model Codes and Descr] i ON MODEL = i."Model Descr"
LEFT OUTER JOIN LKP.[Material Codes and Descript] j ON MATERIAL = j."Matl Descr"
LEFT OUTER JOIN LKP.[Size Codes and Description] k ON SIZE= k.[Size Descr] 

LEFT OUTER JOIN Player_Master.PLAYERNAMES g on a.PLAYERNAME = g.PLAYERNAME and a.SID = g.SID AND a."First Day" = g.FIRSTDAY 

--no where--these fields will be null for players with no hybrids
ORDER BY EXTRA, a.PLAYERNAME, b."PKey"


END



/*

execute CR_Reports.Hybrid_Woods_Shaft '4/8/2010', 26

*/
GO
