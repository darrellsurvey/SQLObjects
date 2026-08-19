DROP PROCEDURE IF EXISTS [CR_Looseleaf].[Wedges];
GO

CREATE PROCEDURE [CR_Looseleaf].[Wedges]
	@FIRSTNAME varchar(50),
	@LASTNAME varchar(50),
	@LOOKUPDATE date,
	@WEDGESHAFTVIS varchar(10) = 'False',
	@WEDGEGRIPVIS varchar(10) = 'False'
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
  DECLARE @FIRSTDAYSHAFTS DATE;
  DECLARE @FIRSTDAYGRIPS DATE;
  DECLARE @SIDVAR INTEGER;
  DECLARE @SIDSHAFTS INTEGER;
  DECLARE @SIDGRIPS INTEGER;
  DECLARE @SHAFTCOUNT INTEGER;


  --selects the proper first day for the player based on if there's an input date
  SELECT TOP 1 @FIRSTDAY = "First Day", @SIDVAR = [Survey ID]
  FROM Player_Master.[Wedge Detail]
  WHERE "Name" = @PLAYERNAME AND "First Day" < @LOOKUPDATE
  ORDER BY "First Day" DESC, [index] desc;

  SELECT TOP 1 @FIRSTDAYSHAFTS = "First Day", @SIDSHAFTS = [Survey ID]
  FROM Player_Master.[Shaft Detail] with (nolock)
  WHERE "Shaft Equip Type" = 'WEDG' AND "Name" = @PLAYERNAME AND "First Day" < @LOOKUPDATE
  ORDER BY "First Day" DESC, [index] desc;

  SELECT TOP 1 @FIRSTDAYGRIPS = "First Day", @SIDGRIPS = [Survey ID]
  FROM Player_Master.[Grip Detail] with (nolock)
  WHERE "Grip Equip Type" = 'WEDG' AND "Name" = @PLAYERNAME AND "First Day" < @LOOKUPDATE
  ORDER BY "First Day" DESC, [index] desc;

  --checks to see if the player has any shafts listed, and runs a simpler (and faster) query if not
  SELECT @SHAFTCOUNT = COUNT(*) FROM Player_Master.[Shaft Detail] WHERE "Name" = @PLAYERNAME AND "Shaft Equip Type" = 'WEDG';

SELECT
[Wedge Club Code] AS CLUBCODE,
COALESCE(a."Mfgr Abbrev", a."Mfgr Descr") AS BRAND,
COALESCE(b."model abbrev", b."Model Descr") AS MODEL,
COALESCE(COALESCE(c."Matl Abbrev", c."Matl Descr"), '-') AS MATERIAL,
COALESCE(l."Type abbrev", l."Type Descr", '-') AS "TYPE",
[Wedge Size Code] AS SIZE,
z.[Wedge Misc Code] AS MISC,
CASE WHEN @WEDGESHAFTVIS <> 'True' THEN NULL ELSE CASE WHEN COALESCE(d."Mfgr Abbrev", d."Mfgr Descr") = COALESCE(e."Mfgr Abbrev", e."Mfgr Descr") THEN '=' ELSE COALESCE(d."Mfgr Abbrev", d."Mfgr Descr") END END AS SHAFTMFGR,
CASE WHEN @WEDGESHAFTVIS <> 'True' THEN NULL ELSE COALESCE(e."Mfgr Abbrev", e."Mfgr Descr") END AS SHAFTBRAND,
CASE WHEN @WEDGESHAFTVIS <> 'True' THEN NULL ELSE COALESCE(f."model abbrev", f."Model Descr") END AS SHAFTMODEL,
CASE WHEN @WEDGESHAFTVIS <> 'True' THEN NULL ELSE COALESCE(COALESCE(m."Flex abbrev", m."Flex Descr"), '-') END AS SHAFTFLEX,
NULL AS SHAFTTYPE,
CASE WHEN @WEDGESHAFTVIS <> 'True' THEN NULL ELSE COALESCE(g."Matl Abbrev", g."Matl Descr") END AS SHAFTMATL,
CASE WHEN @WEDGEGRIPVIS <> 'True' THEN NULL ELSE CASE WHEN COALESCE(h."Mfgr Abbrev", h."Mfgr Descr") = COALESCE(i."Mfgr Abbrev", i."Mfgr Descr") THEN '=' ELSE COALESCE(h."Mfgr Abbrev", h."Mfgr Descr") END END AS GRIPMFGR,
CASE WHEN @WEDGEGRIPVIS <> 'True' THEN NULL ELSE COALESCE(i."Mfgr Abbrev", i."Mfgr Descr") END AS GRIPBRAND,
CASE WHEN @WEDGEGRIPVIS <> 'True' THEN NULL ELSE COALESCE(j."model abbrev", j."Model Descr") END AS GRIPMODEL,
NULL AS GRIPTYPE,
CASE WHEN @WEDGEGRIPVIS <> 'True' THEN NULL ELSE CASE WHEN COALESCE(k."Matl Abbrev", k."Matl Descr") = '(RUBB)' THEN '-' ELSE COALESCE(k."Matl Abbrev", k."Matl Descr") END END AS GRIPMATL,
'True' as isvisible, @WEDGESHAFTVIS AS shaftisvisible, @WEDGEGRIPVIS AS gripisvisible

