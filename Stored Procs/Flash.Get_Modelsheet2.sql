DROP PROCEDURE IF EXISTS [Flash].[Get_Modelsheet2];
GO

-- =============================================

-- Author:		<Author,,Name>

-- Create date: <Create Date,,>

-- Description:	<Description,,>

-- =============================================

CREATE PROCEDURE [Flash].[Get_Modelsheet2]

	-- Add the parameters for the stored procedure here

	@COMPANY varchar(50),

	@TOURNAMENTNAME varchar(60),

	@FIRSTDAY date,

	@REPORTNAME varchar(35)

	

	

AS

BEGIN

    -- SET NOCOUNT ON added to prevent extra result sets from

	-- interfering with SELECT statements.

	SET NOCOUNT ON;



--DECLARE @FIRSTDAY DATE;

DECLARE @SID INT;



SELECT TOP 1 @SID = SID FROM player_master.[TOURNAMENTS_TABLE] WHERE "TOURNAMENT NAME" = @TOURNAMENTNAME AND [FIRST DAY] = @FIRSTDAY;



IF (@REPORTNAME = 'Balls')

SELECT

"Model Descr" As Model, COUNT(BALLBRAND) AS "Count", 

(SELECT COUNT(BALLBRAND) FROM [Input].[All] WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS "TOTAL"

  FROM [Input].[All]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = BALLBRAND

  LEFT OUTER JOIN [LKP].[Model Codes and Descr] ON "Model Descr" = BALLMODEL

  WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY and "Mfgr Descr" = @COMPANY

  GROUP BY "Mfgr Descr", "Model Descr"

      ORDER BY "Count" DESC;





ELSE IF (@REPORTNAME = 'Spikes')

SELECT

"Model Descr" As Model, COUNT(SPIKEBRAND) AS "Count", 

(SELECT COUNT(SPIKEBRAND) FROM [Input].[All] WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS "TOTAL"

  FROM [Input].[All]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = SPIKEBRAND

  LEFT OUTER JOIN [LKP].[Model Codes and Descr] ON "Model Descr" = SPIKEMODEL

  WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY and "Mfgr Descr" = @COMPANY

  GROUP BY "Mfgr Descr", "Model Descr"

	ORDER BY "Count" DESC;





ELSE IF (@REPORTNAME = 'Driver')

--mostly copied from CR_Reports.Drivers

SELECT "Model Descr" + (case when [Size Descr] is null then '' else ' ' + [Size Descr] end) AS Model, COUNT(a."Mfgr Descr") AS "Count",

(SELECT COUNT("BRAND") FROM [Input].[Wood] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY and ISDRIVER = 1) AS "TOTAL"

 FROM

(SELECT * FROM [Input].[Wood] WHERE "First Day" = @FIRSTDAY AND "SID" = @SID) c

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a ON "BRAND" = a."Mfgr Descr" 

LEFT OUTER JOIN LKP.[Model Codes and Descr] ON "MODEL" = "Model Descr"

LEFT OUTER JOIN LKP.[Size Codes and Description] ON [SIZE] = [Size Descr]

WHERE "First Day" = @FIRSTDAY AND "SID" = @SID and ISDRIVER = 1 and "Mfgr Descr" = @COMPANY

GROUP BY "Mfgr Descr", "Model Descr", [Size Descr]

ORDER BY "Count" DESC;





ELSE IF (@REPORTNAME = 'Driver Shaft Brand')



SELECT f."Mfgr Descr" AS Brand, COUNT(f."Mfgr Descr") AS "Count",

(SELECT COUNT([BRAND]) FROM [Input].[Wood] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY and ISDRIVER = 1) AS TOTAL

  

FROM (

SELECT "PKey", PLAYERNAME, "SID", "First Day", ISDRIVER, CLUBCODE, [BRAND], DBRANDCODE, [MODEL], DMODELCODE, SIZE, DSIZECODE, MATERIAL, DMATERIAL

FROM Input.[Wood]

WHERE "First Day" = @FIRSTDAY AND "SID" = @SID and ISDRIVER = 1

GROUP BY "PKey", PLAYERNAME, "SID", "First Day", ISDRIVER, CLUBCODE, [BRAND], DBRANDCODE, [MODEL], DMODELCODE, SIZE, DSIZECODE, MATERIAL, DMATERIAL) a



LEFT OUTER JOIN (SELECT *

FROM Input.[Shaft] WHERE "First Day" = @FIRSTDAY AND "SID" = @SID AND "SHAFTEQUIPTYPE" = 'WOOD') b

ON a.PLAYERNAME = b.PLAYERNAME and a.CLUBCODE = b.[SHAFTCLUBCODE]



LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] f ON [SHAFTBRAND] = f."Mfgr Descr" 

WHERE a."First Day" = @FIRSTDAY AND a."SID" = @SID and a.ISDRIVER = 1

GROUP BY "Mfgr Descr"

ORDER BY COUNT(f."Mfgr Descr") DESC, f."Mfgr Descr" ASC;



ELSE IF (@REPORTNAME = 'Driver Shaft Material')



SELECT f.[Matl Code] AS Brand, COUNT(f.[Matl Code]) AS "Count",

(SELECT COUNT([BRAND]) FROM [Input].[Wood] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY and ISDRIVER = 1) AS TOTAL

  

FROM (

SELECT "PKey", PLAYERNAME, "SID", "First Day", ISDRIVER, CLUBCODE, [BRAND], DBRANDCODE, [MODEL], DMODELCODE, SIZE, DSIZECODE, MATERIAL, DMATERIAL

FROM Input.[Wood]

WHERE "First Day" = @FIRSTDAY AND "SID" = @SID and ISDRIVER = 1

GROUP BY "PKey", PLAYERNAME, "SID", "First Day", ISDRIVER, CLUBCODE, [BRAND], DBRANDCODE, [MODEL], DMODELCODE, SIZE, DSIZECODE, MATERIAL, DMATERIAL) a



LEFT OUTER JOIN (SELECT *

FROM Input.[Shaft] WHERE "First Day" = @FIRSTDAY AND "SID" = @SID AND "SHAFTEQUIPTYPE" = 'WOOD') b

ON a.PLAYERNAME = b.PLAYERNAME and a.CLUBCODE = b.[SHAFTCLUBCODE]



LEFT OUTER JOIN LKP.[Material Codes and Descript] f ON [SHAFTMATL] = f.[Matl Code]

WHERE a."First Day" = @FIRSTDAY AND a."SID" = @SID and a.ISDRIVER = 1

GROUP BY [Matl Code]

ORDER BY COUNT(f.[Matl Code]) DESC, f.[Matl Code] ASC;



ELSE IF (@REPORTNAME = 'Driver Shaft Manufacturer')



SELECT f."Mfgr Descr" AS Brand, COUNT(f."Mfgr Descr") AS "Count",

(SELECT COUNT([BRAND]) FROM [Input].[Wood] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY and ISDRIVER = 1) AS TOTAL

  

FROM (

SELECT "PKey", PLAYERNAME, "SID", "First Day", ISDRIVER, CLUBCODE, [BRAND], DBRANDCODE, [MODEL], DMODELCODE, SIZE, DSIZECODE, MATERIAL, DMATERIAL

FROM Input.[Wood]

WHERE "First Day" = @FIRSTDAY AND "SID" = @SID and ISDRIVER = 1

GROUP BY "PKey", PLAYERNAME, "SID", "First Day", ISDRIVER, CLUBCODE, [BRAND], DBRANDCODE, [MODEL], DMODELCODE, SIZE, DSIZECODE, MATERIAL, DMATERIAL) a



LEFT OUTER JOIN (SELECT *

FROM Input.[Shaft] WHERE "First Day" = @FIRSTDAY AND "SID" = @SID AND "SHAFTEQUIPTYPE" = 'WOOD') b

ON a.PLAYERNAME = b.PLAYERNAME and a.CLUBCODE = b.[SHAFTCLUBCODE]



LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] f ON [SHAFTMFGR] = f."Mfgr Descr" 

