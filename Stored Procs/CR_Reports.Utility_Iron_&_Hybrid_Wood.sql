IF OBJECT_ID('CR_Reports.Utility_Iron_&_Hybrid_Wood') IS NOT NULL
    DROP PROCEDURE [CR_Reports].[Utility_Iron_&_Hybrid_Wood];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CR_Reports].[Utility_Iron_&_Hybrid_Wood]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


with PLAYERTABLE AS (
SELECT
--row_number() OVER(ORDER BY PLAYERNAME) AS BALLNUMBER,
PLAYERNAME, CATEGORY, EXTRA
FROM [Player_Master].[PLAYERNAMES]
WHERE "FIRSTDAY" = @FIRSTDAY AND SID = @SID
),


IRONTABLE as 
(SELECT
row_number() OVER(PARTITION BY PLAYERTABLE.PLAYERNAME ORDER BY "PKey") AS IRONNUMBER,
PLAYERTABLE.PLAYERNAME, PLAYERTABLE.CATEGORY, PLAYERTABLE.EXTRA,
IRONCLUBCODE, DCLUBCODE, IRONBRAND, DBRANDCODE, IRONMODEL, DMODELCODE, "PKey"
FROM PLAYERTABLE
INNER JOIN
(
SELECT "Name" AS PLAYERNAME, "Iron Club Code" AS IRONCLUBCODE, DCLUBCODE, a."Mfgr Descr" AS IRONBRAND, DBRANDCODE, b."Model Descr" AS IRONMODEL, DMODELCODE, "PKey"
FROM Player_Master.[Iron Detail]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a ON "Iron Brand Code" = a."Mfgr Code"
LEFT OUTER JOIN LKP.[Model Codes and Descr] b ON "Iron Model Code" = b."Model Code"
WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID AND "Iron Club Code" LIKE '%^%'
GROUP BY "Name", "Iron Club Code", a."Mfgr Descr", b."Model Descr", "PKey", DCLUBCODE, DBRANDCODE, DMODELCODE) AS I
ON PLAYERTABLE.PLAYERNAME = I.PLAYERNAME
),

WOODTABLE AS (
SELECT
row_number() OVER(PARTITION BY PLAYERTABLE.PLAYERNAME ORDER BY "PKey") AS WOODNUMBER,
PLAYERTABLE.PLAYERNAME, CATEGORY, EXTRA, WOODCLUBCODE, DCLUBCODE, WOODBRAND, DBRANDCODE, WOODMODEL, DMODELCODE, WOODSIZE, DSIZECODE, WOODMATL, DMATERIAL
FROM PLAYERTABLE
INNER JOIN
( SELECT
"Name" AS PLAYERNAME, "Wood Club Code" AS WOODCLUBCODE, DCLUBCODE,
ISNULL(a."Mfgr Abbrev", a."Mfgr Descr") AS WOODBRAND, DBRANDCODE,
ISNULL(b."Model Abbrev", b."Model Descr") AS WOODMODEL, DMODELCODE,
c."Size Descr" AS WOODSIZE, DSIZECODE,
ISNULL(d."Matl Abbrev", d."Matl Descr") AS WOODMATL, DMATERIAL,
"PKey"
FROM Player_Master.[Wood Detail]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a ON "Wood Brand Code" = a."Mfgr Code"
LEFT OUTER JOIN LKP.[Model Codes and Descr] b ON "Wood Model Code" = b."Model Code"
LEFT OUTER JOIN LKP.[Size Codes and Description] c ON "Wood Size Code" = "Size Code"
LEFT OUTER JOIN LKP.[Material Codes and Descript] d ON "Wood Mat'l Code" = "Matl Code"
WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID AND "Wood Club Code" = 'HYB'
) W
ON PLAYERTABLE.PLAYERNAME = W.PLAYERNAME
)


SELECT COALESCE(IRONTABLE.PLAYERNAME, WOODTABLE.PLAYERNAME) AS PLAYERNAME, COALESCE(IRONTABLE.CATEGORY, WOODTABLE.CATEGORY) AS CATEGORY,
COALESCE(IRONTABLE.EXTRA, WOODTABLE.EXTRA) AS EXTRA,
IRONCLUBCODE, IRONTABLE.DCLUBCODE, IRONBRAND, IRONTABLE.DBRANDCODE, IRONMODEL, IRONTABLE.DMODELCODE,
WOODCLUBCODE, WOODTABLE.DCLUBCODE, WOODBRAND, WOODTABLE.DBRANDCODE, WOODMODEL, WOODTABLE.DMODELCODE, WOODSIZE, WOODTABLE.DSIZECODE, WOODMATL, WOODTABLE.DMATERIAL

FROM IRONTABLE
FULL OUTER JOIN
WOODTABLE ON IRONTABLE.PLAYERNAME = WOODTABLE.PLAYERNAME AND IRONNUMBER = WOODNUMBER
Order By COALESCE(IRONTABLE.EXTRA, WOODTABLE.EXTRA), Coalesce(IRONTABLE.PLAYERNAME, WOODTABLE.PLAYERNAME), Coalesce(IRONNUMBER, WOODNUMBER)




/*
SELECT
--row_number() OVER(ORDER BY PLAYERNAME) AS BALLNUMBER,
PLAYERNAME, a."Mfgr Descr" AS BALLBRAND, b."Model Descr" AS BALLMODEL
FROM [Player_Master].[All]
LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] a ON BALLBRAND = a."Mfgr Code" 
LEFT OUTER JOIN [LKP].[Model Codes and Descr] b ON BALLMODEL = b."Model Code" 
WHERE "FIRST DAY" = @FIRSTDAY AND SID = @SID 
) BALLTABLE
LEFT OUTER JOIN
IRONTABLE ON BALLTABLE.PLAYERNAME = IRONTABLE.PLAYERNAME

FULL JOIN

WOODTABLE ON BALLTABLE.PLAYERNAME = WOODTABLE.PLAYERNAME AND coalesce(IRONNUMBER,0) = coalesce(WOODNUMBER,0)

*/


