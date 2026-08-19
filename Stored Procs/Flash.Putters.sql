IF OBJECT_ID('Flash.Putters') IS NOT NULL
    DROP PROCEDURE [Flash].[Putters];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Flash].[Putters]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

if (@SID <> '')
SELECT c.PLAYERNAME, CATEGORY, EXTRA, CLUBCODE, DSEQUENCENO AS DCLUBCODE, ISNULL(a."Mfgr Abbrev", a."Mfgr Descr") AS PUTTERBRAND, DBRANDCODE,
b."Model Descr" AS PUTTERMODEL, DMODELCODE, d.[Size Descr] AS PUTTERSIZE, DSIZECODE
--REPLACE(d.[Size Descr], '-', '')
FROM input.putter c
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a ON BRAND = a."Mfgr Descr"
LEFT OUTER JOIN LKP.[Model Codes and Descr] b ON MODEL = b."Model Descr"
LEFT OUTER JOIN Player_Master.PLAYERNAMES g on c.PLAYERNAME = g.PLAYERNAME and c.SID = g.SID AND c."First Day" = g.FIRSTDAY 
left outer join LKP.[Size Codes and Description] d on SIZE = [Size Descr]

WHERE "First Day" = @FIRSTDAY AND c.SID = @SID 

ORDER BY EXTRA, PLAYERNAME ASC

else

select 'PLAYERNAMEPLAYERNAMEPLAYERNAME' AS PLAYERNAME, 'CATEGORY' AS CATEGORY, 'CLUBCODE' AS CLUBCODE, CAST(0 AS bit) AS DCLUBCODE, 'BRANDBRANDBRANDBRANDBRANDBRANDBRAND' AS PUTTERBRAND, CAST(1 AS bit) AS DBRANDCODE, 'MODELMODELMODELMODELMODELMODEL' AS PUTTERMODEL, CAST(0 AS bit) AS DMODELCODE, 'ASDASDASDASD' AS PUTTERSIZE, CAST(0 AS bit) AS DPUTTERSIZE


END
GO
