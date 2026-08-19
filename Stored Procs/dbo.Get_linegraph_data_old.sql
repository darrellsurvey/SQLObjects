IF OBJECT_ID('dbo.Get_linegraph_data_old') IS NOT NULL
    DROP PROCEDURE [dbo].[Get_linegraph_data_old];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_linegraph_data_old]
	-- Add the parameters for the stored procedure here
	@COMPANY varchar(50),
	@TOUR varchar(60),
	@REPORTNAME varchar(35)
	
	
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


--Set @FIRSTDAY = '10/1/2010';

DECLARE @FIRSTDAY DATE;
DECLARE @SID INT;


IF (@REPORTNAME = 'Bags')
with tourneys as (
select TOP 5 [First Day], TD AS SID, [Tournament Name], [Type] from
Billing.AllOrdersYTD
where [First Day] <= GETDATE() AND Company = @COMPANY and Type = @TOUR
GROUP BY [First Day], TD, [Tournament Name], [Type]
ORDER BY [First Day] DESC
),
itemtable as (
Select a.SID, PLAYERNAME, BAGBRAND, a.[FIRST DAY] FROM Player_Master.[All] a
LEFT OUTER JOIN tourneys b on a.SID = b.SID
WHERE b.[First Day] IS NOT NULL
),
 counttable as (
select SID, [First Day], COUNT(BAGBRAND) AS THINGCOUNT from itemtable GROUP BY SID, [First Day]
)

SELECT item.[First Day] AS "FIRST DAY", item.SID AS "SID", lkptable.[Mfgr Descr] AS MANUFACTURER, COUNT(item.BAGBRAND) AS "COUNT",
CAST(CAST(CAST(COUNT(item.BAGBRAND) as decimal(5,2)) * 100 / CAST(THINGCOUNT as decimal(5,2)) as decimal(5,2)) AS nvarchar) + '%' AS PERCENTAGE, tourneys.[Type] AS "TYPE", MONTH(item.[First Day]), DAY(item.[First Day]), YEAR(item.[First Day]), counttable.THINGCOUNT
FROM tourneys
LEFT OUTER JOIN itemtable item on tourneys.[First Day] = item.[First Day] and tourneys.SID = item.SID
LEFT OUTER JOIN counttable ON tourneys.SID = counttable.SID and tourneys.[First Day] = counttable.[First Day]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] lkptable ON item.BAGBRAND = lkptable.[Mfgr Code]
GROUP BY item.[First Day], item.SID, lkptable.[Mfgr Descr], tourneys.[Type], MONTH(item.[First Day]), DAY(item.[First Day]), YEAR(item.[First Day]), counttable.THINGCOUNT
ORDER BY item.[First Day], item.SID, counttable.THINGCOUNT DESC, COUNT(item.BAGBRAND) DESC;
      
ELSE IF (@REPORTNAME = 'Balls')
with tourneys as (
select TOP 5 [First Day], TD AS SID, [Tournament Name], [Type] from
Billing.AllOrdersYTD
where [First Day] <= GETDATE() AND Company = @COMPANY and Type = @TOUR
GROUP BY [First Day], TD, [Tournament Name], [Type]
ORDER BY [First Day] DESC
),
itemtable as (
Select a.SID, PLAYERNAME, BALLBRAND, a.[FIRST DAY] FROM Player_Master.[All] a
LEFT OUTER JOIN tourneys b on a.SID = b.SID
WHERE b.[First Day] IS NOT NULL
),
 counttable as (
select SID, [First Day], COUNT(BALLBRAND) AS THINGCOUNT from itemtable GROUP BY SID, [First Day]
)

SELECT item.[First Day] AS "FIRST DAY", item.SID AS "SID", lkptable.[Mfgr Descr] AS MANUFACTURER, COUNT(item.BALLBRAND) AS "COUNT",
CAST(CAST(CAST(COUNT(item.BALLBRAND) as decimal(5,2)) * 100 / CAST(THINGCOUNT as decimal(5,2)) as decimal(5,2)) AS nvarchar) + '%' AS PERCENTAGE,
tourneys.[Type] AS "TYPE", MONTH(item.[First Day]), DAY(item.[First Day]), YEAR(item.[First Day]), counttable.THINGCOUNT
FROM tourneys
LEFT OUTER JOIN itemtable item on tourneys.[First Day] = item.[First Day] and tourneys.SID = item.SID
LEFT OUTER JOIN counttable ON tourneys.SID = counttable.SID and tourneys.[First Day] = counttable.[First Day]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] lkptable ON item.BALLBRAND = lkptable.[Mfgr Code]
GROUP BY item.[First Day], item.SID, lkptable.[Mfgr Descr], tourneys.[Type],
MONTH(item.[First Day]), DAY(item.[First Day]), YEAR(item.[First Day]), counttable.THINGCOUNT
ORDER BY item.[First Day], item.SID, counttable.THINGCOUNT DESC, COUNT(item.BALLBRAND) DESC;
      
      
      
ELSE IF (@REPORTNAME = 'Gloves')
with tourneys as (
select TOP 5 [First Day], TD AS SID, [Tournament Name], [Type] from
Billing.AllOrdersYTD
where [First Day] <= GETDATE() AND Company = @COMPANY and Type = @TOUR
GROUP BY [First Day], TD, [Tournament Name], [Type]
ORDER BY [First Day] DESC
),
itemtable as (
Select a.SID, PLAYERNAME, GLOVEBRAND, a.[FIRST DAY] FROM Player_Master.[All] a
LEFT OUTER JOIN tourneys b on a.SID = b.SID
WHERE b.[First Day] IS NOT NULL
),
 counttable as (
select SID, [First Day], COUNT(GLOVEBRAND) AS THINGCOUNT from itemtable GROUP BY SID, [First Day]
)