--, BALLNUMBER, IRONNUMBER, WOODNUMBER
/*FROM (
SELECT
row_number() OVER(ORDER BY PLAYERNAME) AS BALLNUMBER,
PLAYERNAME, a."Mfgr Descr" AS BALLBRAND, b."Model Descr" AS BALLMODEL
FROM [Player_Master].[All]
LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] a ON BALLBRAND = a."Mfgr Code" 
LEFT OUTER JOIN [LKP].[Model Codes and Descr] b ON BALLMODEL = b."Model Code" 
WHERE "FIRST DAY" = @FIRSTDAY AND SID = @SID 
) BALLTABLE
LEFT OUTER JOIN
(
SELECT
row_number() OVER(PARTITION BY "Name" ORDER BY "PKey") AS IRONNUMBER,
"Name" AS PLAYERNAME, "Iron Club Code" AS IRONCLUBCODE, a."Mfgr Descr" AS IRONBRAND, b."Model Descr" AS IRONMODEL, "PKey"
FROM Player_Master.[Iron Detail]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a ON "Iron Brand Code" = a."Mfgr Code"
LEFT OUTER JOIN LKP.[Model Codes and Descr] b ON "Iron Model Code" = b."Model Code"
WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID 
GROUP BY "Name", "Iron Club Code", a."Mfgr Descr", b."Model Descr", "PKey"
) IRONTABLE ON BALLTABLE.PLAYERNAME = IRONTABLE.PLAYERNAME
LEFT OUTER JOIN
(
SELECT
row_number() OVER(PARTITION BY "Name" ORDER BY "PKey") AS WOODNUMBER,
"Name" AS PLAYERNAME, "Wood Club Code" AS WOODCLUBCODE,
ISNULL(a."Mfgr Abbrev", a."Mfgr Descr") AS WOODBRAND,
ISNULL(b."Model Abbrev", b."Model Descr") AS WOODMODEL,
c."Size Descr" AS WOODSIZE,
ISNULL(d."Matl Abbrev", d."Matl Descr") AS WOODMATL,
"PKey"
FROM Player_Master.[Wood Detail]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a ON "Wood Brand Code" = a."Mfgr Code"
LEFT OUTER JOIN LKP.[Model Codes and Descr] b ON "Wood Model Code" = b."Model Code"
LEFT OUTER JOIN LKP.[Size Codes and Description] c ON "Wood Size Code" = "Size Code"
LEFT OUTER JOIN LKP.[Material Codes and Descript] d ON "Wood Mat'l Code" = "Matl Code"
WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID 
) WOODTABLE ON BALLTABLE.PLAYERNAME = WOODTABLE.PLAYERNAME AND COALESCE(IRONNUMBER, 0) = COALESCE(WOODNUMBER, 0)

GROUP BY BALLTABLE.PLAYERNAME, BALLBRAND, BALLMODEL, IRONCLUBCODE, IRONBRAND, IRONMODEL, WOODCLUBCODE, WOODBRAND, WOODMODEL, WOODSIZE, WOODMATL
--, BALLNUMBER, IRONNUMBER, WOODNUMBER
ORDER BY BALLTABLE.PLAYERNAME
*/




/*SELECT PLAYERNAME, a."Mfgr Descr" AS BALLBRAND, b."Model Descr" AS BALLMODEL,
"Iron Club Code" AS IRONCLUBCODE, e."Mfgr Descr" AS IRONBRAND, f."Model Descr" AS IRONMODEL,
 "Wood Club Code" AS WOODCLUBCODE,
ISNULL(a."Mfgr Abbrev", a."Mfgr Descr") AS WOODBRAND,
ISNULL(b."Model Abbrev", b."Model Descr") AS WOODMODEL,
c."Size Descr" AS WOODSIZE,
ISNULL(d."Matl Abbrev", d."Matl Descr") AS WOODMATL

FROM (SELECT * FROM [Player_Master].[All] WHERE "FIRST DAY" = @FIRSTDAY AND SID = @SID) x
LEFT OUTER JOIN (SELECT * FROM Player_Master.[Iron Detail] WHERE "First Day" = @FIRSTDAY and "Survey ID" = @SID) z ON PLAYERNAME = z.Name
LEFT OUTER JOIN (SELECT * FROM Player_Master.[Wood Detail] WHERE "First Day" = @FIRSTDAY and "Survey ID" = @SID) y ON PLAYERNAME = y.Name
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a ON "Wood Brand Code" = a."Mfgr Code"
LEFT OUTER JOIN LKP.[Model Codes and Descr] b ON "Wood Model Code" = b."Model Code"
LEFT OUTER JOIN LKP.[Size Codes and Description] c ON "Wood Size Code" = "Size Code"
LEFT OUTER JOIN LKP.[Material Codes and Descript] d ON "Wood Mat'l Code" = "Matl Code"
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] e ON "Iron Brand Code" = e."Mfgr Code"
LEFT OUTER JOIN LKP.[Model Codes and Descr] f ON "Iron Model Code" = f."Model Code"
LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] g ON BALLBRAND = g."Mfgr Code" 
LEFT OUTER JOIN [LKP].[Model Codes and Descr] h ON BALLMODEL = h."Model Code"


WHERE  x."FIRST DAY" = @FIRSTDAY AND SID = @SID */


END
GO
