DROP PROCEDURE IF EXISTS [CR_Reports].[Hybrid_Woods];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CR_Reports].[Hybrid_Woods]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


SELECT a."Name" AS PLAYERNAME, CATEGORY, EXTRA, b."Wood Club Code" AS CLUBCODE, DCLUBCODE, ISNULL(c."Mfgr Abbrev", c."Mfgr Descr") AS HYBRIDBRAND, DBRANDCODE,
ISNULL(d."Model Abbrev", d."Model Descr") AS HYBRIDMODEL, DMODELCODE, ISNULL("Size Abbrev", "Size Descr") AS HYBRIDSIZE, DSIZECODE, ISNULL("Matl Abbrev", "Matl Descr") AS HYBRIDMATL, DMATERIAL
FROM (

SELECT "Name", "Survey ID", "First Day" FROM [Player_Master].[Wood Detail] WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID GROUP BY "Name", "Survey ID", "First Day") a 
LEFT OUTER JOIN (SELECT * FROM [Player_Master].[Wood Detail] WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID AND "Wood Club Code" = 'HYB') b
ON a."Name" = b."Name"

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] c ON "Wood Brand Code" = c."Mfgr Code"
LEFT OUTER JOIN LKP.[Model Codes and Descr] d ON "Wood Model Code" = d."Model Code"
LEFT OUTER JOIN LKP.[Size Codes and Description] e ON "Wood Size Code" = e."Size Code"
LEFT OUTER JOIN LKP.[Material Codes and Descript] f ON [Wood Mat'l Code] = f."Matl Code"
LEFT OUTER JOIN Player_Master.PLAYERNAMES g on a."Name" = g.PLAYERNAME and a."Survey ID" = g.SID AND a."First Day" = g.FIRSTDAY 

--no where--these fields will be null for players with no hybrids
ORDER BY EXTRA, a."Name", b."PKey"


END
GO