WHERE a."First Day" = @FIRSTDAY AND a."SID" = @SID and a.ISDRIVER = 1

GROUP BY "Mfgr Descr"

ORDER BY COUNT(f."Mfgr Descr") DESC, f."Mfgr Descr" ASC;





ELSE IF (@REPORTNAME = 'Driver Shaft Brand Model')



SELECT f."Mfgr Descr" AS Brand, "Model Descr" as Model, COUNT(f."Mfgr Descr") AS "Count",

(SELECT COUNT([BRAND]) FROM [Input].[Wood] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY and ISDRIVER = 1) AS TOTAL

  

FROM (

SELECT "PKey", PLAYERNAME, "SID", "First Day", ISDRIVER, CLUBCODE, [BRAND], DBRANDCODE, [MODEL], DMODELCODE, SIZE, DSIZECODE, MATERIAL, DMATERIAL

FROM Input.[Wood]

WHERE "First Day" = @FIRSTDAY AND "SID" = @SID and ISDRIVER = 1

GROUP BY "PKey", PLAYERNAME, "SID", "First Day", ISDRIVER, CLUBCODE, [BRAND], DBRANDCODE, [MODEL], DMODELCODE, SIZE, DSIZECODE, MATERIAL, DMATERIAL) a



LEFT OUTER JOIN (SELECT *

FROM Input.[Shaft] WHERE "First Day" = @FIRSTDAY AND "SID" = @SID AND "SHAFTEQUIPTYPE" = 'WOOD') b

ON a.PLAYERNAME = b.PLAYERNAME and a.CLUBCODE = b.[SHAFTCLUBCODE]

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON "Model Descr" = SHAFTMODEL

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] f ON [SHAFTBRAND] = f."Mfgr Descr" 

WHERE a."First Day" = @FIRSTDAY AND a."SID" = @SID and a.ISDRIVER = 1

  GROUP BY "Mfgr Descr", "Model Descr" 

     ORDER BY "Count" DESC;





ELSE IF (@REPORTNAME = 'All Woods')

      SELECT

"Model Descr" as Model, COUNT("BRAND") AS "Count",

(SELECT COUNT("BRAND") FROM [Input].[Wood] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY) AS "TOTAL"

  FROM [Input].[Wood]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = "BRAND"

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON "Model Descr" = "MODEL"

  WHERE [SID]= @SID AND [First Day] = @FIRSTDAY and "Mfgr Descr" = @COMPANY

  GROUP BY "Mfgr Descr", "Model Descr" 

      ORDER BY "Count" DESC;

            



ELSE IF (@REPORTNAME = 'Fairway Including Hybrid')

SELECT "Model Descr" AS Model, COUNT(b."Mfgr Descr") AS "Count",

(SELECT COUNT("BRAND") FROM [Input].[Wood] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY and ISDRIVER = 0) AS "TOTAL"

 FROM [Input].[Wood] a

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] b ON "BRAND" = b."Mfgr Descr" 

