IF OBJECT_ID('Flash.Glove_Shoe_Headgear_Bag') IS NOT NULL
    DROP PROCEDURE [Flash].[Glove_Shoe_Headgear_Bag];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Flash].[Glove_Shoe_Headgear_Bag]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT b.PLAYERNAME, CATEGORY, EXTRA,
	ISNULL(a.[Mfgr Abbrev], a.[Mfgr Descr]) AS GLOVEBRAND, DGLOVEBRAND,
	ISNULL(d.[Mfgr Abbrev], d.[Mfgr Descr]) AS SHOEBRAND, DSHOEBRAND,
	ISNULL(e.[Mfgr Abbrev], e.[Mfgr Descr]) AS HEADGEARBRAND, DHEADGEARBRAND,
	ISNULL(f.[Mfgr Abbrev], f.[Mfgr Descr]) AS BAGBRAND, DBAGBRAND

FROM (SELECT * FROM [Input].[All] WHERE [FIRST DAY] = @FIRSTDAY AND [SID] = @SID )  b
-- all items
LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] a ON GLOVEBRAND = a.[Mfgr Descr] 
LEFT OUTER JOIN Player_Master.PLAYERNAMES c on b.PLAYERNAME = c.PLAYERNAME AND c.FIRSTDAY = b.[FIRST DAY] and c.SID = b.SID 
LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] d ON SHOEBRAND = d.[Mfgr Descr] 
LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] e ON HEADGEARBRAND = e.[Mfgr Descr] 
LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] f ON BAGBRAND = f.[Mfgr Descr] 

ORDER BY EXTRA, b.PLAYERNAME ASC

END
GO
