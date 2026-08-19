IF OBJECT_ID('dbo.LOOSELEAF_GENERATOR_WEDGE') IS NOT NULL
    DROP PROCEDURE [dbo].[LOOSELEAF_GENERATOR_WEDGE];
GO

CREATE PROCEDURE [dbo].[LOOSELEAF_GENERATOR_WEDGE]
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
DECLARE @SHAFTCOUNT INTEGER;
DECLARE @GRIPCOUNT INTEGER;

   --selects the proper first day for the player based on if there's an input date
     SELECT TOP 1 @FIRSTDAY = "First Day", @SIDVAR = [Survey ID]
     FROM Player_Master.[Wedge Detail]
     WHERE "Name" = @PLAYERNAME AND "First Day" < @LOOKUPDATE
     ORDER BY "First Day" DESC;

     SELECT TOP 1 @FIRSTDAYSHAFTS = "First Day", @SIDSHAFTS = [Survey ID]
     FROM Player_Master.[Shaft Detail]
     WHERE "Shaft Equip Type" = 'WEDG' AND "Name" = @PLAYERNAME AND "First Day" < @LOOKUPDATE
     ORDER BY "First Day" DESC;

     SELECT TOP 1 @FIRSTDAYGRIPS = "First Day", @SIDGRIPS = [Survey ID]
     FROM Player_Master.[Grip Detail]
     WHERE "Grip Equip Type" = 'WEDG' AND "Name" = @PLAYERNAME AND "First Day" < @LOOKUPDATE
     ORDER BY "First Day" DESC;

     --checks to see if the player has any shafts listed, and runs a simpler (and faster) query if not
     SELECT @SHAFTCOUNT = COUNT(*) FROM Player_Master.[Shaft Detail] WHERE "Name" = @PLAYERNAME AND "Shaft Equip Type" = 'WEDG';
     SELECT @GRIPCOUNT = COUNT(*) FROM Player_Master.[Grip Detail] WHERE "Name" = @PLAYERNAME AND "Grip Equip Type" = 'WEDG';


    -- Insert statements for procedure here
	--SELECT * FROM Player_Master.[Iron Detail] WHERE [First Day] < @LOOKUPDATE AND Name = @PLAYERNAME


IF (@SHAFTCOUNT > 0 OR @GRIPCOUNT > 0)
--master select statement
--still runs joins on shafts, just lets it return nulls if shafts were not being surveyed for that tournament
  SELECT "Wedge Club Code", c."Mfgr Descr", d."Model Descr", ISNULL(m."Type Descr", '-'), ISNULL(n."Matl Descr", '-'), ISNULL(o."Size Descr", '-'),
  e."Mfgr Descr", f."Mfgr Descr", g."Model Descr", "Shaft Type Code", h."Matl Descr",
  i."Mfgr Descr", j."Mfgr Descr", k."Model Descr", "Grip Type Code", l."Matl Descr",
  COALESCE(p."Flex Descr", '-')
     FROM Player_Master.[Wedge Detail] a
  LEFT OUTER JOIN (SELECT * FROM Player_Master.[Shaft Detail] where "Name" = @PLAYERNAME AND "First Day" = @FIRSTDAYSHAFTS and [Survey ID] = @SIDSHAFTS
  AND "Shaft Equip Type" = 'WEDG') b
  ON a."PKey" = b."PKey"
  LEFT OUTER JOIN (SELECT * FROM Player_Master.[Grip Detail] where "Name" = @PLAYERNAME AND "First Day" = @FIRSTDAYGRIPS and [Survey ID] = @SIDGRIPS
  AND "Grip Equip Type" = 'WEDG') z
  ON a."PKey" = z."PKey"
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] c ON c."Mfgr Code" = "Wedge Brand Code"
  LEFT OUTER JOIN LKP.[Model Codes and Descr] d ON d."Model Code" = "Wedge Model Code"
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] e ON e."Mfgr Code" = "Shaft Mfgr Code"
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] f ON f."Mfgr Code" = "Shaft Brand Code"
  LEFT OUTER JOIN LKP.[Model Codes and Descr] g ON g."Model Code" = "Shaft Model Code"
  LEFT OUTER JOIN LKP.[Material Codes and Descript] h ON h."Matl Code" = "Shaft Mat'l Code"
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] i ON i."Mfgr Code" = "Grip Mfgr Code"
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] j ON j."Mfgr Code" = "Grip Brand Code"
  LEFT OUTER JOIN LKP.[Model Codes and Descr] k ON k."Model Code" = "Grip Model Code"
  LEFT OUTER JOIN LKP.[Material Codes and Descript] l ON l."Matl Code" = "Grip Mat'l Code"
  LEFT OUTER JOIN LKP.[Type Codes and Description] m ON m."Type Code" = "Wedge Type Code"
  LEFT OUTER JOIN LKP.[Material Codes and Descript] n ON n."Matl Code" = "Wedge Mat'l Code"
  LEFT OUTER JOIN LKP.[Size Codes and Description] o ON o."Size Code" = "Wedge Size Code"
  LEFT OUTER JOIN LKP.[Flex Codes and Desc] p ON p."Flex Code" = "Shaft Flex Code"
  WHERE a."Name" = @PLAYERNAME AND a."First Day" = @FIRSTDAY and a.[Survey ID] = @SIDVAR
  GROUP BY a."PKey", "Wedge Club Code", c."Mfgr Descr", d."Model Descr", m."Type Descr", n."Matl Descr", o."Size Descr",
  e."Mfgr Descr", f."Mfgr Descr", g."Model Descr", "Shaft Type Code", h."Matl Descr",
  i."Mfgr Descr", j."Mfgr Descr", k."Model Descr", "Grip Type Code", l."Matl Descr",
  COALESCE(p."Flex Descr", '-')
  ORDER BY a."PKey" ASC

ELSE

--master select statement
--still runs joins on shafts, just lets it return nulls if shafts were not being surveyed for that tournament
  SELECT "Wedge Club Code", c."Mfgr Descr", d."Model Descr", ISNULL("Type Descr", '-'), ISNULL("Wedge Mat'l Code", '-'), ISNULL("Wedge Size Code", '-'),
  '', '', '', '', '',
  '', '', '', '', ''
     FROM Player_Master.[Wedge Detail] a
  LEFT OUTER JOIN (SELECT * FROM Player_Master.[Shaft Detail] where "Name" = @PLAYERNAME AND "First Day" = @FIRSTDAYSHAFTS
  AND "Shaft Equip Type" = 'WEDG') b
  ON a."PKey" = b."PKey"
  LEFT OUTER JOIN (SELECT * FROM Player_Master.[Grip Detail] where "Name" = @PLAYERNAME AND "First Day" = @FIRSTDAYGRIPS
  AND "Grip Equip Type" = 'WEDG') z
  ON a."PKey" = z."PKey"
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] c ON c."Mfgr Code" = "Wedge Brand Code"
  LEFT OUTER JOIN LKP.[Model Codes and Descr] d ON d."Model Code" = "Wedge Model Code"
  LEFT OUTER JOIN LKP.[Type Codes and Description] ON [Wedge Type Code] = "type code"
  WHERE a."Name" = @PLAYERNAME AND a."First Day" = @FIRSTDAY
  GROUP BY a."PKey", "Wedge Club Code", c."Mfgr Descr", d."Model Descr", [Type Descr], "Wedge Mat'l Code", "Wedge Size Code"
  ORDER BY a."PKey" ASC
END
GO
