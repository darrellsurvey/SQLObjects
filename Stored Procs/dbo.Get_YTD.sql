IF OBJECT_ID('dbo.Get_YTD') IS NOT NULL
    DROP PROCEDURE [dbo].[Get_YTD];
GO

-- =============================================

-- Author:		<Author,,Name>

-- Create date: <Create Date,,>

-- Description:	<Description,,>

-- =============================================

CREATE PROCEDURE [dbo].[Get_YTD]

(	

	@COMPANY varchar(50),

	@TOURNAMENTNAME varchar(60),

	@FIRSTDAY varchar(15),

	@REPORTNAME varchar(35),

	@Year char(4)

)	

AS

BEGIN

    -- SET NOCOUNT ON added to prevent extra result sets from

	-- interfering with SELECT statements.

	SET NOCOUNT ON;





DECLARE @query AS nvarchar(MAX)



SET @query = 'SELECT COUNT(BRAND) AS [COUNT], 

					BRAND,

					RIGHT( ''0'' + CAST(MONTH(bb.[FIRST DAY]) AS NVARCHAR), 2) + ''/'' +

					RIGHT( ''0'' + CAST(DAY(bb.[First Day]) AS NVARCHAR),2) + ''/'' +

					CAST(YEAR(bb.[FIRST DAY]) AS NVARCHAR) AS [DATE], 

					[Tournament Name] AS TOURNAMENT, 

					TOUR

					FROM '

				

DECLARE @EquipCase AS nvarchar(MAX)

exec [Search].[EquipmentTableCase] @REPORTNAME, @EquipCase OUT

DECLARE @WhereCase AS nvarchar(MAX)			

exec [Search].[EquipmentWhereCase] @REPORTNAME, @WhereCase OUT

  

SET @query = @query + @EquipCase + @WhereCase +

 ' year([FIRST DAY]) = ' + @Year +

 ' group by Brand, [Tournament Name], Tour, bb.[FIRST DAY]

  ORDER BY bb.[FIRST DAY]'



print @query



exec(@query)



