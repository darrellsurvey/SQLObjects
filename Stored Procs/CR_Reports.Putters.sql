IF OBJECT_ID('CR_Reports.Putters') IS NOT NULL
    DROP PROCEDURE [CR_Reports].[Putters];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CR_Reports].[Putters]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

if (@SID <> '')
SELECT [Name] AS PLAYERNAME, CATEGORY, EXTRA, [Putter Sequence No] AS CLUBCODE, DCLUBCODE, ISNULL(a.[Mfgr Abbrev], a.[Mfgr Descr]) AS PUTTERBRAND, DBRANDCODE,
b.[Model Descr] AS PUTTERMODEL, DMODELCODE, d.[Size Descr] AS PUTTERSIZE, DSIZECODE
--REPLACE(d.[Size Descr], '-', '')
FROM Player_Master.[Putter Detail] c
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a ON [Putter Brand Code] = a.[Mfgr Code]
LEFT OUTER JOIN LKP.[Model Codes and Descr] b ON [Putter Model Code] = b.[Model Code]
LEFT OUTER JOIN Player_Master.PLAYERNAMES g on c.[Name] = g.PLAYERNAME and c.[Survey ID] = g.SID AND c.[First Day] = g.FIRSTDAY 
left outer join LKP.[Size Codes and Description] d on [Putter Size Code] = [Size Code]

WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SID 

ORDER BY EXTRA, [Name] ASC

else

select 'PLAYERNAMEPLAYERNAMEPLAYERNAME' AS PLAYERNAME, 'CATEGORY' AS CATEGORY, 'CLUBCODE' AS CLUBCODE, CAST(0 AS bit) AS DCLUBCODE, 'BRANDBRANDBRANDBRANDBRANDBRANDBRAND' AS PUTTERBRAND, CAST(1 AS bit) AS DBRANDCODE, 'MODELMODELMODELMODELMODELMODEL' AS PUTTERMODEL, CAST(0 AS bit) AS DMODELCODE, 'ASDASDASDASD' AS PUTTERSIZE, CAST(0 AS bit) AS DPUTTERSIZE


END
GO
