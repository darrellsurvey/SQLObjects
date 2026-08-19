IF OBJECT_ID('CR_Reports.wedges_func') IS NOT NULL
    DROP FUNCTION [CR_Reports].[wedges_func];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [CR_Reports].[wedges_func] 
(	
	@FIRSTDAY date,
	@SID int
)
RETURNS TABLE 
AS
RETURN 
(

SELECT [Name] AS PLAYERNAME, CATEGORY, EXTRA, [Wedge Club Code] AS WEDGECLUBCODE, DCLUBCODE, [Wedge Brand Code] AS WEDGEBRAND, DBRANDCODE,
[Wedge Model Code] AS WEDGEMODEL, DMODELCODE, [Wedge Type Code] AS [WEDGETYPE], DTYPECODE

FROM Player_Master.[Wedge Detail] c
LEFT OUTER JOIN Player_Master.PLAYERNAMES g on c.[Name] = g.PLAYERNAME and c.[Survey ID] = g.SID AND c.[First Day] = g.FIRSTDAY 

WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID 




)
GO
