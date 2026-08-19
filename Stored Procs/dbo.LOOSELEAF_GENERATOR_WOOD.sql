IF OBJECT_ID('dbo.LOOSELEAF_GENERATOR_WOOD') IS NOT NULL
    DROP PROCEDURE [dbo].[LOOSELEAF_GENERATOR_WOOD];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[LOOSELEAF_GENERATOR_WOOD]
	-- Add the parameters for the stored procedure here
	@PLAYERNAME varchar(50),
	@LOOKUPDATE date
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE @FIRSTDAY DATE;
DECLARE @SHAFTFIRSTDAY DATE;
DECLARE @GRIPFIRSTDAY DATE;
DECLARE @WOODPKEY INT;
DECLARE @SHAFT_PKEY_OFFSET INT;
DECLARE @GRIP_PKEY_OFFSET INT;
DECLARE @SIDVAR INTEGER;
DECLARE @SHAFTSIDVAR INTEGER;
DECLARE @GRIPSIDVAR INTEGER;

	   --selects the proper first day and SID for the player based on if there's an input date
     SELECT TOP 1 @FIRSTDAY = [First Day], @SIDVAR = [Survey ID]
     FROM Player_Master.[Wood Detail]
     WHERE [Name] = @PLAYERNAME AND [First Day] < @LOOKUPDATE
     ORDER BY [First Day] DESC;

     SELECT TOP 1 @SHAFTFIRSTDAY = [First Day], @SHAFTSIDVAR = [Survey ID]
     FROM Player_Master.[Shaft Detail]
     WHERE [Name] = @PLAYERNAME AND [First Day] < @LOOKUPDATE AND [Shaft Equip Type] = 'WOOD'
     ORDER BY [First Day] DESC;
     
     SELECT TOP 1 @GRIPFIRSTDAY = [First Day], @GRIPSIDVAR = [Survey ID]
     FROM Player_Master.[Grip Detail]
     WHERE [Name] = @PLAYERNAME AND [First Day] < @LOOKUPDATE  AND [Grip Equip Type] = 'WOOD'
     ORDER BY [First Day] DESC;



SELECT @WOODPKEY = MIN([PKey]) FROM [Player_Master].[Wood Detail] WHERE [First Day] = @FIRSTDAY AND [Survey ID] = @SIDVAR AND [Name] = @PLAYERNAME;

SET @SHAFT_PKEY_OFFSET = 
(SELECT MIN([PKey]) FROM [Player_Master].[Shaft Detail] WHERE [First Day] = @SHAFTFIRSTDAY AND [Shaft Equip Type] = 'WOOD' AND [Survey ID] = @SHAFTSIDVAR AND [Name] = @PLAYERNAME)
-
(@WOODPKEY);

SET @GRIP_PKEY_OFFSET = 
(@WOODPKEY) - 
(SELECT MIN([PKey]) FROM [Player_Master].[Grip Detail] WHERE [First Day] = @GRIPFIRSTDAY AND [Grip Equip Type] = 'WOOD' AND [Survey ID] = @GRIPSIDVAR AND [Name] = @PLAYERNAME)
;

--PRINT @GRIP_PKEY_OFFSET;

--SELECT @SHAFT_PKEY_OFFSET = MIN([PKey]) FROM [Player_Master].[Shaft Detail] WHERE [First Day] = @FIRSTDAY AND [Shaft Equip Type] = 'WOOD' AND [Survey ID] = @SIDVAR AND [Name] = @PLAYERNAME;
--SELECT @GRIP_PKEY_OFFSET = MIN([PKey]) FROM [Player_Master].[Grip Detail] WHERE [First Day] = @FIRSTDAY AND [Grip Equip Type] = 'WOOD' AND [Survey ID] = @SIDVAR AND [Name] = @PLAYERNAME;


SELECT
  [Wood Club Code], z.[Mfgr Descr], d.[Model Descr], y.[Matl Descr], ISNULL(m.[Size Descr], '-'), [Wood Misc Code],
  e.[Mfgr Descr], f.[Mfgr Descr], g.[Model Descr], [Shaft Type Code], h.[Matl Descr],
  i.[Mfgr Descr], j.[Mfgr Descr], k.[Model Descr], [Grip Type Code], l.[Matl Descr],
  COALESCE(n.[Flex Descr], '-'), ISDRIVER
  FROM [Player_Master].[Wood Detail] a
LEFT OUTER JOIN (
SELECT * FROM [Player_Master].[Shaft Detail]
WHERE [Survey ID] = @SHAFTSIDVAR AND [First Day] = @SHAFTFIRSTDAY AND [Shaft Equip Type] = 'WOOD' AND [Name] = @PLAYERNAME
) b
ON (b.[PKey] - @SHAFT_PKEY_OFFSET) = a.[PKey]
LEFT OUTER JOIN (
SELECT * FROM [Player_Master].[Grip Detail]
WHERE [Survey ID] = @GRIPSIDVAR AND [First Day] = @GRIPFIRSTDAY AND [Grip Equip Type] = 'WOOD' AND [Name] = @PLAYERNAME
) c
ON (a.[PKey] - @GRIP_PKEY_OFFSET) = c.[PKey]

  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] z ON z.[Mfgr Code] = [Wood Brand Code]
  LEFT OUTER JOIN LKP.[Model Codes and Descr] d ON d.[Model Code] = [Wood Model Code]
  LEFT OUTER JOIN LKP.[Material Codes and Descript] y ON y.[Matl Code] = [Wood Mat'l Code]
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] e ON e.[Mfgr Code] = [Shaft Mfgr Code]
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] f ON f.[Mfgr Code] = [Shaft Brand Code]
  LEFT OUTER JOIN LKP.[Model Codes and Descr] g ON g.[Model Code] = [Shaft Model Code]
  LEFT OUTER JOIN LKP.[Material Codes and Descript] h ON h.[Matl Code] = [Shaft Mat'l Code]
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] i ON i.[Mfgr Code] = [Grip Mfgr Code]
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] j ON j.[Mfgr Code] = [Grip Brand Code]
  LEFT OUTER JOIN LKP.[Model Codes and Descr] k ON k.[Model Code] = [Grip Model Code]
  LEFT OUTER JOIN LKP.[Material Codes and Descript] l ON l.[Matl Code] = [Grip Mat'l Code]
  LEFT OUTER JOIN LKP.[Size Codes and Description] m ON m.[Size Code] = [Wood Size Code]
  LEFT OUTER JOIN LKP.[Flex Codes and Desc] n ON n.[Flex Code] = [Shaft Flex Code]

WHERE a.[Name] = @PLAYERNAME AND a.[First Day] = @FIRSTDAY
ORDER BY a.[Name], a.[PKey]

END
GO