LEFT OUTER JOIN LKP.[Model Codes and Descr] ON "MODEL" = "Model Descr" 

WHERE "First Day" = @FIRSTDAY AND "SID" = @SID and ISDRIVER = 0 and "Mfgr Descr" = @COMPANY

GROUP BY "Mfgr Descr", "Model Descr"

ORDER BY "Count" DESC;

      

      

ELSE IF (@REPORTNAME = 'Fairway wo Hybrid')

SELECT "Model Descr" as Model, COUNT(b."Mfgr Descr") AS "Count",

(SELECT COUNT("BRAND") FROM [Input].[Wood] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY and ISDRIVER = 0 and [CLUBCODE] <> 'HYB') AS "TOTAL"

 FROM [Input].[Wood] a

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] b ON "BRAND" = b."Mfgr Descr" 

LEFT OUTER JOIN LKP.[Model Codes and Descr] ON "MODEL" = "Model Descr" 

WHERE "First Day" = @FIRSTDAY AND "SID" = @SID and ISDRIVER = 0 AND a."CLUBCODE" <> 'HYB' and "Mfgr Descr" = @COMPANY

GROUP BY "Mfgr Descr", "Model Descr"

ORDER BY "Count" DESC;

      

      

ELSE IF (@REPORTNAME = 'Hybrid Woods')

      SELECT

"Model Descr" AS Model, COUNT("BRAND") AS "Count",

(SELECT COUNT("BRAND") FROM [Input].[Wood] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY  AND [CLUBCODE] = 'HYB') AS "TOTAL"

  FROM [Input].[Wood]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = "BRAND"

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON "Model Descr" = [MODEL] 

  WHERE [SID]= @SID AND [First Day] = @FIRSTDAY AND "CLUBCODE" = 'HYB' and "Mfgr Descr" = @COMPANY

  GROUP BY "Mfgr Descr", "Model Descr"

      ORDER BY "Count" DESC;            

            



ELSE IF (@REPORTNAME = 'Hybrid Wood Shaft Material')

      SELECT

"Matl Descr" AS Brand, COUNT("SHAFTMATL") AS "Count",

(SELECT COUNT("SHAFTMATL") FROM [Input].[Shaft] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY AND [SHAFTEQUIPTYPE] = 'WOOD' and [SHAFTCLUBCODE] = 'HYB') AS TOTAL

  FROM [Input].[Shaft]

  LEFT OUTER JOIN [LKP].[Material Codes and Descript] ON "Matl Descr" = "SHAFTMATL" 

  WHERE [SID]= @SID AND [First Day] = @FIRSTDAY AND [SHAFTEQUIPTYPE] = 'WOOD' and [SHAFTCLUBCODE] = 'HYB'

  GROUP BY "Matl Descr"

      ORDER BY COUNT("SHAFTMATL") DESC, "Matl Descr" ASC;





ELSE IF (@REPORTNAME = 'Hybrid Wood Shaft Manufacturer')

      SELECT

"Mfgr Descr" AS Brand, COUNT("SHAFTMFGR") AS "Count",

(SELECT COUNT("SHAFTMFGR") FROM [Input].[Shaft] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY AND [SHAFTEQUIPTYPE] = 'WOOD' and [SHAFTCLUBCODE] = 'HYB') AS TOTAL

  FROM [Input].[Shaft]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = "SHAFTMFGR" 

  WHERE [SID]= @SID AND [First Day] = @FIRSTDAY AND [SHAFTEQUIPTYPE] = 'WOOD' and [SHAFTCLUBCODE] = 'HYB'

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT("SHAFTMFGR") DESC, "Mfgr Descr" ASC;





ELSE IF (@REPORTNAME = 'Hybrid Wood Shaft Brand')

      SELECT

"Mfgr Descr" AS Brand, COUNT("SHAFTBRAND") AS "Count",

(SELECT COUNT("SHAFTBRAND") FROM [Input].[Shaft] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY AND [SHAFTEQUIPTYPE] = 'WOOD' and [SHAFTCLUBCODE] = 'HYB') AS TOTAL

  FROM [Input].[Shaft]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = "SHAFTBRAND"

  WHERE [SID]= @SID AND [First Day] = @FIRSTDAY AND [SHAFTEQUIPTYPE] = 'WOOD' and [SHAFTCLUBCODE] = 'HYB'

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT("SHAFTBRAND") DESC, "Mfgr Descr" ASC;





ELSE IF (@REPORTNAME = 'Hybrid Wood Shaft Brand Model')

      SELECT

"Mfgr Descr" AS Brand, "Model Descr" as Model, COUNT("SHAFTBRAND") AS "Count",

(SELECT COUNT("SHAFTBRAND") FROM [Input].[Shaft] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY AND [SHAFTEQUIPTYPE] = 'WOOD' and [SHAFTCLUBCODE] = 'HYB') AS TOTAL

  FROM [Input].[Shaft]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = "SHAFTBRAND"

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON "Model Descr" = [SHAFTMODEL] 

  WHERE [SID]= @SID AND [First Day] = @FIRSTDAY AND [SHAFTEQUIPTYPE] = 'WOOD' and [SHAFTCLUBCODE] = 'HYB'

  GROUP BY "Mfgr Descr", "Model Descr"

ORDER BY "Count" DESC;





ELSE IF (@REPORTNAME = 'Iron')

      SELECT

"Model Descr" as Model, COUNT("BRAND") AS "Count",

