IF OBJECT_ID('Flash.Ball_Driver_Putter_Glove_Shoes') IS NOT NULL
    DROP PROCEDURE [Flash].[Ball_Driver_Putter_Glove_Shoes];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Flash].[Ball_Driver_Putter_Glove_Shoes]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN

select PLAYERNAME, CATEGORY, EXTRA, b.[Mfgr Descr] AS BALLBRAND, DBALLBRAND, c.[Model Descr] AS BALLMODEL, DBALLMODEL,
WOODCLUBCODE, DCLUBCODE, d.[Mfgr Descr] AS WOODBRAND, DDRIVERBRANDCODE, e.[Model Descr] AS WOODMODEL, DDRIVERMODELCODE,
	f.[Size Descr] AS WOODSIZE, DDRIVERSIZECODE, g.[Matl Descr] AS WOODMATERIAL, DMATERIAL, 
h.[Mfgr Descr] AS PUTTERBRAND, DPUTTERBRANDCODE, i.[Model Descr] AS PUTTERMODEL, DPUTTERMODELCODE, j.[Size Descr] AS PUTTERSIZE, DPUTTERSIZECODE, 
k.[Mfgr Descr] AS GLOVEBRAND, DGLOVEBRAND,
l.[Mfgr Descr] AS SHOEBRAND, DSHOEBRAND

 from Flash.ball_driver_putter_glove_shoes_func(@FIRSTDAY, @SID) a

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] b ON BALLBRAND = b.[Mfgr Code]
LEFT OUTER JOIN LKP.[Model Codes and Descr] c ON BALLMODEL = c.[Model Code] 
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] d ON WOODBRAND = d.[Mfgr Code]
LEFT OUTER JOIN LKP.[Model Codes and Descr] e ON WOODMODEL = e.[Model Code]
LEFT OUTER JOIN LKP.[Size Codes and Description] f ON WOODSIZE = f.[Size Code] 
LEFT OUTER JOIN LKP.[Material Codes and Descript] g ON WOODMATERIAL = g.[Matl Code] 
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] h ON PUTTERBRAND = h.[Mfgr Code]
LEFT OUTER JOIN LKP.[Model Codes and Descr] i ON PUTTERMODEL = i.[Model Code] 
LEFT OUTER JOIN LKP.[Size Codes and Description] j ON PUTTERSIZE = j.[Size Code] 
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] k ON GLOVEBRAND = k.[Mfgr Code]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] l ON SHOEBRAND = l.[Mfgr Code]

ORDER BY EXTRA, PLAYERNAME

END
GO
