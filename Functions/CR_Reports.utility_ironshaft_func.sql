IF OBJECT_ID('CR_Reports.utility_ironshaft_func') IS NOT NULL
    DROP FUNCTION [CR_Reports].[utility_ironshaft_func];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [CR_Reports].[utility_ironshaft_func] 
(	
	@FIRSTDAY date,
	@SID int
)
RETURNS TABLE 
AS
RETURN 
(


SELECT a."Name" AS PLAYERNAME, CATEGORY, EXTRA, b."Shaft Club Code" AS IRONSHAFTCLUBCODE, DCLUBCODE, "Shaft Mfgr Code" AS IRONSHAFTMFGR, DMFGRCODE,
"Shaft Brand Code" AS IRONSHAFTBRAND, DBRANDCODE, "Shaft Model Code" AS IRONSHAFTMODEL, DMODELCODE, "Shaft Mat'l Code" AS IRONSHAFTMATL, DMATERIAL
FROM (

SELECT "Name", "Survey ID", "First Day" FROM Player_Master.[Iron Detail] WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID GROUP BY "Name", "Survey ID", "First Day") a  
LEFT OUTER JOIN (SELECT * FROM Player_Master.[Shaft Detail] WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID AND "Shaft Club Code" LIKE '%^%') b
ON a."Name" = b."Name"

LEFT OUTER JOIN Player_Master.PLAYERNAMES g on a."Name" = g.PLAYERNAME and a."Survey ID" = g.SID AND a."First Day" = g.FIRSTDAY 




)
GO
