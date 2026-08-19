IF OBJECT_ID('Flash.Utility_Ironshaft') IS NOT NULL
    DROP PROCEDURE [Flash].[Utility_Ironshaft];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Flash].[Utility_Ironshaft]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



SELECT a.PLAYERNAME, CATEGORY, EXTRA, b.SHAFTCLUBCODE AS IRONSHAFTCLUBCODE, DCLUBCODE, ISNULL(e."Mfgr Abbrev", e."Mfgr Descr") AS IRONSHAFTMFGR, DMFGRCODE,
ISNULL(c."Mfgr Abbrev", c."Mfgr Descr") AS IRONSHAFTBRAND, DBRANDCODE, ISNULL(d."Model Abbrev", d."Model Descr") AS IRONSHAFTMODEL, DMODELCODE, ISNULL("Matl Descr", "Matl Descr") AS IRONSHAFTMATL, DMATLCODE
FROM (

SELECT PLAYERNAME, SID, "First Day" FROM input.iron WHERE "First Day" = @FIRSTDAY AND SID = @SID GROUP BY PLAYERNAME, SID, "First Day") a  
LEFT OUTER JOIN (SELECT * FROM input.shaft WHERE "First Day" = @FIRSTDAY AND SID = @SID AND SHAFTCLUBCODE LIKE '%^%') b
ON a.PLAYERNAME = b.PLAYERNAME


LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] e ON b.SHAFTMFGR = e."Mfgr Descr"
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] c ON b.SHAFTBRAND = c."Mfgr Descr"
LEFT OUTER JOIN LKP.[Model Codes and Descr] d ON b.SHAFTMODEL = d."Model Descr"
LEFT OUTER JOIN LKP.[Material Codes and Descript] ON b.SHAFTMATL = "Matl Descr"
LEFT OUTER JOIN Player_Master.PLAYERNAMES g on a.PLAYERNAME = g.PLAYERNAME and a.SID = g.SID AND a."First Day" = g.FIRSTDAY 

--no where--these fields will be null for players with no hybrids
ORDER BY EXTRA, a.PLAYERNAME, b."PKey"


END
GO
