IF OBJECT_ID('CR_Reports.Wood_Grips') IS NOT NULL
    DROP PROCEDURE [CR_Reports].[Wood_Grips];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CR_Reports].[Wood_Grips]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


SELECT a.[Name] AS PLAYERNAME, CATEGORY, EXTRA, b.[Grip Club Code] AS WOODCLUBCODE, DCLUBCODE, 
--wood info
ISNULL(f.[Mfgr Abbrev], f.[Mfgr Descr]) AS WOODBRAND, a.DBRANDCODE AS DWOODBRAND,
h.[Model Descr] AS WOODMODEL, a.DMODELCODE AS DWOODMODEL,
ISNULL(i.[Matl Abbrev], i.[Matl Descr]) AS WOODMATL, a.DMATERIAL AS DWOODMATERIAL,
ISNULL(k.[Size Abbrev], k.[Size Descr]) AS WOODSIZE, a.DSIZECODE AS DWOODSIZE,
--grip info
b.[Grip Club Code] AS GRIPLUBCODE, DCLUBCODE, 
ISNULL(e.[Mfgr Abbrev], e.[Mfgr Descr]) AS GRIPMFGR, DMFGRCODE,
ISNULL(c.[Mfgr Abbrev], c.[Mfgr Descr]) AS GRIPBRAND, b.DBRANDCODE,
d.[Model Descr] AS GRIPMODEL, b.DMODELCODE,
ISNULL(j.[Matl Abbrev], j.[Matl Descr]) AS GRIPMATL, b.DMATERIAL

FROM (
SELECT [PKey], [Name], [Survey ID], [First Day], [Wood Brand Code], DBRANDCODE, [Wood Model Code], DMODELCODE, [Wood Size Code], DSIZECODE, [Wood Mat'l Code], DMATERIAL
FROM Player_Master.[Wood Detail]
WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID
GROUP BY [PKey], [Name], [Survey ID], [First Day], [Wood Brand Code], DBRANDCODE, [Wood Model Code], DMODELCODE, [Wood Size Code], DSIZECODE, [Wood Mat'l Code], DMATERIAL) a


LEFT OUTER JOIN (SELECT *,
pkey - ((select MIN(pkey) FROM Player_Master.[Grip Detail] WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID AND [Grip Equip Type] = 'WOOD') - 
(select MIN(pkey) FROM Player_Master.[Wood Detail] WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID))
AS PKEYOFFSET
FROM Player_Master.[Grip Detail] WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID AND [Grip Equip Type] = 'WOOD') b
ON a.PKey = PKEYOFFSET and a.Name = b.Name
--shaft joins
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] e ON b.[Grip Mfgr Code] = e.[Mfgr Code]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] c ON b.[Grip Brand Code] = c.[Mfgr Code]
LEFT OUTER JOIN LKP.[Model Codes and Descr] d ON b.[Grip Model Code] = d.[Model Code]
LEFT OUTER JOIN LKP.[Material Codes and Descript] j ON b.[Grip Mat'l Code] = j.[Matl Code]
--wood joins
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] f ON a.[Wood Brand Code] = f.[Mfgr Code]
LEFT OUTER JOIN LKP.[Model Codes and Descr] h ON a.[Wood Model Code] = h.[Model Code]
LEFT OUTER JOIN LKP.[Material Codes and Descript] i ON a.[Wood Mat'l Code] = i.[Matl Code]
LEFT OUTER JOIN LKP.[Size Codes and Description] k on a.[Wood Size Code] = k.[Size Code]

LEFT OUTER JOIN Player_Master.PLAYERNAMES g on a.[Name] = g.PLAYERNAME and a.[Survey ID] = g.SID AND a.[First Day] = g.FIRSTDAY 


--no where--these fields will be null for players with no hybrids
ORDER BY EXTRA, a.[Name], b.[PKey]



END
GO
