IF OBJECT_ID('Flash.Puttergrip') IS NOT NULL
    DROP PROCEDURE [Flash].[Puttergrip];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Flash].[Puttergrip]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



SELECT a.PLAYERNAME, CATEGORY, EXTRA,
a.BRAND AS PUTTERBRAND, a.DBRANDCODE, a.MODEL AS PUTTERMODEL, a.DMODELCODE, a.SIZE AS PUTTERSIZE, a.DSIZECODE,

b.GRIPCLUBCODE AS GRIPCLUBCODE, DCLUBCODE, COALESCE(e.[Mfgr Abbrev], e.[Mfgr Descr]) AS GRIPMFGR, DMFGRCODE,
COALESCE(c.[Mfgr Abbrev], c.[Mfgr Descr]) AS GRIPBRAND, b.DBRANDCODE, COALESCE(d.[Model Abbrev], d.[Model Descr]) AS GRIPMODEL, b.DMODELCODE, COALESCE(f.[Matl Abbrev], f.[Matl Descr]) AS GRIPMATL, b.DMATERIAL
FROM (

SELECT * FROM input.putter WHERE [First Day] = @FIRSTDAY AND SID = @SID) a 
LEFT OUTER JOIN (SELECT * FROM input.grip WHERE [First Day] = @FIRSTDAY AND SID = @SID AND GRIPEQUIPTYPE = 'PUTT') b
ON a.PLAYERNAME = b.PLAYERNAME

--AND a.[Wood Club Code] = b.[Wood Club Code] AND a.[Wood Brand Code] = b.[Wood Brand Code] AND a.[Wood Model Code] = b.[Wood Model Code]
--AND a.[Field01] = b.[Field01] AND a.[Wood Size Code] = b.[Wood Size Code]

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] e ON b.GRIPMFGR = e.[Mfgr Descr]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] c ON b.GRIPBRAND = c.[Mfgr Descr]
LEFT OUTER JOIN LKP.[Model Codes and Descr] d ON b.GRIPMODEL = d.[Model Descr]
LEFT OUTER JOIN LKP.[Material Codes and Descript] f ON b.GRIPMATL = f.[Matl Descr]
LEFT OUTER JOIN Player_Master.PLAYERNAMES g on a.PLAYERNAME = g.PLAYERNAME and a.SID = g.SID AND a.[First Day] = g.FIRSTDAY 

--no where--these fields will be null for players with no hybrids
--WHERE b.[First Day] = :FIRSTDAY AND b.[Survey ID] = :SID
ORDER BY EXTRA, a.PLAYERNAME, b.[PKey]

END
GO