(SELECT COUNT("BRAND") FROM [Input].[Iron] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY) AS "TOTAL"

  FROM [Input].[Iron]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = "BRAND"

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON "Model Descr" = [MODEL] 

  WHERE [SID]= @SID AND [First Day] = @FIRSTDAY and isset = 1 and "Mfgr Descr" = @COMPANY and not [Input].[Iron].CLUBCODE = '%^%'

  GROUP BY "Mfgr Descr", "Model Descr"

ORDER BY "Count" DESC;





ELSE IF (@REPORTNAME = 'Utility Iron')

  select *, SUM([COUNT]) over() as TOTAL from (

  SELECT "Model Descr" as Model, 

		 sum(case when CLUBCODE like '%-%' then (cast(SUBSTRING(clubcode,3,1) AS tinyint) - 

												cast(SUBSTRING(clubcode,1,1) AS tinyint) +1)

				 else 1 end) AS "Count"

  FROM [Input].[Iron]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = "BRAND"

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON "Model Descr" = "MODEL" 

  WHERE [SID]= @SID AND [First Day] = @FIRSTDAY AND "CLUBCODE" LIKE '%^%' and "Mfgr Descr" = @COMPANY

  GROUP BY "Mfgr Descr", "Model Descr") a

      ORDER BY [Count] desc;

      



ELSE IF (@REPORTNAME = 'Putter')

      SELECT

"Model Descr" as Model, COUNT("BRAND") AS "Count",

(SELECT COUNT("BRAND") FROM [Input].[Putter] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY) AS "TOTAL"

  FROM [Input].[Putter]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = "BRAND"

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON "Model Descr" = [MODEL] 

  WHERE [SID]= @SID AND [First Day] = @FIRSTDAY and "Mfgr Descr" in (SELECT [COMPANY]

		FROM [DARRELL_MASTER].[LKP].[Company_Groups]

		where GROUP_ID = (Select GROUP_ID FROM [DARRELL_MASTER].[LKP].[Company_Groups]

				where company = @COMPANY))

  GROUP BY "Mfgr Descr", "Model Descr"

ORDER BY "Count" DESC;







ELSE IF (@REPORTNAME = 'Shaft')

      SELECT

"Model Descr" as Model, COUNT("SHAFTBRAND") AS "Count",

(SELECT COUNT("SHAFTBRAND") FROM [Input].[Shaft] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY) AS "TOTAL"

  FROM [Input].[Shaft]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = "SHAFTBRAND"

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON "Model Descr" = [SHAFTMODEL] 

  WHERE [SID]= @SID AND [First Day] = @FIRSTDAY and "Mfgr Descr" = @COMPANY

  GROUP BY "Mfgr Descr", "Model Descr"

      ORDER BY "Count" DESC;





ELSE IF (@REPORTNAME = 'Iron Shaft Brand Model')

WITH IRONSETTABLE_SHAFT AS (

SELECT a.PLAYERNAME, [CLUBCODE], [BRAND], [MODEL], [SHAFTMFGR], [SHAFTBRAND], [SHAFTMODEL], [SHAFTMATL]

FROM Input.[Iron] a

LEFT OUTER JOIN Input.[Shaft] b ON a.PLAYERNAME = b.PLAYERNAME and a.[First Day]= b.[First Day] and a.[SID] = b.[SID] and a.[CLUBCODE] = b.[SHAFTCLUBCODE]

WHERE a."SID" = @SID AND a."First Day" = @FIRSTDAY and [SHAFTEQUIPTYPE]= 'IRON' and isset = 1

group by a.PLAYERNAME, [CLUBCODE], [BRAND], [MODEL], [SHAFTMFGR], [SHAFTBRAND], [SHAFTMODEL], [SHAFTMATL]

),

IRONSHAFTBRANDTABLE AS (

SELECT PLAYERNAME, [BRAND], [MODEL] FROM IRONSETTABLE_SHAFT GROUP BY PLAYERNAME, [BRAND], [MODEL]

)

      SELECT

"Mfgr Descr" AS Brand, "Model Descr" as Model, COUNT(BRAND) AS "Count",

(SELECT COUNT(PLAYERNAME) FROM IRONSHAFTBRANDTABLE) AS " TOTAL"

  FROM IRONSHAFTBRANDTABLE

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = BRAND

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON "Model Descr" = MODEL 

  GROUP BY "Mfgr Descr", "Model Descr"

      ORDER BY "Count" DESC;

      

ELSE IF (@REPORTNAME = 'Iron Shaft Material Model')

WITH IRONSETTABLE_SHAFT AS (

SELECT a.PLAYERNAME, [CLUBCODE], [BRAND], [MODEL], [SHAFTMFGR], [SHAFTBRAND], [SHAFTMODEL], [SHAFTMATL]

FROM Input.[Iron] a

LEFT OUTER JOIN Input.[Shaft] b ON a.PLAYERNAME = b.PLAYERNAME and a.[First Day]= b.[First Day] and a.[SID] = b.[SID] and a.[CLUBCODE] = b.[SHAFTCLUBCODE]

WHERE a."SID" = @SID AND a."First Day" = @FIRSTDAY and [SHAFTEQUIPTYPE]= 'IRON' and isset = 1

group by a.PLAYERNAME, [CLUBCODE], [BRAND], [MODEL], [SHAFTMFGR], [SHAFTBRAND], [SHAFTMODEL], [SHAFTMATL]

),



IRONSHAFTMATLTABLE AS (

SELECT PLAYERNAME, [BRAND], [SHAFTMATL] FROM IRONSETTABLE_SHAFT GROUP BY PLAYERNAME, [BRAND], [SHAFTMATL]

)

      SELECT

