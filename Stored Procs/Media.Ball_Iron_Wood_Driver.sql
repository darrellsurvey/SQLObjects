DROP PROCEDURE IF EXISTS [Media].[Ball_Iron_Wood_Driver];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Media].[Ball_Iron_Wood_Driver]
	-- Add the parameters for the stored procedure here
		@FIRSTDAY date,
		@SID int,
		@COMPANY varchar(50)


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT PLAYERNAME, 
    CATEGORY,
    EXTRA,
    b.[Mfgr Descr] AS BALLBRAND, DBALLBRAND,
    CASE WHEN @COMPANY = b.[Mfgr Descr] THEN c.[Model Descr] ELSE NULL END AS BALLMODEL, DBALLMODEL,
    --CASE WHEN @COMPANY = d.[Mfgr Descr] THEN IRONCLUBCODE ELSE NULL END AS IRONCLUBCODE,
    IRONCLUBCODE, DIRONCLUBCODE,
    d.[Mfgr Descr] AS IRONBRAND, DIRONBRANDCODE,
    CASE WHEN @COMPANY = d.[Mfgr Descr] THEN e.[Model Descr] ELSE NULL END AS IRONMODEL, DIRONMODELCODE,
    WOODCLUBCODE, DWOODCLUBCODE,
    f.[Mfgr Descr] AS WOODBRAND, DWOODBRANDCODE,
    CASE WHEN @COMPANY = f.[Mfgr Descr] THEN g.[Model Descr] ELSE NULL END AS WOODMODEL, DWOODMODELCODE,
    CASE WHEN @COMPANY = f.[Mfgr Descr] THEN h.[Size Descr] ELSE NULL END AS WOODSIZE, DSIZECODE,
    CASE WHEN @COMPANY = f.[Mfgr Descr] THEN i.[Matl Descr] ELSE NULL END AS WOODMATL, DMATERIAL
    FROM CR_Reports.ball_iron_wood_driver_func(@FIRSTDAY, @SID) a
    LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] b ON a.BALLBRAND = b.[Mfgr Code]
    LEFT OUTER JOIN LKP.[Model Codes and Descr] c ON a.BALLMODEL = c.[Model Code]
    
    LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] d ON a.IRONBRAND = d.[Mfgr Code]
    LEFT OUTER JOIN LKP.[Model Codes and Descr] e ON a.IRONMODEL = e.[Model Code]
    
    LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] f ON a.WOODBRAND = f.[Mfgr Code]
    LEFT OUTER JOIN LKP.[Model Codes and Descr] g ON a.WOODMODEL = g.[Model Code]
    LEFT OUTER JOIN LKP.[Size Codes and Description] h ON a.WOODSIZE = h.[Size Code]
    LEFT OUTER JOIN LKP.[Material Codes and Descript] i ON a.WOODMATL = i.[Matl Code]
    
    ORDER BY ROW_ORDER ASC
    
	
	
END
GO
