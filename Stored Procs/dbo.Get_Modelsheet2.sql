IF OBJECT_ID('dbo.Get_Modelsheet2') IS NOT NULL
    DROP PROCEDURE [dbo].[Get_Modelsheet2];
GO

-- =============================================

-- Author:		<Author,,Name>

-- Create date: <Create Date,,>

-- Description:	<Description,,>

-- =============================================

CREATE PROCEDURE [dbo].[Get_Modelsheet2]

	-- Add the parameters for the stored procedure here

	@COMPANY varchar(50),

	@TOURNAMENTNAME varchar(60),

	@FIRSTDAY date,

	@REPORTNAME varchar(35)

	

	

AS

BEGIN

    

	-- EXEC  [dbo].[Get_Modelsheet2] 'callaway', 'Farmers Insurance Open', '20250122', 'Wedge'

	-- SET NOCOUNT ON added to prevent extra result sets from

	-- interfering with SELECT statements.

	SET NOCOUNT ON;



--DECLARE @FIRSTDAY DATE;

DECLARE @SID INT;



SELECT TOP 1 @SID = SID FROM [Player_Master].[TOURNAMENTS_TABLE] WHERE [TOURNAMENT NAME] = @TOURNAMENTNAME AND [FIRST DAY] = @FIRSTDAY;







IF (@REPORTNAME = 'Balls')

/*

SELECT

[Model Descr] As Model, COUNT(BALLBRAND) AS [Count], 

(SELECT COUNT(BALLBRAND) FROM [Player_Master].[All] WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS [TOTAL]

  FROM [Player_Master].[All]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = BALLBRAND

  LEFT OUTER JOIN [LKP].[Model Codes and Descr] ON [Model Code] = BALLMODEL

  WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY and [Mfgr Descr] = @COMPANY

  GROUP BY [Mfgr Descr], [Model Descr]

      ORDER BY [Count] DESC;

*/



SELECT

[Model Descr] As Model, COUNT(BALLBRAND) AS [Count], 

