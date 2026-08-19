IF OBJECT_ID('Flash.bag_func') IS NOT NULL
    DROP FUNCTION [Flash].[bag_func];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [Flash].[bag_func] 
(	
	@FIRSTDAY date,
	@SID int
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT b.PLAYERNAME, CATEGORY, EXTRA, a.[Mfgr Code] AS BAGBRAND, DBAGBRAND

FROM Input.[All] b
LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] a ON BAGBRAND = a.[Mfgr Descr] 
LEFT OUTER JOIN Player_Master.PLAYERNAMES c on b.PLAYERNAME = c.PLAYERNAME AND c.FIRSTDAY = b.[FIRST DAY] and c.SID = b.SID 


WHERE [FIRST DAY] = @FIRSTDAY AND b.SID = @SID 
)
GO