SELECT item.[First Day] AS "FIRST DAY", item.SID AS "SID", lkptable.[Mfgr Descr] AS MANUFACTURER, COUNT(item.GLOVEBRAND) AS "COUNT",
CAST(CAST(CAST(COUNT(item.GLOVEBRAND) as decimal(5,2)) * 100 / CAST(THINGCOUNT as decimal(5,2)) as decimal(5,2)) AS nvarchar) + '%' AS PERCENTAGE,
tourneys.[Type] AS "TYPE", MONTH(item.[First Day]), DAY(item.[First Day]), YEAR(item.[First Day]), counttable.THINGCOUNT
FROM tourneys
LEFT OUTER JOIN itemtable item on tourneys.[First Day] = item.[First Day] and tourneys.SID = item.SID
LEFT OUTER JOIN counttable ON tourneys.SID = counttable.SID and tourneys.[First Day] = counttable.[First Day]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] lkptable ON item.GLOVEBRAND = lkptable.[Mfgr Code]
GROUP BY item.[First Day], item.SID, lkptable.[Mfgr Descr], tourneys.[Type],
MONTH(item.[First Day]), DAY(item.[First Day]), YEAR(item.[First Day]), counttable.THINGCOUNT
ORDER BY item.[First Day], item.SID, counttable.THINGCOUNT DESC, COUNT(item.GLOVEBRAND) DESC;
      
      
ELSE IF (@REPORTNAME = 'Shoes')
with tourneys as (
select TOP 5 [First Day], TD AS SID, [Tournament Name], [Type] from
Billing.AllOrdersYTD
where [First Day] <= GETDATE() AND Company = @COMPANY and Type = @TOUR
GROUP BY [First Day], TD, [Tournament Name], [Type]
ORDER BY [First Day] DESC
),
itemtable as (
Select a.SID, PLAYERNAME, SHOEBRAND, a.[FIRST DAY] FROM Player_Master.[All] a
LEFT OUTER JOIN tourneys b on a.SID = b.SID
WHERE b.[First Day] IS NOT NULL
),
 counttable as (
select SID, [First Day], COUNT(SHOEBRAND) AS THINGCOUNT from itemtable GROUP BY SID, [First Day]
)

SELECT item.[First Day] AS "FIRST DAY", item.SID AS "SID", lkptable.[Mfgr Descr] AS MANUFACTURER, COUNT(item.SHOEBRAND) AS "COUNT",
CAST(CAST(CAST(COUNT(item.SHOEBRAND) as decimal(5,2)) * 100 / CAST(THINGCOUNT as decimal(5,2)) as decimal(5,2)) AS nvarchar) + '%' AS PERCENTAGE,
tourneys.[Type] AS "TYPE", MONTH(item.[First Day]), DAY(item.[First Day]), YEAR(item.[First Day]), counttable.THINGCOUNT
FROM tourneys
LEFT OUTER JOIN itemtable item on tourneys.[First Day] = item.[First Day] and tourneys.SID = item.SID
LEFT OUTER JOIN counttable ON tourneys.SID = counttable.SID and tourneys.[First Day] = counttable.[First Day]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] lkptable ON item.SHOEBRAND = lkptable.[Mfgr Code]
GROUP BY item.[First Day], item.SID, lkptable.[Mfgr Descr], tourneys.[Type],
MONTH(item.[First Day]), DAY(item.[First Day]), YEAR(item.[First Day]), counttable.THINGCOUNT
ORDER BY item.[First Day], item.SID, counttable.THINGCOUNT DESC, COUNT(item.SHOEBRAND) DESC;


ELSE IF (@REPORTNAME = 'Driver')
 -- datediff purely for performance reasons, keeps the query from having to join on all driver for all time by limiting it to 4 months back
with tourneys as (
select TOP 5 [First Day], TD AS SID, [Tournament Name], [Type] from
Billing.AllOrdersYTD
where [First Day] <= GETDATE() AND Company = @COMPANY and Type = @TOUR
GROUP BY [First Day], TD, [Tournament Name], [Type]
ORDER BY [First Day] DESC
),
itemtable as (
Select a.[Survey ID], [Name], [Wood Brand Code], a.[FIRST DAY] FROM Player_Master.[Wood Detail] a
LEFT OUTER JOIN tourneys b on a.[Survey ID] = b.SID
WHERE b.[First Day] IS NOT NULL AND ISDRIVER = 1
),
 counttable as (
select [Survey ID], [First Day], COUNT([Wood Brand Code]) AS WOODCOUNT from 
itemtable drivertable GROUP BY [Survey ID], [First Day]
)

