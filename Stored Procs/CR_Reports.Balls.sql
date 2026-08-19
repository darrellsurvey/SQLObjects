IF OBJECT_ID('CR_Reports.Balls') IS NOT NULL
    DROP PROCEDURE [CR_Reports].[Balls];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CR_Reports].[Balls]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


SELECT d.PLAYERNAME, CATEGORY, EXTRA, ISNULL(a."Mfgr Abbrev", a."Mfgr Descr") AS BALLBRAND, DBALLBRAND, b."Model Descr" AS BALLMODEL, DBALLMODEL

FROM [Player_Master].[All] d
LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] a ON BALLBRAND = a."Mfgr Code" 
LEFT OUTER JOIN [LKP].[Model Codes and Descr] b ON BALLMODEL = b."Model Code" 
LEFT OUTER JOIN Player_Master.PLAYERNAMES c on d.PLAYERNAME = c.PLAYERNAME AND d.SID = c.SID AND c.FIRSTDAY = d.[FIRST DAY] 


WHERE "FIRST DAY" = @FIRSTDAY AND d.SID = @SID 
order by EXTRA, PLAYERNAME ASC
END
GO
