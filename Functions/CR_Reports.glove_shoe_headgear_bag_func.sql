DROP FUNCTION IF EXISTS [CR_Reports].[glove_shoe_headgear_bag_func];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [CR_Reports].[glove_shoe_headgear_bag_func] 
(	
	@FIRSTDAY date,
	@SID int
)
RETURNS TABLE 
AS
RETURN 
(

	SELECT b.PLAYERNAME, CATEGORY, EXTRA, GLOVEBRAND, DGLOVEBRAND, SHOEBRAND, DSHOEBRAND, HEADGEARBRAND, DHEADGEARBRAND, BAGBRAND, DBAGBRAND


FROM (SELECT * FROM [Player_Master].[All] WHERE "FIRST DAY" = @FIRSTDAY AND [SID] = @SID )  b
-- all items

LEFT OUTER JOIN Player_Master.PLAYERNAMES c on b.PLAYERNAME = c.PLAYERNAME AND c.FIRSTDAY = b.[FIRST DAY] and c.SID = b.SID 


)
GO