SELECT woods.[First Day] AS "FIRST DAY", woods.[Survey ID] AS "SID", lkptable.[Mfgr Descr] AS MANUFACTURER, COUNT(woods.[Wood Brand Code]) AS "COUNT",
CAST(CAST(CAST(COUNT(woods.[Wood Brand Code]) as decimal(5,2)) * 100 / CAST(WOODCOUNT as decimal(5,2)) as decimal(5,2)) AS nvarchar) + '%' AS PERCENTAGE, tourneys.[Type] AS "TYPE", MONTH(woods.[First Day]), DAY(woods.[First Day]), YEAR(woods.[First Day]), counttable.WOODCOUNT
FROM tourneys
LEFT OUTER JOIN itemtable woods on tourneys.[First Day] = woods.[First Day] and tourneys.SID = woods.[Survey ID]
LEFT OUTER JOIN counttable ON tourneys.SID = counttable.[Survey ID] and tourneys.[First Day] = counttable.[First Day]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] lkptable ON woods.[Wood Brand Code] = lkptable.[Mfgr Code]
GROUP BY woods.[First Day], woods.[Survey ID], lkptable.[Mfgr Descr], tourneys.[Type], MONTH(woods.[First Day]), DAY(woods.[First Day]), YEAR(woods.[First Day]), counttable.WOODCOUNT
ORDER BY woods.[First Day], woods.[Survey ID], counttable.WOODCOUNT DESC, COUNT(woods.[Wood Brand Code]) DESC;
 
 

ELSE IF (@REPORTNAME = 'All Woods')
with tourneys as (
select TOP 5 [First Day], TD AS SID, [Tournament Name], [Type] from
Billing.AllOrdersYTD
where [First Day] <= GETDATE() AND Company = @COMPANY and Type = @TOUR
GROUP BY [First Day], TD, [Tournament Name], [Type]
ORDER BY [First Day] DESC
),
itemtable as (
Select a.[survey id], [Name], [Wood Brand Code], a.[FIRST DAY] FROM Player_Master.[Wood Detail] a
LEFT OUTER JOIN tourneys b on a.[survey id] = b.SID
WHERE b.[First Day] IS NOT NULL
),
 counttable as (
select [Survey ID], [First Day], COUNT([Wood Brand Code]) AS WOODCOUNT from itemtable GROUP BY [Survey ID], [First Day]
)

SELECT woods.[First Day] AS "FIRST DAY", woods.[Survey ID] AS "SID", lkptable.[Mfgr Descr] AS MANUFACTURER, COUNT(woods.[Wood Brand Code]) AS "COUNT",
CAST(CAST(CAST(COUNT(woods.[Wood Brand Code]) as decimal(5,2)) * 100 / CAST(WOODCOUNT as decimal(5,2)) as decimal(5,2)) AS nvarchar) + '%' AS PERCENTAGE, tourneys.[Type] AS "TYPE", MONTH(woods.[First Day]), DAY(woods.[First Day]), YEAR(woods.[First Day]), counttable.WOODCOUNT
FROM tourneys
LEFT OUTER JOIN itemtable woods on tourneys.[First Day] = woods.[First Day] and tourneys.SID = woods.[Survey ID]
LEFT OUTER JOIN counttable ON tourneys.SID = counttable.[Survey ID] and tourneys.[First Day] = counttable.[First Day]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] lkptable ON woods.[Wood Brand Code] = lkptable.[Mfgr Code]
GROUP BY woods.[First Day], woods.[Survey ID], lkptable.[Mfgr Descr], tourneys.[Type], MONTH(woods.[First Day]), DAY(woods.[First Day]), YEAR(woods.[First Day]), counttable.WOODCOUNT
ORDER BY woods.[First Day], woods.[Survey ID], counttable.WOODCOUNT DESC, COUNT(woods.[Wood Brand Code]) DESC;


ELSE IF (@REPORTNAME = 'Fairway w/ Hybrid')
with tourneys as (
select TOP 5 [First Day], TD AS SID, [Tournament Name], [Type] from
Billing.AllOrdersYTD
where [First Day] <= GETDATE() AND Company = @COMPANY and Type = @TOUR
GROUP BY [First Day], TD, [Tournament Name], [Type]
ORDER BY [First Day] DESC
),
itemtable as (
Select a.[Survey ID], [Name], [Wood Brand Code], a.[FIRST DAY] FROM Player_Master.[Wood Detail] a
LEFT OUTER JOIN tourneys b on a.[Survey ID] = b.SID
WHERE b.[First Day] IS NOT NULL AND ISDRIVER IS NULL
),
 counttable as (
select [Survey ID], [First Day], COUNT([Wood Brand Code]) AS WOODCOUNT from 
itemtable drivertable GROUP BY [Survey ID], [First Day]
)

SELECT woods.[First Day] AS "FIRST DAY", woods.[Survey ID] AS "SID", lkptable.[Mfgr Descr] AS MANUFACTURER, COUNT(woods.[Wood Brand Code]) AS "COUNT",
CAST(CAST(CAST(COUNT(woods.[Wood Brand Code]) as decimal(5,2)) * 100 / CAST(WOODCOUNT as decimal(5,2)) as decimal(5,2)) AS nvarchar) + '%' AS PERCENTAGE, tourneys.[Type] AS "TYPE", MONTH(woods.[First Day]), DAY(woods.[First Day]), YEAR(woods.[First Day]), counttable.WOODCOUNT
FROM tourneys
LEFT OUTER JOIN itemtable woods on tourneys.[First Day] = woods.[First Day] and tourneys.SID = woods.[Survey ID]
LEFT OUTER JOIN counttable ON tourneys.SID = counttable.[Survey ID] and tourneys.[First Day] = counttable.[First Day]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] lkptable ON woods.[Wood Brand Code] = lkptable.[Mfgr Code]
GROUP BY woods.[First Day], woods.[Survey ID], lkptable.[Mfgr Descr], tourneys.[Type], MONTH(woods.[First Day]), DAY(woods.[First Day]), YEAR(woods.[First Day]), counttable.WOODCOUNT
ORDER BY woods.[First Day], woods.[Survey ID], counttable.WOODCOUNT DESC, COUNT(woods.[Wood Brand Code]) DESC;
      
      
ELSE IF (@REPORTNAME = 'Fairway w/o Hybrid')
with tourneys as (
select TOP 5 [First Day], TD AS SID, [Tournament Name], [Type] from
Billing.AllOrdersYTD
where [First Day] <= GETDATE() AND Company = @COMPANY and Type = @TOUR
GROUP BY [First Day], TD, [Tournament Name], [Type]
ORDER BY [First Day] DESC
),
itemtable as (
Select a.[Survey ID], [Name], [Wood Brand Code], a.[FIRST DAY] FROM Player_Master.[Wood Detail] a
LEFT OUTER JOIN tourneys b on a.[Survey ID] = b.SID
WHERE b.[First Day] IS NOT NULL AND ISDRIVER IS NULL and a.[Wood Club Code] <> 'HYB'
),
 counttable as (
select [Survey ID], [First Day], COUNT([Wood Brand Code]) AS WOODCOUNT from 
itemtable drivertable GROUP BY [Survey ID], [First Day]
)

