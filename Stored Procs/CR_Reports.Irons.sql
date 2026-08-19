IF OBJECT_ID('CR_Reports.Irons') IS NOT NULL
    DROP PROCEDURE [CR_Reports].[Irons];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CR_Reports].[Irons]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


SELECT [Name] AS PLAYERNAME, CATEGORY, EXTRA, [Iron Club Code] AS CLUBCODE, DCLUBCODE, ISNULL(a.[Mfgr Abbrev], a.[Mfgr Descr]) AS BRAND, DBRANDCODE,
ISNULL(b.[Model Abbrev], b.[Model Descr]) AS MODEL, DMODELCODE

FROM Player_Master.[Iron Detail] c
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a ON [Iron Brand Code] = a.[Mfgr Code]
LEFT OUTER JOIN LKP.[Model Codes and Descr] b ON [Iron Model Code] = b.[Model Code]
LEFT OUTER JOIN Player_Master.PLAYERNAMES g on c.[Name] = g.PLAYERNAME and c.[Survey ID] = g.SID AND c.[First Day] = g.FIRSTDAY 

WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID 

--GROUP BY [Name], CATEGORY, [Iron Club Code], a.[Mfgr Descr], b.[Model Descr]
ORDER BY EXTRA, [Name] ASC, c.PKey


END
GO