/*



--DECLARE @FIRSTDAY DATE;

DECLARE @SID INT;



IF (@TOURNAMENTNAME IS NULL)

SELECT TOP 1 @TOURNAMENTNAME = [TOURNAMENT NAME], @FIRSTDAY = [FIRST DAY] 

FROM [Player_Master].[TOURNAMENTS_TABLE] with (nolock)

WHERE [FIRST DAY] < '10/1/2011'

ORDER BY [FIRST DAY] DESC;





SELECT TOP 1 @SID = SID FROM [Player_Master].[TOURNAMENTS_TABLE] with (nolock)

WHERE [TOURNAMENT NAME] = @TOURNAMENTNAME AND [FIRST DAY] = @FIRSTDAY;



IF (@REPORTNAME = 'Bag')



SELECT COUNT([Mfgr Descr]) AS [COUNT], [Mfgr Descr] AS BRAND,

	RIGHT( '0' + CAST(MONTH(a.[FIRST DAY]) AS NVARCHAR), 2) + '/' +

	CAST(DAY(a.[First Day]) AS NVARCHAR) + '/' +

	CAST(YEAR(a.[FIRST DAY]) AS NVARCHAR) AS [DATE], [Tournament Name] AS TOURNAMENT, [TYPE] AS TOUR

FROM [Player_Master].[All] a with (nolock)

LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] b with (nolock)

  ON [BAGBRAND] = [Mfgr Code]

LEFT OUTER JOIN [Player_Master].TOURNAMENTS_TABLE c with (nolock)

  ON a.[SID] = c.[SID] and a.[First Day] = c.[FIRST DAY]

WHERE YEAR(a.[First Day]) = 2013

GROUP BY [Mfgr Descr], [Tournament Name], [TYPE], a.[FIRST DAY]

ORDER BY a.[FIRST DAY]

      

ELSE IF (@REPORTNAME = 'Ball')

SELECT COUNT([Mfgr Descr]) AS [COUNT], [Mfgr Descr] AS BRAND,

	RIGHT( ('0' + CAST(MONTH(a.[FIRST DAY]) AS NVARCHAR)), 2) + '/' +

	CAST(DAY(a.[First Day]) AS NVARCHAR) + '/' +

	CAST(YEAR(a.[FIRST DAY]) AS NVARCHAR) AS [DATE], [Tournament Name] AS TOURNAMENT, [TYPE] AS TOUR

FROM [Player_Master].[All] a

LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] b ON [BALLBRAND] = [Mfgr Code]

LEFT OUTER JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[SID] = c.[SID] and a.[First Day] = c.[FIRST DAY]

WHERE YEAR(a.[First Day]) = 2013

GROUP BY [Mfgr Descr], [Tournament Name], [TYPE], a.[FIRST DAY]

ORDER BY a.[FIRST DAY]

                 

ELSE IF (@REPORTNAME = 'Glove')

SELECT COUNT([Mfgr Descr]) AS [COUNT], [Mfgr Descr] AS BRAND,

	RIGHT( '0' + CAST(MONTH(a.[FIRST DAY]) AS NVARCHAR), 2) + '/' +

	CAST(DAY(a.[First Day]) AS NVARCHAR) + '/' +

	CAST(YEAR(a.[FIRST DAY]) AS NVARCHAR) AS [DATE], [Tournament Name] AS TOURNAMENT, [TYPE] AS TOUR

FROM [Player_Master].[All] a with (nolock)

LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] b with (nolock)

  ON [GLOVEBRAND] = [Mfgr Code]

LEFT OUTER JOIN [Player_Master].TOURNAMENTS_TABLE c with (nolock)

  ON a.[SID] = c.[SID] and a.[First Day] = c.[FIRST DAY]

WHERE YEAR(a.[First Day]) = 2013

GROUP BY [Mfgr Descr], [Tournament Name], [TYPE], a.[FIRST DAY]

ORDER BY a.[FIRST DAY]

      

ELSE IF (@REPORTNAME = 'Shoes')

SELECT COUNT([Mfgr Descr]) AS [COUNT], [Mfgr Descr] AS BRAND,

	RIGHT( '0' + CAST(MONTH(a.[FIRST DAY]) AS NVARCHAR), 2) + '/' +

	CAST(DAY(a.[First Day]) AS NVARCHAR) + '/' +

	CAST(YEAR(a.[FIRST DAY]) AS NVARCHAR) AS [DATE], [Tournament Name] AS TOURNAMENT, [TYPE] AS TOUR

FROM [Player_Master].[All] a with (nolock)

LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] b with (nolock)

  ON [SHOEBRAND] = [Mfgr Code]

LEFT OUTER JOIN [Player_Master].TOURNAMENTS_TABLE c with (nolock)

  ON a.[SID] = c.[SID] and a.[First Day] = c.[FIRST DAY]

WHERE YEAR(a.[First Day]) = 2013

GROUP BY [Mfgr Descr], [Tournament Name], [TYPE], a.[FIRST DAY]

ORDER BY a.[FIRST DAY]



ELSE IF (@REPORTNAME = 'Driver')

SELECT COUNT([Mfgr Descr]) AS [COUNT], [Mfgr Descr] AS BRAND,

	CAST(MONTH(d.[FIRST DAY]) AS NVARCHAR) + '/' +

	CAST(DAY(d.[First Day]) AS NVARCHAR) + '/' +

	CAST(YEAR(d.[FIRST DAY]) AS NVARCHAR) AS [DATE], [Tournament Name] AS TOURNAMENT, [TYPE] AS TOUR

FROM 

(SELECT [Name], MIN([PKey]) AS PKEY FROM [Player_Master].[Wood Detail] with (nolock)

  WHERE YEAR([First Day]) = 2013 GROUP BY [Name]) e

LEFT OUTER JOIN

(SELECT * FROM [Player_Master].[Wood Detail] with (nolock) 

  WHERE YEAR([First Day]) = 2013) d

  ON e.PKEY = d.[PKey] AND e.[Name] = d.[Name]

LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] b with (nolock) 

  ON [Wood Brand Code] = [Mfgr Code]

LEFT OUTER JOIN [Player_Master].TOURNAMENTS_TABLE c with (nolock)

  ON [Survey ID] = [SID] and d.[First Day] = c.[FIRST DAY]

WHERE YEAR(d.[First Day]) = 2013

GROUP BY [Mfgr Descr], [Tournament Name], [TYPE], d.[FIRST DAY]

ORDER BY d.[FIRST DAY]



ELSE IF (@REPORTNAME = 'All Woods')

SELECT COUNT([Mfgr Descr]) AS [COUNT], [Mfgr Descr] AS BRAND,

	RIGHT( '0' + CAST(MONTH(a.[FIRST DAY]) AS NVARCHAR), 2) + '/' +

	CAST(DAY(a.[First Day]) AS NVARCHAR) + '/' +

	CAST(YEAR(a.[FIRST DAY]) AS NVARCHAR) AS [DATE], [Tournament Name] AS TOURNAMENT, [TYPE] AS TOUR

FROM [Player_Master].[Wood Detail] a with (nolock)

LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] b with (nolock)

  ON [Wood Brand Code] = [Mfgr Code]

LEFT OUTER JOIN [Player_Master].TOURNAMENTS_TABLE c with (nolock)

  ON [Survey ID] = SID and a.[First Day] = c.[FIRST DAY]

WHERE YEAR(a.[First Day]) = 2013

GROUP BY [Mfgr Descr], [Tournament Name], [TYPE], a.[FIRST DAY]

ORDER BY a.[FIRST DAY]





/*ELSE IF (@REPORTNAME = 'Fairway w/ Hybrid')

SELECT b.[Mfgr Descr] AS Brand, COUNT(b.[Mfgr Descr]) AS [Count],

COUNT(b.[Mfgr Descr]) * 100 / (SELECT COUNT([Wood Brand Code]) FROM [Player_Master].[Wood Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY) AS [%]

 FROM

[Player_Master].[Wood Detail] a

LEFT OUTER JOIN

(SELECT [Name] AS DRIVER, MIN([PKey]) AS PKEY FROM [Player_Master].[Wood Detail] WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID GROUP BY [Name]) c

ON a.PKey = c.PKEY 

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] b ON [Wood Brand Code] = b.[Mfgr Code]

WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID AND DRIVER IS NULL

GROUP BY [Mfgr Descr]

ORDER BY COUNT(b.[Mfgr Descr]) DESC, b.[Mfgr Descr] ASC;

      

      

ELSE IF (@REPORTNAME = 'Fairway w/o Hybrid')

SELECT b.[Mfgr Descr] AS Brand, COUNT(b.[Mfgr Descr]) AS [Count],

COUNT(b.[Mfgr Descr]) * 100 / (SELECT COUNT([Wood Brand Code]) FROM [Player_Master].[Wood Detail] WHERE [Survey ID] = @SID AND [First Day] = @FIRSTDAY) AS [%]

 FROM

[Player_Master].[Wood Detail] a

LEFT OUTER JOIN

(SELECT [Name] AS DRIVER, MIN([PKey]) AS PKEY FROM [Player_Master].[Wood Detail] WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID GROUP BY [Name]) c

ON a.PKey = c.PKEY 

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] b ON [Wood Brand Code] = b.[Mfgr Code]

WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID AND DRIVER IS NULL AND a.[Wood Club Code] <> 'HYB'

GROUP BY [Mfgr Descr]

ORDER BY COUNT(b.[Mfgr Descr]) DESC, b.[Mfgr Descr] ASC;*/

      

      

