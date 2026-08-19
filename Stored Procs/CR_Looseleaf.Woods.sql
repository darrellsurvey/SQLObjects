DROP PROCEDURE IF EXISTS [CR_Looseleaf].[Woods];
GO

CREATE PROCEDURE [CR_Looseleaf].[Woods]
	-- Add the parameters for the stored procedure here
	@FIRSTNAME varchar(50),
	@LASTNAME varchar(50),
	@LOOKUPDATE date,
	@WOODSHAFTVIS varchar(10) = 'False',
	@WOODGRIPVIS varchar(10) = 'False'

AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
	SET NOCOUNT ON;

  DECLARE @PLAYERNAME VARCHAR(65);
  IF (@LASTNAME <> '' AND @FIRSTNAME <> '')
  SET @PLAYERNAME = @LASTNAME + ', ' + @FIRSTNAME;
  ELSE
  SET @PLAYERNAME = @FIRSTNAME;

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
  SELECT TOP 1 @FIRSTDAY = "First Day", @SIDVAR = "Survey ID"
  FROM Player_Master.[Wood Detail] with (nolock)
  WHERE "Name" = @PLAYERNAME AND "First Day" < @LOOKUPDATE
  ORDER BY "First Day" DESC, [index] desc;

  SELECT TOP 1 @SHAFTFIRSTDAY = "First Day", @SHAFTSIDVAR = "Survey ID"
  FROM Player_Master.[Shaft Detail] with (nolock)
  WHERE "Name" = @PLAYERNAME AND "First Day" < @LOOKUPDATE AND [Shaft Equip Type] = 'WOOD'
  ORDER BY "First Day" DESC, [index] desc;

  SELECT TOP 1 @GRIPFIRSTDAY = "First Day", @GRIPSIDVAR = "Survey ID"
  FROM Player_Master.[Grip Detail] with (nolock)
  WHERE "Name" = @PLAYERNAME AND "First Day" < @LOOKUPDATE  AND [Grip Equip Type] = 'WOOD'
  ORDER BY "First Day" DESC, [index] desc;

  SELECT @WOODPKEY = MIN("PKey") FROM [Player_Master].[Wood Detail] with (nolock)
  WHERE "First Day" = @FIRSTDAY AND "Survey ID" = @SIDVAR AND "Name" = @PLAYERNAME;

  SET @SHAFT_PKEY_OFFSET =
  (SELECT MIN("PKey") FROM [Player_Master].[Shaft Detail] with (nolock)
  WHERE "First Day" = @SHAFTFIRSTDAY AND "Shaft Equip Type" = 'WOOD'
  AND "Survey ID" = @SHAFTSIDVAR AND "Name" = @PLAYERNAME)
  - (@WOODPKEY)
  ;

  SET @GRIP_PKEY_OFFSET =
  (@WOODPKEY) -
  (SELECT MIN("PKey") FROM [Player_Master].[Grip Detail] with (nolock)
  WHERE "First Day" = @GRIPFIRSTDAY AND "Grip Equip Type" = 'WOOD'
  AND "Survey ID" = @GRIPSIDVAR AND "Name" = @PLAYERNAME)
  ;

