IF OBJECT_ID('dbo.Get_Flash_TopSheet') IS NOT NULL
    DROP PROCEDURE [dbo].[Get_Flash_TopSheet];
GO

-- =============================================

-- Author:		<Author,,Name>

-- Create date: <Create Date,,>

-- Description:	<Description,,>

-- =============================================

CREATE PROCEDURE [dbo].[Get_Flash_TopSheet]

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



IF (@TOURNAMENTNAME IS NULL)

SELECT TOP 1 @TOURNAMENTNAME = [TOURNAMENT NAME], @FIRSTDAY = [FIRST DAY] FROM [Player_Master].[TOURNAMENTS_TABLE]

WHERE Year([FIRST DAY]) = YEAR(@FIRSTDAY)

ORDER BY [FIRST DAY] DESC;





SELECT TOP 1 @SID = SID FROM [Player_Master].[TOURNAMENTS_TABLE] WHERE "TOURNAMENT NAME" = @TOURNAMENTNAME AND [FIRST DAY] = @FIRSTDAY;



IF (@REPORTNAME = 'Bags')



SELECT 

BAGBRAND AS Brand, COUNT(BAGBRAND) AS "Count",

(SELECT COUNT(BAGBRAND) FROM [Input].[All] WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS "TOTAL"

  FROM 

  (select MAX(INPUTNO)AS MI, PLAYERNAME FROM INPUT.[All] where SID= @SID AND [First Day] = @FIRSTDAY group by PLAYERNAME) maxnos

LEFT OUTER JOIN

(SELECT * FROM Input.[All] where SID= @SID AND [First Day] = @FIRSTDAY) input on maxnos.PLAYERNAME = input.PLAYERNAME and maxnos.MI = input.INPUTNO

  GROUP BY BAGBRAND

      ORDER BY COUNT(BAGBRAND) DESC, BAGBRAND ASC;

      

ELSE IF (@REPORTNAME = 'Balls')

SELECT

BALLBRAND AS Brand, COUNT(BALLBRAND) AS "Count", 

(SELECT COUNT(BALLBRAND) FROM [Input].[All] WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS "TOTAL"

  FROM 

  (select MAX(INPUTNO)AS MI, PLAYERNAME FROM INPUT.[All] where SID= @SID AND [First Day] = @FIRSTDAY group by PLAYERNAME) maxnos

LEFT OUTER JOIN

(SELECT * FROM Input.[All] where SID= @SID AND [First Day] = @FIRSTDAY) input on maxnos.PLAYERNAME = input.PLAYERNAME and maxnos.MI = input.INPUTNO

  GROUP BY BALLBRAND

      ORDER BY COUNT(BALLBRAND) DESC, BALLBRAND ASC;

      

      

      --execute dbo.Get_TopSheet 'TITLEIST', 'The Masters', '4/8/2010', 'Balls'

      

      

ELSE IF (@REPORTNAME = 'Gloves')

  SELECT

GLOVEBRAND AS Brand, COUNT(GLOVEBRAND) AS "Count",

(SELECT COUNT(GLOVEBRAND) FROM [Input].[All] WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS "TOTAL"

  FROM 

  (select MAX(INPUTNO)AS MI, PLAYERNAME FROM INPUT.[All] where SID= @SID AND [First Day] = @FIRSTDAY group by PLAYERNAME) maxnos

LEFT OUTER JOIN

(SELECT * FROM Input.[All] where SID= @SID AND [First Day] = @FIRSTDAY) input on maxnos.PLAYERNAME = input.PLAYERNAME and maxnos.MI = input.INPUTNO

  GROUP BY GLOVEBRAND

      ORDER BY COUNT(GLOVEBRAND) DESC, GLOVEBRAND ASC;

      

      

ELSE IF (@REPORTNAME = 'Shoes')

SELECT

SHOEBRAND AS Brand, COUNT(SHOEBRAND) AS "Count",

(SELECT COUNT(SHOEBRAND) FROM [Input].[All] WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS "TOTAL"

  FROM 

  (select MAX(INPUTNO)AS MI, PLAYERNAME FROM INPUT.[All] where SID= @SID AND [First Day] = @FIRSTDAY group by PLAYERNAME) maxnos

LEFT OUTER JOIN

(SELECT * FROM Input.[All] where SID= @SID AND [First Day] = @FIRSTDAY) input on maxnos.PLAYERNAME = input.PLAYERNAME and maxnos.MI = input.INPUTNO

  GROUP BY SHOEBRAND

      ORDER BY COUNT(SHOEBRAND) DESC, SHOEBRAND ASC;





ELSE IF (@REPORTNAME = 'Driver')

select TOP 1 'nothing' from Input.wood;



ELSE IF (@REPORTNAME = 'Driver Shaft Brand')

select TOP 1 'nothing' from Input.wood;





ELSE IF (@REPORTNAME = 'All Woods')

      SELECT

BRAND AS Brand, COUNT(BRAND) AS "Count",

(SELECT COUNT(BRAND) FROM [Input].[Wood] WHERE SID = @SID AND "First Day" = @FIRSTDAY) AS "TOTAL"

  FROM 

  (select MAX(INPUTNO)AS MI, PLAYERNAME FROM INPUT.Wood where SID= @SID AND [First Day] = @FIRSTDAY group by PLAYERNAME) maxnos

LEFT OUTER JOIN

(SELECT * FROM Input.Wood where SID= @SID AND [First Day] = @FIRSTDAY) input on maxnos.PLAYERNAME = input.PLAYERNAME and maxnos.MI = input.INPUTNO

  GROUP BY BRAND

      ORDER BY COUNT(BRAND) DESC, BRAND ASC;

            



ELSE IF (@REPORTNAME = 'Fairway Including Hybrid')

select TOP 1 'nothing' from Input.wood;

      

      

ELSE IF (@REPORTNAME = 'Fairway wo Hybrid')

select TOP 1 'nothing' from Input.wood;

      

      

ELSE IF (@REPORTNAME = 'Hybrid Woods')

      SELECT

"Mfgr Descr" AS Brand, COUNT(BRAND) AS "Count",

(SELECT COUNT(BRAND) FROM [Input].[Wood] WHERE SID = @SID AND "First Day" = @FIRSTDAY) AS "TOTAL"

  FROM 

  (select MAX(INPUTNO)AS MI, PLAYERNAME FROM INPUT.Wood where SID= @SID AND [First Day] = @FIRSTDAY group by PLAYERNAME) maxnos

LEFT OUTER JOIN

(SELECT * FROM Input.Wood where SID= @SID AND [First Day] = @FIRSTDAY) input on maxnos.PLAYERNAME = input.PLAYERNAME and maxnos.MI = input.INPUTNO

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Code" = BRAND

  WHERE CLUBCODE = 'HYB'

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(BRAND) DESC, "Mfgr Descr" ASC;            

            

            

ELSE IF (@REPORTNAME = 'Hybrid Wood Shaft')

select TOP 1 'nothing' from Input.wood;

      

      

ELSE IF (@REPORTNAME = 'Headgear')

SELECT

HEADGEARBRAND AS Brand, COUNT(HEADGEARBRAND) AS "Count",

(SELECT COUNT(HEADGEARBRAND) FROM [Input].[All] WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS "TOTAL"

  FROM 

  (select MAX(INPUTNO)AS MI, PLAYERNAME FROM INPUT.[All] where SID= @SID AND [First Day] = @FIRSTDAY group by PLAYERNAME) maxnos

LEFT OUTER JOIN

(SELECT * FROM Input.[All] where SID= @SID AND [First Day] = @FIRSTDAY) input on maxnos.PLAYERNAME = input.PLAYERNAME and maxnos.MI = input.INPUTNO

  GROUP BY HEADGEARBRAND

      ORDER BY COUNT(HEADGEARBRAND) DESC, HEADGEARBRAND ASC;





ELSE IF (@REPORTNAME = 'Iron')

select TOP 1 'nothing' from Input.wood;





ELSE IF (@REPORTNAME = 'Utility Iron')

      SELECT

"Mfgr Descr" AS Brand, COUNT(BRAND) AS "Count",

(SELECT COUNT(BRAND) FROM [Input].[Iron] WHERE SID = @SID AND "First Day" = @FIRSTDAY) AS "TOTAL"

  FROM 

  (select MAX(INPUTNO)AS MI, PLAYERNAME FROM INPUT.[Iron] where SID= @SID AND [First Day] = @FIRSTDAY group by PLAYERNAME) maxnos

LEFT OUTER JOIN

(SELECT * FROM Input.[Iron] where SID= @SID AND [First Day] = @FIRSTDAY) input on maxnos.PLAYERNAME = input.PLAYERNAME and maxnos.MI = input.INPUTNO

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Code" = BRAND

  WHERE CLUBCODE LIKE 'TOTAL^TOTAL'

  GROUP BY "Mfgr Descr"

      ORDER BY COUNT(BRAND) DESC, "Mfgr Descr" ASC;

      



ELSE IF (@REPORTNAME = 'Putter')

      SELECT

BRAND AS Brand, COUNT(BRAND) AS "Count",

(SELECT COUNT(BRAND) FROM [Input].[Putter] WHERE SID = @SID AND "First Day" = @FIRSTDAY) AS "TOTAL"

  FROM 

  (select MAX(INPUTNO)AS MI, PLAYERNAME FROM INPUT.[Putter] where SID= @SID AND [First Day] = @FIRSTDAY group by PLAYERNAME) maxnos

LEFT OUTER JOIN

(SELECT * FROM Input.[Putter] where SID= @SID AND [First Day] = @FIRSTDAY) input on maxnos.PLAYERNAME = input.PLAYERNAME and maxnos.MI = input.INPUTNO

  GROUP BY BRAND

      ORDER BY COUNT(BRAND) DESC, BRAND ASC;







ELSE IF (@REPORTNAME = 'Shaft')

select TOP 1 'nothing' from Input.wood;





ELSE IF (@REPORTNAME = 'Iron Shaft Material')

select TOP 1 'nothing' from Input.wood;





ELSE IF (@REPORTNAME = 'Iron Shaft Manufacturer')

select TOP 1 'nothing' from Input.wood;





ELSE IF (@REPORTNAME = 'Iron Shaft Brand')

select TOP 1 'nothing' from Input.wood;





ELSE IF (@REPORTNAME = 'Wood Shaft Material')

 select TOP 1 'nothing' from Input.wood;





ELSE IF (@REPORTNAME = 'Wood Shaft Manufacturer')

select TOP 1 'nothing' from Input.wood;





ELSE IF (@REPORTNAME = 'Wood Shaft Brand')

 select TOP 1 'nothing' from Input.wood;





ELSE IF (@REPORTNAME = 'All Wedges')

      SELECT

BRAND AS Brand, COUNT(BRAND) AS "Count",

(SELECT COUNT(BRAND) FROM [Input].[Wedge] WHERE SID = @SID AND "First Day" = @FIRSTDAY) AS "TOTAL"

  FROM 

  (select MAX(INPUTNO)AS MI, PLAYERNAME FROM INPUT.[Wedge] where SID= @SID AND [First Day] = @FIRSTDAY group by PLAYERNAME) maxnos

LEFT OUTER JOIN

(SELECT * FROM Input.[Wedge] where SID= @SID AND [First Day] = @FIRSTDAY) input on maxnos.PLAYERNAME = input.PLAYERNAME and maxnos.MI = input.INPUTNO

  GROUP BY BRAND

      ORDER BY COUNT(BRAND) DESC, BRAND ASC;

      

ELSE IF (@REPORTNAME = 'Pitch Wedges')

      SELECT

BRAND AS Brand, COUNT(BRAND) AS "Count",

(SELECT COUNT(BRAND) FROM [Input].[Wedge] WHERE SID = @SID AND "First Day" = @FIRSTDAY and CLUBCODE = 'PW') AS "TOTAL"

  FROM 

  (select MAX(INPUTNO)AS MI, PLAYERNAME FROM INPUT.[Wedge] where SID= @SID AND [First Day] = @FIRSTDAY group by PLAYERNAME) maxnos

LEFT OUTER JOIN

(SELECT * FROM Input.[Wedge] where SID= @SID AND [First Day] = @FIRSTDAY) input on maxnos.PLAYERNAME = input.PLAYERNAME and maxnos.MI = input.INPUTNO

  WHERE CLUBCODE = 'PW'

  GROUP BY BRAND

      ORDER BY COUNT(BRAND) DESC, BRAND ASC;

      

ELSE IF (@REPORTNAME = 'Other Wedges')

      SELECT

BRAND AS Brand, COUNT(BRAND) AS "Count",

(SELECT COUNT(BRAND) FROM [Input].[Wedge] WHERE SID = @SID AND "First Day" = @FIRSTDAY and CLUBCODE <> 'PW') AS "TOTAL"

  FROM 

  (select MAX(INPUTNO)AS MI, PLAYERNAME FROM INPUT.[Wedge] where SID= @SID AND [First Day] = @FIRSTDAY group by PLAYERNAME) maxnos

LEFT OUTER JOIN

(SELECT * FROM Input.[Wedge] where SID= @SID AND [First Day] = @FIRSTDAY) input on maxnos.PLAYERNAME = input.PLAYERNAME and maxnos.MI = input.INPUTNO

  WHERE CLUBCODE <> 'PW'

  GROUP BY BRAND

      ORDER BY COUNT(BRAND) DESC, BRAND ASC;

ELSE

 

--dummy select to set ourput variables for crystal reports

SELECT 'TITLEISTTITLEISTTITLEISTTITLEIST' AS Brand, 34 as "Count", 12 as "TOTAL" WHERE 1=0;



     







END
GO