SELECT woods.[First Day] AS "FIRST DAY", woods.[Survey ID] AS "SID", lkptable.[Mfgr Descr] AS MANUFACTURER, COUNT(woods.[Wood Brand Code]) AS "COUNT",
CAST(CAST(CAST(COUNT(woods.[Wood Brand Code]) as decimal(5,2)) * 100 / CAST(WOODCOUNT as decimal(5,2)) as decimal(5,2)) AS nvarchar) + '%' AS PERCENTAGE, tourneys.[Type] AS "TYPE", MONTH(woods.[First Day]), DAY(woods.[First Day]), YEAR(woods.[First Day]), counttable.WOODCOUNT
FROM tourneys
LEFT OUTER JOIN itemtable woods on tourneys.[First Day] = woods.[First Day] and tourneys.SID = woods.[Survey ID]
LEFT OUTER JOIN counttable ON tourneys.SID = counttable.[Survey ID] and tourneys.[First Day] = counttable.[First Day]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] lkptable ON woods.[Wood Brand Code] = lkptable.[Mfgr Code]
GROUP BY woods.[First Day], woods.[Survey ID], lkptable.[Mfgr Descr], tourneys.[Type], MONTH(woods.[First Day]), DAY(woods.[First Day]), YEAR(woods.[First Day]), counttable.WOODCOUNT
ORDER BY woods.[First Day], woods.[Survey ID], counttable.WOODCOUNT DESC, COUNT(woods.[Wood Brand Code]) DESC;
      
      
ELSE IF (@REPORTNAME = 'Hybrid Woods')
with tourneys as (
select TOP 5 [First Day], TD AS SID, [Tournament Name], [Type] from
Billing.AllOrdersYTD
where [First Day] <= GETDATE() AND Company = @COMPANY and Type = @TOUR
GROUP BY [First Day], TD, [Tournament Name], [Type]
ORDER BY [First Day] DESC
),
itemtable as (
Select a.[Survey ID], [Name], [Wood Brand Code], a.[FIRST DAY] FROM Player_Master.[Wood Detail] a
LEFT OUTER JOIN tourneys b on a.[Survey ID] = b.SID
WHERE b.[First Day] IS NOT NULL AND a.[Wood Club Code] = 'HYB'
),
 counttable as (
select [Survey ID], [First Day], COUNT([Wood Brand Code]) AS WOODCOUNT from 
itemtable drivertable GROUP BY [Survey ID], [First Day]
)

SELECT woods.[First Day] AS "FIRST DAY", woods.[Survey ID] AS "SID", lkptable.[Mfgr Descr] AS MANUFACTURER, COUNT(woods.[Wood Brand Code]) AS "COUNT",
CAST(CAST(CAST(COUNT(woods.[Wood Brand Code]) as decimal(5,2)) * 100 / CAST(WOODCOUNT as decimal(5,2)) as decimal(5,2)) AS nvarchar) + '%' AS PERCENTAGE, tourneys.[Type] AS "TYPE", MONTH(woods.[First Day]), DAY(woods.[First Day]), YEAR(woods.[First Day]), counttable.WOODCOUNT
FROM tourneys
LEFT OUTER JOIN itemtable woods on tourneys.[First Day] = woods.[First Day] and tourneys.SID = woods.[Survey ID]
LEFT OUTER JOIN counttable ON tourneys.SID = counttable.[Survey ID] and tourneys.[First Day] = counttable.[First Day]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] lkptable ON woods.[Wood Brand Code] = lkptable.[Mfgr Code]
GROUP BY woods.[First Day], woods.[Survey ID], lkptable.[Mfgr Descr], tourneys.[Type], MONTH(woods.[First Day]), DAY(woods.[First Day]), YEAR(woods.[First Day]), counttable.WOODCOUNT
ORDER BY woods.[First Day], woods.[Survey ID], counttable.WOODCOUNT DESC, COUNT(woods.[Wood Brand Code]) DESC;         
            
      
ELSE IF (@REPORTNAME = 'Headgear')
with tourneys as (
select TOP 5 [First Day], TD AS SID, [Tournament Name], [Type] from
Billing.AllOrdersYTD
where [First Day] <= GETDATE() AND Company = @COMPANY and Type = @TOUR
GROUP BY [First Day], TD, [Tournament Name], [Type]
ORDER BY [First Day] DESC
),
itemtable as (
Select a.SID, PLAYERNAME, HEADGEARBRAND, a.[FIRST DAY] FROM Player_Master.[All] a
LEFT OUTER JOIN tourneys b on a.SID = b.SID
WHERE b.[First Day] IS NOT NULL
),
 counttable as (
select SID, [First Day], COUNT(HEADGEARBRAND) AS THINGCOUNT from itemtable GROUP BY SID, [First Day]
)

