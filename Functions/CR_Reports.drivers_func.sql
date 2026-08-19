IF OBJECT_ID('CR_Reports.drivers_func') IS NOT NULL
    DROP FUNCTION [CR_Reports].[drivers_func];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [CR_Reports].[drivers_func] 
(	
	@FIRSTDAY date,
	@SID int
)
RETURNS TABLE 
AS
RETURN 
(


SELECT c.[Name] AS PLAYERNAME, CATEGORY, EXTRA, [Wood Club Code] AS WOODCLUBCODE, DCLUBCODE, [Wood Brand Code] AS WOODBRAND, DBRANDCODE,
[Wood Model Code] AS WOODMODEL, DMODELCODE, [Wood Size Code] AS WOODSIZE, DSIZECODE, [Wood Mat'l Code] AS WOODMATL, DMATERIAL FROM
--min pkey offsets new vs old, in the new it's just where pkey = 1
(SELECT [Name], MIN([PKey]) AS PKEY , [Survey ID], [First Day] FROM [Player_Master].[Wood Detail] WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID GROUP BY [Name], [Survey ID], [First Day]) c
LEFT OUTER JOIN
(SELECT * FROM [Player_Master].[Wood Detail] WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID) d
ON c.PKEY = d.[PKey] AND c.[Name] = d.[Name]
LEFT OUTER JOIN Player_Master.PLAYERNAMES g on c.[Name] = g.PLAYERNAME and c.[Survey ID] = g.SID AND c.[First Day] = g.FIRSTDAY 
WHERE c.[First Day] = @FIRSTDAY AND c.[Survey ID] = @SID 

)
GO
