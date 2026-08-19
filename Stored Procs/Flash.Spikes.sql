IF OBJECT_ID('Flash.Spikes') IS NOT NULL
    DROP PROCEDURE [Flash].[Spikes];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Flash].[Spikes]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


SELECT d.PLAYERNAME, CATEGORY, EXTRA, ISNULL(a."Mfgr Abbrev", a."Mfgr Descr") AS SPIKEBRAND, DSPIKEBRAND, ISNULL(b."Model Abbrev", b."Model Descr") AS SPIKEMODEL, DSPIKEMODEL

FROM input.[All] d
LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] a ON SPIKEBRAND = a."Mfgr Descr" 
LEFT OUTER JOIN [LKP].[Model Codes and Descr] b ON SPIKEMODEL = b."Model Descr" 
LEFT OUTER JOIN Player_Master.PLAYERNAMES c on d.PLAYERNAME = c.PLAYERNAME AND c.FIRSTDAY = d.[FIRST DAY] and c.SID = d.SID

WHERE d."FIRST DAY" = @FIRSTDAY AND d.SID = @SID
ORDER BY EXTRA, d.PLAYERNAME
END
GO