SELECT item.[First Day] AS "FIRST DAY", item.SID AS "SID", lkptable.[Mfgr Descr] AS MANUFACTURER, COUNT(item.HEADGEARBRAND) AS "COUNT",
CAST(CAST(CAST(COUNT(item.HEADGEARBRAND) as decimal(5,2)) * 100 / CAST(THINGCOUNT as decimal(5,2)) as decimal(5,2)) AS nvarchar) + '%' AS PERCENTAGE,
tourneys.[Type] AS "TYPE", MONTH(item.[First Day]), DAY(item.[First Day]), YEAR(item.[First Day]), counttable.THINGCOUNT
FROM tourneys
LEFT OUTER JOIN itemtable item on tourneys.[First Day] = item.[First Day] and tourneys.SID = item.SID
LEFT OUTER JOIN counttable ON tourneys.SID = counttable.SID and tourneys.[First Day] = counttable.[First Day]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] lkptable ON item.HEADGEARBRAND = lkptable.[Mfgr Code]
GROUP BY item.[First Day], item.SID, lkptable.[Mfgr Descr], tourneys.[Type],
MONTH(item.[First Day]), DAY(item.[First Day]), YEAR(item.[First Day]), counttable.THINGCOUNT
ORDER BY item.[First Day], item.SID, counttable.THINGCOUNT DESC, COUNT(item.HEADGEARBRAND) DESC;


ELSE IF (@REPORTNAME = 'Iron')
WITH tourneys as (
select TOP 5 [First Day], TD AS SID, [Tournament Name], [Type] from
Billing.AllOrdersYTD
where [First Day] <= GETDATE() AND Company = @COMPANY and Type = @TOUR
GROUP BY [First Day], TD, [Tournament Name], [Type]
ORDER BY [First Day] DESC
),
itemtable as (
Select a.[Survey ID], [Name], [Iron Brand Code], a.[FIRST DAY] FROM Player_Master.[Iron Detail] a
LEFT OUTER JOIN tourneys b on a.[Survey ID] = b.SID
WHERE b.[First Day] IS NOT NULL AND ISSET = 1
),
 counttable as (
select [Survey ID], [First Day], COUNT([Iron Brand Code]) AS THINGCOUNT from itemtable a GROUP BY [Survey ID], [First Day]
)

SELECT item.[First Day] AS "FIRST DAY", item.[Survey ID] AS "SID", lkptable.[Mfgr Descr] AS MANUFACTURER, COUNT(item.[Iron Brand Code]) AS "COUNT",
CAST(CAST(CAST(COUNT(item.[Iron Brand Code]) as decimal(5,2)) * 100 / CAST(THINGCOUNT as decimal(5,2)) as decimal(5,2)) AS nvarchar) + '%' AS PERCENTAGE,
tourneys.[Type] AS "TYPE", MONTH(item.[First Day]), DAY(item.[First Day]), YEAR(item.[First Day]), counttable.THINGCOUNT
FROM tourneys
LEFT OUTER JOIN itemtable item on tourneys.[First Day] = item.[First Day] and tourneys.SID = item.[Survey ID]
LEFT OUTER JOIN counttable ON tourneys.SID = counttable.[Survey ID] and tourneys.[First Day] = counttable.[First Day]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] lkptable ON item.[Iron Brand Code] = lkptable.[Mfgr Code]
GROUP BY item.[First Day], item.[Survey ID], lkptable.[Mfgr Descr], tourneys.[Type],
MONTH(item.[First Day]), DAY(item.[First Day]), YEAR(item.[First Day]), counttable.THINGCOUNT
ORDER BY item.[First Day], item.[Survey ID], counttable.THINGCOUNT DESC, COUNT(item.[Iron Brand Code]) DESC;


ELSE IF (@REPORTNAME = 'Utility Iron')
WITH tourneys as (
select TOP 5 [First Day], TD AS SID, [Tournament Name], [Type] from
Billing.AllOrdersYTD
where [First Day] <= GETDATE() AND Company = @COMPANY and Type = @TOUR
GROUP BY [First Day], TD, [Tournament Name], [Type]
ORDER BY [First Day] DESC
),
itemtable as (
Select a.[Survey ID], [Name], [Iron Brand Code], a.[FIRST DAY] FROM Player_Master.[Iron Detail] a
LEFT OUTER JOIN tourneys b on a.[Survey ID] = b.SID
WHERE b.[First Day] IS NOT NULL and a.[iron club code] like '%^%'
),
 counttable as (
select [Survey ID], [First Day], COUNT([Iron Brand Code]) AS THINGCOUNT from itemtable a GROUP BY [Survey ID], [First Day]
)

