DROP PROCEDURE IF EXISTS [Flash].[Get_TopSheet];
GO

-- =============================================

-- Author:		<Author,,Name>

-- Create date: <Create Date,,>

-- Description:	<Description,,>

-- =============================================

CREATE PROCEDURE [Flash].[Get_TopSheet]

	-- Add the parameters for the stored procedure here

	@COMPANY varchar(50),

	@TOURNAMENTNAME varchar(60),

	@FIRSTDAY varchar(15),

	@REPORTNAME varchar(35)

	

	--EXECUTE flash.get_topsheet 'TITLEIST', 'The Masters', '4/7/2011', 'Balls'

	

AS

BEGIN

    -- SET NOCOUNT ON added to prevent extra result sets from

	-- interfering with SELECT statements.

	SET NOCOUNT ON;



--DECLARE @FIRSTDAY DATE;

DECLARE @SID INT;



/*IF (@TOURNAMENTNAME IS NULL OR @TOURNAMENTNAME = '')

SELECT TOP 1 @TOURNAMENTNAME = [TOURNAMENT NAME], @FIRSTDAY = [FIRST DAY] FROM Player_master.[TOURNAMENTS_TABLE]

WHERE Year([FIRST DAY]) = YEAR(@FIRSTDAY)

ORDER BY [FIRST DAY] DESC;*/





--checks that it is a valid candidate for a flash report first

IF (SELECT ISFLASH FROM Player_master.[TOURNAMENTS_TABLE] WHERE "TOURNAMENT NAME" = @TOURNAMENTNAME AND [FIRST DAY] = @FIRSTDAY) <> 1 RETURN;





SELECT TOP 1 @SID = SID FROM Player_master.[TOURNAMENTS_TABLE] WHERE "TOURNAMENT NAME" = @TOURNAMENTNAME AND [FIRST DAY] = @FIRSTDAY;



IF (@REPORTNAME = 'Bags')



SELECT 

"Mfgr Descr" AS Brand, COUNT(BAGBRAND) AS "Count",

