DROP FUNCTION IF EXISTS [CR_Reports].[irongrips_func];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [CR_Reports].[irongrips_func] 
(	
	@FIRSTDAY date,
	@SID int
)
RETURNS TABLE 
AS
RETURN 
(


SELECT a."Name" AS PLAYERNAME, CATEGORY, EXTRA, b."Grip Club Code" AS CLUBCODE, DCLUBCODE, "Grip Mfgr Code" AS GRIPMFGR, DMFGRCODE,
"Grip Brand Code" AS GRIPBRAND, DBRANDCODE, "Grip Model Code" AS GRIPMODEL, DMODELCODE, "Grip Mat'l Code" AS GRIPMATL, DMATERIAL
FROM (

SELECT "Name", "Survey ID", "First Day" FROM Player_Master.[Iron Detail] WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID GROUP BY "Name", "Survey ID", "First Day") a  
LEFT OUTER JOIN (SELECT * FROM Player_Master.[Grip Detail] WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID AND "Grip Equip Type" = 'IRON') b
ON a."Name" = b."Name"

LEFT OUTER JOIN Player_Master.PLAYERNAMES g on a."Name" = g.PLAYERNAME and a."Survey ID" = g.SID AND a."First Day" = g.FIRSTDAY 

)
GO