"Matl Descr" AS Brand, COUNT("SHAFTMATL") AS "Count",

(SELECT COUNT("SHAFTMATL") FROM IRONSHAFTMATLTABLE) AS TOTAL

  FROM IRONSHAFTMATLTABLE

  LEFT OUTER JOIN [LKP].[Material Codes and Descript] ON "Matl Descr" = "SHAFTMATL" 

  GROUP BY "Matl Descr"

      ORDER BY COUNT("SHAFTMATL") DESC, "Matl Descr" ASC;

      

ELSE IF (@REPORTNAME = 'Iron Shaft Manufacturer Model')

WITH IRONSETTABLE_SHAFT AS (

SELECT a.PLAYERNAME, [CLUBCODE], [BRAND], [MODEL], [SHAFTMFGR], [SHAFTBRAND], [SHAFTMODEL], [SHAFTMATL]

FROM Input.[Iron] a

LEFT OUTER JOIN Input.[Shaft] b ON a.PLAYERNAME = b.PLAYERNAME and a.[First Day]= b.[First Day] and a.[SID] = b.[SID] and a.[CLUBCODE] = b.[SHAFTCLUBCODE]

WHERE a."SID" = @SID AND a."First Day" = @FIRSTDAY and [SHAFTEQUIPTYPE]= 'IRON' and isset = 1

group by a.PLAYERNAME, [CLUBCODE], [BRAND], [MODEL], [SHAFTMFGR], [SHAFTBRAND], [SHAFTMODEL], [SHAFTMATL]

),

IRONSHAFTMFGRTABLE AS(

SELECT PLAYERNAME, [SHAFTMFGR] from IRONSETTABLE_SHAFT Group by PLAYERNAME, [SHAFTMFGR]

)

      SELECT

"Mfgr Descr" AS Brand, COUNT("SHAFTMFGR") AS "Count",

(SELECT COUNT("SHAFTMFGR") FROM IRONSHAFTMFGRTABLE) AS TOTAL

  FROM IRONSHAFTMFGRTABLE

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = "SHAFTMFGR" 

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT("SHAFTMFGR") DESC, "Mfgr Descr" ASC;



ELSE IF (@REPORTNAME = 'Iron Grip Brand Model')

WITH IRONSETTABLE_Grip AS (

SELECT a.PLAYERNAME, [CLUBCODE], [BRAND], [MODEL], [GRIPMFGR], [GRIPBRAND], [GripMODEL], [GripMATL]

FROM Input.[Iron] a

LEFT OUTER JOIN Input.[Grip] b ON a.PLAYERNAME = b.PLAYERNAME and a.[First Day]= b.[First Day] and a.[SID] = b.[SID] and a.[CLUBCODE] = b.[GripCLUBCODE]

WHERE a."SID" = @SID AND a."First Day" = @FIRSTDAY and [GripEQUIPTYPE]= 'IRON' and isset = 1

group by a.PLAYERNAME, [CLUBCODE], [BRAND], [MODEL], [GripMFGR], [GripBRAND], [GripMODEL], [GripMATL]

),



IRONGripBRANDTABLE AS (

SELECT PLAYERNAME, [GRIPBRAND], GRIPMODEL FROM IRONSETTABLE_Grip GROUP BY PLAYERNAME, [GRIPBRAND], GRIPMODEL

)

      SELECT

"Mfgr Descr" AS Brand, "Model Descr" as Model, COUNT(GRIPBRAND) AS "Count",

(SELECT COUNT([GRIPBRAND]) FROM IRONGripBRANDTABLE) AS "TOTAL"

  FROM IRONGripBRANDTABLE

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = GRIPBRAND

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON "Model Descr" = GRIPMODEL 

   GROUP BY "Mfgr Descr", "Model Descr"

      ORDER BY "Mfgr Descr" ASC, "Model Descr" ASC;

      

ELSE IF (@REPORTNAME = 'Iron Grip Material Model')

WITH IRONSETTABLE_Grip AS (

SELECT a.PLAYERNAME, [CLUBCODE], [BRAND], [MODEL], [GripMFGR], [GripBRAND], [GripMODEL], [GripMATL]

FROM Input.[Iron] a

LEFT OUTER JOIN Input.[Grip] b ON a.PLAYERNAME = b.PLAYERNAME and a.[First Day]= b.[First Day] and a.[SID] = b.[SID] and a.[CLUBCODE] = b.[GripCLUBCODE]

WHERE a."SID" = @SID AND a."First Day" = @FIRSTDAY and [GripEQUIPTYPE]= 'IRON' and isset = 1

group by a.PLAYERNAME, [CLUBCODE], [BRAND], [MODEL], [GripMFGR], [GripBRAND], [GripMODEL], [GripMATL]

),



IRONGripMATLTABLE AS (

SELECT PLAYERNAME, [BRAND], [GripMATL] FROM IRONSETTABLE_Grip GROUP BY PLAYERNAME, [BRAND], [GripMATL]

)

      SELECT

"Matl Descr" AS Brand, COUNT("GripMATL") AS "Count",

(SELECT COUNT("GripMATL") FROM IRONGripMATLTABLE) AS TOTAL

  FROM IRONGripMATLTABLE

  LEFT OUTER JOIN [LKP].[Material Codes and Descript] ON "Matl Descr" = "GripMATL" 

  GROUP BY "Matl Descr"

      ORDER BY COUNT("GripMATL") DESC, "Matl Descr" ASC;

      

ELSE IF (@REPORTNAME = 'Iron Grip Manufacturer Model')

