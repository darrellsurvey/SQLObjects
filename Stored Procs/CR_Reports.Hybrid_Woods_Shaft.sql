IF OBJECT_ID('CR_Reports.Hybrid_Woods_Shaft') IS NOT NULL
    DROP PROCEDURE [CR_Reports].[Hybrid_Woods_Shaft];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CR_Reports].[Hybrid_Woods_Shaft]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



SELECT a.[Name] AS PLAYERNAME, CATEGORY, EXTRA,
b.[Shaft Club Code] AS CLUBCODE, DCLUBCODE,
--woods
ISNULL(h.[Mfgr Abbrev], h.[Mfgr Descr]) AS WOODBRAND, DWOODBRAND,
i.[Model Descr] AS WOODMODEL, DWOODMODEL,
ISNULL(j.[Matl Abbrev], j.[Matl Descr]) AS WOODMATL, DWOODMATERIAL,
ISNULL(k.[Size Abbrev], k.[Size Descr]) AS WOODSIZE, DWOODSIZE,
--shafts
ISNULL(e.[Mfgr Abbrev], e.[Mfgr Descr]) AS SHAFTMFGR, DMFGRCODE,
ISNULL(c.[Mfgr Abbrev], c.[Mfgr Descr]) AS SHAFTBRAND, DBRANDCODE,
d.[Model Descr] AS SHAFTMODEL, DMODELCODE,
ISNULL(f.[Matl Abbrev], f.[Matl Descr]) AS SHAFTMATL, DMATERIAL
FROM (

SELECT [PKey], [Name], [Survey ID], [First Day], [Wood Brand Code], DBRANDCODE AS DWOODBRAND, [Wood Model Code], DMODELCODE AS DWOODMODEL, [Wood Size Code], DSIZECODE AS DWOODSIZE, [Wood Mat'l Code], DMATERIAL AS DWOODMATERIAL
FROM Player_Master.[Wood Detail]
WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID AND [Wood Club Code] = 'HYB'
GROUP BY [PKey], [Name], [Survey ID], [First Day], [Wood Brand Code], DBRANDCODE, [Wood Model Code], DMODELCODE, [Wood Size Code], DSIZECODE, [Wood Mat'l Code], DMATERIAL) a 

LEFT OUTER JOIN
(SELECT *,
pkey - ((select MIN(pkey) FROM Player_Master.[Shaft Detail] WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID AND [Shaft Equip Type] = 'WOOD') - 
(select MIN(pkey) FROM Player_Master.[Wood Detail] WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID))
AS PKEYOFFSET
 FROM [Player_Master].[Shaft Detail] WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID AND [Shaft Club Code] = 'HYB') b
ON a.PKey = PKEYOFFSET and a.Name = b.name

--AND a.[Wood Club Code] = b.[Wood Club Code] AND a.[Wood Brand Code] = b.[Wood Brand Code] AND a.[Wood Model Code] = b.[Wood Model Code]
--AND a.[Field01] = b.[Field01] AND a.[Wood Size Code] = b.[Wood Size Code]


--shaft joins
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] e ON [Shaft Brand Code] = e.[Mfgr Code]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] c ON [Shaft Brand Code] = c.[Mfgr Code]
LEFT OUTER JOIN LKP.[Model Codes and Descr] d ON [Shaft Model Code] = d.[Model Code]
LEFT OUTER JOIN LKP.[Material Codes and Descript] f ON [Shaft Mat'l Code] = f.[Matl Code]
--wood joins
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] h ON [Wood Brand Code] = h.[Mfgr Code]
LEFT OUTER JOIN LKP.[Model Codes and Descr] i ON [Wood Model Code] = i.[Model Code]
LEFT OUTER JOIN LKP.[Material Codes and Descript] j ON [Wood Mat'l Code] = j.[Matl Code]
LEFT OUTER JOIN LKP.[Size Codes and Description] k ON [Wood Size Code]= k.[Size Code] 

LEFT OUTER JOIN Player_Master.PLAYERNAMES g on a.[Name] = g.PLAYERNAME and a.[Survey ID] = g.SID AND a.[First Day] = g.FIRSTDAY 

--no where--these fields will be null for players with no hybrids
ORDER BY EXTRA, a.[Name], b.[PKey]


END



/*

execute CR_Reports.Hybrid_Woods_Shaft '4/8/2010', 26

*/
GO
