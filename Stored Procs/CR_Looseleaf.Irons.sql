IF OBJECT_ID('CR_Looseleaf.Irons') IS NOT NULL
    DROP PROCEDURE [CR_Looseleaf].[Irons];
GO

CREATE PROCEDURE [CR_Looseleaf].[Irons]
  @FIRSTNAME varchar(50),
  @LASTNAME varchar(50),
  @LOOKUPDATE date,
  @IRONSHAFTVIS varchar(10) = 'False',
  @IRONGRIPVIS varchar(10) = 'False'
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
  DECLARE @IRONSHAFTCOUNT INTEGER;

  --selects the proper first day for the player based on if there's an input date
  SELECT TOP 1 @FIRSTDAY = [First Day], @SIDVAR = [Survey ID]
  FROM Player_Master.[Iron Detail] with (nolock)
  WHERE [Name] = @PLAYERNAME AND [First Day] < @LOOKUPDATE
  ORDER BY [First Day] DESC, [index] desc;

  SELECT TOP 1 @FIRSTDAYSHAFTS = [First Day], @SIDSHAFTS = [Survey ID]
  FROM Player_Master.[Shaft Detail] with (nolock)
  WHERE [Shaft Equip Type] = 'IRON' AND [Name] = @PLAYERNAME AND [First Day] < @LOOKUPDATE
  ORDER BY [First Day] DESC, [index] desc;

  SELECT TOP 1 @FIRSTDAYGRIPS = [First Day], @SIDGRIPS = [Survey ID]
  FROM Player_Master.[Grip Detail] with (nolock)
  WHERE [Grip Equip Type] = 'IRON' AND [Name] = @PLAYERNAME AND [First Day] < @LOOKUPDATE
  ORDER BY [First Day] DESC, [index] desc;

  --checks to see if the player has any shafts listed, and runs a simpler (and faster) query if not
  SELECT @IRONSHAFTCOUNT = COUNT(*) FROM Player_Master.[Shaft Detail] with (nolock)
  WHERE [Name] = @PLAYERNAME AND [Shaft Equip Type] = 'IRON';

SELECT
[Iron Club Code] AS CLUBCODE,
COALESCE(a.[Mfgr Abbrev], a.[Mfgr Descr]) AS BRAND,
COALESCE(b.[Model Abbrev], b.[Model Descr]) AS MODEL,
COALESCE(c.[Matl Abbrev], c.[Matl Descr]) AS MATERIAL,
NULL AS [SIZE],
NULL AS MISC,
CASE WHEN @IRONSHAFTVIS <> 'True' THEN NULL ELSE CASE WHEN COALESCE(d.[Mfgr Abbrev], d.[Mfgr Descr]) = COALESCE(e.[Mfgr Abbrev], e.[Mfgr Descr]) THEN '=' ELSE COALESCE(d.[Mfgr Abbrev], d.[Mfgr Descr]) END END AS SHAFTMFGR,
CASE WHEN @IRONSHAFTVIS <> 'True' THEN NULL ELSE COALESCE(e.[Mfgr Abbrev], e.[Mfgr Descr]) END AS SHAFTBRAND,
CASE WHEN @IRONSHAFTVIS <> 'True' THEN NULL ELSE COALESCE(f.[model abbrev], f.[Model Descr]) END AS SHAFTMODEL,
CASE WHEN @IRONSHAFTVIS <> 'True' THEN NULL ELSE COALESCE(COALESCE(l.[Flex Abbrev], l.[Flex Descr]), '-') END AS SHAFTFLEX,
NULL AS SHAFTTYPE,
CASE WHEN @IRONSHAFTVIS <> 'True' THEN NULL ELSE COALESCE(g.[Matl Abbrev], g.[Matl Descr]) END AS SHAFTMATL,
CASE WHEN @IRONGRIPVIS <> 'True' THEN NULL ELSE CASE WHEN COALESCE(h.[Mfgr Abbrev], h.[Mfgr Descr]) = COALESCE(i.[Mfgr Abbrev], i.[Mfgr Descr]) THEN '=' ELSE COALESCE(h.[Mfgr Abbrev], h.[Mfgr Descr]) END END AS GRIPMFGR,
CASE WHEN @IRONGRIPVIS <> 'True' THEN NULL ELSE COALESCE(i.[Mfgr Abbrev], i.[Mfgr Descr]) END AS GRIPBRAND,
CASE WHEN @IRONGRIPVIS <> 'True' THEN NULL ELSE COALESCE(j.[Model Abbrev], j.[Model Descr]) END AS GRIPMODEL,
NULL AS GRIPTYPE,
CASE WHEN @IRONGRIPVIS <> 'True' THEN NULL ELSE CASE WHEN COALESCE(k.[Matl Abbrev], k.[Matl Descr]) = '(RUBB)' THEN '-' ELSE COALESCE(k.[Matl Abbrev], k.[Matl Descr]) END END AS GRIPMATL,
'True' as isvisible, @IRONSHAFTVIS AS shaftisvisible, @IRONGRIPVIS AS gripisvisible

FROM Player_master.[Iron Detail] z with (nolock)
LEFT OUTER JOIN
(SELECT * FROM Player_master.[Shaft Detail] with (nolock)
 WHERE Name = @PLAYERNAME AND [FIRST DAY] = @FIRSTDAYSHAFTS and [Survey ID] = @SIDSHAFTS AND [Shaft Equip Type] = 'IRON') y
ON [Iron Club Code] = [Shaft Club Code] and z.Name = y.Name AND z.[PKey] = y.[PKey]
LEFT OUTER JOIN
(SELECT * FROM Player_master.[Grip Detail] with (nolock)
 WHERE Name = @PLAYERNAME AND [FIRST DAY] = @FIRSTDAYGRIPS and [Survey ID] = @SIDGRIPS AND [Grip Equip Type] = 'IRON') x
ON [Iron Club Code] = [Grip Club Code] and z.Name = x.Name AND z.[PKey] = x.[PKey]

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a with (nolock) ON [Iron Brand Code] = a.[Mfgr Code]
LEFT OUTER JOIN LKP.[Model Codes and Descr] b with (nolock) ON [Iron Model Code] = b.[Model Code]
LEFT OUTER JOIN LKP.[Material Codes and Descript] c with (nolock) ON [Iron Mat'l Code] = c.[Matl Code]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] d with (nolock) ON [Shaft Mfgr Code] = d.[Mfgr Code]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] e with (nolock) ON [Shaft Brand Code] = e.[Mfgr Code]
LEFT OUTER JOIN LKP.[Model Codes and Descr] f with (nolock) ON [Shaft Model Code] = f.[Model Code]
LEFT OUTER JOIN LKP.[Material Codes and Descript] g with (nolock) ON [Shaft Mat'l Code] = g.[Matl Code]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] h with (nolock) ON [Grip Mfgr Code] = h.[Mfgr Code]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] i with (nolock) ON [Grip Brand Code] = i.[Mfgr Code]
LEFT OUTER JOIN LKP.[Model Codes and Descr] j with (nolock) ON [Grip Model Code] = j.[Model Code]
LEFT OUTER JOIN LKP.[Material Codes and Descript] k with (nolock) ON [Grip Mat'l Code] = k.[Matl Code]
LEFT OUTER JOIN LKP.[Flex Codes and Desc] l with (nolock) ON [Shaft Flex Code] = l.[Flex Code]

WHERE z.Name = @PLAYERNAME AND z.[FIRST DAY] = @FIRSTDAY and z.[Survey ID] = @SIDVAR
ORDER BY z.[PKey] ASC

END
GO
