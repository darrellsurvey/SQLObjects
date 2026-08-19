DROP PROCEDURE IF EXISTS [dbo].[Get_tourneys_for_currentweek];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_tourneys_for_currentweek]
	-- Add the parameters for the stored procedure here
	@COMPANY varchar(50)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @COMPANY = 'DARRELL SURVEY'
	
		
	SELECT a.[Tournament Name], b.[FIRST DAY] AS NULLIFNO,
	CAST(MONTH(a.[FIRST DAY]) AS NVARCHAR) + '/' +
	CAST(DAY(a.[First Day]) AS NVARCHAR) + '/' +
	CAST(YEAR(a.[FIRST DAY]) AS NVARCHAR)
	AS "FIRST DAY", [TYPE] AS TOUR
FROM Player_Master.TOURNAMENTS_TABLE a
LEFT OUTER JOIN
(SELECT [Tournament Name], [First Day], TD FROM Billing.AllOrdersYTD GROUP BY [Tournament Name], [First Day], TD) b
ON a.[TOURNAMENT NAME] = b.[Tournament Name] and a.[FIRST DAY] = b.[First Day] and SID = TD
WHERE DATEDIFF(day, a.[First Day], GETDATE()) BETWEEN -2 and 6 and YEAR(a.[First Day]) = YEAR(GETDATE())
AND TYPE <> 'SYSTEM' and b.[FIRST DAY] IS NOT NULL
ORDER BY DATEPART(week, a.[first day]) DESC, 
CASE
WHEN [TYPE] = 'PGA' THEN 1
WHEN [TYPE] = 'NATIONWIDE' THEN 2
WHEN [TYPE] = 'CHAMPIONS' THEN 3
WHEN [TYPE] = 'LPGA' THEN 4
WHEN [TYPE] = 'JGTO' THEN 5
WHEN [TYPE] = 'NCAA' THEN 7
ELSE 6
END,
NULLIFNO DESC, ISFLASH ASC, a.[FIRST DAY] DESC,
 a.[TOURNAMENT NAME];
	
	ELSE
	
	SELECT TOP 9 a.[Tournament Name], b.[FIRST DAY] AS NULLIFNO,
	CAST(MONTH(a.[FIRST DAY]) AS NVARCHAR) + '/' +
	CAST(DAY(a.[First Day]) AS NVARCHAR) + '/' +
	CAST(YEAR(a.[FIRST DAY]) AS NVARCHAR)
	AS "FIRST DAY", [TYPE] AS TOUR,
	ISFLASH, SID
FROM Player_Master.TOURNAMENTS_TABLE a
LEFT OUTER JOIN
(SELECT bi.[Tournament Name], bi.[First Day], bi.TD FROM Billing.AllOrdersYTD bi
INNER JOIN Player_Master.TOURNAMENTS_TABLE tt ON bi.[Tournament Name] = tt.[TOURNAMENT NAME] and tt.[FIRST DAY] = bi.[First Day] and tt.SID = bi.td
WHERE [Company] = @COMPANY AND ISFLASH <= 1 GROUP BY bi.[Tournament Name], bi.[First Day], TD) b
ON a.[TOURNAMENT NAME] = b.[Tournament Name] and a.[FIRST DAY] = b.[First Day] and SID = TD
WHERE DATEDIFF(day, a.[First Day], GETDATE()) BETWEEN -2 and 6 and YEAR(a.[First Day]) = YEAR(GETDATE())
AND TYPE <> 'SYSTEM' and b.[FIRST DAY] IS NOT NULL -- and ISFLASH <= 1
ORDER BY DATEPART(week, a.[first day]) DESC,
CASE
WHEN [TYPE] = 'PGA' THEN 1
WHEN [TYPE] = 'NATIONWIDE' THEN 2
WHEN [TYPE] = 'CHAMPIONS' THEN 3
WHEN [TYPE] = 'LPGA' THEN 4
WHEN [TYPE] = 'JGTO' THEN 5
WHEN [TYPE] = 'NCAA' THEN 7
ELSE 6
END,
NULLIFNO DESC, ISFLASH ASC, a.[FIRST DAY] DESC,
 a.[TOURNAMENT NAME];


--select * from Player_Master.TOURNAMENTS_TABLE where [FIRST DAY] between '4/12/2011' and '4/20/2011'   order by [FIRST DAY] desc

/*


execute dbo.get_tourneys_for_quickcount 'TITLEIST'

*/



END
GO
