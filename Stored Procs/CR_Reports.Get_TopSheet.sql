IF OBJECT_ID('CR_Reports.Get_TopSheet') IS NOT NULL
    DROP PROCEDURE [CR_Reports].[Get_TopSheet];
GO

CREATE PROCEDURE [CR_Reports].[Get_TopSheet]

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



SELECT TOP 1 @SID = SID FROM [Player_Master].[TOURNAMENTS_TABLE] WHERE [TOURNAMENT NAME] = @TOURNAMENTNAME AND [FIRST DAY] = @FIRSTDAY;



IF (@REPORTNAME = 'Bags')



SELECT 

[Mfgr Descr] AS Brand, COUNT(BAGBRAND) AS [Count],

(SELECT COUNT(BAGBRAND) FROM [Player_Master].[All] WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS TOTAL

  FROM [Player_Master].[All]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = BAGBRAND

  WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT(BAGBRAND) DESC, [Mfgr Descr] ASC;

      

ELSE IF (@REPORTNAME = 'Balls')

SELECT

[Mfgr Descr] AS Brand, COUNT(BALLBRAND) AS [Count], 

(SELECT COUNT(BALLBRAND) FROM [Player_Master].[All] WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS TOTAL

  FROM [Player_Master].[All]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = BALLBRAND

  WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT(BALLBRAND) DESC, [Mfgr Descr] ASC;

      

    

      

ELSE IF (@REPORTNAME = 'Gloves')

  SELECT

[Mfgr Descr] AS Brand, COUNT(GLOVEBRAND) AS [Count],

(SELECT COUNT(GLOVEBRAND) FROM [Player_Master].[All] WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS TOTAL

  FROM [Player_Master].[All]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = GLOVEBRAND

  WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT(GLOVEBRAND) DESC, [Mfgr Descr] ASC;

      

      

ELSE IF (@REPORTNAME = 'Shoes')

SELECT

[Mfgr Descr] AS Brand, COUNT(SHOEBRAND) AS [Count],

(SELECT COUNT(SHOEBRAND) FROM [Player_Master].[All] WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS TOTAL

  FROM [Player_Master].[All]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = SHOEBRAND

  WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT(SHOEBRAND) DESC, [Mfgr Descr] ASC;





ELSE IF (@REPORTNAME = 'Raingear')

SELECT

[Mfgr Descr] AS Brand, COUNT(RAINGEARBRAND) AS [Count],

(SELECT COUNT(RAINGEARBRAND) FROM [Player_Master].[All] 

	WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS TOTAL

  FROM [Player_Master].[All]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = RAINGEARBRAND

  WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT(RAINGEARBRAND) DESC, [Mfgr Descr] ASC;

      



ELSE IF (@REPORTNAME = 'Caddies HeadGear')

  SELECT

[Mfgr Descr] AS Brand, COUNT(SHIRTBRAND) AS [Count],

(SELECT COUNT(SHIRTBRAND) FROM [Player_Master].[All] WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS TOTAL

  FROM [Player_Master].[All]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = SHIRTBRAND

  WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT(SHIRTBRAND) DESC, [Mfgr Descr] ASC;

      



ELSE IF (@REPORTNAME = 'Sunglasses')

  SELECT

[Mfgr Descr] AS Brand, COUNT(GLASSESBRAND) AS [Count],

(SELECT COUNT(GLASSESBRAND) FROM [Player_Master].[All] WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS TOTAL

  FROM [Player_Master].[All]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = GLASSESBRAND

  WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT(GLASSESBRAND) DESC, [Mfgr Descr] ASC;







ELSE IF (@REPORTNAME = 'Spikes')

  SELECT

COALESCE([Mfgr Descr], [Mfgr Code]) AS Brand, COUNT(SPIKEBRAND) AS [Count],

(SELECT COUNT(SPIKEBRAND) FROM [Input].[All] WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS TOTAL

  FROM [Player_Master].[All]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = SPIKEBRAND

  WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY

  GROUP BY COALESCE([Mfgr Descr], [Mfgr Code])

      ORDER BY COUNT(SPIKEBRAND) DESC, COALESCE([Mfgr Descr], [Mfgr Code]) ASC;





ELSE IF (@REPORTNAME = 'Driver')



SELECT a.[Mfgr Descr] AS Brand, COUNT(a.[Mfgr Descr]) AS [Count],

(SELECT COUNT([Wood Brand Code]) FROM [Player_Master].[Wood Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY and ISDRIVER = 1) AS TOTAL

 FROM

(SELECT * FROM [Player_Master].[Wood Detail] WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID and ISDRIVER = 1) c

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a ON [Wood Brand Code] = a.[Mfgr Code]

WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID

GROUP BY [Mfgr Descr]

ORDER BY COUNT(a.[Mfgr Descr]) DESC, a.[Mfgr Descr] ASC;





ELSE IF (@REPORTNAME = 'Driver Shaft Brand')



SELECT f.[Mfgr Descr] AS Brand, COUNT(f.[Mfgr Descr]) AS [Count],

(SELECT COUNT([Wood Brand Code]) FROM [Player_Master].[Wood Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY and ISDRIVER = 1) AS TOTAL

  

FROM (

SELECT [PKey], [Name], [Survey ID], [First Day], ISDRIVER, [Wood Club Code], [Wood Brand Code], DBRANDCODE, [Wood Model Code], DMODELCODE, [Wood Size Code], DSIZECODE, [Wood Mat'l Code], DMATERIAL

FROM Player_Master.[Wood Detail]

WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID and ISDRIVER = 1

GROUP BY [PKey], [Name], [Survey ID], [First Day], ISDRIVER, [Wood Club Code], [Wood Brand Code], DBRANDCODE, [Wood Model Code], DMODELCODE, [Wood Size Code], DSIZECODE, [Wood Mat'l Code], DMATERIAL) a



LEFT OUTER JOIN (SELECT *

FROM Player_Master.[Shaft Detail] WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID AND [Shaft Equip Type] = 'WOOD') b

ON a.Name = b.Name and a.[Wood Club Code] = b.[Shaft Club Code] and a.PKey = b.pkey



LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] f ON [Shaft Brand Code] = f.[Mfgr Code]

WHERE a.[First Day] = @FIRSTDAY AND a.[Survey ID] = @SID and a.ISDRIVER = 1

GROUP BY [Mfgr Descr]

ORDER BY COUNT(f.[Mfgr Descr]) DESC, f.[Mfgr Descr] ASC;



ELSE IF (@REPORTNAME = 'Driver Shaft Material')



SELECT f.[Matl Code] AS Brand, COUNT(f.[Matl Code]) AS [Count],

(SELECT COUNT([Wood Brand Code]) FROM [Player_Master].[Wood Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY and ISDRIVER = 1) AS TOTAL

  

FROM (

SELECT [PKey], [Name], [Survey ID], [First Day], ISDRIVER, [Wood Club Code], [Wood Brand Code], DBRANDCODE, [Wood Model Code], DMODELCODE, [Wood Size Code], DSIZECODE, [Wood Mat'l Code], DMATERIAL

FROM Player_Master.[Wood Detail]

WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID and ISDRIVER = 1

GROUP BY [PKey], [Name], [Survey ID], [First Day], ISDRIVER, [Wood Club Code], [Wood Brand Code], DBRANDCODE, [Wood Model Code], DMODELCODE, [Wood Size Code], DSIZECODE, [Wood Mat'l Code], DMATERIAL) a



LEFT OUTER JOIN (SELECT *

FROM Player_Master.[Shaft Detail] WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID AND [Shaft Equip Type] = 'WOOD') b

ON a.Name = b.Name and a.[Wood Club Code] = b.[Shaft Club Code] and a.PKey = b.pkey



LEFT OUTER JOIN LKP.[Material Codes and Descript] f ON [Shaft Mat'l Code] = f.[Matl Code]

WHERE a.[First Day] = @FIRSTDAY AND a.[Survey ID] = @SID and a.ISDRIVER = 1

GROUP BY [Matl Code]

ORDER BY COUNT(f.[Matl Code]) DESC, f.[Matl Code] ASC;



ELSE IF (@REPORTNAME = 'Driver Shaft Manufacturer')



SELECT f.[Mfgr Descr] AS Brand, COUNT(f.[Mfgr Descr]) AS [Count],

(SELECT COUNT([Wood Brand Code]) FROM [Player_Master].[Wood Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY and ISDRIVER = 1) AS TOTAL

  

FROM (

SELECT [PKey], [Name], [Survey ID], [First Day], ISDRIVER, [Wood Club Code], [Wood Brand Code], DBRANDCODE, [Wood Model Code], DMODELCODE, [Wood Size Code], DSIZECODE, [Wood Mat'l Code], DMATERIAL

FROM Player_Master.[Wood Detail]

WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID and ISDRIVER = 1

GROUP BY [PKey], [Name], [Survey ID], [First Day], ISDRIVER, [Wood Club Code], [Wood Brand Code], DBRANDCODE, [Wood Model Code], DMODELCODE, [Wood Size Code], DSIZECODE, [Wood Mat'l Code], DMATERIAL) a



LEFT OUTER JOIN (SELECT *

FROM Player_Master.[Shaft Detail] WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID AND [Shaft Equip Type] = 'WOOD') b

ON a.Name = b.Name and a.[Wood Club Code] = b.[Shaft Club Code] and a.PKey = b.pkey



LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] f ON [Shaft Mfgr Code] = f.[Mfgr Code]

WHERE a.[First Day] = @FIRSTDAY AND a.[Survey ID] = @SID and a.ISDRIVER = 1

GROUP BY [Mfgr Descr]

ORDER BY COUNT(f.[Mfgr Descr]) DESC, f.[Mfgr Descr] ASC;





ELSE IF (@REPORTNAME = 'All Woods')

      SELECT

[Mfgr Descr] AS Brand, COUNT([Wood Brand Code]) AS [Count],

(SELECT COUNT([Wood Brand Code]) FROM [Player_Master].[Wood Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY) AS TOTAL

  FROM [Player_Master].[Wood Detail]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Wood Brand Code]

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT([Wood Brand Code]) DESC, [Mfgr Descr] ASC;

            



ELSE IF (@REPORTNAME = 'Fairway Including Hybrid')

SELECT b.[Mfgr Descr] AS Brand, COUNT(b.[Mfgr Descr]) AS [Count],

(SELECT COUNT([Wood Brand Code]) FROM [Player_Master].[Wood Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY  and ISDRIVER=0) AS TOTAL

 FROM

[Player_Master].[Wood Detail] a

LEFT OUTER JOIN

(SELECT [Name] AS DRIVER, MIN([PKey]) AS PKEY FROM [Player_Master].[Wood Detail] WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID GROUP BY [Name]) c

ON a.PKey = c.PKEY 

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] b ON [Wood Brand Code] = b.[Mfgr Code]

WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID AND DRIVER IS NULL

GROUP BY [Mfgr Descr]

ORDER BY COUNT(b.[Mfgr Descr]) DESC, b.[Mfgr Descr] ASC;

      

      

ELSE IF (@REPORTNAME = 'Fairway wo Hybrid')

SELECT b.[Mfgr Descr] AS Brand, COUNT(b.[Mfgr Descr]) AS [Count],

(SELECT COUNT([Wood Brand Code]) FROM [Player_Master].[Wood Detail] 

WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY  AND ISDRIVER = 0 and [Wood Club Code]<> 'HYB') AS TOTAL

 FROM

[Player_Master].[Wood Detail] a

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] b ON [Wood Brand Code] = b.[Mfgr Code]

WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID AND a.ISDRIVER = 0 AND a.[Wood Club Code] <> 'HYB'

GROUP BY [Mfgr Descr]

ORDER BY COUNT(b.[Mfgr Descr]) DESC, b.[Mfgr Descr] ASC;

      

      

ELSE IF (@REPORTNAME = 'Hybrid Woods')

      SELECT

[Mfgr Descr] AS Brand, COUNT([Wood Brand Code]) AS [Count],

(SELECT COUNT([Wood Brand Code]) FROM [Player_Master].[Wood Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY and  [Wood Club Code]= 'HYB') AS TOTAL

  FROM [Player_Master].[Wood Detail]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Wood Brand Code]

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND [Wood Club Code] = 'HYB'

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT([Wood Brand Code]) DESC, [Mfgr Descr] ASC;            

            

            

ELSE IF (@REPORTNAME = 'Hybrid Wood Shaft')

      SELECT

[Mfgr Descr] AS Brand, COUNT([Shaft Brand Code]) AS [Count],

(SELECT COUNT([Shaft Brand Code]) FROM [Player_Master].[Shaft Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY and [Shaft Equip Type]= 'WOOD' and [Shaft Club Code] = 'HYB') AS TOTAL

  FROM [Player_Master].[Shaft Detail]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Shaft Brand Code]

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY and [Shaft Equip Type]= 'WOOD' and [Shaft Club Code] = 'HYB'

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT([Shaft Brand Code]) DESC, [Mfgr Descr] ASC;    





ELSE IF (@REPORTNAME = 'Hybrid Wood Shaft Material')

      SELECT

[Matl Descr] AS Brand, COUNT([Shaft Mat'l Code]) AS [Count],

(SELECT COUNT([Shaft Mat'l Code]) FROM [Player_Master].[Shaft Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'WOOD' and [Shaft Club Code] = 'HYB') AS TOTAL

  FROM [Player_Master].[Shaft Detail]

  LEFT OUTER JOIN [LKP].[Material Codes and Descript] ON [Matl Code] = [Shaft Mat'l Code] 

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'WOOD' and [Shaft Club Code] = 'HYB'

  GROUP BY [Matl Descr]

      ORDER BY COUNT([Shaft Mat'l Code]) DESC, [Matl Descr] ASC;





ELSE IF (@REPORTNAME = 'Hybrid Wood Shaft Manufacturer')

      SELECT

[Mfgr Descr] AS Brand, COUNT([Shaft Mfgr Code]) AS [Count],

(SELECT COUNT([Shaft Mfgr Code]) FROM [Player_Master].[Shaft Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'WOOD' and [Shaft Club Code] = 'HYB') AS TOTAL

  FROM [Player_Master].[Shaft Detail]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Shaft Mfgr Code] 

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'WOOD' and [Shaft Club Code] = 'HYB'

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT([Shaft Mfgr Code]) DESC, [Mfgr Descr] ASC;





ELSE IF (@REPORTNAME = 'Hybrid Wood Shaft Brand')

      SELECT

[Mfgr Descr] AS Brand, COUNT([Shaft Brand Code]) AS [Count],

(SELECT COUNT([Shaft Brand Code]) FROM [Player_Master].[Shaft Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'WOOD' and [Shaft Club Code] = 'HYB') AS TOTAL

  FROM [Player_Master].[Shaft Detail]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Shaft Brand Code]

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'WOOD' and [Shaft Club Code] = 'HYB'

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT([Shaft Brand Code]) DESC, [Mfgr Descr] ASC;







      

ELSE IF (@REPORTNAME = 'Headgear')

SELECT

[Mfgr Descr] AS Brand, COUNT(HEADGEARBRAND) AS [Count],

(SELECT COUNT(HEADGEARBRAND) FROM [Player_Master].[All] WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS TOTAL

  FROM [Player_Master].[All]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = HEADGEARBRAND

  WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT(HEADGEARBRAND) DESC, [Mfgr Descr] ASC;





ELSE IF (@REPORTNAME = 'Iron')



WITH IRONSETTABLE AS (

SELECT Name, [Iron Brand Code] as [Iron Brand Code] FROM Player_Master.[Iron Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY and ISSET = 1 group by Name, [Iron Brand Code]

)



      SELECT

[Mfgr Descr] AS Brand, COUNT([Iron Brand Code]) AS [Count],

(SELECT COUNT([Iron Brand Code]) FROM IRONSETTABLE) AS TOTAL

  FROM IRONSETTABLE a

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Iron Brand Code]

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT([Iron Brand Code]) DESC, [Mfgr Descr] ASC;





ELSE IF (@REPORTNAME = 'Utility Iron')

      SELECT

[Mfgr Descr] AS Brand, COUNT([Iron Brand Code]) AS [Count],

(SELECT COUNT([Iron Brand Code]) FROM [Player_Master].[Iron Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY  and [Iron Club Code] like '%^%') AS TOTAL

  FROM [Player_Master].[Iron Detail]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Iron Brand Code]

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND [Iron Club Code] LIKE '%^%'

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT([Iron Brand Code]) DESC, [Mfgr Descr] ASC;

      



ELSE IF (@REPORTNAME = 'Putter')

      SELECT

[Mfgr Descr] AS Brand, COUNT([Putter Brand Code]) AS [Count],

(SELECT COUNT([Putter Brand Code]) FROM [Player_Master].[Putter Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY) AS TOTAL

  FROM [Player_Master].[Putter Detail]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Putter Brand Code]

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT([Putter Brand Code]) DESC, [Mfgr Descr] ASC;







ELSE IF (@REPORTNAME = 'Shaft')

      SELECT

[Mfgr Descr] AS Brand, COUNT([Shaft Brand Code]) AS [Count],

(SELECT COUNT([Shaft Brand Code]) FROM [Player_Master].[Shaft Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY) AS TOTAL

  FROM [Player_Master].[Shaft Detail]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Shaft Brand Code]

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT([Shaft Brand Code]) DESC, [Mfgr Descr] ASC;





ELSE IF (@REPORTNAME = 'Iron Shaft Material')

WITH IRONSETTABLE_SHAFT AS (

SELECT a.Name, [Iron Club Code], [Iron Brand Code], [Iron Model Code], [Shaft Mfgr Code], [Shaft Brand Code], [Shaft Model Code], [Shaft Mat'l Code]

FROM Player_Master.[Iron Detail] a

LEFT OUTER JOIN Player_Master.[Shaft Detail] b ON a.Name = b.Name and a.[First Day]= b.[First Day] and a.[Survey ID] = b.[Survey ID] and a.[Iron Club Code] = b.[Shaft Club Code]

WHERE a.[Survey ID] = @SID AND a.[First Day] = @FIRSTDAY and ISSET = 1 and [Shaft Equip Type]= 'IRON'

group by a.Name, [Iron Club Code], [Iron Brand Code], [Iron Model Code], [Shaft Mfgr Code], [Shaft Brand Code], [Shaft Model Code], [Shaft Mat'l Code]

),



IRONSHAFTMATLTABLE AS (

SELECT Name, [Iron Brand Code], [Shaft Mat'l Code] FROM IRONSETTABLE_SHAFT GROUP BY Name, [Iron Brand Code], [Shaft Mat'l Code]

)





      SELECT

[Matl Descr] AS Brand, COUNT([Shaft Mat'l Code]) AS [Count],

(SELECT COUNT([Shaft Mat'l Code]) FROM IRONSHAFTMATLTABLE) AS TOTAL

  FROM IRONSHAFTMATLTABLE

  LEFT OUTER JOIN [LKP].[Material Codes and Descript] ON [Matl Code] = [Shaft Mat'l Code] 

  GROUP BY [Matl Descr]

      ORDER BY COUNT([Shaft Mat'l Code]) DESC, [Matl Descr] ASC;





ELSE IF (@REPORTNAME = 'Iron Shaft Manufacturer')

WITH IRONSETTABLE_SHAFT AS (

SELECT a.Name, [Iron Club Code], [Iron Brand Code], [Iron Model Code], [Shaft Mfgr Code], [Shaft Brand Code], [Shaft Model Code], [Shaft Mat'l Code]

FROM Player_Master.[Iron Detail] a

LEFT OUTER JOIN Player_Master.[Shaft Detail] b ON a.Name = b.Name and a.[First Day]= b.[First Day] and a.[Survey ID] = b.[Survey ID] and a.[Iron Club Code] = b.[Shaft Club Code]

WHERE a.[Survey ID] = @SID AND a.[First Day] = @FIRSTDAY and ISSET = 1 and [Shaft Equip Type]= 'IRON'

group by a.Name, [Iron Club Code], [Iron Brand Code], [Iron Model Code], [Shaft Mfgr Code], [Shaft Brand Code], [Shaft Model Code], [Shaft Mat'l Code]

),

IRONSHAFTMFGRTABLE AS(

SELECT Name, [Shaft Mfgr Code] from IRONSETTABLE_SHAFT Group by Name, [shaft mfgr code]

)

      SELECT

[Mfgr Descr] AS Brand, COUNT([Shaft Mfgr Code]) AS [Count],

(SELECT COUNT([Shaft Mfgr Code]) FROM IRONSHAFTMFGRTABLE) AS TOTAL

  FROM IRONSHAFTMFGRTABLE

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Shaft Mfgr Code] 

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT([Shaft Mfgr Code]) DESC, [Mfgr Descr] ASC;





ELSE IF (@REPORTNAME = 'Iron Shaft Brand')

WITH IRONSETTABLE_SHAFT AS (

SELECT a.Name, [Iron Club Code], [Iron Brand Code], [Iron Model Code], [Shaft Mfgr Code], [Shaft Brand Code], [Shaft Model Code], [Shaft Mat'l Code]

FROM Player_Master.[Iron Detail] a

LEFT OUTER JOIN Player_Master.[Shaft Detail] b ON a.Name = b.Name and a.[First Day]= b.[First Day] and a.[Survey ID] = b.[Survey ID] and a.[Iron Club Code] = b.[Shaft Club Code]

WHERE a.[Survey ID] = @SID AND a.[First Day] = @FIRSTDAY and ISSET = 1 and [Shaft Equip Type]= 'IRON'

group by a.Name, [Iron Club Code], [Iron Brand Code], [Iron Model Code], [Shaft Mfgr Code], [Shaft Brand Code], [Shaft Model Code], [Shaft Mat'l Code]

),

IRONSHAFTBRANDTABLE AS(

SELECT Name, [Shaft Brand Code] from IRONSETTABLE_SHAFT Group by Name, [shaft brand code]

)

      SELECT

[Mfgr Descr] AS Brand, COUNT([Shaft Brand Code]) AS [Count],

(SELECT COUNT([Shaft Brand Code]) FROM IRONSHAFTBRANDTABLE) AS TOTAL

  FROM IRONSHAFTBRANDTABLE

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Shaft Brand Code]

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT([Shaft Brand Code]) DESC, [Mfgr Descr] ASC;





ELSE IF (@REPORTNAME = 'Utility Iron Shaft Material')

WITH IRONSETTABLE_SHAFT AS (

SELECT a.Name, [Iron Club Code], [Iron Brand Code], [Iron Model Code], [Shaft Mfgr Code], [Shaft Brand Code], [Shaft Model Code], [Shaft Mat'l Code]

FROM Player_Master.[Iron Detail] a 

LEFT OUTER JOIN Player_Master.[Shaft Detail] b ON a.Name = b.Name and a.[First Day]= b.[First Day] and a.[Survey ID] = b.[Survey ID] and a.[Iron Club Code] = b.[Shaft Club Code]

WHERE a.[Survey ID] = @SID AND a.[First Day] = @FIRSTDAY and [Shaft Equip Type]= 'IRON' and [Iron Club Code] like '%^%'

group by a.Name, [Iron Club Code], [Iron Brand Code], [Iron Model Code], [Shaft Mfgr Code], [Shaft Brand Code], [Shaft Model Code], [Shaft Mat'l Code]

),



IRONSHAFTMATLTABLE AS (

SELECT Name, [Iron Brand Code], [Shaft Mat'l Code] FROM IRONSETTABLE_SHAFT GROUP BY Name, [Iron Brand Code], [Shaft Mat'l Code]

)





      SELECT

[Matl Descr] AS Brand, COUNT([Shaft Mat'l Code]) AS [Count],

(SELECT COUNT([Shaft Mat'l Code]) FROM IRONSHAFTMATLTABLE) AS TOTAL

  FROM IRONSHAFTMATLTABLE

  LEFT OUTER JOIN [LKP].[Material Codes and Descript] ON [Matl Code] = [Shaft Mat'l Code] 

  GROUP BY [Matl Descr]

      ORDER BY COUNT([Shaft Mat'l Code]) DESC, [Matl Descr] ASC;





ELSE IF (@REPORTNAME = 'Utility Iron Shaft Manufacturer')

WITH IRONSETTABLE_SHAFT AS (

SELECT a.Name, [Iron Club Code], [Iron Brand Code], [Iron Model Code], [Shaft Mfgr Code], [Shaft Brand Code], [Shaft Model Code], [Shaft Mat'l Code]

FROM Player_Master.[Iron Detail] a

LEFT OUTER JOIN Player_Master.[Shaft Detail] b ON a.Name = b.Name and a.[First Day]= b.[First Day] and a.[Survey ID] = b.[Survey ID] and a.[Iron Club Code] = b.[Shaft Club Code]

WHERE a.[Survey ID] = @SID AND a.[First Day] = @FIRSTDAY and [Shaft Equip Type]= 'IRON' and [Iron Club Code] like '%^%'

group by a.Name, [Iron Club Code], [Iron Brand Code], [Iron Model Code], [Shaft Mfgr Code], [Shaft Brand Code], [Shaft Model Code], [Shaft Mat'l Code]

),

IRONSHAFTMFGRTABLE AS(

SELECT Name, [Shaft Mfgr Code] from IRONSETTABLE_SHAFT Group by Name, [shaft mfgr code]

)

      SELECT

[Mfgr Descr] AS Brand, COUNT([Shaft Mfgr Code]) AS [Count],

(SELECT COUNT([Shaft Mfgr Code]) FROM IRONSHAFTMFGRTABLE) AS TOTAL

  FROM IRONSHAFTMFGRTABLE

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Shaft Mfgr Code] 

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT([Shaft Mfgr Code]) DESC, [Mfgr Descr] ASC;





ELSE IF (@REPORTNAME = 'Utility Iron Shaft Brand')

WITH IRONSETTABLE_SHAFT AS (

SELECT a.Name, [Iron Club Code], [Iron Brand Code], [Iron Model Code], [Shaft Mfgr Code], [Shaft Brand Code], [Shaft Model Code], [Shaft Mat'l Code]

FROM Player_Master.[Iron Detail] a

LEFT OUTER JOIN Player_Master.[Shaft Detail] b ON a.Name = b.Name and a.[First Day]= b.[First Day] and a.[Survey ID] = b.[Survey ID] and a.[Iron Club Code] = b.[Shaft Club Code]

WHERE a.[Survey ID] = @SID AND a.[First Day] = @FIRSTDAY and [Shaft Equip Type]= 'IRON' and [Iron Club Code] like '%^%'

group by a.Name, [Iron Club Code], [Iron Brand Code], [Iron Model Code], [Shaft Mfgr Code], [Shaft Brand Code], [Shaft Model Code], [Shaft Mat'l Code]

),

IRONSHAFTBRANDTABLE AS(

SELECT Name, [Shaft Brand Code] from IRONSETTABLE_SHAFT Group by Name, [shaft brand code]

)

      SELECT

[Mfgr Descr] AS Brand, COUNT([Shaft Brand Code]) AS [Count],

(SELECT COUNT([Shaft Brand Code]) FROM IRONSHAFTBRANDTABLE) AS TOTAL

  FROM IRONSHAFTBRANDTABLE

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Shaft Brand Code]

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT([Shaft Brand Code]) DESC, [Mfgr Descr] ASC;





ELSE IF (@REPORTNAME = 'Wood Shaft Material')

      SELECT

[Matl Descr] AS Brand, COUNT([Shaft Mat'l Code]) AS [Count],

(SELECT COUNT([Shaft Mat'l Code]) FROM [Player_Master].[Shaft Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'WOOD') AS TOTAL

  FROM [Player_Master].[Shaft Detail]

  LEFT OUTER JOIN [LKP].[Material Codes and Descript] ON [Matl Code] = [Shaft Mat'l Code] 

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'WOOD'

  GROUP BY [Matl Descr]

      ORDER BY COUNT([Shaft Mat'l Code]) DESC, [Matl Descr] ASC;





ELSE IF (@REPORTNAME = 'Wood Shaft Manufacturer')

      SELECT

[Mfgr Descr] AS Brand, COUNT([Shaft Mfgr Code]) AS [Count],

(SELECT COUNT([Shaft Mfgr Code]) FROM [Player_Master].[Shaft Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'WOOD') AS TOTAL

  FROM [Player_Master].[Shaft Detail]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Shaft Mfgr Code] 

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'WOOD'

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT([Shaft Mfgr Code]) DESC, [Mfgr Descr] ASC;





ELSE IF (@REPORTNAME = 'Wood Shaft Brand')

      SELECT

[Mfgr Descr] AS Brand, COUNT([Shaft Brand Code]) AS [Count],

(SELECT COUNT([Shaft Brand Code]) FROM [Player_Master].[Shaft Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'WOOD') AS TOTAL

  FROM [Player_Master].[Shaft Detail]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Shaft Brand Code]

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'WOOD'

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT([Shaft Brand Code]) DESC, [Mfgr Descr] ASC;







ELSE IF (@REPORTNAME = 'Iron Grip Material')

WITH IRONSETTABLE_Grip AS (

SELECT a.Name, [Iron Club Code], [Iron Brand Code], [Iron Model Code], [Grip Mfgr Code], [Grip Brand Code], [Grip Model Code], [Grip Mat'l Code]

FROM Player_Master.[Iron Detail] a

LEFT OUTER JOIN Player_Master.[Grip Detail] b ON a.Name = b.Name and a.[First Day]= b.[First Day] and a.[Survey ID] = b.[Survey ID] and a.[Iron Club Code] = b.[Grip Club Code]

WHERE a.[Survey ID] = @SID AND a.[First Day] = @FIRSTDAY and ISSET = 1 and [Grip Equip Type]= 'IRON'

group by a.Name, [Iron Club Code], [Iron Brand Code], [Iron Model Code], [Grip Mfgr Code], [Grip Brand Code], [Grip Model Code], [Grip Mat'l Code]

),



IRONGripMATLTABLE AS (

SELECT Name, [Iron Brand Code], [Grip Mat'l Code] FROM IRONSETTABLE_Grip GROUP BY Name, [Iron Brand Code], [Grip Mat'l Code]

)





      SELECT

[Matl Descr] AS Brand, COUNT([Grip Mat'l Code]) AS [Count],

(SELECT COUNT([Grip Mat'l Code]) FROM IRONGRIPMATLTABLE) AS TOTAL

  FROM IRONGripMATLTABLE

  LEFT OUTER JOIN [LKP].[Material Codes and Descript] ON [Matl Code] = [Grip Mat'l Code] 

  GROUP BY [Matl Descr]

      ORDER BY COUNT([Grip Mat'l Code]) DESC, [Matl Descr] ASC;





ELSE IF (@REPORTNAME = 'Iron Grip Manufacturer')

WITH IRONSETTABLE_GRIP AS (

SELECT a.Name, [Iron Club Code], [Iron Brand Code], [Iron Model Code], [Grip Mfgr Code], [Grip Brand Code], [Grip Model Code], [Grip Mat'l Code]

FROM Player_Master.[Iron Detail] a

LEFT OUTER JOIN Player_Master.[Grip Detail] b ON a.Name = b.Name and a.[First Day]= b.[First Day] and a.[Survey ID] = b.[Survey ID] and a.[Iron Club Code] = b.[Grip Club Code]

WHERE a.[Survey ID] = @SID AND a.[First Day] = @FIRSTDAY and ISSET = 1 and [Grip Equip Type]= 'IRON'

group by a.Name, [Iron Club Code], [Iron Brand Code], [Iron Model Code], [Grip Mfgr Code], [Grip Brand Code], [Grip Model Code], [Grip Mat'l Code]

),

IRONGRIPMFGRTABLE AS(

SELECT Name, [Grip Mfgr Code] from IRONSETTABLE_Grip Group by Name, [Grip mfgr code]

)





      SELECT

[Mfgr Descr] AS Brand, COUNT([Grip Mfgr Code]) AS [Count],

(SELECT COUNT([Grip Mfgr Code]) FROM IRONGRIPMFGRTABLE) AS TOTAL

  FROM IRONGripMFGRTABLE

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Grip Mfgr Code] 

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT([Grip Mfgr Code]) DESC, [Mfgr Descr] ASC;





ELSE IF (@REPORTNAME = 'Iron Grip Brand')

WITH IRONSETTABLE_Grip AS (

SELECT a.Name, [Iron Club Code], [Iron Brand Code], [Iron Model Code], [Grip Mfgr Code], [Grip Brand Code], [Grip Model Code], [Grip Mat'l Code]

FROM Player_Master.[Iron Detail] a

LEFT OUTER JOIN Player_Master.[Grip Detail] b ON a.Name = b.Name and a.[First Day]= b.[First Day] and a.[Survey ID] = b.[Survey ID] and a.[Iron Club Code] = b.[Grip Club Code]

WHERE a.[Survey ID] = @SID AND a.[First Day] = @FIRSTDAY and ISSET = 1 and [Grip Equip Type]= 'IRON'

group by a.Name, [Iron Club Code], [Iron Brand Code], [Iron Model Code], [Grip Mfgr Code], [Grip Brand Code], [Grip Model Code], [Grip Mat'l Code]

),

IRONGripBRANDTABLE AS(

SELECT Name, [Grip Brand Code] from IRONSETTABLE_Grip Group by Name, [Grip brand code]

)

      SELECT

[Mfgr Descr] AS Brand, COUNT([Grip Brand Code]) AS [Count],

(SELECT COUNT([Grip Brand Code]) FROM IRONGripBRANDTABLE) AS TOTAL

  FROM IRONGripBRANDTABLE

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Grip Brand Code]

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT([Grip Brand Code]) DESC, [Mfgr Descr] ASC;





ELSE IF (@REPORTNAME = 'Wood Grip Material')

      SELECT

[Matl Descr] AS Brand, COUNT([Grip Mat'l Code]) AS [Count],

(SELECT COUNT([Grip Mat'l Code]) FROM [Player_Master].[Grip Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY AND [Grip Equip Type] = 'WOOD') AS TOTAL

  FROM [Player_Master].[Grip Detail]

  LEFT OUTER JOIN [LKP].[Material Codes and Descript] ON [Matl Code] = [Grip Mat'l Code] 

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND [Grip Equip Type] = 'WOOD'

  GROUP BY [Matl Descr]

      ORDER BY COUNT([Grip Mat'l Code]) DESC, [Matl Descr] ASC;





ELSE IF (@REPORTNAME = 'Wood Grip Manufacturer')

      SELECT

[Mfgr Descr] AS Brand, COUNT([Grip Mfgr Code]) AS [Count],

(SELECT COUNT([Grip Mfgr Code]) FROM [Player_Master].[Grip Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY AND [Grip Equip Type] = 'WOOD') AS TOTAL

  FROM [Player_Master].[Grip Detail]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Grip Mfgr Code] 

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND [Grip Equip Type] = 'WOOD'

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT([Grip Mfgr Code]) DESC, [Mfgr Descr] ASC;





ELSE IF (@REPORTNAME = 'Wood Grip Brand')

      SELECT

[Mfgr Descr] AS Brand, COUNT([Grip Brand Code]) AS [Count],

(SELECT COUNT([Grip Brand Code]) FROM [Player_Master].[Grip Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY AND [Grip Equip Type] = 'WOOD') AS TOTAL

  FROM [Player_Master].[Grip Detail]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Grip Brand Code]

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND [Grip Equip Type] = 'WOOD'

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT([Grip Brand Code]) DESC, [Mfgr Descr] ASC;

      

      

      

ELSE IF (@REPORTNAME = 'Putter Grip Material')

      SELECT

[Matl Descr] AS Brand, COUNT([Grip Mat'l Code]) AS [Count],

(SELECT COUNT([Grip Mat'l Code]) FROM [Player_Master].[Grip Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY AND [Grip Equip Type] = 'WOOD') AS TOTAL

  FROM [Player_Master].[Grip Detail]

  LEFT OUTER JOIN [LKP].[Material Codes and Descript] ON [Matl Code] = [Grip Mat'l Code] 

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND [Grip Equip Type] = 'PUTT'

  GROUP BY [Matl Descr]

      ORDER BY COUNT([Grip Mat'l Code]) DESC, [Matl Descr] ASC;





ELSE IF (@REPORTNAME = 'Putter Grip Manufacturer')

      SELECT

[Mfgr Descr] AS Brand, COUNT([Grip Mfgr Code]) AS [Count],

(SELECT COUNT([Grip Mfgr Code]) FROM [Player_Master].[Grip Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY AND [Grip Equip Type] = 'WOOD') AS TOTAL

  FROM [Player_Master].[Grip Detail]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Grip Mfgr Code] 

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND [Grip Equip Type] = 'PUTT'

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT([Grip Mfgr Code]) DESC, [Mfgr Descr] ASC;





ELSE IF (@REPORTNAME = 'Putter Grip Brand')

      SELECT

[Mfgr Descr] AS Brand, COUNT([Grip Brand Code]) AS [Count],

(SELECT COUNT([Grip Brand Code]) FROM [Player_Master].[Grip Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY AND [Grip Equip Type] = 'WOOD') AS TOTAL

  FROM [Player_Master].[Grip Detail]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Grip Brand Code]

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND [Grip Equip Type] = 'PUTT'

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT([Grip Brand Code]) DESC, [Mfgr Descr] ASC;

      



ELSE IF (@REPORTNAME = 'All Wedges (Including PW)')

      SELECT

[Mfgr Descr] AS Brand, COUNT([Wedge Brand Code]) AS [Count],

(SELECT COUNT([Wedge Brand Code]) FROM [Player_Master].[Wedge Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY) AS TOTAL

  FROM [Player_Master].[Wedge Detail]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Wedge Brand Code]

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT([Wedge Brand Code]) DESC, [Mfgr Descr] ASC;

      

ELSE IF (@REPORTNAME = 'Pitching Wedge')

      SELECT

[Mfgr Descr] AS Brand, COUNT([Wedge Brand Code]) AS [Count],

(SELECT COUNT([Wedge Brand Code]) FROM [Player_Master].[Wedge Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY and [Wedge Club Code] = 'PW') AS TOTAL

  FROM [Player_Master].[Wedge Detail]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Wedge Brand Code]

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY and [Wedge Club Code] = 'PW'

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT([Wedge Brand Code]) DESC, [Mfgr Descr] ASC;

					    

ELSE IF (@REPORTNAME = 'All Wedges (Excl. PW) AW,GW,SW,LW')

      SELECT

[Mfgr Descr] AS Brand, COUNT([Wedge Brand Code]) AS [Count],

(SELECT COUNT([Wedge Brand Code]) FROM [Player_Master].[Wedge Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY and [Wedge Club Code] <> 'PW') AS TOTAL

  FROM [Player_Master].[Wedge Detail]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Wedge Brand Code]

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY and [Wedge Club Code] <> 'PW'

  GROUP BY [Mfgr Descr]

      ORDER BY COUNT([Wedge Brand Code]) DESC, [Mfgr Descr] ASC;

ELSE

 

--dummy select to set ourput variables for crystal reports

SELECT 'TITLEISTTITLEISTTITLEISTTITLEIST' AS Brand, 34 as [Count], 12 as [%] WHERE 1=0;



     







END
GO
