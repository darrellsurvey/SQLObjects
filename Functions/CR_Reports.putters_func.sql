IF OBJECT_ID('CR_Reports.putters_func') IS NOT NULL
    DROP FUNCTION [CR_Reports].[putters_func];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [CR_Reports].[putters_func] 
(	
	@FIRSTDAY date,
	@SID int
)
RETURNS TABLE 
AS
RETURN 
(

SELECT [Name] AS PLAYERNAME, CATEGORY, EXTRA, [Putter Sequence No] AS CLUBCODE, DCLUBCODE, [Putter Brand Code] AS PUTTERBRAND, DBRANDCODE,
[Putter Model Code] AS PUTTERMODEL, DMODELCODE, [Putter Size Code] AS PUTTERSIZE, DSIZECODE
--REPLACE(d.[Size Descr], '-', '')
FROM Player_Master.[Putter Detail] c

LEFT OUTER JOIN Player_Master.PLAYERNAMES g on c.[Name] = g.PLAYERNAME and c.[Survey ID] = g.SID AND c.[First Day] = g.FIRSTDAY 

WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID 

)
GO
