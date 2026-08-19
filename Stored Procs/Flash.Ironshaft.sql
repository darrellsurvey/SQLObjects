IF OBJECT_ID('Flash.Ironshaft') IS NOT NULL
    DROP PROCEDURE [Flash].[Ironshaft];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Flash].[Ironshaft]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT a.PLAYERNAME, CATEGORY, EXTRA, b.SHAFTCLUBCODE AS IRONCLUBCODE, DCLUBCODE, 
--IRON info
ISNULL(f.[Mfgr Abbrev], f.[Mfgr Descr]) AS IRONBRAND, a.DBRANDCODE AS DIRONBRAND,
h.[Model Descr] AS IRONMODEL, a.DMODELCODE AS DIRONMODEL,
ISNULL(i.[Matl Abbrev], i.[Matl Descr]) AS IRONMATL, a.DMATERIAL AS DIRONMATERIAL,
ISNULL(k.[Size Abbrev], k.[Size Descr]) AS IRONSIZE, a.DSIZECODE AS DIRONSIZE,
--shaft info
b.SHAFTCLUBCODE AS SHAFTCLUBCODE, DCLUBCODE, 
ISNULL(e.[Mfgr Abbrev], e.[Mfgr Descr]) AS SHAFTMFGR, DMFGRCODE,
ISNULL(c.[Mfgr Abbrev], c.[Mfgr Descr]) AS SHAFTBRAND, b.DBRANDCODE,
d.[Model Descr] AS SHAFTMODEL, b.DMODELCODE,
ISNULL(j.[Matl Abbrev], j.[Matl Descr]) AS SHAFTMATL, b.DMATLCODE

FROM (
SELECT [PKey], PLAYERNAME, SID, [First Day], CLUBCODE, BRAND, DBRANDCODE, MODEL, DMODELCODE, SIZE, DSIZECODE, MATERIAL, DMATERIAL
FROM input.IRON
WHERE [First Day] = @FIRSTDAY AND SID = @SID
GROUP BY [PKey], PLAYERNAME, SID, [First Day], CLUBCODE, BRAND, DBRANDCODE, MODEL, DMODELCODE, SIZE, DSIZECODE, MATERIAL, DMATERIAL) a

LEFT OUTER JOIN (SELECT *
FROM input.shaft WHERE [First Day] = @FIRSTDAY AND SID = @SID AND SHAFTEQUIPTYPE = 'IRON') b
ON a.PKey = b.pkey and a.PLAYERNAME = b.PLAYERNAME and a.CLUBCODE = b.shaftclubcode
--shaft joins
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] e ON b.SHAFTMFGR = e.[Mfgr Descr]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] c ON b.SHAFTBRAND = c.[Mfgr Descr]
LEFT OUTER JOIN LKP.[Model Codes and Descr] d ON b.SHAFTMODEL = d.[Model Descr]
LEFT OUTER JOIN LKP.[Material Codes and Descript] j ON b.SHAFTMATL = j.[Matl Descr]
--IRON joins
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] f ON a.BRAND = f.[Mfgr Descr]
LEFT OUTER JOIN LKP.[Model Codes and Descr] h ON a.MODEL = h.[Model Descr]
LEFT OUTER JOIN LKP.[Material Codes and Descript] i ON a.MATERIAL = i.[Matl Descr]
LEFT OUTER JOIN LKP.[Size Codes and Description] k on a.SIZE = k.[Size Code]

LEFT OUTER JOIN Player_Master.PLAYERNAMES g on a.PLAYERNAME = g.PLAYERNAME and a.SID = g.SID AND a.[First Day] = g.FIRSTDAY 


--no where--these fields will be null for players with no hybrids
ORDER BY EXTRA, a.PLAYERNAME, b.[PKey]


END
GO
