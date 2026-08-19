DROP PROCEDURE IF EXISTS [dbo].[Get_TopSheet2];
GO

-- =============================================

-- Author:		<Author,,Name>

-- Create date: <Create Date,,>

-- Description:	<Description,,>

-- =============================================

CREATE PROCEDURE [dbo].[Get_TopSheet2]

	-- Add the parameters for the stored procedure here

	@COMPANY varchar(50),

	@TOURNAMENTNAME varchar(60),

	@FIRSTDAY varchar(15),

	@REPORTNAME varchar(35)

	

	

AS

BEGIN

    -- SET NOCOUNT ON added to prevent extra result sets from

	-- interfering with SELECT statements.

	SET NOCOUNT ON;



--DECLARE @FIRSTDAY DATE;

DECLARE @SID INT;



/*IF (@TOURNAMENTNAME IS NULL OR @TOURNAMENTNAME = '')

SELECT TOP 1 @TOURNAMENTNAME = [TOURNAMENT NAME], @FIRSTDAY = [FIRST DAY] FROM [Player_Master].[TOURNAMENTS_TABLE]

WHERE Year([FIRST DAY]) = YEAR(@FIRSTDAY)

ORDER BY [FIRST DAY] DESC;*/





SELECT TOP 1 @SID = SID FROM [Player_Master].[TOURNAMENTS_TABLE] WHERE "TOURNAMENT NAME" = @TOURNAMENTNAME AND [FIRST DAY] = @FIRSTDAY;



     

IF (@REPORTNAME = 'Balls')

SELECT

"Model Descr" AS MODEL, COUNT(BALLMODEL) AS "Count", 

