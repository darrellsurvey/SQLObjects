DROP PROCEDURE IF EXISTS [dbo].[Get_items_for_quickcount];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_items_for_quickcount]
	-- Add the parameters for the stored procedure here
	@COMPANY varchar(50),
	@USERNAME varchar(50)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	
DECLARE @TOUR varchar(20)
DECLARE @YEAR integer
DECLARE @TOURNEYNAME varchar(100)
	
--gets the first available tour, year and tourney name
SELECT TOP 1 @TOUR = [Type], @YEAR = YEAR([first day]), @TOURNEYNAME = [TOURNAMENT NAME] FROM billing.AllOrdersYTD a
 WHERE [FIRST DAY] <= GETDATE()
 ORDER BY [FIRST DAY] DESC, [TYPE];
	
	
	IF @COMPANY = 'DARRELL SURVEY'

SELECT ROW_NUMBER() OVER (ORDER BY ITEMNAME ASC) AS ROWID, ITEMNAME AS ITEM
FROM LKP.Report_Lookup
WHERE REPORTITEM = 'Top'
GROUP BY ITEMNAME
ORDER BY REPLACE(ITEMNAME, 'All ', '') ASC;

		--select ROW_NUMBER() OVER (ORDER BY ITEMNAME ASC) AS ROWID, 
		--ITEMNAME AS ITEM from Billing.AllOrdersYTD a LEFT OUTER JOIN LKP.Report_Lookup b on a.[Report Name]  = b.REPORTNAME
		--WHERE ITEMNAME IS NOT NULL and b.REPORTITEM = 'Top' GROUP BY ITEMNAME ORDER BY REPLACE(ITEMNAME, 'All ', '') ASC;

	ELSE

/*
				
SELECT ROW_NUMBER() OVER (ORDER BY ITEMNAME ASC) AS ROWID, ITEMNAME AS ITEM
FROM LKP.Report_Lookup
WHERE REPORTITEM = 'Top' AND REPORTNAME IN (SELECT DISTINCT([Report Name]) FROM Billing.AllOrdersYTD WHERE Company = REPLACE(@COMPANY, ' ', ''))
GROUP BY ITEMNAME
ORDER BY REPLACE(ITEMNAME, 'All ', '') ASC;

*/

SELECT ROW_NUMBER() OVER (ORDER BY ITEMNAME ASC) AS ROWID, ITEMNAME AS ITEM
FROM LKP.Report_Lookup
WHERE REPORTITEM = 'Top' AND REPORTNAME IN (SELECT DISTINCT([Report Name]) FROM Billing.AllOrdersYTD WHERE Company = REPLACE(@COMPANY, ' ', '') and [First Day]>GETDATE()-7)
GROUP BY ITEMNAME
ORDER BY REPLACE(ITEMNAME, 'All ', '') ASC;

				
		--select ROW_NUMBER() OVER (ORDER BY ITEMNAME ASC) AS ROWID, 
		--ITEMNAME AS ITEM from Billing.AllOrdersYTD a LEFT OUTER JOIN LKP.Report_Lookup b on a.[Report Name]  = b.REPORTNAME
		--WHERE a.Company = @COMPANY AND ITEMNAME IS NOT NULL and b.REPORTITEM = 'Top' GROUP BY ITEMNAME ORDER BY REPLACE(ITEMNAME, 'All ', '') ASC;
		
		-- select * from lkp.report_lookup
		
		-- execute dbo.get_items_for_quickcount 'TRUE TEMPER', 'billconst'
				

END
GO
