DROP FUNCTION IF EXISTS [CR_Reports].[woods_func];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [CR_Reports].[woods_func] 
(	
	@FIRSTDAY date,
	@SID int
)
RETURNS TABLE 
AS
RETURN 
(

SELECT "Name" AS PLAYERNAME, CATEGORY, EXTRA, "Wood Club Code" AS WOODCLUBCODE, DCLUBCODE,
"Wood Brand Code" AS WOODBRAND, DBRANDCODE,
"Wood Model Code" AS WOODMODEL, DMODELCODE,
"Wood Size Code" AS WOODSIZE, DSIZECODE,
"Wood Mat'l Code" AS WOODMATL, DMATERIAL

FROM Player_Master.[Wood Detail] e
LEFT OUTER JOIN Player_Master.PLAYERNAMES g on e."Name" = g.PLAYERNAME and e."Survey ID" = g.SID AND e."First Day" = g.FIRSTDAY 

WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID 


)
GO
