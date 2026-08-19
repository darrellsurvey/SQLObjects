IF OBJECT_ID('Flash.Shoes_Spikes') IS NOT NULL
    DROP PROCEDURE [Flash].[Shoes_Spikes];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Flash].[Shoes_Spikes]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT b.PLAYERNAME, CATEGORY, EXTRA,
	COALESCE(d."Mfgr Abbrev", d."Mfgr Descr") AS SHOEBRAND, DSHOEBRAND,
	COALESCE(e."Mfgr Abbrev", e."Mfgr Descr") AS SPIKEBRAND, DSPIKEBRAND,
	COALESCE(f."Model Abbrev", f."Model Descr") AS SPIKEMODEL, DSPIKEMODEL

FROM (SELECT * FROM Input.[All] WHERE "FIRST DAY" = @FIRSTDAY AND [SID] = @SID )  b
-- all items
LEFT OUTER JOIN Player_Master.PLAYERNAMES c on b.PLAYERNAME = c.PLAYERNAME AND c.FIRSTDAY = b.[FIRST DAY] and c.SID = b.SID 
LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] d ON SHOEBRAND = d."Mfgr Descr"  
LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] e ON SPIKEBRAND = e."Mfgr Descr"  
LEFT OUTER JOIN [LKP].[Model Codes and Descr] f ON SPIKEMODEL = f."Model Descr"  


ORDER BY EXTRA, b.PLAYERNAME ASC

END
GO
