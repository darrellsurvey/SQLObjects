IF OBJECT_ID('CR_Looseleaf.Putter') IS NOT NULL
    DROP PROCEDURE [CR_Looseleaf].[Putter];
GO

CREATE PROCEDURE [CR_Looseleaf].[Putter]
	-- Add the parameters for the stored procedure here
	@FIRSTNAME varchar(50),
	@LASTNAME varchar(50),
	@LOOKUPDATE date,
	@PUTTERSHAFTVIS varchar(10) = 'False',
	@PUTTERGRIPVIS varchar(10) = 'False'
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
  DECLARE @FIRSTDAYGRIPS DATE;
  DECLARE @SIDVAR INTEGER;
  DECLARE @SIDGRIPS INTEGER;

  --selects the proper first day for the player based on if there's an input date
  SELECT TOP 1 @FIRSTDAY = [First Day], @SIDVAR = [Survey ID]
  FROM Player_Master.[Putter Detail] with (nolock)
  WHERE [Name] = @PLAYERNAME AND [First Day] < @LOOKUPDATE
  ORDER BY [First Day] DESC, [index] desc;

  SELECT TOP 1 @FIRSTDAYGRIPS = [First Day], @SIDGRIPS = [Survey ID]
  FROM Player_Master.[Grip Detail] with (nolock)
  WHERE [Grip Equip Type] = 'PUTT' AND [Name] = @PLAYERNAME AND [First Day] < @LOOKUPDATE
  ORDER BY [First Day] DESC, [index] desc;

SELECT
[Putter Sequence No] AS CLUBCODE,
COALESCE(a.[Mfgr Abbrev], a.[Mfgr Descr]) AS BRAND,
COALESCE(b.[model abbrev], b.[Model Descr]) AS MODEL,
COALESCE(c.[Matl Abbrev], c.[Matl Descr]) AS MATERIAL,
COALESCE(l.[Size Abbrev], l.[Size Descr], '-') AS [SIZE],
NULL AS MISC,
NULL AS SHAFTMFGR,
NULL AS SHAFTBRAND,
NULL AS SHAFTMODEL,
NULL AS SHAFTTYPE,
NULL AS SHAFTMATL,
CASE WHEN @PUTTERGRIPVIS <> 'True' THEN NULL ELSE CASE WHEN COALESCE(h.[Mfgr Abbrev], h.[Mfgr Descr]) = COALESCE(i.[Mfgr Abbrev], i.[Mfgr Descr]) THEN '=' ELSE COALESCE(h.[Mfgr Abbrev], h.[Mfgr Descr]) END END AS GRIPMFGR,
CASE WHEN @PUTTERGRIPVIS <> 'True' THEN NULL ELSE COALESCE(i.[Mfgr Abbrev], i.[Mfgr Descr]) END AS GRIPBRAND,
CASE WHEN @PUTTERGRIPVIS <> 'True' THEN NULL ELSE COALESCE(j.[Model Abbrev], j.[Model Descr]) END AS GRIPMODEL,
NULL AS GRIPTYPE,
CASE WHEN @PUTTERGRIPVIS <> 'True' THEN NULL ELSE CASE WHEN COALESCE(k.[Matl Abbrev], k.[Matl Descr]) = '(RUBB)' THEN '-' ELSE COALESCE(k.[Matl Abbrev], k.[Matl Descr]) END END AS GRIPMATL,
'True' as isvisible, 'False' AS shaftisvisible, @PUTTERGRIPVIS AS gripisvisible

FROM Player_Master.[Putter Detail] z with (nolock)
LEFT OUTER JOIN
(SELECT * FROM Player_Master.[Grip Detail]
WHERE Name = @PLAYERNAME AND [FIRST DAY] = @FIRSTDAYGRIPS  and [Survey ID] = @SIDGRIPS
AND [Grip Equip Type] = 'PUTT') x
ON [Putter Sequence No] = [Grip Club Code]
  and z.Name = x.Name
  AND z.[PKey] = x.[PKey]

LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] a with (nolock) ON [Putter Brand Code] = a.[Mfgr Code]
LEFT OUTER JOIN LKP.[Model Codes and Descr] b with (nolock) ON [Putter Model Code] = b.[Model Code]
LEFT OUTER JOIN LKP.[Material Codes and Descript] c with (nolock) ON [Putter Mat'l Code] = c.[Matl Code]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] h with (nolock) ON [Grip Mfgr Code] = h.[Mfgr Code]
LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] i with (nolock) ON [Grip Brand Code] = i.[Mfgr Code]
LEFT OUTER JOIN LKP.[Model Codes and Descr] j with (nolock) ON [Grip Model Code] = j.[Model Code]
LEFT OUTER JOIN LKP.[Material Codes and Descript] k with (nolock) ON [Grip Mat'l Code] = k.[Matl Code]
LEFT OUTER JOIN LKP.[Size Codes and Description] l with (nolock) ON [Putter Size Code] = l.[Size Code]

WHERE z.Name = @PLAYERNAME AND z.[FIRST DAY] = @FIRSTDAY and z.[Survey ID] = @SIDVAR
ORDER BY z.[PKey] ASC

END
GO
