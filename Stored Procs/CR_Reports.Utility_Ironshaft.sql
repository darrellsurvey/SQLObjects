IF OBJECT_ID('CR_Reports.Utility_Ironshaft') IS NOT NULL
    DROP PROCEDURE [CR_Reports].[Utility_Ironshaft];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CR_Reports].[Utility_Ironshaft]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



SELECT a.[Name] AS PLAYERNAME, CATEGORY, EXTRA, b.[Shaft Club Code] AS IRONSHAFTCLUBCODE, DCLUBCODE, ISNULL(e.[Mfgr Abbrev], e.[Mfgr Descr]) AS IRONSHAFTMFGR, DMFGRCODE,
ISNULL(c.[Mfgr Abbrev], c.[Mfgr Descr]) AS IRONSHAFTBRAND, DBRANDCODE, ISNULL(d.[Model Abbrev], d.[Model Descr]) AS IRONSHAFTMODEL, DMODELCODE, ISNULL([Matl Descr], [Matl Descr]) AS IRONSHAFTMATL, DMATERIAL
FROM (

SELECT [Name], [Survey ID], [First Day] FROM Player_Master.[Iron Detail] WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID GROUP BY [Name], [Survey ID], [First Day]) a  
LEFT OUTER JOIN (SELECT * FROM Player_Master.[Shaft Detail] WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID AND [Shaft Club Code] LIKE '%^%') b
ON a.[Name] = b.[Name]


LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] e ON b.[Shaft Mfgr Code] = e.[Mfgr Code]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] c ON b.[Shaft Brand Code] = c.[Mfgr Code]
LEFT OUTER JOIN LKP.[Model Codes and Descr] d ON b.[Shaft Model Code] = d.[Model Code]
LEFT OUTER JOIN LKP.[Material Codes and Descript] ON b.[Shaft Mat'l Code] = [Matl Code]
LEFT OUTER JOIN Player_Master.PLAYERNAMES g on a.[Name] = g.PLAYERNAME and a.[Survey ID] = g.SID AND a.[First Day] = g.FIRSTDAY 

--no where--these fields will be null for players with no hybrids
ORDER BY EXTRA, a.[Name], b.[PKey]


END
GO