SELECT
[Wood Club Code] AS CLUBCODE,
COALESCE(a."Mfgr Abbrev", a."Mfgr Descr") AS BRAND,
COALESCE(b."model abbrev", b."Model Descr") AS MODEL,
COALESCE(c."Matl Abbrev", c."Matl Descr") AS MATERIAL,
COALESCE(l."Size Abbrev", l."Size Descr", '-') AS "SIZE",
[Wood Misc Code] AS MISC,
CASE WHEN @WOODSHAFTVIS = 'True' OR (@WOODSHAFTVIS = 'DriverOnly' AND ISNULL(z.ISDRIVER,0) = 1) THEN CASE WHEN COALESCE(d."Mfgr Abbrev", d."Mfgr Descr") = COALESCE(e."Mfgr Abbrev", e."Mfgr Descr") THEN '=' ELSE COALESCE(d."Mfgr Abbrev", d."Mfgr Descr") END ELSE NULL END AS SHAFTMFGR,
CASE WHEN @WOODSHAFTVIS = 'True' OR (@WOODSHAFTVIS = 'DriverOnly' AND ISNULL(z.ISDRIVER,0) = 1) THEN COALESCE(e."Mfgr Abbrev", e."Mfgr Descr") ELSE NULL END AS SHAFTBRAND,
CASE WHEN @WOODSHAFTVIS = 'True' OR (@WOODSHAFTVIS = 'DriverOnly' AND ISNULL(z.ISDRIVER,0) = 1) THEN COALESCE(f."model abbrev", f."Model Descr") ELSE NULL END AS SHAFTMODEL,
CASE WHEN @WOODSHAFTVIS = 'True' OR (@WOODSHAFTVIS = 'DriverOnly' AND ISNULL(z.ISDRIVER,0) = 1) THEN COALESCE(COALESCE(m."FLEX abbrev", m."Flex Descr"), '-') ELSE NULL END AS SHAFTFLEX,
NULL AS SHAFTTYPE,
CASE WHEN @WOODSHAFTVIS = 'True' OR (@WOODSHAFTVIS = 'DriverOnly' AND ISNULL(z.ISDRIVER,0) = 1) THEN COALESCE(g."Matl Abbrev", g."Matl Descr") ELSE NULL END AS SHAFTMATL,
CASE WHEN @WOODGRIPVIS <> 'True' THEN NULL ELSE CASE WHEN COALESCE(h."Mfgr Abbrev", h."Mfgr Descr") = COALESCE(i."Mfgr Abbrev", i."Mfgr Descr") THEN '=' ELSE COALESCE(h."Mfgr Abbrev", h."Mfgr Descr") END END AS GRIPMFGR,
CASE WHEN @WOODGRIPVIS <> 'True' THEN NULL ELSE COALESCE(i."Mfgr Abbrev", i."Mfgr Descr") END AS GRIPBRAND,
CASE WHEN @WOODGRIPVIS <> 'True' THEN NULL ELSE COALESCE(j."Model Abbrev", j."Model Descr") END AS GRIPMODEL,
NULL AS GRIPTYPE,
CASE WHEN @WOODGRIPVIS <> 'True' THEN NULL ELSE CASE WHEN COALESCE(k."Matl Abbrev", k."Matl Descr") = '(RUBB)' THEN '-' ELSE COALESCE(k."Matl Abbrev", k."Matl Descr") END END AS GRIPMATL,
'True' as isvisible, CASE WHEN @WOODSHAFTVIS = 'True' OR (@WOODSHAFTVIS = 'DriverOnly' AND ISNULL(z.ISDRIVER,0) = 1) THEN 'True' ELSE 'False' END AS shaftisvisible, @WOODGRIPVIS AS gripisvisible

FROM Player_Master.[Wood Detail] z with (nolock)
LEFT OUTER JOIN
(SELECT * FROM Player_Master.[Shaft Detail] with (nolock)
WHERE Name = @PLAYERNAME AND "FIRST DAY" = @SHAFTFIRSTDAY and [Survey ID] = @SHAFTSIDVAR AND [Shaft Equip Type] = 'WOOD') y
ON [Wood Club Code] = [Shaft Club Code] and z.Name = y.Name AND z."PKey" = y."PKey"
LEFT OUTER JOIN
(SELECT * FROM Player_Master.[Grip Detail] with (nolock)
 WHERE Name = @PLAYERNAME AND "FIRST DAY" = @GRIPFIRSTDAY and [Survey ID] = @GRIPSIDVAR AND [Grip Equip Type] = 'WOOD') x
ON [Wood Club Code] = [Grip Club Code] and z.Name = x.Name AND z."PKey" = x."PKey"

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a with (nolock) ON [Wood Brand Code] = a."Mfgr Code"
LEFT OUTER JOIN LKP.[Model Codes and Descr] b with (nolock) ON [Wood Model Code] = b."Model Code"
LEFT OUTER JOIN LKP.[Material Codes and Descript] c with (nolock) ON [Wood Mat'l Code] = c."Matl Code"
LEFT OUTER JOIN LKP.[Size Codes and Description] l with (nolock) ON [Wood Size Code] = l.[Size Code]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] d with (nolock) ON [Shaft Mfgr Code] = d."Mfgr Code"
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] e with (nolock) ON [Shaft Brand Code] = e."Mfgr Code"
LEFT OUTER JOIN LKP.[Model Codes and Descr] f with (nolock) ON [Shaft Model Code] = f."Model Code"
LEFT OUTER JOIN LKP.[Material Codes and Descript] g with (nolock) ON [Shaft Mat'l Code] = g."Matl Code"
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] h with (nolock) ON [Grip Mfgr Code] = h."Mfgr Code"
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] i with (nolock) ON [Grip Brand Code] = i."Mfgr Code"
LEFT OUTER JOIN LKP.[Model Codes and Descr] j with (nolock) ON [Grip Model Code] = j."Model Code"
LEFT OUTER JOIN LKP.[Material Codes and Descript] k with (nolock) ON [Grip Mat'l Code] = k."Matl Code"
LEFT OUTER JOIN LKP.[Flex Codes and Desc] m with (nolock) ON [Shaft Flex Code] = m.[Flex Code]

WHERE z.Name = @PLAYERNAME AND z."FIRST DAY" = @FIRSTDAY and z.[Survey ID] = @SIDVAR
ORDER BY z."PKey" ASC;

END
GO