ELSE IF (@REPORTNAME = 'Hybrid Woods')

SELECT COUNT([Mfgr Descr]) AS [COUNT], [Mfgr Descr] AS BRAND,

	RIGHT( '0' + CAST(MONTH(a.[FIRST DAY]) AS NVARCHAR), 2) + '/' +

	CAST(DAY(a.[First Day]) AS NVARCHAR) + '/' +

	CAST(YEAR(a.[FIRST DAY]) AS NVARCHAR) AS [DATE], [Tournament Name] AS TOURNAMENT, [TYPE] AS TOUR

FROM [Player_Master].[Wood Detail] a with (nolock)

LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] b ON [Wood Brand Code] = [Mfgr Code]

LEFT OUTER JOIN [Player_Master].TOURNAMENTS_TABLE c ON [Survey ID] = SID and a.[First Day] = c.[FIRST DAY]

WHERE YEAR(a.[First Day]) = 2013 and [Wood Club Code] = 'HYB'

GROUP BY [Mfgr Descr], [Tournament Name] , [TYPE], a.[FIRST DAY]

ORDER BY a.[FIRST DAY]

      

ELSE IF (@REPORTNAME = 'Headgear')

SELECT COUNT([Mfgr Descr]) AS [COUNT], [Mfgr Descr] AS BRAND,

	RIGHT( '0' + CAST(MONTH(a.[FIRST DAY]) AS NVARCHAR), 2) + '/' +

	CAST(DAY(a.[First Day]) AS NVARCHAR) + '/' +

	CAST(YEAR(a.[FIRST DAY]) AS NVARCHAR) AS [DATE], [Tournament Name] AS TOURNAMENT, [TYPE] AS TOUR

FROM [Player_Master].[All] a with (nolock)

LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] b ON [HEADGEARBRAND] = [Mfgr Code]

LEFT OUTER JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[SID] = c.[SID] and a.[First Day] = c.[FIRST DAY]

WHERE YEAR(a.[First Day]) = 2013

GROUP BY [Mfgr Descr], [Tournament Name], [TYPE], a.[FIRST DAY]

ORDER BY a.[FIRST DAY]



ELSE IF (@REPORTNAME = 'Iron')

