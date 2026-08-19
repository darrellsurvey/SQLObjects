IF OBJECT_ID('CR_Reports.Shoes_Spikes') IS NOT NULL
    DROP PROCEDURE [CR_Reports].[Shoes_Spikes];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CR_Reports].[Shoes_Spikes]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT b.PLAYERNAME, CATEGORY, EXTRA,
	COALESCE(d.[Mfgr Abbrev], d.[Mfgr Descr]) AS SHOEBRAND, DSHOEBRAND,
	COALESCE(e.[Mfgr Abbrev], e.[Mfgr Descr]) AS SPIKEBRAND, DSPIKEBRAND,
	COALESCE(f.[Model Abbrev], f.[Model Descr]) AS SPIKEMODEL, DSPIKEMODEL

FROM (SELECT * FROM Player_Master.[All] WHERE [FIRST DAY] = @FIRSTDAY AND [SID] = @SID )  b
-- all items
LEFT OUTER JOIN Player_Master.PLAYERNAMES c on b.PLAYERNAME = c.PLAYERNAME AND c.FIRSTDAY = b.[FIRST DAY] and c.SID = b.SID 
LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] d ON SHOEBRAND = d.[Mfgr Code]  
LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] e ON SPIKEBRAND = e.[Mfgr Code]  
LEFT OUTER JOIN [LKP].[Model Codes and Descr] f ON SPIKEMODEL = f.[Model Code]  


ORDER BY EXTRA, b.PLAYERNAME ASC

END
GO
