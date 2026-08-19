IF OBJECT_ID('dbo.Get_tourneys_for_quickcount') IS NOT NULL
    DROP PROCEDURE [dbo].[Get_tourneys_for_quickcount];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_tourneys_for_quickcount]
	-- Add the parameters for the stored procedure here
	@COMPANY varchar(50),
	@USERNAME varchar(50)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
IF @COMPANY = 'DARRELL SURVEY'
 begin	
	
	
	SELECT TOP 9 a.[Tournament Name], a.[FIRST DAY] AS NULLIFNO,
	CAST(MONTH(a.[FIRST DAY]) AS NVARCHAR) + '/' +
	CAST(DAY(a.[First Day]) AS NVARCHAR) + '/' +
	CAST(YEAR(a.[FIRST DAY]) AS NVARCHAR)
	AS [FIRST DAY], [TYPE] AS TOUR,
	NULL AS ISLASH, cu.STATUS
FROM Billing.AllOrdersYTD a
LEFT OUTER JOIN
(SELECT DISTINCT(REPORTNAME) FROM LKP.Report_Lookup WHERE REPORTITEM = 'Top' AND REPORTCONTEXT = 'Website') b ON 1=1
LEFT OUTER JOIN [Player_Master].[Tournament_Custom_Status] cu ON a.TD = cu.sid and a.[FIRST DAY] = cu.[First Day]

WHERE a.[First Day] > dateadd(DD, -8, GETDATE())AND TYPE <> 'SYSTEM'
GROUP BY
[Tournament Name], a.[First Day], 
	CAST(MONTH(a.[FIRST DAY]) AS NVARCHAR) + '/' +
	CAST(DAY(a.[First Day]) AS NVARCHAR) + '/' +
	CAST(YEAR(a.[FIRST DAY]) AS NVARCHAR), [TYPE], cu.STATUS
	
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
NULLIFNO DESC, 
 a.[TOURNAMENT NAME];

end
else
begin

	
	SELECT TOP 9 a.[Tournament Name], a.[FIRST DAY] AS NULLIFNO,
	CAST(MONTH(a.[FIRST DAY]) AS NVARCHAR) + '/' +
	CAST(DAY(a.[First Day]) AS NVARCHAR) + '/' +
	CAST(YEAR(a.[FIRST DAY]) AS NVARCHAR)
	AS [FIRST DAY], [TYPE] AS TOUR,
	NULL AS ISLASH, cu.STATUS
FROM Billing.AllOrdersYTD a
LEFT OUTER JOIN
(SELECT DISTINCT(REPORTNAME) FROM LKP.Report_Lookup WHERE REPORTITEM = 'Top' AND REPORTCONTEXT = 'Website') b ON 1=1
LEFT OUTER JOIN [Player_Master].[Tournament_Custom_Status] cu ON a.TD = cu.sid and a.[FIRST DAY] = cu.[First Day]

WHERE a.[First Day] > dateadd(DD, -8, GETDATE())
AND TYPE <> 'SYSTEM' AND Company = @COMPANY
GROUP BY
[Tournament Name], a.[First Day], 
	CAST(MONTH(a.[FIRST DAY]) AS NVARCHAR) + '/' +
	CAST(DAY(a.[First Day]) AS NVARCHAR) + '/' +
	CAST(YEAR(a.[FIRST DAY]) AS NVARCHAR), [TYPE], cu.STATUS
	
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
NULLIFNO DESC, 
 a.[TOURNAMENT NAME];




end
--select * from Player_Master.TOURNAMENTS_TABLE where [FIRST DAY] between '4/12/2011' and '4/20/2011'   order by [FIRST DAY] desc

/*


execute dbo.get_tourneys_for_quickcount 'TITLEIST'

*/



END
GO