(SELECT COUNT(BALLMODEL) FROM [Player_Master].[All] WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS TOTAL

  FROM [Player_Master].[All]

  LEFT OUTER JOIN [LKP].[Model Codes and Descr] ON "Model Code" = BALLMODEL

  WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY and [BALLBRAND] = @COMPANY 

  GROUP BY "Model Descr"

      ORDER BY COUNT(BALLMODEL) DESC, "Model Descr" ASC;

      

      

      --execute dbo.Get_TopSheet 'TITLEIST', 'The Masters', '4/8/2010', 'Balls'

      

      

ELSE IF (@REPORTNAME = 'Spikes')

  SELECT

COALESCE("Model Descr", "Model Code") AS MODEL, COUNT(SPIKEMODEL) AS "Count",

(SELECT COUNT(SPIKEMODEL) FROM [Input].[All] WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS TOTAL

  FROM [Player_Master].[All]

  LEFT OUTER JOIN [LKP].[Model Codes and Descr] ON "Model Code" = SPIKEMODEL

  WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY

  GROUP BY COALESCE("Model Descr", "Model Code")

      ORDER BY COUNT(SPIKEMODEL) DESC, COALESCE("Model Descr", "Model Code") ASC;





ELSE IF (@REPORTNAME = 'Driver')

SELECT a."Model Descr" AS MODEL, COUNT(a."Model Descr") AS "Count",

(SELECT COUNT("Wood MODEL Code") FROM [Player_Master].[Wood Detail] WHERE "Survey ID" = @SID AND "First Day" = @FIRSTDAY and ISDRIVER = 1) AS TOTAL

 FROM

(SELECT * FROM [Player_Master].[Wood Detail] WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID and ISDRIVER = 1) c

LEFT OUTER JOIN LKP.[Model Codes and Descr] a ON "Wood MODEL Code" = a."Model Code"

WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID

GROUP BY "Model Descr"

ORDER BY COUNT(a."Model Descr") DESC, a."Model Descr" ASC;







ELSE IF (@REPORTNAME = 'All Woods')

      SELECT

"Model Descr" AS MODEL, COUNT("Wood MODEL Code") AS "Count",

(SELECT COUNT("Wood MODEL Code") FROM [Player_Master].[Wood Detail] WHERE "Survey ID" = @SID AND "First Day" = @FIRSTDAY) AS TOTAL

  FROM [Player_Master].[Wood Detail]

  LEFT OUTER JOIN [LKP].[Model Codes and Descr] ON "Model Code" = "Wood MODEL Code"

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY

  GROUP BY "Model Descr"

      ORDER BY COUNT("Wood MODEL Code") DESC, "Model Descr" ASC;

            



ELSE IF (@REPORTNAME = 'Fairway Including Hybrid')

SELECT b."Model Descr" AS MODEL, COUNT(b."Model Descr") AS "Count",

(SELECT COUNT("Wood MODEL Code") FROM [Player_Master].[Wood Detail] WHERE "Survey ID" = @SID AND "First Day" = @FIRSTDAY and ISDRIVER = 0) AS TOTAL

 FROM [Player_Master].[Wood Detail] a

LEFT OUTER JOIN LKP.[Model Codes and Descr] b ON "Wood MODEL Code" = b."Model Code"

WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID and ISDRIVER = 0

GROUP BY "Model Descr"

ORDER BY COUNT(b."Model Descr") DESC, b."Model Descr" ASC;

      

      

ELSE IF (@REPORTNAME = 'Fairway wo Hybrid')

SELECT b."Model Descr" AS MODEL, COUNT(b."Model Descr") AS "Count",

(SELECT COUNT("Wood MODEL Code") FROM [Player_Master].[Wood Detail] WHERE "Survey ID" = @SID AND "First Day" = @FIRSTDAY  AND ISDRIVER = 0 and [Wood club Code] <> 'HYB') AS TOTAL

 FROM [Player_Master].[Wood Detail] a

LEFT OUTER JOIN LKP.[Model Codes and Descr] b ON "Wood MODEL Code" = b."Model Code"

WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SID and ISDRIVER = 0 AND a."Wood Club Code" <> 'HYB'

GROUP BY "Model Descr"

ORDER BY COUNT(b."Model Descr") DESC, b."Model Descr" ASC;

      

      

ELSE IF (@REPORTNAME = 'Hybrid Woods')

      SELECT

"Model Descr" AS MODEL, COUNT("Wood MODEL Code") AS "Count",

(SELECT COUNT("Wood MODEL Code") FROM [Player_Master].[Wood Detail] WHERE "Survey ID" = @SID AND "First Day" = @FIRSTDAY  and [Wood club Code] = 'HYB') AS TOTAL

  FROM [Player_Master].[Wood Detail]

  LEFT OUTER JOIN [LKP].[Model Codes and Descr] ON "Model Code" = "Wood MODEL Code"

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND "Wood Club Code" = 'HYB'

  GROUP BY "Model Descr"

      ORDER BY COUNT("Wood MODEL Code") DESC, "Model Descr" ASC;            

 

 ELSE IF (@REPORTNAME = 'Wood wo Hybrid')

      SELECT

"Model Descr" AS MODEL, COUNT("Wood MODEL Code") AS "Count",

(SELECT COUNT("Wood MODEL Code") FROM [Player_Master].[Wood Detail] WHERE "Survey ID" = @SID AND "First Day" = @FIRSTDAY  and [Wood club Code] <> 'HYB') AS TOTAL

  FROM [Player_Master].[Wood Detail]

  LEFT OUTER JOIN [LKP].[Model Codes and Descr] ON "Model Code" = "Wood MODEL Code"

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND "Wood Club Code" <> 'HYB'

  GROUP BY "Model Descr"

      ORDER BY COUNT("Wood MODEL Code") DESC, "Model Descr" ASC;           



ELSE IF (@REPORTNAME = 'Iron')

WITH IRONSETTABLE AS (

SELECT Name, [Iron MODEL Code] as "Iron MODEL Code" FROM Player_Master.[Iron Detail] WHERE "Survey ID" = @SID AND "First Day" = @FIRSTDAY and ISSET = 1 group by Name, [Iron MODEL Code]

)



      SELECT

"Model Descr" AS MODEL, COUNT("Iron MODEL Code") AS "Count",

(SELECT COUNT("Iron MODEL Code") FROM IRONSETTABLE) AS TOTAL

  FROM IRONSETTABLE a

  LEFT OUTER JOIN [LKP].[Model Codes and Descr] ON "Model Code" = "Iron MODEL Code"

  GROUP BY "Model Descr"

      ORDER BY COUNT("Iron MODEL Code") DESC, "Model Descr" ASC;





ELSE IF (@REPORTNAME = 'Utility Iron')

 select *, SUM([COUNT]) over() as TOTAL from ( 

 SELECT "Model Descr" AS MODEL, 

		sum(case when [Iron Club Code] like '%-%' then (cast(SUBSTRING([Iron Club Code],3,1) AS tinyint) - 

												cast(SUBSTRING([Iron Club Code],1,1) AS tinyint) +1)

				 else 1 end) AS "Count"

  FROM [Player_Master].[Iron Detail]

  LEFT OUTER JOIN [LKP].[Model Codes and Descr] ON "Model Code" = "Iron MODEL Code"

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND [Iron Club Code] LIKE '%^%'

  GROUP BY "Model Descr") a

  ORDER BY [COUNT] DESC, [model] ASC;

      



ELSE IF (@REPORTNAME = 'Putter')

      SELECT

"Model Descr" AS MODEL, COUNT("Putter MODEL Code") AS "Count",

(SELECT COUNT("Putter MODEL Code") FROM [Player_Master].[Putter Detail] WHERE "Survey ID" = @SID AND "First Day" = @FIRSTDAY) AS TOTAL

  FROM [Player_Master].[Putter Detail]

  LEFT OUTER JOIN [LKP].[Model Codes and Descr] ON "Model Code" = "Putter MODEL Code"

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY

  GROUP BY "Model Descr"

      ORDER BY COUNT("Putter MODEL Code") DESC, "Model Descr" ASC;





ELSE IF (@REPORTNAME = 'All Wedges (Including PW)')

--ELSE IF (@REPORTNAME = 'All Wedges')

      SELECT

"Model Descr" AS MODEL, COUNT("Wedge MODEL Code") AS "Count",

(SELECT COUNT("Wedge MODEL Code") FROM [Player_Master].[Wedge Detail] WHERE "Survey ID" = @SID AND "First Day" = @FIRSTDAY) AS TOTAL

  FROM [Player_Master].[Wedge Detail]

  LEFT OUTER JOIN [LKP].[Model Codes and Descr] ON "Model Code" = "Wedge MODEL Code"

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY

  GROUP BY "Model Descr"

      ORDER BY COUNT("Wedge MODEL Code") DESC, "Model Descr" ASC;

  

ELSE IF (@REPORTNAME = 'Pitching Wedge')      

--ELSE IF (@REPORTNAME = 'Pitch Wedges')

      SELECT

"Model Descr" AS MODEL, COUNT("Wedge MODEL Code") AS "Count",

(SELECT COUNT("Wedge MODEL Code") FROM [Player_Master].[Wedge Detail] WHERE "Survey ID" = @SID AND "First Day" = @FIRSTDAY and [Wedge Club Code] = 'PW') AS TOTAL

  FROM [Player_Master].[Wedge Detail]

  LEFT OUTER JOIN [LKP].[Model Codes and Descr] ON "Model Code" = "Wedge MODEL Code"

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY and [Wedge Club Code] = 'PW'

  GROUP BY "Model Descr"

      ORDER BY COUNT("Wedge MODEL Code") DESC, "Model Descr" ASC;



ELSE IF (@REPORTNAME = 'All Wedges (Excl. PW) AW,GW,SW,LW')      

--ELSE IF (@REPORTNAME = 'Other Wedges')

      SELECT

"Model Descr" AS MODEL, COUNT("Wedge MODEL Code") AS "Count",

(SELECT COUNT("Wedge MODEL Code") FROM [Player_Master].[Wedge Detail] WHERE "Survey ID" = @SID AND "First Day" = @FIRSTDAY and [Wedge Club Code] <> 'PW') AS TOTAL

  FROM [Player_Master].[Wedge Detail]

  LEFT OUTER JOIN [LKP].[Model Codes and Descr] ON "Model Code" = "Wedge MODEL Code"

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY and [Wedge Club Code] <> 'PW'

  GROUP BY "Model Descr"

      ORDER BY COUNT("Wedge MODEL Code") DESC, "Model Descr" ASC;

ELSE

 

--dummy select to set ourput variables for crystal reports

SELECT 'TITLEISTTITLEISTTITLEISTTITLEIST' AS MODEL, 34 as "Count", 12 as "%" WHERE 1=0;



     







END
GO
