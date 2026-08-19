IF OBJECT_ID('CR_Reports.wedgeshaft_func') IS NOT NULL
    DROP FUNCTION [CR_Reports].[wedgeshaft_func];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [CR_Reports].[wedgeshaft_func] 
(	
	@FIRSTDAY date,
	@SID int
)
RETURNS TABLE 
AS
RETURN 
(

SELECT a.[Name] AS PLAYERNAME, CATEGORY, EXTRA, b.[Shaft Club Code] AS CLUBCODE, DCLUBCODE, [Shaft Mfgr Code] AS MFGR, DMFGRCODE,
[Shaft Brand Code] AS BRAND, DBRANDCODE, [Shaft Model Code] AS MODEL, DMODELCODE, [Shaft Mat'l Code] AS MATL, DMATERIAL
FROM (

SELECT [Name], [Survey ID], [First Day] FROM Player_Master.[Wedge Detail] WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID GROUP BY [Name], [Survey ID], [First Day]) a  
LEFT OUTER JOIN (SELECT * FROM Player_Master.[Shaft Detail] WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID AND [Shaft Equip Type] = 'WEDG') b
ON a.[Name] = b.[Name]

LEFT OUTER JOIN Player_Master.PLAYERNAMES g on a.[Name] = g.PLAYERNAME and a.[Survey ID] = g.SID AND a.[First Day] = g.FIRSTDAY 


)
GO