(SELECT COUNT(BALLBRAND) FROM [Player_Master].[All] WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS [TOTAL]

  FROM [Player_Master].[All]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = BALLBRAND

  LEFT OUTER JOIN [LKP].[Model Codes and Descr] ON [Model Code] = BALLMODEL

  WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY and [Mfgr Descr] in (SELECT [COMPANY]

		FROM [DARRELL_MASTER].[LKP].[Company_Groups]

		where GROUP_ID = (Select GROUP_ID FROM [DARRELL_MASTER].[LKP].[Company_Groups]

				where company = @COMPANY))

  GROUP BY [Mfgr Descr], [Model Descr]

      ORDER BY [Count] DESC;





ELSE IF (@REPORTNAME = 'Spikes')

SELECT

[Model Descr] As Model, COUNT(SPIKEBRAND) AS [Count], 

(SELECT COUNT(SPIKEBRAND) FROM [Input].[All] WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY) AS [TOTAL]

  FROM [Player_Master].[All]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = SPIKEBRAND

  LEFT OUTER JOIN [LKP].[Model Codes and Descr] ON [Model Code] = SPIKEMODEL

  WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY and [Mfgr Descr] = @COMPANY

  GROUP BY [Mfgr Descr], [Model Descr]

      ORDER BY [Count] DESC;





ELSE IF (@REPORTNAME = 'Driver')

--mostly copied from CR_Reports.Drivers

SELECT [Model Descr] + N' - ' + [Size Descr] AS Model, COUNT(a.[Mfgr Descr]) AS [Count],

(SELECT COUNT([Wood Brand Code]) FROM [Player_Master].[Wood Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY) AS [TOTAL]

 FROM

(SELECT * FROM [Player_Master].[Wood Detail] WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID) c

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a ON [Wood Brand Code] = a.[Mfgr Code]

LEFT OUTER JOIN LKP.[Model Codes and Descr] ON [Wood Model Code] = [Model Code]

LEFT OUTER JOIN LKP.[Size Codes and Description] ON [Wood Size Code] = [Size Code]

WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID and ISDRIVER = 1 and [Mfgr Descr] = @COMPANY

GROUP BY [Mfgr Descr], [Model Descr], [Size Descr]

ORDER BY [Count] DESC;





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





ELSE IF (@REPORTNAME = 'Driver Shaft Brand Model')



SELECT f.[Mfgr Descr] AS Brand, [Model Descr] as Model, COUNT(f.[Mfgr Descr]) AS [Count],

(SELECT COUNT([Wood Brand Code]) FROM [Player_Master].[Wood Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY and ISDRIVER = 1) AS TOTAL

  

FROM (

SELECT [PKey], [Name], [Survey ID], [First Day], ISDRIVER, [Wood Club Code], [Wood Brand Code], DBRANDCODE, [Wood Model Code], DMODELCODE, [Wood Size Code], DSIZECODE, [Wood Mat'l Code], DMATERIAL

FROM Player_Master.[Wood Detail]

WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID and ISDRIVER = 1

GROUP BY [PKey], [Name], [Survey ID], [First Day], ISDRIVER, [Wood Club Code], [Wood Brand Code], DBRANDCODE, [Wood Model Code], DMODELCODE, [Wood Size Code], DSIZECODE, [Wood Mat'l Code], DMATERIAL) a



LEFT OUTER JOIN (SELECT *

FROM Player_Master.[Shaft Detail] WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID AND [Shaft Equip Type] = 'WOOD') b

ON a.Name = b.Name and a.[Wood Club Code] = b.[Shaft Club Code] and a.PKey = b.pkey

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON [Model Code] = [Shaft Model Code]

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] f ON [Shaft Brand Code] = f.[Mfgr Code]

WHERE a.[First Day] = @FIRSTDAY AND a.[Survey ID] = @SID and a.ISDRIVER = 1

  GROUP BY [Mfgr Descr], [Model Descr] 

      ORDER BY [Count] DESC;





ELSE IF (@REPORTNAME = 'All Woods')

      SELECT

[Model Descr] as Model, COUNT([Wood Brand Code]) AS [Count],

(SELECT COUNT([Wood Brand Code]) FROM [Player_Master].[Wood Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY) AS [TOTAL]

  FROM [Player_Master].[Wood Detail]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Wood Brand Code]

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON [Model Code] = [Wood Model Code]

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY and [Mfgr Descr] = @COMPANY

  GROUP BY [Mfgr Descr], [Model Descr] 

      ORDER BY [Count] DESC;

            



ELSE IF (@REPORTNAME = 'Fairway Including Hybrid ')

SELECT [Model Descr] AS Model, COUNT(b.[Mfgr Descr]) AS [Count],

(SELECT COUNT([Wood Brand Code]) FROM [Player_Master].[Wood Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY and ISDRIVER = 0) AS [TOTAL]

 FROM [Player_Master].[Wood Detail] a

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] b ON [Wood Brand Code] = b.[Mfgr Code]

LEFT OUTER JOIN LKP.[Model Codes and Descr] ON [Wood Model Code] = [Model Code]

WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID and ISDRIVER = 0 and [Mfgr Descr] = @COMPANY

GROUP BY [Mfgr Descr], [Model Descr] 

ORDER BY [Count] DESC;

      

      

ELSE IF (@REPORTNAME = 'Fairway wo Hybrid ')

SELECT [Model Descr] as Model, COUNT(b.[Mfgr Descr]) AS [Count],

(SELECT COUNT([Wood Brand Code]) FROM [Player_Master].[Wood Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY and [Wood Club Code] <> 'HYB' and ISDRIVER = 0) AS [TOTAL]

 FROM [Player_Master].[Wood Detail] a

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] b ON [Wood Brand Code] = b.[Mfgr Code]

LEFT OUTER JOIN LKP.[Model Codes and Descr] ON [Wood Model Code] = [Model Code]

WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID and ISDRIVER = 0 AND a.[Wood Club Code] <> 'HYB' and [Mfgr Descr] = @COMPANY

GROUP BY [Mfgr Descr], [Model Descr] 

ORDER BY [Count] DESC;

      

      

ELSE IF (@REPORTNAME = 'Hybrid Woods')

      SELECT

[Model Descr] AS Model, COUNT([Wood Brand Code]) AS [Count],

(SELECT COUNT([Wood Brand Code]) FROM [Player_Master].[Wood Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY and [Wood Club Code] = 'HYB' ) AS [TOTAL]

  FROM [Player_Master].[Wood Detail]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Wood Brand Code]

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON [Model Code] = [Wood Model Code] 

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND [Wood Club Code] = 'HYB' and [Mfgr Descr] = @COMPANY

  GROUP BY [Mfgr Descr], [Model Descr]

      ORDER BY [Count] DESC;            



ELSE IF (@REPORTNAME = 'Wood wo Hybrid')

      SELECT

[Model Descr] AS Model, COUNT([Wood Brand Code]) AS [Count],

(SELECT COUNT([Wood Brand Code]) FROM [Player_Master].[Wood Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY and [Wood Club Code] <> 'HYB' ) AS [TOTAL]

  FROM [Player_Master].[Wood Detail]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Wood Brand Code]

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON [Model Code] = [Wood Model Code] 

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND [Wood Club Code] <> 'HYB' and [Mfgr Descr] = @COMPANY

  GROUP BY [Mfgr Descr], [Model Descr]

      ORDER BY [Count] DESC;  



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





ELSE IF (@REPORTNAME = 'Hybrid Wood Shaft Brand Model')

      SELECT

[Mfgr Descr] AS Brand, [Model Descr] as Model, COUNT([Shaft Brand Code]) AS [Count],

(SELECT COUNT([Shaft Brand Code]) FROM [Player_Master].[Shaft Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'WOOD' and [Shaft Club Code] = 'HYB') AS TOTAL

  FROM [Player_Master].[Shaft Detail]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Shaft Brand Code]

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON [Model Code] = [Shaft Model Code] 

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'WOOD' and [Shaft Club Code] = 'HYB'

  GROUP BY [Mfgr Descr], [Model Descr]

      ORDER BY [Count] DESC;





ELSE IF (@REPORTNAME = 'Iron')

      SELECT

[Model Descr] as Model, COUNT([Iron Brand Code]) AS [Count],

(SELECT COUNT([Iron Brand Code]) FROM [Player_Master].[Iron Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY) AS [TOTAL]

  FROM [Player_Master].[Iron Detail]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Iron Brand Code]

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON [Model Code] = [Iron Model Code] 

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY and ISSET = 1 and [Mfgr Descr] = @COMPANY and not [Player_Master].[Iron Detail].[Iron Club Code] like '%^%'

  GROUP BY [Mfgr Descr], [Model Descr]

      ORDER BY [Count] DESC;





ELSE IF (@REPORTNAME = 'Utility Iron')

select *, SUM([COUNT]) over() as TOTAL from ( 

SELECT [Model Descr] as Model, 

sum(case when [Iron Club Code] like '%-%' then (cast(SUBSTRING([Iron Club Code],3,1) AS tinyint) - 

												cast(SUBSTRING([Iron Club Code],1,1) AS tinyint) +1)

				 else 1 end) AS [Count]

  FROM [Player_Master].[Iron Detail]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Iron Brand Code]

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON [Model Code] = [Iron Model Code] 

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND [Iron Club Code] LIKE '%^%' and [Mfgr Descr] = @COMPANY

  GROUP BY [Mfgr Descr], [Model Descr]) a

      ORDER BY [Count] DESC;

      



ELSE IF (@REPORTNAME = 'Putter')

      SELECT

[Model Descr] as Model, COUNT([Putter Brand Code]) AS [Count],

(SELECT COUNT([Putter Brand Code]) FROM [Player_Master].[Putter Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY) AS [TOTAL]

  FROM [Player_Master].[Putter Detail]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Putter Brand Code]

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON [Model Code] = [Putter Model Code] 

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY and [Mfgr Descr] in (SELECT [COMPANY]

		FROM [DARRELL_MASTER].[LKP].[Company_Groups]

		where GROUP_ID = (Select GROUP_ID FROM [DARRELL_MASTER].[LKP].[Company_Groups]

				where company = @COMPANY))

  GROUP BY [Mfgr Descr], [Model Descr]

      ORDER BY [Count] DESC;







ELSE IF (@REPORTNAME = 'Shaft')

      SELECT

[Model Descr] as Model, COUNT([Shaft Brand Code]) AS [Count],

(SELECT COUNT([Shaft Brand Code]) FROM [Player_Master].[Shaft Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY) AS [TOTAL]

  FROM [Player_Master].[Shaft Detail]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Shaft Brand Code]

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON [Model Code] = [Shaft Model Code] 

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY and [Mfgr Descr] = @COMPANY

  GROUP BY [Mfgr Descr], [Model Descr]

      ORDER BY [Count] DESC;





ELSE IF (@REPORTNAME = 'Iron Shaft Brand Model')

      SELECT

[Mfgr Descr] AS Brand, [Model Descr] as Model, COUNT([Shaft Brand Code]) AS [Count],

(SELECT COUNT([Shaft Brand Code]) FROM [Player_Master].[Shaft Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'IRON') AS [ TOTAL]

  FROM [Player_Master].[Iron Detail] a LEFT OUTER JOIN Player_Master.[Shaft Detail] b ON a.[Survey ID] =  b.[Survey ID] and a.[First Day] = b.[First Day] and a.[Iron Club Code] = b.[Shaft Club Code] and a.Name = b.Name 

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Shaft Brand Code]

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON [Model Code] = [Shaft Model Code] 

  WHERE a.[Survey ID]= @SID AND a.[First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'IRON' AND ISSET = 1

  GROUP BY [Mfgr Descr], [Model Descr]

      ORDER BY [Count] DESC;

      

ELSE IF (@REPORTNAME = 'Iron Shaft Material Model')

WITH IRONSETTABLE_SHAFT AS (

SELECT a.Name, [Iron Club Code], [Iron Brand Code], [Iron Model Code], [Shaft Mfgr Code], [Shaft Brand Code], [Shaft Model Code], [Shaft Mat'l Code]

FROM Player_Master.[Iron Detail] a

LEFT OUTER JOIN Player_Master.[Shaft Detail] b ON a.Name = b.Name and a.[First Day]= b.[First Day] and a.[Survey ID] = b.[Survey ID] and a.[Iron Club Code] = b.[Shaft Club Code] and a.Name = b.Name

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

      

ELSE IF (@REPORTNAME = 'Iron Shaft Manufacturer Model')

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





ELSE IF (@REPORTNAME = 'Utility Iron Shaft Brand Model')

      SELECT

[Mfgr Descr] AS Brand, [Model Descr] as Model, COUNT([Shaft Brand Code]) AS [Count],

(SELECT COUNT([Shaft Brand Code]) FROM [Player_Master].[Shaft Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'IRON' AND [Shaft Club Code] LIKE '%^%') AS [ TOTAL]

  FROM [Player_Master].[Shaft Detail]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Shaft Brand Code]

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON [Model Code] = [Shaft Model Code] 

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'IRON' and [Shaft Club Code] like '%^%'

  GROUP BY [Mfgr Descr], [Model Descr]

      ORDER BY [Count] DESC;





ELSE IF (@REPORTNAME = 'Wood Shaft Brand Model')

      SELECT

[Mfgr Descr] AS Brand, [Model Descr] as Model, COUNT([Shaft Brand Code]) AS [Count],

(SELECT COUNT([Shaft Brand Code]) FROM [Player_Master].[Shaft Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'WOOD') AS [ TOTAL]

  FROM [Player_Master].[Shaft Detail]

  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Shaft Brand Code]

  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON [Model Code] = [Shaft Model Code] 

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'WOOD'

  GROUP BY [Mfgr Descr], [Model Descr]

      ORDER BY [Count] DESC;





ELSE IF (@REPORTNAME = 'Wood Shaft Manufacturer Model')

      SELECT

[Matl Descr] AS Brand, COUNT([Shaft Mat'l Code]) AS [Count],

(SELECT COUNT([Shaft Mat'l Code]) FROM [Player_Master].[Shaft Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'WOOD') AS TOTAL

  FROM [Player_Master].[Shaft Detail]

  LEFT OUTER JOIN [LKP].[Material Codes and Descript] ON [Matl Code] = [Shaft Mat'l Code] 

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'WOOD'

  GROUP BY [Matl Descr]

      ORDER BY COUNT([Shaft Mat'l Code]) DESC, [Matl Descr] ASC;





ELSE IF (@REPORTNAME = 'Wood Shaft Material Model')

      SELECT

[Matl Descr] AS Brand, COUNT([Shaft Mat'l Code]) AS [Count],

(SELECT COUNT([Shaft Mat'l Code]) FROM [Player_Master].[Shaft Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'WOOD') AS TOTAL

  FROM [Player_Master].[Shaft Detail]

  LEFT OUTER JOIN [LKP].[Material Codes and Descript] ON [Matl Code] = [Shaft Mat'l Code] 

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'WOOD'

  GROUP BY [Matl Descr]

      ORDER BY COUNT([Shaft Mat'l Code]) DESC, [Matl Descr] ASC;



      



ELSE IF (@REPORTNAME = 'Wedge')

--      SELECT

--[Model Descr] as Model, COUNT([Wedge Brand Code]) AS [Count],

--(SELECT COUNT([Wedge Brand Code]) FROM [Player_Master].[Wedge Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY) AS [TOTAL]

--  FROM [Player_Master].[Wedge Detail]

--  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON [Mfgr Code] = [Wedge Brand Code]

--  LEFT OUTER JOIN LKP.[Model Codes and Descr] ON [Model Code] = [Wedge Model Code] 

--  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY and [Mfgr Descr] = @COMPANY

--  GROUP BY [Mfgr Descr], [Model Descr]

--      ORDER BY [Count] DESC;



select Model, Count, TOTAL from (

SELECT b.[Mfgr Descr] as Brand, coalesce(mg.ModelGroup, m.[Model Descr]) as Model, COUNT(*) AS [Count], sum(COUNT(*)) over() AS [TOTAL]

FROM [Player_Master].[Wedge Detail] w

LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] b ON b.[Mfgr Code] = w.[Wedge Brand Code]

LEFT OUTER JOIN LKP.[Model Codes and Descr] m ON m.[Model Code] = w.[Wedge Model Code] 

LEFT OUTER JOIN LKP.ModelGroup mg ON m.[Model Code] = mg.ModelCode

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY

  GROUP BY [Mfgr Descr], coalesce(mg.ModelGroup, m.[Model Descr])) a

where Brand = @COMPANY

ORDER BY [Count] DESC;



      

ELSE IF (@REPORTNAME = 'All Wedges (Including PW)')

      select Model, Count, TOTAL from (

SELECT b.[Mfgr Descr] as Brand, coalesce(mg.ModelGroup, m.[Model Descr]) as Model, COUNT(*) AS [Count], sum(COUNT(*)) over() AS [TOTAL]

FROM [Player_Master].[Wedge Detail] w

LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] b ON b.[Mfgr Code] = w.[Wedge Brand Code]

LEFT OUTER JOIN LKP.[Model Codes and Descr] m ON m.[Model Code] = w.[Wedge Model Code] 

LEFT OUTER JOIN LKP.ModelGroup mg ON m.[Model Code] = mg.ModelCode

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY

  GROUP BY [Mfgr Descr], coalesce(mg.ModelGroup, m.[Model Descr])) a

where Brand = @COMPANY

ORDER BY [Count] DESC;

      

ELSE IF (@REPORTNAME = 'Pitching Wedge')

select Model, Count, TOTAL from (

SELECT b.[Mfgr Descr] as Brand, coalesce(mg.ModelGroup, m.[Model Descr]) as Model, COUNT(*) AS [Count], sum(COUNT(*)) over() AS [TOTAL]

FROM [Player_Master].[Wedge Detail] w

LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] b ON b.[Mfgr Code] = w.[Wedge Brand Code]

LEFT OUTER JOIN LKP.[Model Codes and Descr] m ON m.[Model Code] = w.[Wedge Model Code] 

LEFT OUTER JOIN LKP.ModelGroup mg ON m.[Model Code] = mg.ModelCode

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY and [Wedge Club Code] = 'PW'

  GROUP BY [Mfgr Descr], coalesce(mg.ModelGroup, m.[Model Descr])) a

where Brand = @COMPANY

ORDER BY [Count] DESC;



     

ELSE IF (@REPORTNAME = 'All Wedges (Excl. PW) AW,GW,SW,LW')

select Model, Count, TOTAL from (

SELECT b.[Mfgr Descr] as Brand, coalesce(mg.ModelGroup, m.[Model Descr]) as Model, COUNT(*) AS [Count], sum(COUNT(*)) over() AS [TOTAL]

FROM [Player_Master].[Wedge Detail] w

LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] b ON b.[Mfgr Code] = w.[Wedge Brand Code]

LEFT OUTER JOIN LKP.[Model Codes and Descr] m ON m.[Model Code] = w.[Wedge Model Code] 

LEFT OUTER JOIN LKP.ModelGroup mg ON m.[Model Code] = mg.ModelCode

  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY and [Wedge Club Code] <> 'PW'

  GROUP BY [Mfgr Descr], coalesce(mg.ModelGroup, m.[Model Descr])) a

where Brand = @COMPANY

ORDER BY [Count] DESC;



ELSE

 

--dummy select to set ourput variables for crystal reports

SELECT 'asdfasdfsadfasdfsadfsadffd' AS Model, 11 as [Count], 12 as [TOTAL] WHERE 1=0;



     







END
GO