SELECT COUNT([Mfgr Descr]) AS [COUNT], [Mfgr Descr] AS BRAND,

	RIGHT( '0' + CAST(MONTH(a.[FIRST DAY]) AS NVARCHAR), 2) + '/' +

	CAST(DAY(a.[First Day]) AS NVARCHAR) + '/' +

	CAST(YEAR(a.[FIRST DAY]) AS NVARCHAR) AS [DATE], [Tournament Name] AS TOURNAMENT, [TYPE] AS TOUR

FROM [Player_Master].[Iron Detail] a with (nolock)

LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] b ON [Iron Brand Code] = [Mfgr Code]

LEFT OUTER JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[Survey ID] = c.[SID] and a.[First Day] = c.[FIRST DAY]

WHERE YEAR(a.[First Day]) = 2013 and ISSET = 1

GROUP BY [Mfgr Descr], [Tournament Name], [TYPE], a.[FIRST DAY]

ORDER BY a.[FIRST DAY]



ELSE IF (@REPORTNAME = 'Utility Iron')

SELECT COUNT([Mfgr Descr]) AS [COUNT], [Mfgr Descr] AS BRAND,

	RIGHT( '0' + CAST(MONTH(a.[FIRST DAY]) AS NVARCHAR), 2) + '/' +

	CAST(DAY(a.[First Day]) AS NVARCHAR) + '/' +

	CAST(YEAR(a.[FIRST DAY]) AS NVARCHAR) AS [DATE], [Tournament Name] AS TOURNAMENT, [TYPE] AS TOUR

FROM [Player_Master].[Iron Detail] a with (nolock)

LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] b with (nolock)

  ON [Iron Brand Code] = [Mfgr Code]

LEFT OUTER JOIN [Player_Master].TOURNAMENTS_TABLE c with (nolock)

  ON a.[Survey ID] = c.[SID] and a.[First Day] = c.[FIRST DAY]

WHERE YEAR(a.[First Day]) = 2013 and [Iron Club Code] like '%^%'

GROUP BY [Mfgr Descr], [Tournament Name], [TYPE], a.[FIRST DAY]

ORDER BY a.[FIRST DAY]



ELSE IF (@REPORTNAME = 'Putter')

SELECT COUNT([Mfgr Descr]) AS [COUNT], [Mfgr Descr] AS BRAND,

	RIGHT( '0' + CAST(MONTH(a.[FIRST DAY]) AS NVARCHAR), 2) + '/' +

	CAST(DAY(a.[First Day]) AS NVARCHAR) + '/' +

	CAST(YEAR(a.[FIRST DAY]) AS NVARCHAR) AS [DATE], [Tournament Name] AS TOURNAMENT, [TYPE] AS TOUR

FROM [Player_Master].[Putter Detail] a with (nolock)

LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] b with (nolock)

  ON [Putter Brand Code]   = [Mfgr Code]

LEFT OUTER JOIN [Player_Master].TOURNAMENTS_TABLE c with (nolock)

  ON a.[Survey ID] = c.[SID] and a.[First Day] = c.[FIRST DAY]

WHERE YEAR(a.[First Day]) = 2013

GROUP BY [Mfgr Descr], [Tournament Name], [TYPE], a.[FIRST DAY]

ORDER BY a.[FIRST DAY]





ELSE IF (@REPORTNAME = 'Wedge')

SELECT COUNT([Mfgr Descr]) AS [COUNT], [Mfgr Descr] AS BRAND,

	RIGHT( '0' + CAST(MONTH(a.[FIRST DAY]) AS NVARCHAR), 2) + '/' +

	CAST(DAY(a.[First Day]) AS NVARCHAR) + '/' +

	CAST(YEAR(a.[FIRST DAY]) AS NVARCHAR) AS [DATE], [Tournament Name] AS TOURNAMENT, [TYPE] AS TOUR

FROM [Player_Master].[Wedge Detail] a with (nolock)

LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] b with (nolock)

  ON [Wedge Brand Code] = [Mfgr Code]

LEFT OUTER JOIN [Player_Master].TOURNAMENTS_TABLE c with (nolock)

  ON a.[Survey ID] = c.[SID] and a.[First Day] = c.[FIRST DAY]

WHERE YEAR(a.[First Day]) = 2013

GROUP BY [Mfgr Descr], [Tournament Name], [TYPE], a.[FIRST DAY]

ORDER BY a.[FIRST DAY]



ELSE

 

--dummy select to set output variables for crystal reports

SELECT 12 AS [COUNT], 'TITLEIST' AS BRAND, 'The Masters' AS TOURNAMENT, 'PGA' AS TOUR WHERE 1=0





*/



END
GO
