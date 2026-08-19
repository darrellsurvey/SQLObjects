IF OBJECT_ID('Media.irons_func') IS NOT NULL
    DROP FUNCTION [Media].[irons_func];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [Media].[irons_func] 
(	
	@FIRSTDAY date,
	@SID int
)
RETURNS TABLE 
AS
RETURN 
(

with IRONTABLE as (
SELECT row_number() OVER(PARTITION BY Name ORDER BY c."PKey" ASC) AS IRONNUMBER,
Name, CATEGORY, EXTRA,
[Iron Club Code] AS IRONCLUBCODE, DCLUBCODE AS DIRONCLUBCODE, 
a."Mfgr Descr" AS IRONBRAND, DBRANDCODE AS DIRONBRANDCODE,
b."Model Descr" AS IRONMODEL, DMODELCODE AS DIRONMODELCODE

FROM [Player_Master].[Iron Detail] c
LEFT OUTER JOIN Player_Master.PLAYERNAMES d ON c.[Survey ID] = d.SID and c.Name = d.PLAYERNAME and c.[First Day] = d.FIRSTDAY 
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a ON [Iron Brand Code] = a."Mfgr Code"
LEFT OUTER JOIN LKP.[Model Codes and Descr] b ON [Iron Model Code] = b."Model Code"

WHERE "First Day" = @FIRSTDAY AND [Survey ID] = @SID 
GROUP BY Name, CATEGORY, EXTRA, [Iron Club Code], a."Mfgr Descr", b."Model Descr", c."PKey", DCLUBCODE, DBRANDCODE, DMODELCODE
),

IRONSHAFTTABLE as (
SELECT 
row_number() OVER(PARTITION BY Name ORDER BY b."PKey" ASC) AS SHAFTNUMBER,
ISNULL(e."Mfgr Abbrev", e."Mfgr Descr") AS SHAFTMFGR, DMFGRCODE AS DIRONSHAFTMFGR,
ISNULL(c."Mfgr Abbrev", c."Mfgr Descr") AS SHAFTBRAND, DBRANDCODE AS DIRONSHAFTBRAND,
ISNULL(d."Model Abbrev", d."Model Descr") AS SHAFTMODEL, DMODELCODE AS DIRONSHAFTMODEL,
ISNULL(f."Matl Abbrev", f."Matl Descr") AS SHAFTMATL, DMATERIAL AS DIRONSHAFTMATL
FROM Player_Master.[Shaft Detail] b
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] e ON b."Shaft Mfgr Code" = e."Mfgr Code"
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] c ON b."Shaft Brand Code" = c."Mfgr Code"
LEFT OUTER JOIN LKP.[Model Codes and Descr] d ON b."Shaft Model Code" = d."Model Code"
LEFT OUTER JOIN LKP.[Material Codes and Descript] f ON b."Shaft Mat'l Code" = f."Matl Code"

WHERE [Shaft Equip Type] = 'IRON'

),

IRONGRIPTABLE as (

SELECT 
row_number() OVER(PARTITION BY Name ORDER BY b."PKey" ASC) AS GRIPNUMBER,
ISNULL(e."Mfgr Abbrev", e."Mfgr Descr") AS GRIPMFGR, DMFGRCODE AS DIRONGRIPMFGR,
ISNULL(c."Mfgr Abbrev", c."Mfgr Descr") AS GRIPBRAND, DBRANDCODE AS DIRONGRIPBRAND,
ISNULL(d."Model Abbrev", d."Model Descr") AS GRIPMODEL, DMODELCODE AS DIRONGRIPMODEL,
ISNULL(f."Matl Abbrev", f."Matl Descr") AS GRIPMATL, DMATERIAL AS DIRONGRIPMATL
FROM Player_Master.[Grip Detail] b
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] e ON b."Grip Mfgr Code" = e."Mfgr Code"
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] c ON b."Grip Brand Code" = c."Mfgr Code"
LEFT OUTER JOIN LKP.[Model Codes and Descr] d ON b."Grip Model Code" = d."Model Code"
LEFT OUTER JOIN LKP.[Material Codes and Descript] f ON b."Grip Mat'l Code" = f."Matl Code"

WHERE [Grip Equip Type] = 'IRON'

)


SELECT * FROM IRONTABLE
LEFT OUTER JOIN IRONSHAFTTABLE ON IRONNUMBER = SHAFTNUMBER
LEFT OUTER JOIN IRONGRIPTABLE ON IRONNUMBER = GRIPNUMBER


)
GO
