IF OBJECT_ID('CR_Reports.woodshafts_func') IS NOT NULL
    DROP FUNCTION [CR_Reports].[woodshafts_func];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [CR_Reports].[woodshafts_func] 
(	
	@FIRSTDAY date,
	@SID int
)
RETURNS TABLE 
AS
RETURN 
(


SELECT a.[Name] AS PLAYERNAME, CATEGORY, EXTRA, b.[Shaft Club Code] AS WOODCLUBCODE, DCLUBCODE AS DWOODCLUBCODE, 
--wood info
[Wood Brand Code] AS WOODBRAND, a.DBRANDCODE AS DWOODBRAND,
[Wood Model Code] AS WOODMODEL, a.DMODELCODE AS DWOODMODEL,
[Wood Mat'l Code] AS WOODMATL, a.DMATERIAL AS DWOODMATERIAL,
[Wood Size Code] AS WOODSIZE, a.DSIZECODE AS DWOODSIZE,
--shaft info
b.[Shaft Club Code] AS SHAFTCLUBCODE, DCLUBCODE AS DWOODSHAFTCLUBCODE, 
[Shaft Mfgr Code] AS SHAFTMFGR, DMFGRCODE,
[Shaft Brand Code] AS SHAFTBRAND, b.DBRANDCODE,
[Shaft Model Code] AS SHAFTMODEL, b.DMODELCODE,
[Shaft Mat'l Code] AS SHAFTMATL, b.DMATERIAL

FROM (
SELECT [PKey], [Name], [Survey ID], [First Day], [Wood Brand Code], DBRANDCODE, [Wood Model Code], DMODELCODE, [Wood Size Code], DSIZECODE, [Wood Mat'l Code], DMATERIAL
FROM Player_Master.[Wood Detail]
WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID
GROUP BY [PKey], [Name], [Survey ID], [First Day], [Wood Brand Code], DBRANDCODE, [Wood Model Code], DMODELCODE, [Wood Size Code], DSIZECODE, [Wood Mat'l Code], DMATERIAL) a


LEFT OUTER JOIN (SELECT *,
pkey - ((select MIN(pkey) FROM Player_Master.[Shaft Detail] WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID AND [Shaft Equip Type] = 'WOOD') - 
(select MIN(pkey) FROM Player_Master.[Wood Detail] WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID))
AS PKEYOFFSET
FROM Player_Master.[Shaft Detail] WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID AND [Shaft Equip Type] = 'WOOD') b
ON a.PKey = PKEYOFFSET and a.Name = b.Name

LEFT OUTER JOIN Player_Master.PLAYERNAMES g on a.[Name] = g.PLAYERNAME and a.[Survey ID] = g.SID AND a.[First Day] = g.FIRSTDAY 


)
GO