SELECT item.[First Day] AS "FIRST DAY", item.[Survey ID] AS "SID", lkptable.[Mfgr Descr] AS MANUFACTURER, COUNT(item.[Iron Brand Code]) AS "COUNT",
CAST(CAST(CAST(COUNT(item.[Iron Brand Code]) as decimal(5,2)) * 100 / CAST(THINGCOUNT as decimal(5,2)) as decimal(5,2)) AS nvarchar) + '%' AS PERCENTAGE,
tourneys.[Type] AS "TYPE", MONTH(item.[First Day]), DAY(item.[First Day]), YEAR(item.[First Day]), counttable.THINGCOUNT
FROM tourneys
LEFT OUTER JOIN itemtable item on tourneys.[First Day] = item.[First Day] and tourneys.SID = item.[Survey ID]
LEFT OUTER JOIN counttable ON tourneys.SID = counttable.[Survey ID] and tourneys.[First Day] = counttable.[First Day]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] lkptable ON item.[Iron Brand Code] = lkptable.[Mfgr Code]
GROUP BY item.[First Day], item.[Survey ID], lkptable.[Mfgr Descr], tourneys.[Type],
MONTH(item.[First Day]), DAY(item.[First Day]), YEAR(item.[First Day]), counttable.THINGCOUNT
ORDER BY item.[First Day], item.[Survey ID], counttable.THINGCOUNT DESC, COUNT(item.[Iron Brand Code]) DESC;
      

ELSE IF (@REPORTNAME = 'Putters')
WITH tourneys as (
select TOP 5 [First Day], TD AS SID, [Tournament Name], [Type] from
Billing.AllOrdersYTD
where [First Day] <= GETDATE() AND Company = @COMPANY and Type = @TOUR
GROUP BY [First Day], TD, [Tournament Name], [Type]
ORDER BY [First Day] DESC
),
itemtable as (
Select a.[Survey ID], [Name], [Putter Brand Code], a.[FIRST DAY] FROM Player_Master.[Putter Detail] a
LEFT OUTER JOIN tourneys b on a.[Survey ID] = b.SID
WHERE b.[First Day] IS NOT NULL
),
 counttable as (
select [Survey ID], [First Day], COUNT([Putter Brand Code]) AS THINGCOUNT from itemtable a GROUP BY [Survey ID], [First Day]
)

SELECT item.[First Day] AS "FIRST DAY", item.[Survey ID] AS "SID", lkptable.[Mfgr Descr] AS MANUFACTURER, COUNT(item.[Putter Brand Code]) AS "COUNT",
CAST(CAST(CAST(COUNT(item.[Putter Brand Code]) as decimal(5,2)) * 100 / CAST(THINGCOUNT as decimal(5,2)) as decimal(5,2)) AS nvarchar) + '%' AS PERCENTAGE,
tourneys.[Type] AS "TYPE", MONTH(item.[First Day]), DAY(item.[First Day]), YEAR(item.[First Day]), counttable.THINGCOUNT
FROM tourneys
LEFT OUTER JOIN itemtable item on tourneys.[First Day] = item.[First Day] and tourneys.SID = item.[Survey ID]
LEFT OUTER JOIN counttable ON tourneys.SID = counttable.[Survey ID] and tourneys.[First Day] = counttable.[First Day]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] lkptable ON item.[Putter Brand Code] = lkptable.[Mfgr Code]
GROUP BY item.[First Day], item.[Survey ID], lkptable.[Mfgr Descr], tourneys.[Type],
MONTH(item.[First Day]), DAY(item.[First Day]), YEAR(item.[First Day]), counttable.THINGCOUNT
ORDER BY item.[First Day], item.[Survey ID], counttable.THINGCOUNT DESC, COUNT(item.[Putter Brand Code]) DESC;


