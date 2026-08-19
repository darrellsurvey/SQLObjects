IF OBJECT_ID('CR_Reports.utility_irons_func') IS NOT NULL
    DROP FUNCTION [CR_Reports].[utility_irons_func];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [CR_Reports].[utility_irons_func] 
(	
	@FIRSTDAY date,
	@SID int
)
RETURNS TABLE 
AS
RETURN 
(




SELECT a.[Name] AS PLAYERNAME, CATEGORY, EXTRA, b.[Iron Club Code] AS IRONCLUBCODE, DCLUBCODE AS DIRONCLUBCODE, [Iron Brand Code] AS IRONBRAND, DBRANDCODE AS DIRONBRANDCODE,
[Iron Model Code] AS IRONMODEL, DMODELCODE AS DIRONMODELCODE

FROM (

SELECT [Name], [Survey ID], [First Day] FROM Player_Master.[Iron Detail] WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID GROUP BY [Name], [Survey ID], [First Day]) a  
LEFT OUTER JOIN (SELECT * FROM Player_Master.[Iron Detail] WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID AND [Iron Club Code] LIKE '%^%') b
ON a.[Name] = b.[Name]
LEFT OUTER JOIN Player_Master.PLAYERNAMES g on a.[Name] = g.PLAYERNAME and a.[Survey ID] = g.SID AND a.[First Day] = g.FIRSTDAY 


)
GO
