IF OBJECT_ID('Flash.Fairway_inc_hyb') IS NOT NULL
    DROP PROCEDURE [Flash].[Fairway_inc_hyb];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Flash].[Fairway_inc_hyb]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	
	SELECT d.PLAYERNAME, CATEGORY, EXTRA, CLUBCODE AS WOODCLUBCODE, DCLUBCODE, ISNULL(a.[Mfgr Abbrev], a.[Mfgr Descr]) AS WOODBRAND, DBRANDCODE,
	ISNULL(b.[Model Abbrev], b.[Model Descr]) AS WOODMODEL, DMODELCODE, ISNULL([Size Abbrev], [Size Descr]) AS WOODSIZE, DSIZECODE, ISNULL([Matl Abbrev], [Matl Descr]) AS WOODMATL, DMATERIAL FROM
--min pkey offsets new vs old, in the new it's just where pkey = 1
--selects the woods, joins the drivers, and selects what's null
(SELECT * FROM Input.[Wood] WHERE [First Day] = @FIRSTDAY AND SID = @SID) d
LEFT OUTER JOIN
(SELECT PLAYERNAME AS DRIVER, MIN([PKey]) AS PKEY FROM Input.[Wood] WHERE [First Day] = @FIRSTDAY AND SID = @SID GROUP BY PLAYERNAME) c
ON c.PKEY = d.[PKey] AND DRIVER = d.PLAYERNAME

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a ON BRAND = a.[Mfgr Descr]
LEFT OUTER JOIN LKP.[Model Codes and Descr] b ON MODEL = b.[Model Descr]
LEFT OUTER JOIN LKP.[Size Codes and Description] e ON SIZE = e.[Size Descr]
LEFT OUTER JOIN LKP.[Material Codes and Descript] f ON MATERIAL = f.[Matl Descr]
LEFT OUTER JOIN Player_Master.PLAYERNAMES g on d.PLAYERNAME = g.PLAYERNAME and d.SID = g.SID AND d.[First Day] = g.FIRSTDAY 

WHERE d.[First Day] = @FIRSTDAY AND d.SID = @SID AND DRIVER IS NULL
ORDER BY EXTRA, d.PLAYERNAME ASC, c.[PKey] ASC

END
GO
