IF OBJECT_ID('CR_Reports.fairway_inc_hyb_func') IS NOT NULL
    DROP FUNCTION [CR_Reports].[fairway_inc_hyb_func];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [CR_Reports].[fairway_inc_hyb_func] 
(	
	@FIRSTDAY date,
	@SID int
)
RETURNS TABLE 
AS
RETURN 
(


	SELECT d."Name" AS PLAYERNAME, CATEGORY, EXTRA, "Wood Club Code" AS CLUBCODE, DCLUBCODE, "Wood Brand Code" AS BRAND, DBRANDCODE,
	"Wood Model Code" AS MODEL, DMODELCODE, "Wood Size Code" AS SIZE, DSIZECODE, "Wood Mat'l Code" AS MATL, DMATERIAL FROM
--min pkey offsets new vs old, in the new it's just where pkey = 1
--selects the woods, joins the drivers, and selects what's null
(SELECT * FROM Player_Master.[Wood Detail] WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID) d
LEFT OUTER JOIN
(SELECT "Name" AS DRIVER, MIN("PKey") AS PKEY FROM Player_Master.[Wood Detail] WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID GROUP BY "Name") c
ON c.PKEY = d."PKey" AND DRIVER = d."Name"

LEFT OUTER JOIN Player_Master.PLAYERNAMES g on d."Name" = g.PLAYERNAME and d."Survey ID" = g.SID AND d."First Day" = g.FIRSTDAY 

WHERE d."First Day" = @FIRSTDAY AND d."Survey ID" = @SID AND DRIVER IS NULL

)
GO
