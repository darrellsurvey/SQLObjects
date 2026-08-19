DROP FUNCTION IF EXISTS [CR_Reports].[ironshaft_func];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [CR_Reports].[ironshaft_func] 
(	
	@FIRSTDAY date,
	@SID int
)
RETURNS TABLE 
AS
RETURN 
(

SELECT a."Name" AS PLAYERNAME, CATEGORY, EXTRA, b."Shaft Club Code" AS SHAFTCLUBCODE, DCLUBCODE,
"Shaft Mfgr Code" AS SHAFTMFGR, DMFGRCODE,
"Shaft Brand Code" AS SHAFTBRAND, DBRANDCODE,
"Shaft Model Code" AS SHAFTMODEL, DMODELCODE,
"Shaft Mat'l Code" AS SHAFTMATL, DMATERIAL
FROM (

SELECT "Name", "Survey ID", "First Day" FROM Player_Master.[Iron Detail] WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID GROUP BY "Name", "Survey ID", "First Day") a 
LEFT OUTER JOIN (SELECT * FROM Player_Master.[Shaft Detail] WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID AND "Shaft Equip Type" = 'IRON') b
ON a."Name" = b."Name"

LEFT OUTER JOIN Player_Master.PLAYERNAMES g on a."Name" = g.PLAYERNAME and a."Survey ID" = g.SID AND a."First Day" = g.FIRSTDAY 

)
GO