/*
ELSE IF (@REPORTNAME = 'Shaft')
      SELECT
"Mfgr Descr" AS Brand, COUNT("Shaft Brand Code") AS "Count",
COUNT("Shaft Brand Code") * 100 / (SELECT COUNT("Shaft Brand Code") FROM [Player_Master].[Shaft Detail] WHERE "Survey ID" = @SID AND "First Day" = @FIRSTDAY) AS "%"
  FROM [Player_Master].[Shaft Detail]
  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Code" = "Shaft Brand Code"
  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY
  GROUP BY "Mfgr Descr"
      ORDER BY COUNT("Shaft Brand Code") DESC, "Mfgr Descr" ASC;


ELSE IF (@REPORTNAME = 'Iron Shaft Material')
      SELECT
"Matl Descr" AS Brand, COUNT("Shaft Mat'l Code") AS "Count",
COUNT("Shaft Mat'l Code") * 100 / (SELECT COUNT("Shaft Mat'l Code") FROM [Player_Master].[Shaft Detail] WHERE "Survey ID" = @SID AND "First Day" = @FIRSTDAY AND [Shaft Equip Type] = 'IRON') AS "%"
  FROM [Player_Master].[Shaft Detail]
  LEFT OUTER JOIN [LKP].[Material Codes and Descript] ON "Matl Code" = "Shaft Mat'l Code" 
  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'IRON'
  GROUP BY "Matl Descr"
      ORDER BY COUNT("Shaft Mat'l Code") DESC, "Matl Descr" ASC;


ELSE IF (@REPORTNAME = 'Iron Shaft Manufacturer')
      SELECT
"Mfgr Descr" AS Brand, COUNT("Shaft Mfgr Code") AS "Count",
COUNT("Shaft Mfgr Code") * 100 / (SELECT COUNT("Shaft Mfgr Code") FROM [Player_Master].[Shaft Detail] WHERE "Survey ID" = @SID AND "First Day" = @FIRSTDAY AND [Shaft Equip Type] = 'IRON') AS "%"
  FROM [Player_Master].[Shaft Detail]
  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Code" = "Shaft Mfgr Code" 
  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'IRON'
  GROUP BY "Mfgr Descr"
      ORDER BY COUNT("Shaft Mfgr Code") DESC, "Mfgr Descr" ASC;


ELSE IF (@REPORTNAME = 'Iron Shaft Brand')
      SELECT
"Mfgr Descr" AS Brand, COUNT("Shaft Brand Code") AS "Count",
COUNT("Shaft Brand Code") * 100 / (SELECT COUNT("Shaft Brand Code") FROM [Player_Master].[Shaft Detail] WHERE "Survey ID" = @SID AND "First Day" = @FIRSTDAY AND [Shaft Equip Type] = 'IRON') AS "%"
  FROM [Player_Master].[Shaft Detail]
  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Code" = "Shaft Brand Code"
  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'IRON'
  GROUP BY "Mfgr Descr"
      ORDER BY COUNT("Shaft Brand Code") DESC, "Mfgr Descr" ASC;


ELSE IF (@REPORTNAME = 'Wood Shaft Material')
      SELECT
"Matl Descr" AS Brand, COUNT("Shaft Mat'l Code") AS "Count",
COUNT("Shaft Mat'l Code") * 100 / (SELECT COUNT("Shaft Mat'l Code") FROM [Player_Master].[Shaft Detail] WHERE "Survey ID" = @SID AND "First Day" = @FIRSTDAY AND [Shaft Equip Type] = 'WOOD') AS "%"
  FROM [Player_Master].[Shaft Detail]
  LEFT OUTER JOIN [LKP].[Material Codes and Descript] ON "Matl Code" = "Shaft Mat'l Code" 
  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'WOOD'
  GROUP BY "Matl Descr"
      ORDER BY COUNT("Shaft Mat'l Code") DESC, "Matl Descr" ASC;


ELSE IF (@REPORTNAME = 'Wood Shaft Manufacturer')
      SELECT
"Mfgr Descr" AS Brand, COUNT("Shaft Mfgr Code") AS "Count",
COUNT("Shaft Mfgr Code") * 100 / (SELECT COUNT("Shaft Mfgr Code") FROM [Player_Master].[Shaft Detail] WHERE "Survey ID" = @SID AND "First Day" = @FIRSTDAY AND [Shaft Equip Type] = 'WOOD') AS "%"
  FROM [Player_Master].[Shaft Detail]
  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Code" = "Shaft Mfgr Code" 
  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'WOOD'
  GROUP BY "Mfgr Descr"
      ORDER BY COUNT("Shaft Mfgr Code") DESC, "Mfgr Descr" ASC;


ELSE IF (@REPORTNAME = 'Wood Shaft Brand')
      SELECT
"Mfgr Descr" AS Brand, COUNT("Shaft Brand Code") AS "Count",
COUNT("Shaft Brand Code") * 100 / (SELECT COUNT("Shaft Brand Code") FROM [Player_Master].[Shaft Detail] WHERE "Survey ID" = @SID AND "First Day" = @FIRSTDAY AND [Shaft Equip Type] = 'WOOD') AS "%"
  FROM [Player_Master].[Shaft Detail]
  LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON "Mfgr Code" = "Shaft Brand Code"
  WHERE [Survey ID]= @SID AND [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'WOOD'
  GROUP BY "Mfgr Descr"
      ORDER BY COUNT("Shaft Brand Code") DESC, "Mfgr Descr" ASC;
*/

ELSE IF (@REPORTNAME = 'All Wedges')
WITH tourneys as (
select TOP 5 [First Day], TD AS SID, [Tournament Name], [Type] from
Billing.AllOrdersYTD
where [First Day] <= GETDATE() AND Company = @COMPANY and Type = @TOUR
GROUP BY [First Day], TD, [Tournament Name], [Type]
ORDER BY [First Day] DESC
),
itemtable as (
Select a.[Survey ID], [Name], [Wedge Brand Code], a.[FIRST DAY] FROM Player_Master.[Wedge Detail] a
LEFT OUTER JOIN tourneys b on a.[Survey ID] = b.SID
WHERE b.[First Day] IS NOT NULL
),
 counttable as (
select [Survey ID], [First Day], COUNT([Wedge Brand Code]) AS THINGCOUNT from itemtable a GROUP BY [Survey ID], [First Day]
)

SELECT item.[First Day] AS "FIRST DAY", item.[Survey ID] AS "SID", lkptable.[Mfgr Descr] AS MANUFACTURER, COUNT(item.[Wedge Brand Code]) AS "COUNT",
CAST(CAST(CAST(COUNT(item.[Wedge Brand Code]) as decimal(5,2)) * 100 / CAST(THINGCOUNT as decimal(5,2)) as decimal(5,2)) AS nvarchar) + '%' AS PERCENTAGE,
tourneys.[Type] AS "TYPE", MONTH(item.[First Day]), DAY(item.[First Day]), YEAR(item.[First Day]), counttable.THINGCOUNT
FROM tourneys
LEFT OUTER JOIN itemtable item on tourneys.[First Day] = item.[First Day] and tourneys.SID = item.[Survey ID]
LEFT OUTER JOIN counttable ON tourneys.SID = counttable.[Survey ID] and tourneys.[First Day] = counttable.[First Day]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] lkptable ON item.[Wedge Brand Code] = lkptable.[Mfgr Code]
GROUP BY item.[First Day], item.[Survey ID], lkptable.[Mfgr Descr], tourneys.[Type],
MONTH(item.[First Day]), DAY(item.[First Day]), YEAR(item.[First Day]), counttable.THINGCOUNT
ORDER BY item.[First Day], item.[Survey ID], counttable.THINGCOUNT DESC, COUNT(item.[Wedge Brand Code]) DESC;