(SELECT COUNT(BAGBRAND) FROM [Input].[All] WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS TOTAL

  FROM [Input].[All]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = BAGBRAND

  WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(BAGBRAND) DESC, "Mfgr Descr" ASC;

      

ELSE IF (@REPORTNAME = 'Balls')

SELECT

"Mfgr Descr" AS Brand, COUNT(BALLBRAND) AS "Count", 

(SELECT COUNT(BALLBRAND) FROM [Input].[All] WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS TOTAL

  FROM [Input].[All]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = BALLBRAND

  WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(BALLBRAND) DESC, "Mfgr Descr" ASC;

     

      

ELSE IF (@REPORTNAME = 'Gloves')

  SELECT

"Mfgr Descr" AS Brand, COUNT(GLOVEBRAND) AS "Count",

(SELECT COUNT(GLOVEBRAND) FROM [Input].[All] WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS TOTAL

  FROM [Input].[All]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = GLOVEBRAND

  WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(GLOVEBRAND) DESC, "Mfgr Descr" ASC;

      

ELSE IF (@REPORTNAME = 'Caddies HeadGear')

  SELECT

"Mfgr Descr" AS Brand, COUNT(CADDYHEADBRAND) AS "Count",

(SELECT COUNT(CADDYHEADBRAND) FROM [Input].[All] WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS TOTAL

  FROM [Input].[All]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = CADDYHEADBRAND

  WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(CADDYHEADBRAND) DESC, "Mfgr Descr" ASC;

 

 

ELSE IF (@REPORTNAME = 'Shirt')

  SELECT

"Mfgr Descr" AS Brand, COUNT(SHIRTBRAND) AS "Count",

(SELECT COUNT(SHIRTBRAND) FROM [Input].[All] WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS TOTAL

  FROM [Input].[All]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = SHIRTBRAND

  WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(SHIRTBRAND) DESC, "Mfgr Descr" ASC;

      

      

ELSE IF (@REPORTNAME = 'Spikes')

  SELECT

COALESCE("Mfgr Descr", "Mfgr Code") AS Brand, COUNT(SPIKEBRAND) AS "Count",

(SELECT COUNT(SPIKEBRAND) FROM [Input].[All] WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS TOTAL

  FROM [Input].[All]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = SPIKEBRAND

  WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY

  GROUP BY COALESCE("Mfgr Descr", "Mfgr Code")

      ORDER BY COUNT(SPIKEBRAND) DESC, COALESCE("Mfgr Descr", "Mfgr Code") ASC;

      

      

ELSE IF (@REPORTNAME = 'Shoes')

SELECT

"Mfgr Descr" AS Brand, COUNT(SHOEBRAND) AS "Count",

(SELECT COUNT(SHOEBRAND) FROM [Input].[All] WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS TOTAL

  FROM [Input].[All]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = SHOEBRAND

  WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(SHOEBRAND) DESC, "Mfgr Descr" ASC;

      

ELSE IF (@REPORTNAME = 'Sunglasses')

SELECT

"Mfgr Descr" AS Brand, COUNT(GLASSESBRAND) AS "Count",

(SELECT COUNT(GLASSESBRAND) FROM [Input].[All] WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS TOTAL

  FROM [Input].[All]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = GLASSESBRAND

  WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(GLASSESBRAND) DESC, "Mfgr Descr" ASC;      





ELSE IF (@REPORTNAME = 'Driver')



SELECT a."Mfgr Descr" AS Brand, COUNT(a."Mfgr Descr") AS "Count",

(SELECT COUNT(BRAND) FROM [Input].[Wood] WHERE SID = @SID AND "First Day" = @FIRSTDAY and ISDRIVER = 1) AS TOTAL

 FROM

(SELECT * FROM [Input].[Wood] WHERE "First Day" = @FIRSTDAY AND SID = @SID and ISDRIVER = 1) c

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a ON BRAND = a."Mfgr Descr"

WHERE "First Day" = @FIRSTDAY AND SID = @SID

GROUP BY "Mfgr Descr"

ORDER BY COUNT(a."Mfgr Descr") DESC, a."Mfgr Descr" ASC;





ELSE IF (@REPORTNAME = 'Driver Shaft Brand')



SELECT f."Mfgr Descr" AS Brand, COUNT(f."Mfgr Descr") AS "Count",

(SELECT COUNT(BRAND) FROM [Input].[Wood] WHERE SID = @SID AND "First Day" = @FIRSTDAY and ISDRIVER = 1) AS TOTAL

  

FROM (

SELECT "PKey", PLAYERNAME, SID, "First Day", ISDRIVER, CLUBCODE, BRAND, DBRANDCODE, MODEL, DMODELCODE, SIZE, DSIZECODE, MATERIAL, DMATERIAL

FROM Input.[Wood]

WHERE "First Day" = @FIRSTDAY AND SID = @SID and ISDRIVER = 1

GROUP BY "PKey", PLAYERNAME, SID, "First Day", ISDRIVER, CLUBCODE, BRAND, DBRANDCODE, MODEL, DMODELCODE, SIZE, DSIZECODE, MATERIAL, DMATERIAL) a



LEFT OUTER JOIN (SELECT *

FROM Input.[Shaft] WHERE "First Day" = @FIRSTDAY AND SID = @SID AND SHAFTEQUIPTYPE = 'WOOD') b

ON a.PLAYERNAME = b.PLAYERNAME and a.CLUBCODE = b.SHAFTCLUBCODE and a.PKey = b.PKey



LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] f ON SHAFTBRAND = f."Mfgr Descr"

WHERE a."First Day" = @FIRSTDAY AND a.SID = @SID and a.ISDRIVER = 1

GROUP BY "Mfgr Descr"

ORDER BY COUNT(f."Mfgr Descr") DESC, f."Mfgr Descr" ASC;



ELSE IF (@REPORTNAME = 'Driver Shaft Material')



SELECT f.[Matl Descr] AS Brand, COUNT(f.[Matl Descr]) AS "Count",

(SELECT COUNT(BRAND) FROM [Input].[Wood] WHERE SID = @SID AND "First Day" = @FIRSTDAY and ISDRIVER = 1) AS TOTAL

  

FROM (

SELECT "PKey", PLAYERNAME, SID, "First Day", ISDRIVER, CLUBCODE, BRAND, DBRANDCODE, MODEL, DMODELCODE, SIZE, DSIZECODE, MATERIAL, DMATERIAL

FROM Input.[Wood]

WHERE "First Day" = @FIRSTDAY AND SID = @SID and ISDRIVER = 1

GROUP BY "PKey", PLAYERNAME, SID, "First Day", ISDRIVER, CLUBCODE, BRAND, DBRANDCODE, MODEL, DMODELCODE, SIZE, DSIZECODE, MATERIAL, DMATERIAL) a



LEFT OUTER JOIN (SELECT *

FROM Input.[Shaft] WHERE "First Day" = @FIRSTDAY AND SID = @SID AND SHAFTEQUIPTYPE = 'WOOD') b

ON a.PLAYERNAME = b.PLAYERNAME and a.CLUBCODE = b.SHAFTCLUBCODE and a.PKey = b.PKey



LEFT OUTER JOIN LKP.[Material Codes and Descript] f ON SHAFTMATL = f.[Matl Descr]

WHERE a."First Day" = @FIRSTDAY AND a.SID = @SID and a.ISDRIVER = 1

GROUP BY [Matl Descr]

ORDER BY COUNT(f.[Matl Descr]) DESC, f.[Matl Descr] ASC;



ELSE IF (@REPORTNAME = 'Driver Shaft Manufacturer')



SELECT f."Mfgr Descr" AS Brand, COUNT(f."Mfgr Descr") AS "Count",

(SELECT COUNT(BRAND) FROM [Input].[Wood] WHERE SID = @SID AND "First Day" = @FIRSTDAY and ISDRIVER = 1) AS TOTAL

  

FROM (

SELECT "PKey", PLAYERNAME, SID, "First Day", ISDRIVER, CLUBCODE, BRAND, DBRANDCODE, MODEL, DMODELCODE, SIZE, DSIZECODE, MATERIAL, DMATERIAL

FROM Input.[Wood]

WHERE "First Day" = @FIRSTDAY AND SID = @SID and ISDRIVER = 1

GROUP BY "PKey", PLAYERNAME, SID, "First Day", ISDRIVER, CLUBCODE, BRAND, DBRANDCODE, MODEL, DMODELCODE, SIZE, DSIZECODE, MATERIAL, DMATERIAL) a



LEFT OUTER JOIN (SELECT *

FROM Input.[Shaft] WHERE "First Day" = @FIRSTDAY AND SID = @SID AND SHAFTEQUIPTYPE = 'WOOD') b

ON a.PLAYERNAME = b.PLAYERNAME and a.CLUBCODE = b.SHAFTCLUBCODE and a.PKey = b.PKey



LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] f ON SHAFTMFGR = f."Mfgr Descr"

WHERE a."First Day" = @FIRSTDAY AND a.SID = @SID and a.ISDRIVER = 1

GROUP BY "Mfgr Descr"

ORDER BY COUNT(f."Mfgr Descr") DESC, f."Mfgr Descr" ASC;





ELSE IF (@REPORTNAME = 'All Woods')

      SELECT

"Mfgr Descr" AS Brand, COUNT(BRAND) AS "Count",

(SELECT COUNT(BRAND) FROM [Input].[Wood] WHERE SID = @SID AND "First Day" = @FIRSTDAY) AS TOTAL

  FROM [Input].[Wood]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = BRAND

  WHERE SID= @SID AND [First Day] = @FIRSTDAY

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(BRAND) DESC, "Mfgr Descr" ASC;

            



ELSE IF (@REPORTNAME = 'Fairway Including Hybrid')

SELECT b."Mfgr Descr" AS Brand, COUNT(b."Mfgr Descr") AS "Count",

(SELECT COUNT(BRAND) FROM [Input].[Wood] WHERE SID = @SID AND "First Day" = @FIRSTDAY and ISDRIVER=0) AS TOTAL

 FROM [Input].[Wood] a

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] b ON BRAND = b."Mfgr Descr"

WHERE "First Day" = @FIRSTDAY AND SID = @SID AND isDRIVER = 0

GROUP BY "Mfgr Descr"

ORDER BY COUNT(b."Mfgr Descr") DESC, b."Mfgr Descr" ASC;

      

      

ELSE IF (@REPORTNAME = 'Fairway wo Hybrid')

SELECT b."Mfgr Descr" AS Brand, COUNT(b."Mfgr Descr") AS "Count",

(SELECT COUNT(BRAND) FROM [Input].[Wood] WHERE SID = @SID AND "First Day" = @FIRSTDAY  AND ISDRIVER = 0 and [CLUBCODE] <> 'HYB') AS TOTAL

 FROM [Input].[Wood] a

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] b ON BRAND = b."Mfgr Descr"

WHERE "First Day" = @FIRSTDAY AND SID = @SID AND isDRIVER = 0 AND a.CLUBCODE <> 'HYB'

GROUP BY "Mfgr Descr"

ORDER BY COUNT(b."Mfgr Descr") DESC, b."Mfgr Descr" ASC;

      

      

ELSE IF (@REPORTNAME = 'Hybrid Woods')

      SELECT

"Mfgr Descr" AS Brand, COUNT(BRAND) AS "Count",

(SELECT COUNT(BRAND) FROM [Input].[Wood] WHERE SID = @SID AND "First Day" = @FIRSTDAY and CLUBCODE = 'HYB') AS TOTAL

  FROM [Input].[Wood]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = BRAND

  WHERE SID= @SID AND [First Day] = @FIRSTDAY AND CLUBCODE = 'HYB'

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(BRAND) DESC, "Mfgr Descr" ASC;            

            

            

ELSE IF (@REPORTNAME = 'Hybrid Wood Shaft')

      SELECT

"Mfgr Descr" AS Brand, COUNT(SHAFTBRAND) AS "Count",

(SELECT COUNT(SHAFTBRAND) FROM [Input].[Shaft] WHERE SID = @SID AND "First Day" = @FIRSTDAY and SHAFTEQUIPTYPE= 'WOOD' and SHAFTCLUBCODE = 'HYB') AS TOTAL

  FROM [Input].[Shaft]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = SHAFTBRAND

  WHERE SID= @SID AND [First Day] = @FIRSTDAY and SHAFTEQUIPTYPE= 'WOOD' and SHAFTCLUBCODE = 'HYB'

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(SHAFTBRAND) DESC, "Mfgr Descr" ASC;    





ELSE IF (@REPORTNAME = 'Hybrid Wood Shaft Material')

      SELECT

"Matl Descr" AS Brand, COUNT(SHAFTMATL) AS "Count",

(SELECT COUNT(SHAFTMATL) FROM [Input].[Shaft] WHERE SID = @SID AND "First Day" = @FIRSTDAY AND SHAFTEQUIPTYPE = 'WOOD' and SHAFTCLUBCODE = 'HYB') AS TOTAL

  FROM [Input].[Shaft]

  LEFT OUTER JOIN [LKP].[Material Codes and Descript] ON "Matl Descr" = SHAFTMATL 

  WHERE SID= @SID AND [First Day] = @FIRSTDAY AND SHAFTEQUIPTYPE = 'WOOD' and SHAFTCLUBCODE = 'HYB'

  GROUP BY "Matl Descr"

      ORDER BY COUNT(SHAFTMATL) DESC, "Matl Descr" ASC;





ELSE IF (@REPORTNAME = 'Hybrid Wood Shaft Manufacturer')

      SELECT

"Mfgr Descr" AS Brand, COUNT(SHAFTMFGR) AS "Count",

(SELECT COUNT(SHAFTMFGR) FROM [Input].[Shaft] WHERE SID = @SID AND "First Day" = @FIRSTDAY AND SHAFTEQUIPTYPE = 'WOOD' and SHAFTCLUBCODE = 'HYB') AS TOTAL

  FROM [Input].[Shaft]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = SHAFTMFGR 

  WHERE SID= @SID AND [First Day] = @FIRSTDAY AND SHAFTEQUIPTYPE = 'WOOD' and SHAFTCLUBCODE = 'HYB'

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(SHAFTMFGR) DESC, "Mfgr Descr" ASC;





ELSE IF (@REPORTNAME = 'Hybrid Wood Shaft Brand')

      SELECT

"Mfgr Descr" AS Brand, COUNT(SHAFTBRAND) AS "Count",

(SELECT COUNT(SHAFTBRAND) FROM [Input].[Shaft] WHERE SID = @SID AND "First Day" = @FIRSTDAY AND SHAFTEQUIPTYPE = 'WOOD' and SHAFTCLUBCODE = 'HYB') AS TOTAL

  FROM [Input].[Shaft]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = SHAFTBRAND

  WHERE SID= @SID AND [First Day] = @FIRSTDAY AND SHAFTEQUIPTYPE = 'WOOD' and SHAFTCLUBCODE = 'HYB'

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(SHAFTBRAND) DESC, "Mfgr Descr" ASC;







      

ELSE IF (@REPORTNAME = 'Headgear')

SELECT

"Mfgr Descr" AS Brand, COUNT(HEADGEARBRAND) AS "Count",

(SELECT COUNT(HEADGEARBRAND) FROM [Input].[All] WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS TOTAL

  FROM [Input].[All]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = HEADGEARBRAND

  WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(HEADGEARBRAND) DESC, "Mfgr Descr" ASC;





ELSE IF (@REPORTNAME = 'Iron')



WITH IRONSETTABLE AS (

SELECT PLAYERNAME, BRAND as BRAND FROM Input.[Iron] WHERE SID = @SID AND "First Day" = @FIRSTDAY and isset = 1 group by PLAYERNAME, BRAND

)



      SELECT

"Mfgr Descr" AS Brand, COUNT(BRAND) AS "Count",

(SELECT COUNT(BRAND) FROM IRONSETTABLE) AS TOTAL

  FROM IRONSETTABLE a

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = BRAND

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(BRAND) DESC, "Mfgr Descr" ASC;





ELSE IF (@REPORTNAME = 'Utility Iron')

 select *, SUM([COUNT]) over() as TOTAL from (

 SELECT "Mfgr Descr" AS Brand, 

		sum(case when CLUBCODE like '%-%' then (cast(SUBSTRING(clubcode,3,1) AS tinyint) - 

												cast(SUBSTRING(clubcode,1,1) AS tinyint) +1)

				 else 1 end) AS "Count"

  FROM [Input].[Iron]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = BRAND

  WHERE SID= @SID AND [First Day] = @FIRSTDAY AND CLUBCODE LIKE '%^%'

  GROUP BY "Mfgr Descr") a

  ORDER BY [COUNT] DESC, Brand ASC;

      



ELSE IF (@REPORTNAME = 'Putter')

      SELECT

"Mfgr Descr" AS Brand, COUNT(BRAND) AS "Count",

(SELECT COUNT(BRAND) FROM [Input].[Putter] WHERE SID = @SID AND "First Day" = @FIRSTDAY) AS TOTAL

  FROM [Input].[Putter]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = BRAND

  WHERE SID= @SID AND [First Day] = @FIRSTDAY

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(BRAND) DESC, "Mfgr Descr" ASC;







ELSE IF (@REPORTNAME = 'Shaft')

      SELECT

"Mfgr Descr" AS Brand, COUNT(SHAFTBRAND) AS "Count",

(SELECT COUNT(SHAFTBRAND) FROM [Input].[Shaft] WHERE SID = @SID AND "First Day" = @FIRSTDAY) AS TOTAL

  FROM [Input].[Shaft]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = SHAFTBRAND

  WHERE SID= @SID AND [First Day] = @FIRSTDAY

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(SHAFTBRAND) DESC, "Mfgr Descr" ASC;





ELSE IF (@REPORTNAME = 'Iron Shaft Material')

WITH IRONSETTABLE_SHAFT AS (

SELECT a.PLAYERNAME, CLUBCODE, BRAND, MODEL, SHAFTMFGR, SHAFTBRAND, SHAFTMODEL, SHAFTMATL

FROM Input.[Iron] a

LEFT OUTER JOIN Input.[Shaft] b ON a.PLAYERNAME = b.PLAYERNAME and a.[First Day]= b.[First Day] and a.SID = b.SID and a.CLUBCODE = b.SHAFTCLUBCODE

WHERE a.SID = @SID AND a."First Day" = @FIRSTDAY and SHAFTEQUIPTYPE= 'IRON' and isset = 1

group by a.PLAYERNAME, CLUBCODE, BRAND, MODEL, SHAFTMFGR, SHAFTBRAND, SHAFTMODEL, SHAFTMATL

),



IRONSHAFTMATLTABLE AS (

SELECT PLAYERNAME, BRAND, SHAFTMATL FROM IRONSETTABLE_SHAFT GROUP BY PLAYERNAME, BRAND, SHAFTMATL

)





      SELECT

"Matl Descr" AS Brand, COUNT(SHAFTMATL) AS "Count",

(SELECT COUNT(SHAFTMATL) FROM IRONSHAFTMATLTABLE) AS TOTAL

  FROM IRONSHAFTMATLTABLE

  LEFT OUTER JOIN [LKP].[Material Codes and Descript] ON "Matl Descr" = SHAFTMATL 

  GROUP BY "Matl Descr"

      ORDER BY COUNT(SHAFTMATL) DESC, "Matl Descr" ASC;





ELSE IF (@REPORTNAME = 'Iron Shaft Manufacturer')

WITH IRONSETTABLE_SHAFT AS (

SELECT a.PLAYERNAME, CLUBCODE, BRAND, MODEL, SHAFTMFGR, SHAFTBRAND, SHAFTMODEL, SHAFTMATL

FROM Input.[Iron] a

LEFT OUTER JOIN Input.[Shaft] b ON a.PLAYERNAME = b.PLAYERNAME and a.[First Day]= b.[First Day] and a.SID = b.SID and a.CLUBCODE = b.SHAFTCLUBCODE

WHERE a.SID = @SID AND a."First Day" = @FIRSTDAY and SHAFTEQUIPTYPE= 'IRON' and isset = 1

group by a.PLAYERNAME, CLUBCODE, BRAND, MODEL, SHAFTMFGR, SHAFTBRAND, SHAFTMODEL, SHAFTMATL

),

IRONSHAFTMFGRTABLE AS(

SELECT PLAYERNAME, SHAFTMFGR from IRONSETTABLE_SHAFT Group by PLAYERNAME, SHAFTMFGR

)

      SELECT

"Mfgr Descr" AS Brand, COUNT(SHAFTMFGR) AS "Count",

(SELECT COUNT(SHAFTMFGR) FROM IRONSHAFTMFGRTABLE) AS TOTAL

  FROM IRONSHAFTMFGRTABLE

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = SHAFTMFGR 

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(SHAFTMFGR) DESC, "Mfgr Descr" ASC;





ELSE IF (@REPORTNAME = 'Iron Shaft Brand')

WITH IRONSETTABLE_SHAFT AS (

SELECT a.PLAYERNAME, CLUBCODE, BRAND, MODEL, SHAFTMFGR, SHAFTBRAND, SHAFTMODEL, SHAFTMATL

FROM Input.[Iron] a

LEFT OUTER JOIN Input.[Shaft] b ON a.PLAYERNAME = b.PLAYERNAME and a.[First Day]= b.[First Day] and a.SID = b.SID and a.CLUBCODE = b.SHAFTCLUBCODE

WHERE a.SID = @SID AND a."First Day" = @FIRSTDAY and SHAFTEQUIPTYPE= 'IRON' and isset = 1

group by a.PLAYERNAME, CLUBCODE, BRAND, MODEL, SHAFTMFGR, SHAFTBRAND, SHAFTMODEL, SHAFTMATL

),

IRONSHAFTBRANDTABLE AS(

SELECT PLAYERNAME, SHAFTBRAND from IRONSETTABLE_SHAFT Group by PLAYERNAME, SHAFTBRAND

)

      SELECT

"Mfgr Descr" AS Brand, COUNT(SHAFTBRAND) AS "Count",

(SELECT COUNT(SHAFTBRAND) FROM IRONSHAFTBRANDTABLE) AS TOTAL

  FROM IRONSHAFTBRANDTABLE

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = SHAFTBRAND

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(SHAFTBRAND) DESC, "Mfgr Descr" ASC;





ELSE IF (@REPORTNAME = 'Utility Iron Shaft Material')

WITH IRONSETTABLE_SHAFT AS (

SELECT a.PLAYERNAME, CLUBCODE, BRAND, MODEL, SHAFTMFGR, SHAFTBRAND, SHAFTMODEL, SHAFTMATL

FROM Input.[Iron] a 

LEFT OUTER JOIN Input.[Shaft] b ON a.PLAYERNAME = b.PLAYERNAME and a.[First Day]= b.[First Day] and a.SID = b.SID and a.CLUBCODE = b.SHAFTCLUBCODE

WHERE a.SID = @SID AND a."First Day" = @FIRSTDAY and SHAFTEQUIPTYPE= 'IRON' and CLUBCODE like '%^%'

group by a.PLAYERNAME, CLUBCODE, BRAND, MODEL, SHAFTMFGR, SHAFTBRAND, SHAFTMODEL, SHAFTMATL

),



IRONSHAFTMATLTABLE AS (

SELECT PLAYERNAME, BRAND, SHAFTMATL FROM IRONSETTABLE_SHAFT GROUP BY PLAYERNAME, BRAND, SHAFTMATL

)





      SELECT

"Matl Descr" AS Brand, COUNT(SHAFTMATL) AS "Count",

(SELECT COUNT(SHAFTMATL) FROM IRONSHAFTMATLTABLE) AS TOTAL

  FROM IRONSHAFTMATLTABLE

  LEFT OUTER JOIN [LKP].[Material Codes and Descript] ON "Matl Descr" = SHAFTMATL 

  GROUP BY "Matl Descr"

      ORDER BY COUNT(SHAFTMATL) DESC, "Matl Descr" ASC;





ELSE IF (@REPORTNAME = 'Utility Iron Shaft Manufacturer')

WITH IRONSETTABLE_SHAFT AS (

SELECT a.PLAYERNAME, CLUBCODE, BRAND, MODEL, SHAFTMFGR, SHAFTBRAND, SHAFTMODEL, SHAFTMATL

FROM Input.[Iron] a

LEFT OUTER JOIN Input.[Shaft] b ON a.PLAYERNAME = b.PLAYERNAME and a.[First Day]= b.[First Day] and a.SID = b.SID and a.CLUBCODE = b.SHAFTCLUBCODE

WHERE a.SID = @SID AND a."First Day" = @FIRSTDAY and SHAFTEQUIPTYPE= 'IRON' and CLUBCODE like '%^%'

group by a.PLAYERNAME, CLUBCODE, BRAND, MODEL, SHAFTMFGR, SHAFTBRAND, SHAFTMODEL, SHAFTMATL

),

IRONSHAFTMFGRTABLE AS(

SELECT PLAYERNAME, SHAFTMFGR from IRONSETTABLE_SHAFT Group by PLAYERNAME, SHAFTMFGR

)

      SELECT

"Mfgr Descr" AS Brand, COUNT(SHAFTMFGR) AS "Count",

(SELECT COUNT(SHAFTMFGR) FROM IRONSHAFTMFGRTABLE) AS TOTAL

  FROM IRONSHAFTMFGRTABLE

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = SHAFTMFGR 

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(SHAFTMFGR) DESC, "Mfgr Descr" ASC;





ELSE IF (@REPORTNAME = 'Utility Iron Shaft Brand')

WITH IRONSETTABLE_SHAFT AS (

SELECT a.PLAYERNAME, CLUBCODE, BRAND, MODEL, SHAFTMFGR, SHAFTBRAND, SHAFTMODEL, SHAFTMATL

FROM Input.[Iron] a

LEFT OUTER JOIN Input.[Shaft] b ON a.PLAYERNAME = b.PLAYERNAME and a.[First Day]= b.[First Day] and a.SID = b.SID and a.CLUBCODE = b.SHAFTCLUBCODE

WHERE a.SID = @SID AND a."First Day" = @FIRSTDAY and SHAFTEQUIPTYPE= 'IRON' and CLUBCODE like '%^%'

group by a.PLAYERNAME, CLUBCODE, BRAND, MODEL, SHAFTMFGR, SHAFTBRAND, SHAFTMODEL, SHAFTMATL

),

IRONSHAFTBRANDTABLE AS(

SELECT PLAYERNAME, SHAFTBRAND from IRONSETTABLE_SHAFT Group by PLAYERNAME, SHAFTBRAND

)

      SELECT

"Mfgr Descr" AS Brand, COUNT(SHAFTBRAND) AS "Count",

(SELECT COUNT(SHAFTBRAND) FROM IRONSHAFTBRANDTABLE) AS TOTAL

  FROM IRONSHAFTBRANDTABLE

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = SHAFTBRAND

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(SHAFTBRAND) DESC, "Mfgr Descr" ASC;





ELSE IF (@REPORTNAME = 'Wood Shaft Material')

      SELECT

"Matl Descr" AS Brand, COUNT(SHAFTMATL) AS "Count",

(SELECT COUNT(SHAFTMATL) FROM [Input].[Shaft] WHERE SID = @SID AND "First Day" = @FIRSTDAY AND SHAFTEQUIPTYPE = 'WOOD') AS TOTAL

  FROM [Input].[Shaft]

  LEFT OUTER JOIN [LKP].[Material Codes and Descript] ON "Matl Descr" = SHAFTMATL 

  WHERE SID= @SID AND [First Day] = @FIRSTDAY AND SHAFTEQUIPTYPE = 'WOOD'

  GROUP BY "Matl Descr"

      ORDER BY COUNT(SHAFTMATL) DESC, "Matl Descr" ASC;





ELSE IF (@REPORTNAME = 'Wood Shaft Manufacturer')

      SELECT

"Mfgr Descr" AS Brand, COUNT(SHAFTMFGR) AS "Count",

(SELECT COUNT(SHAFTMFGR) FROM [Input].[Shaft] WHERE SID = @SID AND "First Day" = @FIRSTDAY AND SHAFTEQUIPTYPE = 'WOOD') AS TOTAL

  FROM [Input].[Shaft]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = SHAFTMFGR 

  WHERE SID= @SID AND [First Day] = @FIRSTDAY AND SHAFTEQUIPTYPE = 'WOOD'

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(SHAFTMFGR) DESC, "Mfgr Descr" ASC;





ELSE IF (@REPORTNAME = 'Wood Shaft Brand')

      SELECT

"Mfgr Descr" AS Brand, COUNT(SHAFTBRAND) AS "Count",

(SELECT COUNT(SHAFTBRAND) FROM [Input].[Shaft] WHERE SID = @SID AND "First Day" = @FIRSTDAY AND SHAFTEQUIPTYPE = 'WOOD') AS TOTAL

  FROM [Input].[Shaft]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = SHAFTBRAND

  WHERE SID= @SID AND [First Day] = @FIRSTDAY AND SHAFTEQUIPTYPE = 'WOOD'

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(SHAFTBRAND) DESC, "Mfgr Descr" ASC;

      

      

ELSE IF (@REPORTNAME = 'Wedge Shaft Material')

      SELECT

"Matl Descr" AS Brand, COUNT(SHAFTMATL) AS "Count",

(SELECT COUNT(SHAFTMATL) FROM [Input].[Shaft] WHERE SID = @SID AND "First Day" = @FIRSTDAY AND SHAFTEQUIPTYPE = 'WEDG') AS TOTAL

  FROM [Input].[Shaft]

  LEFT OUTER JOIN [LKP].[Material Codes and Descript] ON "Matl Descr" = SHAFTMATL 

  WHERE SID= @SID AND [First Day] = @FIRSTDAY AND SHAFTEQUIPTYPE = 'WEDG'

  GROUP BY "Matl Descr"

      ORDER BY COUNT(SHAFTMATL) DESC, "Matl Descr" ASC;





ELSE IF (@REPORTNAME = 'Wedge Shaft Manufacturer')

      SELECT

"Mfgr Descr" AS Brand, COUNT(SHAFTMFGR) AS "Count",

(SELECT COUNT(SHAFTMFGR) FROM [Input].[Shaft] WHERE SID = @SID AND "First Day" = @FIRSTDAY AND SHAFTEQUIPTYPE = 'WEDG') AS TOTAL

  FROM [Input].[Shaft]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = SHAFTMFGR 

  WHERE SID= @SID AND [First Day] = @FIRSTDAY AND SHAFTEQUIPTYPE = 'WEDG'

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(SHAFTMFGR) DESC, "Mfgr Descr" ASC;





ELSE IF (@REPORTNAME = 'Wedge Shaft Brand')

      SELECT

"Mfgr Descr" AS Brand, COUNT(SHAFTBRAND) AS "Count",

(SELECT COUNT(SHAFTBRAND) FROM [Input].[Shaft] WHERE SID = @SID AND "First Day" = @FIRSTDAY AND SHAFTEQUIPTYPE = 'WEDG') AS TOTAL

  FROM [Input].[Shaft]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = SHAFTBRAND

  WHERE SID= @SID AND [First Day] = @FIRSTDAY AND SHAFTEQUIPTYPE = 'WEDG'

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(SHAFTBRAND) DESC, "Mfgr Descr" ASC;      





ELSE IF (@REPORTNAME = 'Wedge VS. Shaft Manufacturer')

with cte_Wedge as (SELECT w.BRAND, 

							s.[Shaftmfgr], 

							w.[INDEX]

					FROM Input.Wedge w

					inner join input.Shaft s 

					on w.[SID] = s.[SID] and

						w.[First Day] = s.[First Day] and

						w.playerName = s.playerName and

						w.PKey = s.PKey and

						s.[ShaftEquipType] = 'WEDG'

					WHERE w.[First Day] = @FirstDay AND w.[SID] = @Sid)



SELECT a.BRAND AS [Wedge Brand], 

		a.SHAFTMFGR AS [Shaft Manufacturer],

		COUNT(*) AS "Count",

		sum(COUNT(*)) over () AS "Total"

FROM cte_Wedge as a

GROUP BY a.BRAND, a.SHAFTmfgr

ORDER BY [Wedge Brand], COUNT(*) desc, a.SHAFTmfgr;



ELSE IF (@REPORTNAME = 'Wedge VS. Shaft Brand')

with cte_Wedge as (SELECT w.BRAND, 

							s.[ShaftBrand], 

							w.[INDEX]

					FROM Input.Wedge w

					inner join input.Shaft s 

					on w.[SID] = s.[SID] and

						w.[First Day] = s.[First Day] and

						w.playerName = s.playerName and

						w.PKey = s.PKey and

						s.[ShaftEquipType] = 'WEDG'

					WHERE w.[First Day] = @FirstDay AND w.[SID] = @Sid)



SELECT a.BRAND AS [Wedge Brand], 

		a.SHAFTBRAND AS [Shaft Brand],

		COUNT(*) AS "Count",

		sum(COUNT(*)) over () AS "Total"

FROM cte_Wedge as a

GROUP BY a.BRAND, a.SHAFTBRAND 

ORDER BY [Wedge Brand], COUNT(*) desc, a.SHAFTBRAND;









ELSE IF (@REPORTNAME = 'Utility Iron VS. Shaft Brand')

with cte_wood as (SELECT i.BRAND, 

							s.[ShaftBrand], 

							i.PLAYERNAME 

					FROM Input.[Iron] i

					inner join input.Shaft s 

					on i.[SID] = s.[SID] and

						i.[First Day] = s.[First Day] and

						i.playerName = s.playerName and

						i.PKey = s.PKey and

						s.[ShaftEquipType] = 'IRON'

					WHERE i.[First Day] = @FirstDay AND i.[SID] = @Sid and i.CLUBCODE like '%^%')



SELECT a.BRAND AS [Iron Brand], 

		a.SHAFTBRAND AS [Shaft Brand],

		COUNT(*) AS "Count",

		sum(COUNT(*)) over () AS "Total"

FROM cte_wood as a

GROUP BY a.BRAND, a.SHAFTBRAND 

ORDER BY [iron Brand], COUNT(*) desc, a.SHAFTBRAND;





ELSE IF (@REPORTNAME = 'Utility Iron VS. Shaft Manufacturer')

with cte_wood as (SELECT i.BRAND, 

							s.[SHAFTMFGR] , 

							i.PLAYERNAME 

					FROM Input.[Iron] i

					inner join input.Shaft s 

					on i.[SID] = s.[SID] and

						i.[First Day] = s.[First Day] and

						i.playerName = s.playerName and

						i.PKey = s.PKey and

						s.[ShaftEquipType] = 'IRON'

					WHERE i.[First Day] = @FirstDay AND i.[SID] = @Sid and i.CLUBCODE like '%^%')



SELECT a.BRAND AS [Iron Brand], 

		a.SHAFTMFGR AS [Shaft Brand],

		COUNT(*) AS "Count",

		sum(COUNT(*)) over () AS "Total"

FROM cte_wood as a

GROUP BY a.BRAND, a.SHAFTMFGR 

ORDER BY [iron Brand], COUNT(*) desc, a.SHAFTMFGR;



ELSE IF (@REPORTNAME = 'Iron VS. Shaft Brand')

with cte_wood as (SELECT distinct i.BRAND, 

							s.[ShaftBrand], 

							i.PLAYERNAME 

					FROM Input.[Iron] i

					inner join input.Shaft s 

					on i.[SID] = s.[SID] and

						i.[First Day] = s.[First Day] and

						i.playerName = s.playerName and

						i.PKey = s.PKey and

						s.[ShaftEquipType] = 'IRON'

					WHERE i.[First Day] = @FirstDay AND i.[SID] = @Sid and i.ISSET = 1)



SELECT a.BRAND AS [Iron Brand], 

		a.SHAFTBRAND AS [Shaft Brand],

		COUNT(*) AS "Count",

		sum(COUNT(*)) over () AS "Total"

FROM cte_wood as a

GROUP BY a.BRAND, a.SHAFTBRAND 

ORDER BY [iron Brand], COUNT(*) desc, a.SHAFTBRAND;





ELSE IF (@REPORTNAME = 'Iron VS. Shaft Manufacturer')

with cte_wood as (SELECT distinct i.BRAND, 

							s.[SHAFTMFGR] , 

							i.PLAYERNAME 

					FROM Input.[Iron] i

					inner join input.Shaft s 

					on i.[SID] = s.[SID] and

						i.[First Day] = s.[First Day] and

						i.playerName = s.playerName and

						i.PKey = s.PKey and

						s.[ShaftEquipType] = 'IRON'

					WHERE i.[First Day] = @FirstDay AND i.[SID] = @Sid and i.ISSET = 1)



SELECT a.BRAND AS [Iron Brand], 

		a.SHAFTMFGR AS [Shaft Manufacturer],

		COUNT(*) AS "Count",

		sum(COUNT(*)) over () AS "Total"

FROM cte_wood as a

GROUP BY a.BRAND, a.SHAFTMFGR 

ORDER BY [iron Brand], COUNT(*) desc, a.SHAFTMFGR;





ELSE IF (@REPORTNAME = 'Driver VS. Shaft Manufacturer')

with cte_wood as (SELECT w.BRAND, 

							s.[Shaftmfgr], 

							w.[INDEX]

					FROM Input.[Wood] w

					inner join input.Shaft s 

					on w.[SID] = s.[SID] and

						w.[First Day] = s.[First Day] and

						w.playerName = s.playerName and

						w.PKey = s.PKey and

						s.[ShaftEquipType] = 'WOOD'

					WHERE w.[First Day] = @FirstDay AND w.[SID] = @Sid and w.ISDRIVER = 1)



SELECT a.BRAND AS [Wood Brand], 

		a.SHAFTMFGR AS [Shaft Manufacturer],

		COUNT(*) AS "Count",

		sum(COUNT(*)) over () AS "Total"

FROM cte_wood as a

GROUP BY a.BRAND, a.SHAFTmfgr

ORDER BY [Wood Brand], COUNT(*) desc, a.SHAFTmfgr;



ELSE IF (@REPORTNAME = 'Driver VS. Shaft Brand')

with cte_wood as (SELECT w.BRAND, 

							s.[ShaftBrand], 

							w.[INDEX]

					FROM Input.[Wood] w

					inner join input.Shaft s 

					on w.[SID] = s.[SID] and

						w.[First Day] = s.[First Day] and

						w.playerName = s.playerName and

						w.PKey = s.PKey and

						s.[ShaftEquipType] = 'WOOD'

					WHERE w.[First Day] = @FirstDay AND w.[SID] = @Sid and w.ISDRIVER = 1)



SELECT a.BRAND AS [Wood Brand], 

		a.SHAFTBRAND AS [Shaft Brand],

		COUNT(*) AS "Count",

		sum(COUNT(*)) over () AS "Total"

FROM cte_wood as a

GROUP BY a.BRAND, a.SHAFTBRAND 

ORDER BY [Wood Brand], COUNT(*) desc, a.SHAFTBRAND;





ELSE IF (@REPORTNAME = 'Hybrid Wood VS. Shaft Manufacturer')

with cte_wood as (SELECT w.BRAND, 

							s.[Shaftmfgr], 

							w.[INDEX]

					FROM Input.[Wood] w

					inner join input.Shaft s 

					on w.[SID] = s.[SID] and

						w.[First Day] = s.[First Day] and

						w.playerName = s.playerName and

						w.PKey = s.PKey and

						s.[ShaftEquipType] = 'WOOD'

					WHERE w.[First Day] = @FirstDay AND w.[SID] = @Sid and w.CLUBCODE = 'HYB')



SELECT a.BRAND AS [Wood Brand], 

		a.SHAFTMFGR AS [Shaft Manufacturer],

		COUNT(*) AS "Count",

		sum(COUNT(*)) over () AS "Total"

FROM cte_wood as a

GROUP BY a.BRAND, a.SHAFTmfgr

ORDER BY [Wood Brand], COUNT(*) desc, a.SHAFTmfgr;



ELSE IF (@REPORTNAME = 'Hybrid Wood VS. Shaft Brand')

with cte_wood as (SELECT w.BRAND, 

							s.[ShaftBrand], 

							w.[INDEX]

					FROM Input.[Wood] w

					inner join input.Shaft s 

					on w.[SID] = s.[SID] and

						w.[First Day] = s.[First Day] and

						w.playerName = s.playerName and

						w.PKey = s.PKey and

						s.[ShaftEquipType] = 'WOOD'

					WHERE w.[First Day] = @FirstDay AND w.[SID] = @Sid and w.CLUBCODE = 'HYB')



SELECT a.BRAND AS [Wood Brand], 

		a.SHAFTBRAND AS [Shaft Brand],

		COUNT(*) AS "Count",

		sum(COUNT(*)) over () AS "Total"

FROM cte_wood as a

GROUP BY a.BRAND, a.SHAFTBRAND 

ORDER BY [Wood Brand], COUNT(*) desc, a.SHAFTBRAND;





ELSE IF (@REPORTNAME = 'Wood VS. Shaft Manufacturer')

with cte_wood as (SELECT w.BRAND, 

							s.[Shaftmfgr], 

							w.[INDEX]

					FROM Input.[Wood] w

					inner join input.Shaft s 

					on w.[SID] = s.[SID] and

						w.[First Day] = s.[First Day] and

						w.playerName = s.playerName and

						w.PKey = s.PKey and

						s.[ShaftEquipType] = 'WOOD'

					WHERE w.[First Day] = @FirstDay AND w.[SID] = @Sid)



SELECT a.BRAND AS [Wood Brand], 

		a.SHAFTMFGR AS [Shaft Manufacturer],

		COUNT(*) AS "Count",

		sum(COUNT(*)) over () AS "Total"

FROM cte_wood as a

GROUP BY a.BRAND, a.SHAFTmfgr

ORDER BY [Wood Brand], COUNT(*) desc, a.SHAFTmfgr;



ELSE IF (@REPORTNAME = 'Wood VS. Shaft Brand')

with cte_wood as (SELECT w.BRAND, 

							s.[ShaftBrand], 

							w.[INDEX]

					FROM Input.[Wood] w

					inner join input.Shaft s 

					on w.[SID] = s.[SID] and

						w.[First Day] = s.[First Day] and

						w.playerName = s.playerName and

						w.PKey = s.PKey and

						s.[ShaftEquipType] = 'WOOD'

					WHERE w.[First Day] = @FirstDay AND w.[SID] = @Sid)



SELECT a.BRAND AS [Wood Brand], 

		a.SHAFTBRAND AS [Shaft Brand],

		COUNT(*) AS "Count",

		sum(COUNT(*)) over () AS "Total"

FROM cte_wood as a

GROUP BY a.BRAND, a.SHAFTBRAND 

ORDER BY [Wood Brand], COUNT(*) desc, a.SHAFTBRAND;







ELSE IF (@REPORTNAME = 'Iron Grip Material')

WITH IRONSETTABLE_Grip AS (

SELECT a.PLAYERNAME, CLUBCODE, BRAND, MODEL, GRIPMFGR, GRIPBRAND, GRIPMODEL, GRIPMATL

FROM Input.[Iron] a

LEFT OUTER JOIN Input.[Grip] b ON a.PLAYERNAME = b.PLAYERNAME and a.[First Day]= b.[First Day] and a.SID = b.SID and a.CLUBCODE = b.GRIPCLUBCODE

WHERE a.SID = @SID AND a."First Day" = @FIRSTDAY and GRIPEQUIPTYPE= 'IRON' and isset = 1

group by a.PLAYERNAME, CLUBCODE, BRAND, MODEL, GRIPMFGR, GRIPBRAND, GRIPMODEL, GRIPMATL

),





IRONGripMATLTABLE AS (

SELECT PLAYERNAME, BRAND, GRIPMATL FROM IRONSETTABLE_Grip GROUP BY PLAYERNAME, BRAND, GRIPMATL

)





      SELECT

"Matl Descr" AS Brand, COUNT(GRIPMATL) AS "Count",

(SELECT COUNT(GRIPMATL) FROM IRONGRIPMATLTABLE) AS TOTAL

  FROM IRONGripMATLTABLE

  LEFT OUTER JOIN [LKP].[Material Codes and Descript] ON "Matl Descr" = GRIPMATL 

  GROUP BY "Matl Descr"

      ORDER BY COUNT(GRIPMATL) DESC, "Matl Descr" ASC;









ELSE IF (@REPORTNAME = 'Iron Grip Manufacturer')

WITH IRONSETTABLE_GRIP AS (

SELECT a.PLAYERNAME, CLUBCODE, BRAND, MODEL, GRIPMFGR, GRIPBRAND, GRIPMODEL, GRIPMATL

FROM Input.[Iron] a

LEFT OUTER JOIN Input.[Grip] b ON a.PLAYERNAME = b.PLAYERNAME and a.[First Day]= b.[First Day] and a.SID = b.SID and a.CLUBCODE = b.GRIPCLUBCODE

WHERE a.SID = @SID AND a."First Day" = @FIRSTDAY and GRIPEQUIPTYPE= 'IRON' and isset = 1

group by a.PLAYERNAME, CLUBCODE, BRAND, MODEL, GRIPMFGR, GRIPBRAND, GRIPMODEL, GRIPMATL

),

IRONGRIPMFGRTABLE AS(

SELECT PLAYERNAME, GRIPMFGR from IRONSETTABLE_Grip Group by PLAYERNAME, GRIPMFGR

)





      SELECT

"Mfgr Descr" AS Brand, COUNT(GRIPMFGR) AS "Count",

(SELECT COUNT(GRIPMFGR) FROM IRONGRIPMFGRTABLE) AS TOTAL

  FROM IRONGripMFGRTABLE

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = GRIPMFGR 

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(GRIPMFGR) DESC, "Mfgr Descr" ASC;





ELSE IF (@REPORTNAME = 'Iron Grip Brand')

WITH IRONSETTABLE_Grip AS (

SELECT a.PLAYERNAME, CLUBCODE, BRAND, MODEL, GRIPMFGR, GRIPBRAND, GRIPMODEL, GRIPMATL

FROM Input.[Iron] a

LEFT OUTER JOIN Input.[Grip] b ON a.PLAYERNAME = b.PLAYERNAME and a.[First Day]= b.[First Day] and a.SID = b.SID and a.CLUBCODE = b.GRIPCLUBCODE

WHERE a.SID = @SID AND a."First Day" = @FIRSTDAY and GRIPEQUIPTYPE= 'IRON' and isset = 1

group by a.PLAYERNAME, CLUBCODE, BRAND, MODEL, GRIPMFGR, GRIPBRAND, GRIPMODEL, GRIPMATL

),

IRONGripBRANDTABLE AS(

SELECT PLAYERNAME, GRIPBRAND from IRONSETTABLE_Grip Group by PLAYERNAME, GRIPBRAND

)

      SELECT

"Mfgr Descr" AS Brand, COUNT(GRIPBRAND) AS "Count",

(SELECT COUNT(GRIPBRAND) FROM IRONGripBRANDTABLE) AS TOTAL

  FROM IRONGripBRANDTABLE

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = GRIPBRAND

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(GRIPBRAND) DESC, "Mfgr Descr" ASC;





ELSE IF (@REPORTNAME = 'Wedge Grip Material')

      SELECT

"Matl Descr" AS Brand, COUNT(GRIPMATL) AS "Count",

(SELECT COUNT(GRIPMATL) FROM [Input].[Grip] WHERE SID = @SID AND "First Day" = @FIRSTDAY AND GRIPEQUIPTYPE = 'WEDG') AS TOTAL

  FROM [Input].[Grip]

  LEFT OUTER JOIN [LKP].[Material Codes and Descript] ON "Matl Descr" = GRIPMATL 

  WHERE SID= @SID AND [First Day] = @FIRSTDAY AND GRIPEQUIPTYPE = 'WEDG'

  GROUP BY "Matl Descr"

      ORDER BY COUNT(GRIPMATL) DESC, "Matl Descr" ASC;





ELSE IF (@REPORTNAME = 'Wedge Grip Manufacturer')

      SELECT

"Mfgr Descr" AS Brand, COUNT(GRIPMFGR) AS "Count",

(SELECT COUNT(GRIPMFGR) FROM [Input].[Grip] WHERE SID = @SID AND "First Day" = @FIRSTDAY AND GRIPEQUIPTYPE = 'WEDG') AS TOTAL

  FROM [Input].[Grip]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = GRIPMFGR 

  WHERE SID= @SID AND [First Day] = @FIRSTDAY AND GRIPEQUIPTYPE = 'WEDG'

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(GRIPMFGR) DESC, "Mfgr Descr" ASC;





ELSE IF (@REPORTNAME = 'Wedge Grip Brand')

      SELECT

"Mfgr Descr" AS Brand, COUNT(GRIPBRAND) AS "Count",

(SELECT COUNT(GRIPBRAND) FROM [Input].[Grip] WHERE SID = @SID AND "First Day" = @FIRSTDAY AND GRIPEQUIPTYPE = 'WEDG') AS TOTAL

  FROM [Input].[Grip]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = GRIPBRAND

  WHERE SID= @SID AND [First Day] = @FIRSTDAY AND GRIPEQUIPTYPE = 'WEDG'

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(GRIPBRAND) DESC, "Mfgr Descr" ASC;

      

      

ELSE IF (@REPORTNAME = 'Wood Grip Material')

      SELECT

"Matl Descr" AS Brand, COUNT(GRIPMATL) AS "Count",

(SELECT COUNT(GRIPMATL) FROM [Input].[Grip] WHERE SID = @SID AND "First Day" = @FIRSTDAY AND GRIPEQUIPTYPE = 'WOOD') AS TOTAL

  FROM [Input].[Grip]

  LEFT OUTER JOIN [LKP].[Material Codes and Descript] ON "Matl Descr" = GRIPMATL 

  WHERE SID= @SID AND [First Day] = @FIRSTDAY AND GRIPEQUIPTYPE = 'WOOD'

  GROUP BY "Matl Descr"

      ORDER BY COUNT(GRIPMATL) DESC, "Matl Descr" ASC;





ELSE IF (@REPORTNAME = 'Wood Grip Manufacturer')

      SELECT

"Mfgr Descr" AS Brand, COUNT(GRIPMFGR) AS "Count",

(SELECT COUNT(GRIPMFGR) FROM [Input].[Grip] WHERE SID = @SID AND "First Day" = @FIRSTDAY AND GRIPEQUIPTYPE = 'WOOD') AS TOTAL

  FROM [Input].[Grip]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = GRIPMFGR 

  WHERE SID= @SID AND [First Day] = @FIRSTDAY AND GRIPEQUIPTYPE = 'WOOD'

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(GRIPMFGR) DESC, "Mfgr Descr" ASC;





ELSE IF (@REPORTNAME = 'Wood Grip Brand')

      SELECT

"Mfgr Descr" AS Brand, COUNT(GRIPBRAND) AS "Count",

(SELECT COUNT(GRIPBRAND) FROM [Input].[Grip] WHERE SID = @SID AND "First Day" = @FIRSTDAY AND GRIPEQUIPTYPE = 'WOOD') AS TOTAL

  FROM [Input].[Grip]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = GRIPBRAND

  WHERE SID= @SID AND [First Day] = @FIRSTDAY AND GRIPEQUIPTYPE = 'WOOD'

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(GRIPBRAND) DESC, "Mfgr Descr" ASC;

      

      

ELSE IF (@REPORTNAME = 'Putter Grip Brand')

      SELECT

"Mfgr Descr" AS Brand, COUNT(GRIPBRAND) AS "Count",

(SELECT COUNT(GRIPBRAND) FROM [Input].[Grip] WHERE SID = @SID AND "First Day" = @FIRSTDAY AND GRIPEQUIPTYPE = 'PUTT') AS TOTAL

  FROM [Input].[Grip]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = GRIPBRAND

  WHERE SID= @SID AND [First Day] = @FIRSTDAY AND GRIPEQUIPTYPE = 'PUTT'

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(GRIPBRAND) DESC, "Mfgr Descr" ASC;

      



ELSE IF (@REPORTNAME = 'Putter Grip Material')

      SELECT

"Matl Descr" AS Brand, COUNT(GRIPMATL) AS "Count",

(SELECT COUNT(GRIPMATL) FROM [Input].[Grip] WHERE SID = @SID AND "First Day" = @FIRSTDAY AND GRIPEQUIPTYPE = 'PUTT') AS TOTAL

  FROM [Input].[Grip]

  LEFT OUTER JOIN [LKP].[Material Codes and Descript] ON "Matl Descr" = GRIPMATL

  WHERE SID= @SID AND [First Day] = @FIRSTDAY AND GRIPEQUIPTYPE = 'PUTT'

  GROUP BY "Matl Descr"

      ORDER BY COUNT(GRIPMATL) DESC, "Matl Descr" ASC;

      

      

ELSE IF (@REPORTNAME = 'Putter Grip Manufacturer')

      SELECT

"Mfgr Descr" AS Brand, COUNT(GRIPMFGR) AS "Count",

(SELECT COUNT(GRIPMFGR) FROM [Input].[Grip] WHERE SID = @SID AND "First Day" = @FIRSTDAY AND GRIPEQUIPTYPE = 'PUTT') AS TOTAL

  FROM [Input].[Grip]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = GRIPMFGR

  WHERE SID= @SID AND [First Day] = @FIRSTDAY AND GRIPEQUIPTYPE = 'PUTT'

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(GRIPMFGR) DESC, "Mfgr Descr" ASC;

      



ELSE IF (@REPORTNAME = 'All Wedges (Including PW)')

      SELECT

"Mfgr Descr" AS Brand, COUNT(BRAND) AS "Count",

(SELECT COUNT(BRAND) FROM [Input].[Wedge] WHERE SID = @SID AND "First Day" = @FIRSTDAY) AS TOTAL

  FROM [Input].[Wedge]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = BRAND

  WHERE SID= @SID AND [First Day] = @FIRSTDAY

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(BRAND) DESC, "Mfgr Descr" ASC;

      

ELSE IF (@REPORTNAME = 'Pitching Wedge')

      SELECT

"Mfgr Descr" AS Brand, COUNT(BRAND) AS "Count",

(SELECT COUNT(BRAND) FROM [Input].[Wedge] WHERE SID = @SID AND "First Day" = @FIRSTDAY and CLUBCODE = 'PW') AS TOTAL

  FROM [Input].[Wedge]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = BRAND

  WHERE SID= @SID AND [First Day] = @FIRSTDAY and CLUBCODE = 'PW'

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(BRAND) DESC, "Mfgr Descr" ASC;

      

ELSE IF (@REPORTNAME = 'All Wedges (Excl. PW) AW,GW,SW,LW')

      SELECT

"Mfgr Descr" AS Brand, COUNT(BRAND) AS "Count",

(SELECT COUNT(BRAND) FROM [Input].[Wedge] WHERE SID = @SID AND "First Day" = @FIRSTDAY and CLUBCODE <> 'PW') AS TOTAL

  FROM [Input].[Wedge]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = BRAND

  WHERE SID= @SID AND [First Day] = @FIRSTDAY and CLUBCODE <> 'PW'

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(BRAND) DESC, "Mfgr Descr" ASC;

ELSE

 

--dummy select to set ourput variables for crystal reports

SELECT 'TITLEISTTITLEISTTITLEISTTITLEIST' AS Brand, 34 as "Count", 12 as "%" WHERE 1=0;



END
GO
