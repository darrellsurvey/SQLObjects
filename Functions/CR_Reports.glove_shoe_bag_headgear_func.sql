IF OBJECT_ID('CR_Reports.glove_shoe_bag_headgear_func') IS NOT NULL
    DROP FUNCTION [CR_Reports].[glove_shoe_bag_headgear_func];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [CR_Reports].[glove_shoe_bag_headgear_func] 
(	
	@FIRSTDAY date,
	@SID int
)
RETURNS TABLE 
AS
RETURN 
(

	SELECT b.PLAYERNAME, CATEGORY, EXTRA, GLOVEBRAND, DGLOVEBRAND, SHOEBRAND, DSHOEBRAND, BAGBRAND, DBAGBRAND, HEADGEARBRAND, DHEADGEARBRAND


FROM (SELECT * FROM [Player_Master].[All] WHERE "FIRST DAY" = @FIRSTDAY AND [SID] = @SID )  b
-- all items

LEFT OUTER JOIN Player_Master.PLAYERNAMES c on b.PLAYERNAME = c.PLAYERNAME AND c.FIRSTDAY = b.[FIRST DAY] and c.SID = b.SID 


)
GO
