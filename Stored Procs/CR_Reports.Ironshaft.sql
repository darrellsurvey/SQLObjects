DROP PROCEDURE IF EXISTS [CR_Reports].[Ironshaft];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CR_Reports].[Ironshaft]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


SELECT a."Name" AS PLAYERNAME, CATEGORY, EXTRA, b."Shaft Club Code" AS SHAFTCLUBCODE, DCLUBCODE,
ISNULL(e."Mfgr Abbrev", e."Mfgr Descr") AS SHAFTMFGR, DMFGRCODE,
ISNULL(c."Mfgr Abbrev", c."Mfgr Descr") AS SHAFTBRAND, DBRANDCODE,
ISNULL(d."Model Abbrev", d."Model Descr") AS SHAFTMODEL, DMODELCODE,
ISNULL(f."Matl Abbrev", f."Matl Descr") AS SHAFTMATL, DMATERIAL
FROM (

SELECT "Name", "Survey ID", "First Day" FROM Player_Master.[Iron Detail] WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID GROUP BY "Name", "Survey ID", "First Day") a 
LEFT OUTER JOIN (SELECT * FROM Player_Master.[Shaft Detail] WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID AND "Shaft Equip Type" = 'IRON') b
ON a."Name" = b."Name"

--AND a."Wood Club Code" = b."Wood Club Code" AND a."Wood Brand Code" = b."Wood Brand Code" AND a."Wood Model Code" = b."Wood Model Code"
--AND a."Field01" = b."Field01" AND a."Wood Size Code" = b."Wood Size Code"

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] e ON b."Shaft Mfgr Code" = e."Mfgr Code"
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] c ON b."Shaft Brand Code" = c."Mfgr Code"
LEFT OUTER JOIN LKP.[Model Codes and Descr] d ON b."Shaft Model Code" = d."Model Code"
LEFT OUTER JOIN LKP.[Material Codes and Descript] f ON b."Shaft Mat'l Code" = f."Matl Code"
LEFT OUTER JOIN Player_Master.PLAYERNAMES g on a."Name" = g.PLAYERNAME and a."Survey ID" = g.SID AND a."First Day" = g.FIRSTDAY 

--no where--these fields will be null for players with no hybrids
--WHERE b."First Day" = :FIRSTDAY AND b."Survey ID" = :SID
ORDER BY EXTRA, a."Name", b."PKey"


END
GO
