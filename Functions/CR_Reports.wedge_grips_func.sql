IF OBJECT_ID('CR_Reports.wedge_grips_func') IS NOT NULL
    DROP FUNCTION [CR_Reports].[wedge_grips_func];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [CR_Reports].[wedge_grips_func] 
(	
	@FIRSTDAY date,
	@SID int
)
RETURNS TABLE 
AS
RETURN 
(

SELECT a."Name" AS PLAYERNAME, CATEGORY, EXTRA, b."Grip Club Code" AS CLUBCODE, DCLUBCODE, "Grip Mfgr Code" AS MFGR, DMFGRCODE,
"Grip Brand Code" AS BRAND, DBRANDCODE, "Grip Model Code" AS MODEL, DMODELCODE, "Grip Mat'l Code" AS MATL, DMATERIAL
FROM (

SELECT "Name", "Survey ID", "First Day" FROM Player_Master.[Wedge Detail] WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID GROUP BY "Name", "Survey ID", "First Day") a
LEFT OUTER JOIN (SELECT * FROM [Player_Master].[Grip Detail] WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID AND "Grip Equip Type" = 'WEDG') b
ON a."Name" = b."Name"

LEFT OUTER JOIN Player_Master.PLAYERNAMES g on a."Name" = g.PLAYERNAME and a."Survey ID" = g.SID AND a."First Day" = g.FIRSTDAY 




)
GO
