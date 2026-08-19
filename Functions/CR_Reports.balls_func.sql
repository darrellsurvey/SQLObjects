IF OBJECT_ID('CR_Reports.balls_func') IS NOT NULL
    DROP FUNCTION [CR_Reports].[balls_func];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [CR_Reports].[balls_func] 
(	
	@FIRSTDAY date,
	@SID int
)
RETURNS TABLE 
AS
RETURN 
(

SELECT d.PLAYERNAME, CATEGORY, EXTRA, BALLBRAND, DBALLBRAND, BALLMODEL, DBALLMODEL

FROM [Player_Master].[All] d
LEFT OUTER JOIN Player_Master.PLAYERNAMES c on d.PLAYERNAME = c.PLAYERNAME AND d.SID = c.SID AND c.FIRSTDAY = d.[FIRST DAY] 


WHERE "FIRST DAY" = @FIRSTDAY AND d.SID = @SID 

)
GO
