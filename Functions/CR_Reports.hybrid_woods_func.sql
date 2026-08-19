IF OBJECT_ID('CR_Reports.hybrid_woods_func') IS NOT NULL
    DROP FUNCTION [CR_Reports].[hybrid_woods_func];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [CR_Reports].[hybrid_woods_func] 
(	
	@FIRSTDAY date,
	@SID int
)
RETURNS TABLE 
AS
RETURN 
(

SELECT a."Name" AS PLAYERNAME, CATEGORY, EXTRA, b."Wood Club Code" AS CLUBCODE, DCLUBCODE, "Wood Brand Code" AS HYBRIDBRAND, DBRANDCODE,
"Wood Model Code" AS HYBRIDMODEL, DMODELCODE, "Wood Size Code" AS HYBRIDSIZE, DSIZECODE, "Wood Mat'l Code" AS HYBRIDMATL, DMATERIAL
FROM (

SELECT "Name", "Survey ID", "First Day" FROM [Player_Master].[Wood Detail] WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID GROUP BY "Name", "Survey ID", "First Day") a 
LEFT OUTER JOIN (SELECT * FROM [Player_Master].[Wood Detail] WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID AND "Wood Club Code" = 'HYB') b
ON a."Name" = b."Name"

LEFT OUTER JOIN Player_Master.PLAYERNAMES g on a."Name" = g.PLAYERNAME and a."Survey ID" = g.SID AND a."First Day" = g.FIRSTDAY 


)
GO
