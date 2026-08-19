IF OBJECT_ID('CR_Reports.Drivershaft') IS NOT NULL
    DROP PROCEDURE [CR_Reports].[Drivershaft];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CR_Reports].[Drivershaft]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT drivers."Name" AS PLAYERNAME, CATEGORY, EXTRA, "Shaft Club Code" AS WOODCLUBCODE, DSHAFTCLUBCODE,
--woods
ISNULL(h."Mfgr Abbrev", h."Mfgr Descr") AS WOODBRAND, DBRANDCODE,
i."Model Descr" AS WOODMODEL, DMODELCODE,
ISNULL(j."Matl Abbrev", j."Matl Descr") AS WOODMATL, DMATERIAL,
ISNULL(k."Size Abbrev", k."Size Descr") AS WOODSIZE, DSIZECODE,
--shafts
ISNULL(a."Mfgr Abbrev", a."Mfgr Descr") AS SHAFTMFGR, DSHAFTMFGR,
ISNULL(b."Mfgr Abbrev", b."Mfgr Descr") AS SHAFTBRAND, DSHAFTBRAND,
c."Model Descr" AS SHAFTMODEL, DSHAFTMODEL,
ISNULL(f."Matl Abbrev", f."Matl Descr") AS SHAFTMATL, DSHAFTMATL
FROM

(SELECT * FROM Player_Master.[Wood Detail] where [First Day] = @FIRSTDAY and [survey id] = @SID and ISDRIVER = 1) drivers
LEFT OUTER JOIN
(SELECT 
Name, PKey,
[Shaft Club Code], DCLUBCODE AS DSHAFTCLUBCODE,
[Shaft Mfgr Code], DMFGRCODE AS DSHAFTMFGR,
[Shaft Brand Code],DBRANDCODE AS DSHAFTBRAND,
[Shaft Model Code], DMODELCODE AS DSHAFTMODEL,
[Shaft Mat'l Code], DMATERIAL AS DSHAFTMATL
FROM Player_Master.[Shaft Detail] where [First Day] = @FIRSTDAY and [survey id] = @SID) shafts
on drivers.Name = shafts.Name and drivers.[Wood Club Code] = shafts.[Shaft Club Code] and drivers.PKey = shafts.pkey

/*--min pkey offsets new vs old, in the new it's just where pkey = 1
(SELECT "Name", MIN("PKey") AS PKEY, "Survey ID", "First Day" FROM [Player_Master].[Shaft Detail] WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID AND "Shaft Equip Type" = 'WOOD'
GROUP BY "Name", "Survey ID", "First Day") e
LEFT OUTER JOIN

(SELECT * FROM (

(SELECT PKey AS SHAFTPKEY, Name AS SHAFTNAME,
[Shaft Club Code], DCLUBCODE AS DSHAFTCLUBCODE,
[Shaft Mfgr Code], DMFGRCODE AS DSHAFTMFGR,
[Shaft Brand Code],DBRANDCODE AS DSHAFTBRAND,
[Shaft Model Code], DMODELCODE AS DSHAFTMODEL,
[Shaft Mat'l Code], DMATERIAL AS DSHAFTMATL,
pkey - ((select MIN(pkey) FROM Player_Master.[Shaft Detail] WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID AND "Shaft Equip Type" = 'WOOD') - 
(select MIN(pkey) FROM Player_Master.[Wood Detail] WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID))
AS PKEYOFFSET
FROM [Player_Master].[Shaft Detail] WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID AND "Shaft Equip Type" = 'WOOD') shaft
LEFT OUTER JOIN
(SELECT * FROM Player_Master.[Wood Detail] WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID) wood
ON wood.PKey = shaft.PKEYOFFSET
)) d

ON e.PKEY = d.SHAFTPKEY AND e."Name" = d."Name"*/


--shaft joins
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a ON "Shaft Brand Code" = a."Mfgr Code"
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] b ON "Shaft Brand Code" = b."Mfgr Code"
LEFT OUTER JOIN LKP.[Model Codes and Descr] c ON "Shaft Model Code" = c."Model Code"
LEFT OUTER JOIN LKP.[Material Codes and Descript] f ON "Shaft Mat'l Code" = f."Matl Code"
--wood joins
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] h ON "Wood Brand Code" = h."Mfgr Code"
LEFT OUTER JOIN LKP.[Model Codes and Descr] i ON "Wood Model Code" = i."Model Code"
LEFT OUTER JOIN LKP.[Material Codes and Descript] j ON "Wood Mat'l Code" = j."Matl Code"
LEFT OUTER JOIN LKP.[Size Codes and Description] k ON [Wood Size Code] = k.[Size Code]

LEFT OUTER JOIN Player_Master.PLAYERNAMES g on drivers."Name" = g.PLAYERNAME and drivers."Survey ID" = g.SID AND drivers."First Day" = g.FIRSTDAY 

WHERE drivers."First Day" = @FIRSTDAY AND drivers."Survey ID" = @SID 
ORDER BY EXTRA, drivers."Name" ASC

END




/*

execute CR_Reports.Drivershaft '4/8/2010', 26

*/
GO