WITH IRONSETTABLE_Grip AS (

SELECT a.PLAYERNAME, [CLUBCODE], [BRAND], [MODEL], [GripMFGR], [GripBRAND], [GripMODEL], [GripMATL]

FROM Input.[Iron] a

LEFT OUTER JOIN Input.[Grip] b ON a.PLAYERNAME = b.PLAYERNAME and a.[First Day]= b.[First Day] and a.[SID] = b.[SID] and a.[CLUBCODE] = b.[GripCLUBCODE]

WHERE a."SID" = @SID AND a."First Day" = @FIRSTDAY and [GripEQUIPTYPE]= 'IRON' and isset = 1

group by a.PLAYERNAME, [CLUBCODE], [BRAND], [MODEL], [GripMFGR], [GripBRAND], [GripMODEL], [GripMATL]

),

IRONGripMFGRTABLE AS(

SELECT PLAYERNAME, [GripMFGR] from IRONSETTABLE_Grip Group by PLAYERNAME, [GripMFGR]

)

      SELECT

"Mfgr Descr" AS Brand, COUNT("GripMFGR") AS "Count",

(SELECT COUNT("GripMFGR") FROM IRONGripMFGRTABLE) AS TOTAL

  FROM IRONGripMFGRTABLE

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = "GripMFGR" 

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT("GripMFGR") DESC, "Mfgr Descr" ASC;



ELSE IF (@REPORTNAME = 'Utility Iron Shaft Material')

WITH IRONSETTABLE_SHAFT AS (

SELECT a.PLAYERNAME, [CLUBCODE], [BRAND], [MODEL], [SHAFTMFGR], [SHAFTBRAND], [SHAFTMODEL], [SHAFTMATL]

FROM Input.[Iron] a 

LEFT OUTER JOIN Input.[Shaft] b ON a.PLAYERNAME = b.PLAYERNAME and a.[First Day]= b.[First Day] and a.[SID] = b.[SID] and a.[CLUBCODE] = b.[SHAFTCLUBCODE]

WHERE a."SID" = @SID AND a."First Day" = @FIRSTDAY and [SHAFTEQUIPTYPE]= 'IRON' and [CLUBCODE] like '%^%'

group by a.PLAYERNAME, [CLUBCODE], [BRAND], [MODEL], [SHAFTMFGR], [SHAFTBRAND], [SHAFTMODEL], [SHAFTMATL]

),



IRONSHAFTMATLTABLE AS (

SELECT PLAYERNAME, [BRAND], [SHAFTMATL] FROM IRONSETTABLE_SHAFT GROUP BY PLAYERNAME, [BRAND], [SHAFTMATL]

)





      SELECT

"Matl Descr" AS Brand, COUNT("SHAFTMATL") AS "Count",

(SELECT COUNT("SHAFTMATL") FROM IRONSHAFTMATLTABLE) AS TOTAL

  FROM IRONSHAFTMATLTABLE

  LEFT OUTER JOIN [LKP].[Material Codes and Descript] ON "Matl Descr" = "SHAFTMATL" 

  GROUP BY "Matl Descr"

      ORDER BY COUNT("SHAFTMATL") DESC, "Matl Descr" ASC;





ELSE IF (@REPORTNAME = 'Utility Iron Shaft Manufacturer')

WITH IRONSETTABLE_SHAFT AS (

SELECT a.PLAYERNAME, [CLUBCODE], [BRAND], [MODEL], [SHAFTMFGR], [SHAFTBRAND], [SHAFTMODEL], [SHAFTMATL]

FROM Input.[Iron] a

LEFT OUTER JOIN Input.[Shaft] b ON a.PLAYERNAME = b.PLAYERNAME and a.[First Day]= b.[First Day] and a.[SID] = b.[SID] and a.[CLUBCODE] = b.[SHAFTCLUBCODE]

WHERE a."SID" = @SID AND a."First Day" = @FIRSTDAY and [SHAFTEQUIPTYPE]= 'IRON' and [CLUBCODE] like '%^%'

group by a.PLAYERNAME, [CLUBCODE], [BRAND], [MODEL], [SHAFTMFGR], [SHAFTBRAND], [SHAFTMODEL], [SHAFTMATL]

),

IRONSHAFTMFGRTABLE AS(

SELECT PLAYERNAME, [SHAFTMFGR] from IRONSETTABLE_SHAFT Group by PLAYERNAME, [SHAFTMFGR]

)

      SELECT

"Mfgr Descr" AS Brand, COUNT("SHAFTMFGR") AS "Count",

(SELECT COUNT("SHAFTMFGR") FROM IRONSHAFTMFGRTABLE) AS TOTAL

  FROM IRONSHAFTMFGRTABLE

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = "SHAFTMFGR" 

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT("SHAFTMFGR") DESC, "Mfgr Descr" ASC;





ELSE IF (@REPORTNAME = 'Utility Iron Shaft Brand')

WITH IRONSETTABLE_SHAFT AS (

SELECT a.PLAYERNAME, [CLUBCODE], [BRAND], [MODEL], [SHAFTMFGR], [SHAFTBRAND], [SHAFTMODEL], [SHAFTMATL]

FROM Input.[Iron] a

LEFT OUTER JOIN Input.[Shaft] b ON a.PLAYERNAME = b.PLAYERNAME and a.[First Day]= b.[First Day] and a.[SID] = b.[SID] and a.[CLUBCODE] = b.[SHAFTCLUBCODE]

WHERE a."SID" = @SID AND a."First Day" = @FIRSTDAY and [SHAFTEQUIPTYPE]= 'IRON' and [CLUBCODE] like '%^%'

group by a.PLAYERNAME, [CLUBCODE], [BRAND], [MODEL], [SHAFTMFGR], [SHAFTBRAND], [SHAFTMODEL], [SHAFTMATL]

),

