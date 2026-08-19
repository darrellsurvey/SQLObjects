IF OBJECT_ID('Flash.Drivershaft') IS NOT NULL
    DROP PROCEDURE [Flash].[Drivershaft];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Flash].[Drivershaft]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT drivers.PLAYERNAME AS PLAYERNAME, CATEGORY, EXTRA, SHAFTCLUBCODE AS WOODCLUBCODE, DSHAFTCLUBCODE,
--woods
COALESCE(h.[Mfgr Abbrev], h.[Mfgr Descr]) AS WOODBRAND, DBRANDCODE,
i.[Model Descr] AS WOODMODEL, DMODELCODE,
COALESCE(j.[Matl Abbrev], j.[Matl Descr]) AS WOODMATL, DMATERIAL,
COALESCE(k.[Size Abbrev], k.[Size Descr]) AS WOODSIZE, DSIZECODE,
--shafts
COALESCE(a.[Mfgr Abbrev], a.[Mfgr Descr]) AS SHAFTMFGR, DSHAFTMFGR,
COALESCE(b.[Mfgr Abbrev], b.[Mfgr Descr]) AS SHAFTBRAND, DSHAFTBRAND,
c.[Model Descr] AS SHAFTMODEL, DSHAFTMODEL,
COALESCE(f.[Matl Abbrev], f.[Matl Descr]) AS SHAFTMATL, DSHAFTMATL
FROM

(SELECT * FROM Input.[Wood] where [First Day] = @FIRSTDAY and SID = @SID and ISDRIVER = 1) drivers
LEFT OUTER JOIN
(SELECT 
PLAYERNAME,
SHAFTCLUBCODE, DCLUBCODE AS DSHAFTCLUBCODE,
SHAFTMFGR, DMFGRCODE AS DSHAFTMFGR,
SHAFTBRAND,DBRANDCODE AS DSHAFTBRAND,
SHAFTMODEL, DMODELCODE AS DSHAFTMODEL,
SHAFTMATL, DMATLCODE AS DSHAFTMATL, pkey
FROM Input.[Shaft] where [First Day] = @FIRSTDAY and SID = @SID) shafts
on drivers.PLAYERNAME = shafts.PLAYERNAME and drivers.CLUBCODE = shafts.SHAFTCLUBCODE and drivers.PKey = shafts.pkey


--shaft joins
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a ON SHAFTMFGR = a.[Mfgr Descr]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] b ON SHAFTBRAND = b.[Mfgr Descr]
LEFT OUTER JOIN LKP.[Model Codes and Descr] c ON SHAFTMODEL = c.[Model Descr]
LEFT OUTER JOIN LKP.[Material Codes and Descript] f ON SHAFTMATL = f.[Matl Descr]
--wood joins
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] h ON BRAND = h.[Mfgr Descr]
LEFT OUTER JOIN LKP.[Model Codes and Descr] i ON MODEL = i.[Model Descr]
LEFT OUTER JOIN LKP.[Material Codes and Descript] j ON MATERIAL = j.[Matl Descr]
LEFT OUTER JOIN LKP.[Size Codes and Description] k ON SIZE = k.[Size Descr]

LEFT OUTER JOIN Player_Master.PLAYERNAMES g on drivers.PLAYERNAME = g.PLAYERNAME and drivers.SID = g.SID AND drivers.[First Day] = g.FIRSTDAY 

WHERE drivers.[First Day] = @FIRSTDAY AND drivers.SID = @SID 
ORDER BY EXTRA, drivers.PLAYERNAME ASC

END




/*

execute CR_Reports.Drivershaft '4/8/2010', 26

*/
GO
