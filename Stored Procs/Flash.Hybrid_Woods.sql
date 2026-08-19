IF OBJECT_ID('Flash.Hybrid_Woods') IS NOT NULL
    DROP PROCEDURE [Flash].[Hybrid_Woods];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Flash].[Hybrid_Woods]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


SELECT a.PLAYERNAME, CATEGORY, EXTRA, b.CLUBCODE, DCLUBCODE, ISNULL(c.[Mfgr Abbrev], c.[Mfgr Descr]) AS HYBRIDBRAND, DBRANDCODE,
ISNULL(d.[Model Abbrev], d.[Model Descr]) AS HYBRIDMODEL, DMODELCODE, ISNULL([Size Abbrev], [Size Descr]) AS HYBRIDSIZE, DSIZECODE, ISNULL([Matl Abbrev], [Matl Descr]) AS HYBRIDMATL, DMATERIAL
FROM (

SELECT PLAYERNAME, SID, [First Day] FROM Input.Wood WHERE [First Day] = @FIRSTDAY AND SID = @SID GROUP BY PLAYERNAME, SID, [First Day]) a 
LEFT OUTER JOIN (SELECT * FROM Input.Wood WHERE [First Day] = @FIRSTDAY AND SID = @SID AND CLUBCODE = 'HYB') b
ON a.PLAYERNAME = b.PLAYERNAME

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] c ON BRAND = c.[Mfgr Descr]
LEFT OUTER JOIN LKP.[Model Codes and Descr] d ON MODEL = d.[Model Descr]
LEFT OUTER JOIN LKP.[Size Codes and Description] e ON SIZE = e.[Size Descr]
LEFT OUTER JOIN LKP.[Material Codes and Descript] f ON MATERIAL = f.[Matl Descr]
LEFT OUTER JOIN Player_Master.PLAYERNAMES g on a.PLAYERNAME = g.PLAYERNAME and a.SID = g.SID AND a.[First Day] = g.FIRSTDAY 

--no where--these fields will be null for players with no hybrids
ORDER BY EXTRA, a.PLAYERNAME, b.[PKey]


END
GO