FROM Player_Master.[Wedge Detail] z with (nolock)
LEFT OUTER JOIN
(SELECT * FROM Player_master.[Shaft Detail] with (nolock)
WHERE Name = @PLAYERNAME AND "FIRST DAY" = @FIRSTDAYSHAFTS and [Survey ID] = @SIDSHAFTS AND [Shaft Equip Type] = 'WEDG') y
ON [Wedge Club Code] = [Shaft Club Code] and z.Name = y.Name AND z."PKey" = y."PKey"
LEFT OUTER JOIN
(SELECT * FROM Player_master.[Grip Detail] with (nolock)
WHERE Name = @PLAYERNAME AND "FIRST DAY" = @FIRSTDAYGRIPS and [Survey ID] = @SIDGRIPS AND [Grip Equip Type] = 'WEDG') x
ON [Wedge Club Code] = [Grip Club Code] and z.Name = x.Name AND z."PKey" = x."PKey"

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a with (nolock) ON [Wedge Brand Code] = a."Mfgr Code"
LEFT OUTER JOIN LKP.[Model Codes and Descr] b with (nolock) ON [Wedge Model Code] = b."Model Code"
LEFT OUTER JOIN LKP.[Material Codes and Descript] c with (nolock) ON [Wedge Mat'l Code] = c."Matl Code"
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] d with (nolock) ON [Shaft Mfgr Code] = d."Mfgr Code"
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] e with (nolock) ON [Shaft Brand Code] = e."Mfgr Code"
LEFT OUTER JOIN LKP.[Model Codes and Descr] f with (nolock) ON [Shaft Model Code] = f."Model Code"
LEFT OUTER JOIN LKP.[Material Codes and Descript] g with (nolock) ON [Shaft Mat'l Code] = g."Matl Code"
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] h with (nolock) ON [Grip Mfgr Code] = h."Mfgr Code"
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] i with (nolock) ON [Grip Brand Code] = i."Mfgr Code"
LEFT OUTER JOIN LKP.[Model Codes and Descr] j with (nolock) ON [Grip Model Code] = j."Model Code"
LEFT OUTER JOIN LKP.[Material Codes and Descript] k with (nolock) ON [Grip Mat'l Code] = k."Matl Code"
left outer join Lkp.[Type Codes and Description] l with (nolock) ON z.[Wedge Type Code] = l.[Type Code]
LEFT OUTER JOIN LKP.[Flex Codes and Desc] m with (nolock) ON [Shaft Flex Code] = m.[Flex Code]

WHERE z.Name = @PLAYERNAME AND z."FIRST DAY" = @FIRSTDAY and z.[Survey ID] = @SIDVAR
ORDER BY z."PKey" ASC

END
GO
