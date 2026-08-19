IF OBJECT_ID('CR_Reports.Fairway_no_hyb') IS NOT NULL
    DROP PROCEDURE [CR_Reports].[Fairway_no_hyb];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CR_Reports].[Fairway_no_hyb]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT d.[Name] AS PLAYERNAME, [Wood Club Code] AS CLUBCODE, DCLUBCODE, ISNULL(a.[Mfgr Abbrev], a.[Mfgr Descr]) AS BRAND, DBRANDCODE,
	ISNULL(b.[Model Abbrev], b.[Model Descr]) AS MODEL, DMODELCODE, ISNULL([Size Abbrev], [Size Descr]) AS SIZE, DSIZECODE, ISNULL([Matl Abbrev], [Matl Descr]) AS MATL, DMATERIAL FROM
--min pkey offsets new vs old, in the new it's just where pkey = 1
--selects the woods, joins the drivers, and selects what's null
(SELECT * FROM Player_Master.[Wood Detail] WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID) d
LEFT OUTER JOIN
(SELECT [Name] AS DRIVER, MIN([PKey]) AS PKEY FROM Player_Master.[Wood Detail] WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID GROUP BY [Name]) c
ON c.PKEY = d.[PKey] AND DRIVER = d.[Name]

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a ON [Wood Brand Code] = a.[Mfgr Code]
LEFT OUTER JOIN LKP.[Model Codes and Descr] b ON [Wood Model Code] = b.[Model Code]
LEFT OUTER JOIN LKP.[Size Codes and Description] e ON [Wood Size Code] = e.[Size Code]
LEFT OUTER JOIN LKP.[Material Codes and Descript] f ON [Wood Mat'l Code] = f.[Matl Code]
LEFT OUTER JOIN Player_Master.PLAYERNAMES g on d.[Name] = g.PLAYERNAME and d.[Survey ID] = g.SID AND d.[First Day] = g.FIRSTDAY 

WHERE d.[First Day] = @FIRSTDAY AND d.[Survey ID] = @SID AND DRIVER IS NULL AND [Wood Club Code] <> 'HYB'
ORDER BY EXTRA, d.[Name] ASC, c.[PKey] ASC

END
GO
