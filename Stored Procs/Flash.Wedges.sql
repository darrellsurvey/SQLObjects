IF OBJECT_ID('Flash.Wedges') IS NOT NULL
    DROP PROCEDURE [Flash].[Wedges];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Flash].[Wedges]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


SELECT c.PLAYERNAME, CATEGORY, EXTRA, CLUBCODE AS WEDGECLUBCODE, DCLUBCODE, ISNULL(a."Mfgr Abbrev", a."Mfgr Descr") AS WEDGEBRAND, DBRANDCODE,
ISNULL(b."Model Abbrev", b."Model Descr") AS WEDGEMODEL, DMODELCODE, ISNULL("Type Abbrev", "Type Descr") AS "WEDGESIZE", DTYPECODE AS DSIZECODE
 
FROM input.wedge c
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a ON BRAND = a."Mfgr Descr"
LEFT OUTER JOIN LKP.[Model Codes and Descr] b ON MODEL = b."Model Descr"
LEFT OUTER JOIN LKP.[Type Codes and Description] ON TYPE = "Type Descr"
LEFT OUTER JOIN Player_Master.PLAYERNAMES g on c.PLAYERNAME = g.PLAYERNAME and c.SID = g.SID AND c."First Day" = g.FIRSTDAY 

WHERE "First Day" = @FIRSTDAY AND c.SID = @SID 
ORDER BY EXTRA, c.PLAYERNAME, c."PKey"


END


-- execute [Flash].[Wedges] '9/1/2011', 844

--select top 100 * from darrell_master.input.wedge where [first day] = '9/1/2011'
GO