IRONSHAFTBRANDTABLE AS(

SELECT PLAYERNAME, [SHAFTBRAND] from IRONSETTABLE_SHAFT Group by PLAYERNAME, [SHAFTBRAND]

)

      SELECT

"Mfgr Descr" AS Brand, COUNT("SHAFTBRAND") AS "Count",

(SELECT COUNT("SHAFTBRAND") FROM IRONSHAFTBRANDTABLE) AS TOTAL

  FROM IRONSHAFTBRANDTABLE

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = "SHAFTBRAND"

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT("SHAFTBRAND") DESC, "Mfgr Descr" ASC;





ELSE IF (@REPORTNAME = 'Utility Iron Shaft Brand Model')

      SELECT

"Mfgr Descr" AS Brand, "Model Descr" as Model, COUNT("SHAFTBRAND") AS "Count",

(SELECT COUNT("SHAFTBRAND") FROM [Input].[Shaft] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY AND "SHAFTEQUIPTYPE" = 'IRON'  and [SHAFTCLUBCODE] like '%^%') AS " TOTAL"

  FROM [Input].[Shaft]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = "SHAFTBRAND"

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON "Model Descr" = "SHAFTMODEL" 

  WHERE [SID]= @SID AND [First Day] = @FIRSTDAY AND "SHAFTEQUIPTYPE" = 'IRON' and [SHAFTCLUBCODE] like '%^%'

  GROUP BY "Mfgr Descr", "Model Descr"

      ORDER BY "Count" DESC;





ELSE IF (@REPORTNAME = 'Wood Shaft Brand Model')

      SELECT

"Mfgr Descr" AS Brand, "Model Descr" as Model, COUNT("SHAFTBRAND") AS "Count",

(SELECT COUNT("SHAFTBRAND") FROM [Input].[Shaft] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY AND "SHAFTEQUIPTYPE" = 'WOOD') AS " TOTAL"

  FROM [Input].[Shaft]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = "SHAFTBRAND"

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON "Model Descr" = "SHAFTMODEL" 

  WHERE [SID]= @SID AND [First Day] = @FIRSTDAY AND "SHAFTEQUIPTYPE" = 'WOOD'

  GROUP BY "Mfgr Descr", "Model Descr"

      ORDER BY "Count" DESC;





ELSE IF (@REPORTNAME = 'Wood Shaft Manufacturer Model')

      SELECT

"Mfgr Descr" AS Brand, COUNT(SHAFTMFGR) AS "Count",

(SELECT COUNT("SHAFTMATL") FROM [Input].[Shaft] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY AND [SHAFTEQUIPTYPE] = 'WOOD') AS TOTAL

  FROM [Input].[Shaft]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = SHAFTMFGR 

  WHERE [SID]= @SID AND [First Day] = @FIRSTDAY AND [SHAFTEQUIPTYPE] = 'WOOD'

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(SHAFTMFGR) DESC, "Mfgr Descr" ASC;





ELSE IF (@REPORTNAME = 'Wood Shaft Material Model')

      SELECT

"Matl Descr" AS Brand, COUNT("SHAFTMATL") AS "Count",

(SELECT COUNT("SHAFTMATL") FROM [Input].[Shaft] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY AND [SHAFTEQUIPTYPE] = 'WOOD') AS TOTAL

  FROM [Input].[Shaft]

  LEFT OUTER JOIN [LKP].[Material Codes and Descript] ON "Matl Descr" = "SHAFTMATL" 

  WHERE [SID]= @SID AND [First Day] = @FIRSTDAY AND [SHAFTEQUIPTYPE] = 'WOOD'

  GROUP BY "Matl Descr"

      ORDER BY COUNT("SHAFTMATL") DESC, "Matl Descr" ASC;



      





ELSE IF (@REPORTNAME = 'Wood Grip Brand Model')

      SELECT

"Mfgr Descr" AS Brand, "Model Descr" as Model, COUNT("GripBRAND") AS "Count",

(SELECT COUNT("GripBRAND") FROM [Input].[Grip] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY AND "GripEQUIPTYPE" = 'WOOD') AS " TOTAL"

  FROM [Input].[Grip]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = "GripBRAND"

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON "Model Descr" = "GripMODEL" 

  WHERE [SID]= @SID AND [First Day] = @FIRSTDAY AND "GripEQUIPTYPE" = 'WOOD'

  GROUP BY "Mfgr Descr", "Model Descr"

      ORDER BY "Count" DESC;





ELSE IF (@REPORTNAME = 'Wood Grip Manufacturer Model')

      SELECT

"Mfgr Descr" AS Brand, COUNT(GripMFGR) AS "Count",

(SELECT COUNT("GripMATL") FROM [Input].[Grip] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY AND [GripEQUIPTYPE] = 'WOOD') AS TOTAL

  FROM [Input].[Grip]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = GripMFGR 

  WHERE [SID]= @SID AND [First Day] = @FIRSTDAY AND [GripEQUIPTYPE] = 'WOOD'

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(GripMFGR) DESC, "Mfgr Descr" ASC;





ELSE IF (@REPORTNAME = 'Wood Grip Material Model')

      SELECT

"Matl Descr" AS Brand, COUNT("GripMATL") AS "Count",

