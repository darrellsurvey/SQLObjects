IF OBJECT_ID('dbo.LOOSELEAF_GENERATOR_PUTTER') IS NOT NULL
    DROP PROCEDURE [dbo].[LOOSELEAF_GENERATOR_PUTTER];
GO

CREATE PROCEDURE [dbo].[LOOSELEAF_GENERATOR_PUTTER]
	-- Add the parameters for the stored procedure here
	@PLAYERNAME varchar(50),
	@LOOKUPDATE date
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE @FIRSTDAY DATE;
DECLARE @FIRSTDAYGRIPS DATE;
DECLARE @SIDVAR INTEGER;
DECLARE @SIDGRIPS INTEGER;


   --selects the proper first day for the player based on if there's an input date
     SELECT TOP 1 @FIRSTDAY = "First Day"
     FROM Player_Master.[Putter Detail]
     WHERE "Name" = @PLAYERNAME AND "First Day" < @LOOKUPDATE
     ORDER BY "First Day" DESC;

     SELECT TOP 1 @FIRSTDAYGRIPS = "First Day"
     FROM Player_Master.[Grip Detail]
     WHERE "Grip Equip Type" = 'PUTT' AND "Name" = @PLAYERNAME AND "First Day" < @LOOKUPDATE
     ORDER BY "First Day" DESC;


    -- Insert statements for procedure here
	--SELECT * FROM Player_Master.[Iron Detail] WHERE [First Day] < @LOOKUPDATE AND Name = @PLAYERNAME



--master select statement
--still runs joins on shafts, just lets it return nulls if shafts were not being surveyed for that tournament
  SELECT "Putter Sequence No", c."Mfgr Descr", d."Model Descr", ISNULL(m."Type Descr", '-'), ISNULL(n."Size Descr", '-'), ISNULL(o."Matl Descr", '-'),
  --blanks for shafts
  '','','','','',
  i."Mfgr Descr", j."Mfgr Descr", k."Model Descr", "Grip Type Code", l."Matl Descr"
  FROM Player_Master.[Putter Detail] a
  LEFT OUTER JOIN (SELECT * FROM Player_Master.[Grip Detail] where "Name" = @PLAYERNAME AND "First Day" = @FIRSTDAYGRIPS
  AND "Grip Equip Type" = 'PUTT') z
  ON a."PKey" = z."PKey"
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] c ON c."Mfgr Code" = "Putter Brand Code"
  LEFT OUTER JOIN LKP.[Model Codes and Descr] d ON d."Model Code" = "Putter Model Code"
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] i ON i."Mfgr Code" = "Grip Mfgr Code"
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] j ON j."Mfgr Code" = "Grip Brand Code"
  LEFT OUTER JOIN LKP.[Model Codes and Descr] k ON k."Model Code" = "Grip Model Code"
  LEFT OUTER JOIN LKP.[Material Codes and Descript] l ON l."Matl Code" = "Grip Mat'l Code"
  LEFT OUTER JOIN LKP.[Type Codes and Description] m ON m."Type Code" = "Putter Type Code"
  LEFT OUTER JOIN LKP.[Size Codes and Description] n ON n."Size Code" = "Putter Size Code"
  LEFT OUTER JOIN LKP.[Material Codes and Descript] o ON o."Matl Code" = "Putter Mat'l Code"
  WHERE a."Name" = @PLAYERNAME AND a."First Day" = @FIRSTDAY
  GROUP BY a."PKey", "Putter Sequence No", c."Mfgr Descr", d."Model Descr", m."Type Descr", o."Matl Descr", n."Size Descr",
  i."Mfgr Descr", j."Mfgr Descr", k."Model Descr", "Grip Type Code", l."Matl Descr"
  ORDER BY a."PKey" ASC


END
GO
