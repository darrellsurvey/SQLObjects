IF OBJECT_ID('Flash.Ball_Glove_Shoes') IS NOT NULL
    DROP PROCEDURE [Flash].[Ball_Glove_Shoes];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Flash].[Ball_Glove_Shoes]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT b.PLAYERNAME, CATEGORY, EXTRA,
	COALESCE(e."Mfgr Abbrev", e."Mfgr Descr") AS BALLBRAND, DBALLBRAND,
	COALESCE(f."Model Abbrev", f."Model Descr") AS BALLMODEL, DBALLMODEL,
	COALESCE(a."Mfgr Abbrev", a."Mfgr Descr") AS GLOVEBRAND, DGLOVEBRAND,
	COALESCE(d."Mfgr Abbrev", d."Mfgr Descr") AS SHOEBRAND, DSHOEBRAND


FROM (SELECT * FROM Input.[All] WHERE "FIRST DAY" = @FIRSTDAY AND [SID] = @SID )  b
-- all items
LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] a ON GLOVEBRAND = a."Mfgr Descr"  
LEFT OUTER JOIN Player_Master.PLAYERNAMES c on b.PLAYERNAME = c.PLAYERNAME AND c.FIRSTDAY = b.[FIRST DAY] and c.SID = b.SID 
LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] d ON SHOEBRAND = d."Mfgr Descr"  
LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] e ON BALLBRAND = e."Mfgr Descr"  
LEFT OUTER JOIN [LKP].[Model Codes and Descr] f ON BALLMODEL = f."Model Descr"  


ORDER BY EXTRA, b.PLAYERNAME ASC

END
GO
