DROP PROCEDURE IF EXISTS [dbo].[Get_all_input_descrs];
GO

CREATE PROCEDURE [dbo].[Get_all_input_descrs]
	@Description as varchar(50)
AS
BEGIN
    SET NOCOUNT ON;

SELECT a.DESCR, "TABLE", C FROM (

SELECT UPPER("Mfgr Descr") AS DESCR, 'LKP.[Manufacturer Codes and Desc]' AS "TABLE", 'Mfgr Descr' AS C, '' as L1, '' as L2, '' as L3  FROM LKP.[Manufacturer Codes and Desc]
UNION ALL
SELECT UPPER("Matl Descr") AS DESCR, 'LKP.[Material Codes and Descript]' AS "TABLE", 'Matl Descr' AS C, '' as L1, '' as L2, '' as L3 FROM LKP.[Material Codes and Descript]
UNION ALL
SELECT UPPER("Model Descr") AS DESCR, 'LKP.[Brand/Model Codes with Equip]' AS "TABLE", 'Model Descr' AS C, [Model Lvl1] as L1, [Model Lvl2] as L2, [Model Lvl3] as L3 FROM LKP.[Model Codes and Descr]
UNION ALL
SELECT UPPER("Type Descr") AS DESCR, 'LKP.[Type Codes and Description]' AS "TABLE", 'Type Descr' AS C, '' as L1, '' as L2, '' as L3 FROM LKP.[Type Codes and Description]
UNION ALL
SELECT UPPER("Size Descr") AS DESCR, 'LKP.[Size Codes and Description]' AS "TABLE", 'Size Descr' AS C, '' as L1, '' as L2, '' as L3 FROM LKP.[Size Codes and Description]

) a
WHERE a.DESCR = @Description

END
GO
