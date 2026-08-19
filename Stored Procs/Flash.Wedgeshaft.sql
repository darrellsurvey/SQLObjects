IF OBJECT_ID('Flash.Wedgeshaft') IS NOT NULL
    DROP PROCEDURE [Flash].[Wedgeshaft];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Flash].[Wedgeshaft]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


SELECT a.PLAYERNAME, CATEGORY, EXTRA, b.SHAFTCLUBCODE AS CLUBCODE, DCLUBCODE, ISNULL(e."Mfgr Abbrev", e."Mfgr Descr") AS MFGR, DMFGRCODE,
ISNULL(c."Mfgr Abbrev", c."Mfgr Descr") AS BRAND, DBRANDCODE, ISNULL(d."Model Abbrev", d."Model Descr") AS MODEL, DMODELCODE, ISNULL("Matl Abbrev", "Matl Descr") AS MATL, DMATLCODE 
FROM (

SELECT PLAYERNAME, SID, "First Day" FROM input.wedge WHERE "First Day" = @FIRSTDAY AND SID = @SID GROUP BY PLAYERNAME, SID, "First Day") a  
LEFT OUTER JOIN (SELECT * FROM input.shaft WHERE "First Day" = @FIRSTDAY AND SID = @SID AND SHAFTEQUIPTYPE = 'WEDG') b
ON a.PLAYERNAME = b.PLAYERNAME

--AND a."Wood Club Descr" = b."Wood Club Descr" AND a."Wood Brand Descr" = b."Wood Brand Descr" AND a."Wood Model Descr" = b."Wood Model Descr"
--AND a."Field01" = b."Field01" AND a."Wood Size Descr" = b."Wood Size Descr"

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] e ON b.SHAFTMFGR = e."Mfgr Descr"
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] c ON b.SHAFTBRAND = c."Mfgr Descr"
LEFT OUTER JOIN LKP.[Model Codes and Descr] d ON b.SHAFTMODEL = d."Model Descr"
LEFT OUTER JOIN LKP.[Material Codes and Descript] ON b.SHAFTMATL = "Matl Descr"
LEFT OUTER JOIN Player_Master.PLAYERNAMES g on a.PLAYERNAME = g.PLAYERNAME and a.SID = g.SID AND a."First Day" = g.FIRSTDAY 

--no where--these fields will be null for players with no hybrids
--WHERE b."First Day" = :FIRSTDAY AND b.SID = :SID
ORDER BY EXTRA, PLAYERNAME, b."PKey"


END
GO
