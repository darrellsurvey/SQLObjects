IF OBJECT_ID('CR_Reports.Wedges') IS NOT NULL
    DROP PROCEDURE [CR_Reports].[Wedges];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CR_Reports].[Wedges]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


SELECT [Name] AS PLAYERNAME, CATEGORY, EXTRA, [Wedge Club Code] AS WEDGECLUBCODE, DCLUBCODE, ISNULL(a.[Mfgr Abbrev], a.[Mfgr Descr]) AS WEDGEBRAND, DBRANDCODE,
ISNULL(b.[Model Abbrev], b.[Model Descr]) AS WEDGEMODEL, DMODELCODE, ISNULL([Type Abbrev], [Type Descr]) AS [WEDGETYPE], DTYPECODE

FROM Player_Master.[Wedge Detail] c
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a ON [Wedge Brand Code] = a.[Mfgr Code]
LEFT OUTER JOIN LKP.[Model Codes and Descr] b ON [Wedge Model Code] = b.[Model Code]
LEFT OUTER JOIN LKP.[Type Codes and Description] ON [Wedge Type Code] = [Type Code]
LEFT OUTER JOIN Player_Master.PLAYERNAMES g on c.[Name] = g.PLAYERNAME and c.[Survey ID] = g.SID AND c.[First Day] = g.FIRSTDAY 

WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID 
ORDER BY EXTRA, [Name], c.[PKey]


END
GO
