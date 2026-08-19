IF OBJECT_ID('dbo.LOOSELEAF_GENERATOR_IRON') IS NOT NULL
    DROP PROCEDURE [dbo].[LOOSELEAF_GENERATOR_IRON];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[LOOSELEAF_GENERATOR_IRON]
	-- Add the parameters for the stored procedure here
	@PLAYERNAME varchar(50),
	@LOOKUPDATE date
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE @FIRSTDAY DATE;
DECLARE @FIRSTDAYSHAFTS DATE;
DECLARE @FIRSTDAYGRIPS DATE;
DECLARE @SIDVAR INTEGER;
DECLARE @SIDSHAFTS INTEGER;
DECLARE @SIDGRIPS INTEGER;
DECLARE @IRONSHAFTCOUNT INTEGER;
DECLARE @IRONGRIPCOUNT INTEGER;

   --selects the proper first day for the player based on if there's an input date
     SELECT TOP 1 @FIRSTDAY = [First Day]
     FROM Player_Master.[Iron Detail]
     WHERE [Name] = @PLAYERNAME AND [First Day] < @LOOKUPDATE
     ORDER BY [First Day] DESC;
     
     SELECT TOP 1 @FIRSTDAYSHAFTS = [First Day]
     FROM Player_Master.[Shaft Detail]
     WHERE [Shaft Equip Type] = 'IRON' AND [Name] = @PLAYERNAME AND [First Day] < @LOOKUPDATE
     ORDER BY [First Day] DESC;
     
     SELECT TOP 1 @FIRSTDAYGRIPS = [First Day]
     FROM Player_Master.[Grip Detail]
     WHERE [Grip Equip Type] = 'IRON' AND [Name] = @PLAYERNAME AND [First Day] < @LOOKUPDATE
     ORDER BY [First Day] DESC;
     
     --checks to see if the player has any shafts listed, and runs a simpler (and faster) query if not
     SELECT @IRONSHAFTCOUNT = COUNT(*) FROM Player_Master.[Shaft Detail] WHERE [Name] = @PLAYERNAME AND [Shaft Equip Type] = 'IRON';
     SELECT @IRONGRIPCOUNT = COUNT(*) FROM Player_Master.[Grip Detail] WHERE [Name] = @PLAYERNAME AND [Grip Equip Type] = 'IRON';


    -- Insert statements for procedure here
	--SELECT * FROM Player_Master.[Iron Detail] WHERE [First Day] < @LOOKUPDATE AND Name = @PLAYERNAME
	
	
IF (@IRONSHAFTCOUNT > 0 OR @IRONGRIPCOUNT > 0)
--master select statement
--still runs joins on shafts, just lets it return nulls if shafts were not being surveyed for that tournament
  SELECT [Iron Club Code], c.[Mfgr Descr], d.[Model Descr], [Iron Type Code], [Iron Mat'l Code], [Iron Size Code],
  e.[Mfgr Descr], f.[Mfgr Descr], g.[Model Descr], [Shaft Type Code], h.[Matl Descr],
  i.[Mfgr Descr], j.[Mfgr Descr], k.[Model Descr], [Grip Type Code], l.[Matl Descr],
  COALESCE(m.[Flex Descr], '-') AS shaftflex
  
  FROM Player_Master.[Iron Detail] a
  LEFT OUTER JOIN (SELECT * FROM Player_Master.[Shaft Detail] where [Name] = @PLAYERNAME AND [First Day] = @FIRSTDAYSHAFTS 
  AND [Shaft Equip Type] = 'IRON') b
  ON [Iron Club Code] = [Shaft Club Code] and a.PKey = b.PKey
  LEFT OUTER JOIN (SELECT * FROM Player_Master.[Grip Detail] where [Name] = @PLAYERNAME AND [First Day] = @FIRSTDAYGRIPS
  AND [Grip Equip Type] = 'IRON') z
  ON [Iron Club Code] = [Grip Club Code] and a.PKey = z.PKey
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] c ON c.[Mfgr Code] = [Iron Brand Code]
  LEFT OUTER JOIN LKP.[Model Codes and Descr] d ON d.[Model Code] = [Iron Model Code]
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] e ON e.[Mfgr Code] = [Shaft Mfgr Code]
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] f ON f.[Mfgr Code] = [Shaft Brand Code]
  LEFT OUTER JOIN LKP.[Model Codes and Descr] g ON g.[Model Code] = [Shaft Model Code]
  LEFT OUTER JOIN LKP.[Material Codes and Descript] h ON h.[Matl Code] = [Shaft Mat'l Code]
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] i ON i.[Mfgr Code] = [Grip Mfgr Code]
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] j ON j.[Mfgr Code] = [Grip Brand Code]
  LEFT OUTER JOIN LKP.[Model Codes and Descr] k ON k.[Model Code] = [Grip Model Code]
  LEFT OUTER JOIN LKP.[Material Codes and Descript] l ON l.[Matl Code] = [Grip Mat'l Code]
  LEFT OUTER JOIN LKP.[Flex Codes and Desc] m ON m.[Flex Code] = [Shaft Flex Code]
  WHERE a.[Name] = @PLAYERNAME AND a.[First Day] = @FIRSTDAY
  GROUP BY a.[PKey], [Iron Club Code], c.[Mfgr Descr], d.[Model Descr], [Iron Type Code], [Iron Mat'l Code], [Iron Size Code],
  e.[Mfgr Descr], f.[Mfgr Descr], g.[Model Descr], [Shaft Type Code], h.[Matl Descr], 
  i.[Mfgr Descr], j.[Mfgr Descr], k.[Model Descr], [Grip Type Code], l.[Matl Descr],
  COALESCE(m.[Flex Descr], '-')
  ORDER BY a.[PKey] ASC

ELSE

--master select statement
--still runs joins on shafts, just lets it return nulls if shafts were not being surveyed for that tournament
  SELECT [Iron Club Code], c.[Mfgr Descr], d.[Model Descr], [Iron Type Code], [Iron Mat'l Code], [Iron Size Code],
  '', '', '', '', '',
  '', '', '', '', ''
  FROM Player_Master.[Iron Detail] a
  LEFT OUTER JOIN (SELECT * FROM Player_Master.[Shaft Detail] where [Name] = @PLAYERNAME AND [First Day] = @FIRSTDAYSHAFTS
  AND [Shaft Equip Type] = 'IRON') b
  ON [Iron Club Code] = [Shaft Club Code]
  LEFT OUTER JOIN (SELECT * FROM Player_Master.[Grip Detail] where [Name] = @PLAYERNAME AND [First Day] = @FIRSTDAYGRIPS
  AND [Grip Equip Type] = 'IRON') z
  ON [Iron Club Code] = [Grip Club Code]
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] c ON c.[Mfgr Code] = [Iron Brand Code]
  LEFT OUTER JOIN LKP.[Model Codes and Descr] d ON d.[Model Code] = [Iron Model Code]
  WHERE a.[Name] = @PLAYERNAME AND a.[First Day] = @FIRSTDAY
  GROUP BY a.[PKey], [Iron Club Code], c.[Mfgr Descr], d.[Model Descr], [Iron Type Code], [Iron Mat'l Code], [Iron Size Code]
  ORDER BY a.[PKey] ASC
END
GO
