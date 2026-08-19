DROP FUNCTION IF EXISTS [CR_Reports].[hybrid_woods_shaft_func];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [CR_Reports].[hybrid_woods_shaft_func] 
(	
	@FIRSTDAY date,
	@SID int
)
RETURNS TABLE 
AS
RETURN 
(


SELECT a."Name" AS PLAYERNAME, CATEGORY, EXTRA,
b."Shaft Club Code" AS CLUBCODE, DCLUBCODE,
--woods
"Wood Brand Code" AS WOODBRAND, DWOODBRAND,
"Wood Model Code" AS WOODMODEL, DWOODMODEL,
"Wood Mat'l Code" AS WOODMATL, DWOODMATERIAL,
"Wood Size Code" AS WOODSIZE, DWOODSIZE,
--shafts
"Shaft Mfgr Code" AS SHAFTMFGR, DMFGRCODE,
"Shaft Brand Code" AS SHAFTBRAND, DBRANDCODE,
"Shaft Model Code" AS SHAFTMODEL, DMODELCODE,
"Shaft Mat'l Code" AS SHAFTMATL, DMATERIAL
FROM (

SELECT "PKey", "Name", "Survey ID", "First Day", [Wood Brand Code], DBRANDCODE AS DWOODBRAND, [Wood Model Code], DMODELCODE AS DWOODMODEL, [Wood Size Code], DSIZECODE AS DWOODSIZE, [Wood Mat'l Code], DMATERIAL AS DWOODMATERIAL
FROM Player_Master.[Wood Detail]
WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID AND [Wood Club Code] = 'HYB'
GROUP BY "PKey", "Name", "Survey ID", "First Day", [Wood Brand Code], DBRANDCODE, [Wood Model Code], DMODELCODE, [Wood Size Code], DSIZECODE, [Wood Mat'l Code], DMATERIAL) a 

LEFT OUTER JOIN
(SELECT *,
pkey - ((select MIN(pkey) FROM Player_Master.[Shaft Detail] WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID AND "Shaft Equip Type" = 'WOOD') - 
(select MIN(pkey) FROM Player_Master.[Wood Detail] WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID))
AS PKEYOFFSET
 FROM [Player_Master].[Shaft Detail] WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID AND "Shaft Club Code" = 'HYB') b
ON a.PKey = PKEYOFFSET and a.Name = b.name

LEFT OUTER JOIN Player_Master.PLAYERNAMES g on a."Name" = g.PLAYERNAME and a."Survey ID" = g.SID AND a."First Day" = g.FIRSTDAY 


)
GO