ELSE IF (@REPORTNAME = 'Pitch Wedges')
WITH tourneys as (
select TOP 5 [First Day], TD AS SID, [Tournament Name], [Type] from
Billing.AllOrdersYTD
where [First Day] <= GETDATE() AND Company = @COMPANY and Type = @TOUR
GROUP BY [First Day], TD, [Tournament Name], [Type]
ORDER BY [First Day] DESC
),
itemtable as (
Select a.[Survey ID], [Name], [Wedge Brand Code], a.[FIRST DAY] FROM Player_Master.[Wedge Detail] a
LEFT OUTER JOIN tourneys b on a.[Survey ID] = b.SID
WHERE b.[First Day] IS NOT NULL and a.[Wedge Club Code] = 'PW'
),
 counttable as (
select [Survey ID], [First Day], COUNT([Wedge Brand Code]) AS THINGCOUNT from itemtable a GROUP BY [Survey ID], [First Day]
)

SELECT item.[First Day] AS "FIRST DAY", item.[Survey ID] AS "SID", lkptable.[Mfgr Descr] AS MANUFACTURER, COUNT(item.[Wedge Brand Code]) AS "COUNT",
CAST(CAST(CAST(COUNT(item.[Wedge Brand Code]) as decimal(5,2)) * 100 / CAST(THINGCOUNT as decimal(5,2)) as decimal(5,2)) AS nvarchar) + '%' AS PERCENTAGE,
tourneys.[Type] AS "TYPE", MONTH(item.[First Day]), DAY(item.[First Day]), YEAR(item.[First Day]), counttable.THINGCOUNT
FROM tourneys
LEFT OUTER JOIN itemtable item on tourneys.[First Day] = item.[First Day] and tourneys.SID = item.[Survey ID]
LEFT OUTER JOIN counttable ON tourneys.SID = counttable.[Survey ID] and tourneys.[First Day] = counttable.[First Day]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] lkptable ON item.[Wedge Brand Code] = lkptable.[Mfgr Code]
GROUP BY item.[First Day], item.[Survey ID], lkptable.[Mfgr Descr], tourneys.[Type],
MONTH(item.[First Day]), DAY(item.[First Day]), YEAR(item.[First Day]), counttable.THINGCOUNT
ORDER BY item.[First Day], item.[Survey ID], counttable.THINGCOUNT DESC, COUNT(item.[Wedge Brand Code]) DESC;

ELSE IF (@REPORTNAME = 'Other Wedges')
WITH tourneys as (
select TOP 5 [First Day], TD AS SID, [Tournament Name], [Type] from
Billing.AllOrdersYTD
where [First Day] <= GETDATE() AND Company = @COMPANY and Type = @TOUR
GROUP BY [First Day], TD, [Tournament Name], [Type]
ORDER BY [First Day] DESC
),
itemtable as (
Select a.[Survey ID], [Name], [Wedge Brand Code], a.[FIRST DAY] FROM Player_Master.[Wedge Detail] a
LEFT OUTER JOIN tourneys b on a.[Survey ID] = b.SID
WHERE b.[First Day] IS NOT NULL and a.[Wedge Club Code] <> 'PW'
),
 counttable as (
select [Survey ID], [First Day], COUNT([Wedge Brand Code]) AS THINGCOUNT from itemtable a GROUP BY [Survey ID], [First Day]
)

SELECT item.[First Day] AS "FIRST DAY", item.[Survey ID] AS "SID", lkptable.[Mfgr Descr] AS MANUFACTURER, COUNT(item.[Wedge Brand Code]) AS "COUNT",
CAST(CAST(CAST(COUNT(item.[Wedge Brand Code]) as decimal(5,2)) * 100 / CAST(THINGCOUNT as decimal(5,2)) as decimal(5,2)) AS nvarchar) + '%' AS PERCENTAGE,
tourneys.[Type] AS "TYPE", MONTH(item.[First Day]), DAY(item.[First Day]), YEAR(item.[First Day]), counttable.THINGCOUNT
FROM tourneys
LEFT OUTER JOIN itemtable item on tourneys.[First Day] = item.[First Day] and tourneys.SID = item.[Survey ID]
LEFT OUTER JOIN counttable ON tourneys.SID = counttable.[Survey ID] and tourneys.[First Day] = counttable.[First Day]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] lkptable ON item.[Wedge Brand Code] = lkptable.[Mfgr Code]
GROUP BY item.[First Day], item.[Survey ID], lkptable.[Mfgr Descr], tourneys.[Type],
MONTH(item.[First Day]), DAY(item.[First Day]), YEAR(item.[First Day]), counttable.THINGCOUNT
ORDER BY item.[First Day], item.[Survey ID], counttable.THINGCOUNT DESC, COUNT(item.[Wedge Brand Code]) DESC;




ELSE
 
--dummy select to set ourput variables for crystal reports
SELECT TOP 1 [FIRST DAY], SID, 'TITLEIST' as MANUFACTURER, 12 as "COUNT", '12.34%' as PERCENTAGE, @TOUR AS "TYPE", 8, 26, 2010, 123 FROM Player_Master.[All] where PLAYERNAME = 'ZYXYXZYX';

     




END
GO
