IF OBJECT_ID('Media.Ball_Driver_Putter_Glove_Shoes') IS NOT NULL
    DROP PROCEDURE [Media].[Ball_Driver_Putter_Glove_Shoes];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Media].[Ball_Driver_Putter_Glove_Shoes]
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

    WOODCLUBCODE, DWOODCLUBCODE,
    f.[Mfgr Descr] AS WOODBRAND, DWOODBRANDCODE,
    
    CASE WHEN @COMPANY = f.[Mfgr Descr] THEN g.[Model Descr] ELSE NULL END AS WOODMODEL, DWOODMODELCODE,
    CASE WHEN @COMPANY = f.[Mfgr Descr] THEN h.[Size Descr] ELSE NULL END AS WOODSIZE, DWOODSIZECODE,
    CASE WHEN @COMPANY = f.[Mfgr Descr] THEN i.[Matl Descr] ELSE NULL END AS WOODMATL, DMATERIAL,
    
    j.[Mfgr Descr] AS PUTTERBRAND, DPUTTERBRANDCODE,
    
    CASE WHEN @COMPANY = j.[Mfgr Descr] THEN k.[Model Descr] ELSE NULL END AS PUTTERMODEL, DPUTTERMODELCODE,
    CASE WHEN @COMPANY = j.[Mfgr Descr] THEN l.[Size Descr] ELSE NULL END AS PUTTERSIZE, DPUTTERSIZECODE,
    
    m.[Mfgr Descr] AS GLOVEBRAND,
    n.[Mfgr Descr] AS SHOESBRAND
    
    FROM CR_Reports.all_equipment_func(@FIRSTDAY, @SID) a
    LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] b ON a.BALLBRAND = b.[Mfgr Code]
    LEFT OUTER JOIN LKP.[Model Codes and Descr] c ON a.BALLMODEL = c.[Model Code]
    
    LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] f ON a.WOODBRAND = f.[Mfgr Code]
    LEFT OUTER JOIN LKP.[Model Codes and Descr] g ON a.WOODMODEL = g.[Model Code]
    LEFT OUTER JOIN LKP.[Size Codes and Description] h ON a.WOODSIZE = h.[Size Code]
    LEFT OUTER JOIN LKP.[Material Codes and Descript] i ON a.WOODMATL = i.[Matl Code]
    
    LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] j ON a.PUTTERBRAND = j.[Mfgr Code]
    LEFT OUTER JOIN LKP.[Model Codes and Descr] k ON a.PUTTERMODEL = k.[Model Code]
    LEFT OUTER JOIN LKP.[Size Codes and Description] l ON a.PUTTERSIZE = l.[Size Code]
    
    LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] m ON a.GLOVEBRAND = m.[Mfgr Code] 
    LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] n ON a.SHOESBRAND = n.[Mfgr Code] 
    
    ORDER BY ROW_ORDER ASC
    
	
	--  SELECT * FROM CR_Reports.ball_driver_putter_glove_shoes_func('7/21/2011', 678) 
	
	
END
GO
