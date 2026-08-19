IF OBJECT_ID('CR_Reports.Woods') IS NOT NULL
    DROP PROCEDURE [CR_Reports].[Woods];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CR_Reports].[Woods]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


SELECT [Name] AS PLAYERNAME, CATEGORY, EXTRA, [Wood Club Code] AS WOODCLUBCODE, DCLUBCODE,
ISNULL(a.[Mfgr Abbrev], a.[Mfgr Descr]) AS WOODBRAND, DBRANDCODE,
ISNULL(b.[Model Abbrev], b.[Model Descr]) AS WOODMODEL, DMODELCODE,
ISNULL(c.[Size Abbrev], c.[Size Descr]) AS WOODSIZE, DSIZECODE,
ISNULL(d.[Matl Abbrev], d.[Matl Descr]) AS WOODMATL, DMATERIAL

FROM Player_Master.[Wood Detail] e
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a ON [Wood Brand Code] = a.[Mfgr Code]
LEFT OUTER JOIN LKP.[Model Codes and Descr] b ON [Wood Model Code] = b.[Model Code]
LEFT OUTER JOIN LKP.[Size Codes and Description] c ON [Wood Size Code] = [Size Code]
LEFT OUTER JOIN LKP.[Material Codes and Descript] d ON [Wood Mat'l Code] = [Matl Code]
LEFT OUTER JOIN Player_Master.PLAYERNAMES g on e.[Name] = g.PLAYERNAME and e.[Survey ID] = g.SID AND e.[First Day] = g.FIRSTDAY 

WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID 
ORDER BY EXTRA, [Name], e.[PKey]


END
GO
