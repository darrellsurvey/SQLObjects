DROP FUNCTION IF EXISTS [CR_Reports].[drivershaft_func];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [CR_Reports].[drivershaft_func] 
(	
	@FIRSTDAY date,
	@SID int
)
RETURNS TABLE 
AS
RETURN 
(


SELECT drivers."Name" AS PLAYERNAME, CATEGORY, EXTRA, "Shaft Club Code" AS WOODCLUBCODE, DSHAFTCLUBCODE,
--woods
"Wood Brand Code" AS WOODBRAND, DBRANDCODE,
"Wood Model Code" AS WOODMODEL, DMODELCODE,
"Wood Mat'l Code" AS WOODMATL, DMATERIAL,
"Wood Size Code" AS WOODSIZE, DSIZECODE,
--shafts
"Shaft Mfgr Code" AS SHAFTMFGR, DSHAFTMFGR,
"Shaft Brand Code" AS SHAFTBRAND, DSHAFTBRAND,
"Shaft Model Code" AS SHAFTMODEL, DSHAFTMODEL,
"Shaft Mat'l Code" AS SHAFTMATL, DSHAFTMATL
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

LEFT OUTER JOIN Player_Master.PLAYERNAMES g on drivers."Name" = g.PLAYERNAME and drivers."Survey ID" = g.SID AND drivers."First Day" = g.FIRSTDAY 

WHERE drivers."First Day" = @FIRSTDAY AND drivers."Survey ID" = @SID 

)
GO
