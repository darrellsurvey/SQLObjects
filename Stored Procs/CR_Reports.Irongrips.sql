DROP PROCEDURE IF EXISTS [CR_Reports].[Irongrips];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CR_Reports].[Irongrips]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



SELECT a."Name" AS PLAYERNAME, CATEGORY, EXTRA, b."Grip Club Code" AS CLUBCODE, DCLUBCODE, ISNULL(e."Mfgr Abbrev", e."Mfgr Descr") AS GRIPMFGR, DMFGRCODE,
ISNULL(c."Mfgr Abbrev", c."Mfgr Descr") AS GRIPBRAND, DBRANDCODE, ISNULL(d."Model Abbrev", d."Model Descr") AS GRIPMODEL, DMODELCODE, ISNULL("Matl Abbrev", "Matl Descr") AS GRIPMATL, DMATERIAL
FROM (

SELECT "Name", "Survey ID", "First Day" FROM Player_Master.[Iron Detail] WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID GROUP BY "Name", "Survey ID", "First Day") a  
LEFT OUTER JOIN (SELECT * FROM Player_Master.[Grip Detail] WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID AND "Grip Equip Type" = 'IRON') b
ON a."Name" = b."Name"

--AND a."Wood Club Code" = b."Wood Club Code" AND a."Wood Brand Code" = b."Wood Brand Code" AND a."Wood Model Code" = b."Wood Model Code"
--AND a."Field01" = b."Field01" AND a."Wood Size Code" = b."Wood Size Code"

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] e ON "Grip Brand Code" = e."Mfgr Code"
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] c ON "Grip Brand Code" = c."Mfgr Code"
LEFT OUTER JOIN LKP.[Model Codes and Descr] d ON "Grip Model Code" = d."Model Code"
LEFT OUTER JOIN LKP.[Material Codes and Descript] f ON "Grip Mat'l Code" = f."Matl Code"
LEFT OUTER JOIN Player_Master.PLAYERNAMES g on a."Name" = g.PLAYERNAME and a."Survey ID" = g.SID AND a."First Day" = g.FIRSTDAY 

--no where--these fields will be null for players with no hybrids
--WHERE b."First Day" = :FIRSTDAY AND b."Survey ID" = :SID
ORDER BY EXTRA, a."Name", b."PKey"


END
GO