(SELECT COUNT("GripMATL") FROM [Input].[Grip] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY AND [GripEQUIPTYPE] = 'WOOD') AS TOTAL

  FROM [Input].[Grip]

  LEFT OUTER JOIN [LKP].[Material Codes and Descript] ON "Matl Descr" = "GripMATL" 

  WHERE [SID]= @SID AND [First Day] = @FIRSTDAY AND [GripEQUIPTYPE] = 'WOOD'

  GROUP BY "Matl Descr"

      ORDER BY COUNT("GripMATL") DESC, "Matl Descr" ASC;



      





ELSE IF (@REPORTNAME = 'Putter Grip Brand Model')

      SELECT

"Mfgr Descr" AS Brand, "Model Descr" as Model, COUNT("GripBRAND") AS "Count",
(SELECT COUNT("GripBRAND") FROM [Input].[Grip] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY AND "GripEQUIPTYPE" = 'PUTT') AS " TOTAL"

  FROM [Input].[Grip]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = "GripBRAND"

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON "Model Descr" = "GripMODEL" 

  WHERE [SID]= @SID AND [First Day] = @FIRSTDAY AND "GripEQUIPTYPE" = 'PUTT'

  GROUP BY "Mfgr Descr", "Model Descr"

      ORDER BY "Count" DESC;





ELSE IF (@REPORTNAME = 'Putter Grip Manufacturer Model')

      SELECT

"Mfgr Descr" AS Brand, COUNT(GripMFGR) AS "Count",

(SELECT COUNT("GripMATL") FROM [Input].[Grip] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY AND [GripEQUIPTYPE] = 'PUTT') AS TOTAL

  FROM [Input].[Grip]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = GripMFGR 

  WHERE [SID]= @SID AND [First Day] = @FIRSTDAY AND [GripEQUIPTYPE] = 'PUTT'

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(GripMFGR) DESC, "Mfgr Descr" ASC;





ELSE IF (@REPORTNAME = 'Putter Grip Material Model')

      SELECT

"Matl Descr" AS Brand, COUNT("GripMATL") AS "Count",

(SELECT COUNT("GripMATL") FROM [Input].[Grip] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY AND [GripEQUIPTYPE] = 'PUTT') AS TOTAL

  FROM [Input].[Grip]

  LEFT OUTER JOIN [LKP].[Material Codes and Descript] ON "Matl Descr" = "GripMATL" 

  WHERE [SID]= @SID AND [First Day] = @FIRSTDAY AND [GripEQUIPTYPE] = 'PUTT'

  GROUP BY "Matl Descr"

      ORDER BY COUNT("GripMATL") DESC, "Matl Descr" ASC;





      



ELSE IF (@REPORTNAME = 'Wedge')

      SELECT

"Model Descr" as Model, COUNT("BRAND") AS "Count",

(SELECT COUNT("BRAND") FROM [Input].[Wedge] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY) AS "TOTAL"

  FROM [Input].[Wedge]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = "BRAND"

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON "Model Descr" = [MODEL] 

  WHERE [SID]= @SID AND [First Day] = @FIRSTDAY and "Mfgr Descr" = @COMPANY

  GROUP BY "Mfgr Descr", "Model Descr"

      ORDER BY "Count" DESC;

      

ELSE IF (@REPORTNAME = 'All Wedges (Including PW)')

      SELECT

"Model Descr" as Model, COUNT("BRAND") AS "Count",

(SELECT COUNT("BRAND") FROM [Input].[Wedge] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY) AS "TOTAL"

  FROM [Input].[Wedge]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = "BRAND"

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON "Model Descr" = [MODEL] 

  WHERE [SID]= @SID AND [First Day] = @FIRSTDAY and "Mfgr Descr" = @COMPANY

  GROUP BY "Mfgr Descr", "Model Descr"

      ORDER BY "Count" DESC;

      

ELSE IF (@REPORTNAME = 'Pitching Wedge')

      SELECT

"Model Descr" as Model, COUNT("BRAND") AS "Count",

(SELECT COUNT("BRAND") FROM [Input].[Wedge] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY and [CLUBCODE] = 'PW') AS "TOTAL"

  FROM [Input].[Wedge]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = "BRAND"

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON "Model Descr" = [MODEL] 

  WHERE [SID]= @SID AND [First Day] = @FIRSTDAY and [CLUBCODE] = 'PW' and "Mfgr Descr" = @COMPANY

  GROUP BY "Mfgr Descr", "Model Descr"

      ORDER BY "Count" DESC;

      

ELSE IF (@REPORTNAME = 'All Wedges (Excl. PW) AW,GW,SW,LW')

      SELECT

"Model Descr" as Model, COUNT("BRAND") AS "Count",

(SELECT COUNT("BRAND") FROM [Input].[Wedge] WHERE "SID" = @SID AND "First Day" = @FIRSTDAY and [CLUBCODE] <> 'PW') AS "TOTAL"

  FROM [Input].[Wedge]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Descr" = "BRAND"

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON "Model Descr" = [MODEL] 

  WHERE [SID]= @SID AND [First Day] = @FIRSTDAY and [CLUBCODE] <> 'PW' and "Mfgr Descr" = @COMPANY

  GROUP BY "Mfgr Descr", "Model Descr"

      ORDER BY "Count" DESC;

ELSE

 

--dummy select to set ourput variables for crystal reports

SELECT 'asdf' AS Brand, 'asdf' AS Model, 11 as "Count", 12 as "TOTAL" WHERE 1=0;



     







END
GO
