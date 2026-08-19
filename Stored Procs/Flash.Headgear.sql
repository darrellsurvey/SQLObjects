DROP PROCEDURE IF EXISTS [Flash].[Headgear];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Flash].[Headgear]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT b.PLAYERNAME, CATEGORY, EXTRA, ISNULL(a."Mfgr Abbrev", a."Mfgr Descr") AS HEADGEARBRAND, DHEADGEARBRAND

FROM [Input].[All] b
LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] a ON HEADGEARBRAND = a."Mfgr Descr" 
LEFT OUTER JOIN Player_Master.PLAYERNAMES c on b.PLAYERNAME = c.PLAYERNAME AND c.FIRSTDAY = b.[FIRST DAY] and c.SID = b.SID 

WHERE "FIRST DAY" = @FIRSTDAY AND b.SID = @SID 
ORDER BY EXTRA, b.PLAYERNAME ASC

END
GO
