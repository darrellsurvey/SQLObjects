DROP FUNCTION IF EXISTS [CR_Reports].[irons_func];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [CR_Reports].[irons_func] 
(	
	@FIRSTDAY date,
	@SID int
)
RETURNS TABLE 
AS
RETURN 
(

SELECT "Name" AS PLAYERNAME, CATEGORY, EXTRA, "Iron Club Code" AS CLUBCODE, DCLUBCODE, "Iron Brand Code" AS BRAND, DBRANDCODE,
"Iron Model Code" AS MODEL, DMODELCODE

FROM Player_Master.[Iron Detail] c
LEFT OUTER JOIN Player_Master.PLAYERNAMES g on c."Name" = g.PLAYERNAME and c."Survey ID" = g.SID AND c."First Day" = g.FIRSTDAY 

WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID 

)
GO
