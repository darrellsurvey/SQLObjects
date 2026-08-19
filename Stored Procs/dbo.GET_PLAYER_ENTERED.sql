IF OBJECT_ID('dbo.GET_PLAYER_ENTERED') IS NOT NULL
    DROP PROCEDURE [dbo].[GET_PLAYER_ENTERED];
GO

CREATE PROCEDURE [dbo].[GET_PLAYER_ENTERED]
    @PLAYER varchar(50),
    @FIRSTDAY date,
    @SID int,
    @INPUTNO int  -- unused; kept only for call-site signature compatibility.
                  -- [Input].* tables (unlike INPUT_1) only ever hold the
                  -- current version per player -- older INPUTNOs are deleted
                  -- on every save -- so there is nothing to resolve/filter here.
AS
BEGIN
    SET NOCOUNT ON;

    -- PKey IS the on-screen line number for that equipment type (e.g. the 5th
    -- line entered under Woods has PKey = 5 in [Input].[Wood], and the same
    -- line's shaft/grip -- if any -- has PKey = 5 in [Input].[Shaft]/[Grip]
    -- filtered to SHAFTEQUIPTYPE/GRIPEQUIPTYPE = 'WOOD'. So PKey doubles as
    -- both the output ITEMNO and the correct join key between a club and its
    -- shaft/grip -- no CLUBCODE matching needed at all.

    -- Which real concept is assigned to misc1/misc2/misc3 for THIS tournament
    -- (e.g. misc1='PlayerShirt') -- persisted in Input.survey_items at Create
    -- Tournament / Update Equipment time. 'False' means that slot isn't
    -- active for this event. Looking this up here (instead of tagging output
    -- rows with the real concept name) keeps the output byte-compatible with
    -- every already-compiled .exe expecting literal 'MISC1'/'MISC2'/'MISC3'
    -- ITEM tags -- no VB change or redistribution needed.
    DECLARE @Misc1Concept varchar(50), @Misc2Concept varchar(50), @Misc3Concept varchar(50);
    SELECT @Misc1Concept = value FROM Input.survey_items WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY AND survey_item = 'misc1';
    SELECT @Misc2Concept = value FROM Input.survey_items WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY AND survey_item = 'misc2';
    SELECT @Misc3Concept = value FROM Input.survey_items WHERE SID = @SID AND [FIRST DAY] = @FIRSTDAY AND survey_item = 'misc3';
    IF @Misc1Concept = 'False' SET @Misc1Concept = NULL;
    IF @Misc2Concept = 'False' SET @Misc2Concept = NULL;
    IF @Misc3Concept = 'False' SET @Misc3Concept = NULL;

    -- ===== CLUBS =====
    SELECT @PLAYER AS [PLAYER], @SID AS [SID], @FIRSTDAY AS [FIRST DAY],
           'IRON' AS [ITEM], PKey AS [ITEMNO],
           CLUBCODE, CAST(DCLUBCODE AS smallint) AS DCLUBCODE,
           CAST(NULL AS varchar(50)) AS BRAND, CAST(0 AS smallint) AS DBRAND,
           BRAND AS MODEL, CAST(DBRANDCODE AS smallint) AS DMODEL,
           MODEL AS MISC1, CAST(DMODELCODE AS smallint) AS DMISC1,
           CAST(NULL AS varchar(50)) AS MISC2, CAST(0 AS smallint) AS DMISC2,
           CAST(NULL AS varchar(50)) AS MISC3, CAST(0 AS smallint) AS DMISC3,
           NULL, NULL, INPUTNO
    FROM [Input].[Iron]
    WHERE PLAYERNAME = @PLAYER AND SID = @SID AND [FIRST DAY] = @FIRSTDAY

    UNION ALL
    SELECT @PLAYER, @SID, @FIRSTDAY, 'WEDGE', PKey,
           CLUBCODE, CAST(DCLUBCODE AS smallint),
           NULL, 0,
           BRAND, CAST(DBRANDCODE AS smallint),
           MODEL, CAST(DMODELCODE AS smallint),
           TYPE, CAST(DTYPECODE AS smallint),
           NULL, 0,
           NULL, NULL, INPUTNO
    FROM [Input].[Wedge]
    WHERE PLAYERNAME = @PLAYER AND SID = @SID AND [FIRST DAY] = @FIRSTDAY

    UNION ALL
    SELECT @PLAYER, @SID, @FIRSTDAY, 'WOOD', PKey,
           CLUBCODE, CAST(DCLUBCODE AS smallint),
           NULL, 0,
           BRAND, CAST(DBRANDCODE AS smallint),
           MODEL, CAST(DMODELCODE AS smallint),
           MATERIAL, CAST(DMATERIAL AS smallint),
           SIZE, CAST(DSIZECODE AS smallint),
           NULL, NULL, INPUTNO
    FROM [Input].[Wood]
    WHERE PLAYERNAME = @PLAYER AND SID = @SID AND [FIRST DAY] = @FIRSTDAY

    UNION ALL
    SELECT @PLAYER, @SID, @FIRSTDAY, 'PUTTER', PKey,
           NULL, 0,
           NULL, 0,
           BRAND, CAST(DBRANDCODE AS smallint),
           MODEL, CAST(DMODELCODE AS smallint),
           NULL, 0,
           SIZE, CAST(DSIZECODE AS smallint),
           NULL, NULL, INPUTNO
    FROM [Input].[Putter]
    WHERE PLAYERNAME = @PLAYER AND SID = @SID AND [FIRST DAY] = @FIRSTDAY

    -- ===== SHAFTS (PKey = the club's own line number; ITEM text just
    --      depends on which equip type this row belongs to) =====
    UNION ALL
    SELECT @PLAYER, @SID, @FIRSTDAY,
           CASE s.SHAFTEQUIPTYPE WHEN 'WEDG' THEN 'WEDGE SHAFT' ELSE s.SHAFTEQUIPTYPE + ' SHAFT' END,
           s.PKey,
           NULL, 0,
           s.SHAFTMFGR, CAST(s.DMFGRCODE AS smallint),
           s.SHAFTBRAND, CAST(s.DBRANDCODE AS smallint),
           s.SHAFTMODEL, CAST(s.DMODELCODE AS smallint),
           s.SHAFTMATL, CAST(s.DMATLCODE AS smallint),
           s.SHAFTFLEX, CAST(s.DSHAFTFLEX AS smallint),
           NULL, NULL, s.INPUTNO
    FROM [Input].[Shaft] s
    WHERE s.PLAYERNAME = @PLAYER AND s.SID = @SID AND s.[FIRST DAY] = @FIRSTDAY

    -- ===== GRIPS (mfgr/brand/model/matl only -- no flex slot) =====
    UNION ALL
    SELECT @PLAYER, @SID, @FIRSTDAY,
           CASE g.GRIPEQUIPTYPE WHEN 'WEDG' THEN 'WEDGE GRIP' WHEN 'PUTT' THEN 'PUTTER GRIP' ELSE g.GRIPEQUIPTYPE + ' GRIP' END,
           g.PKey,
           NULL, 0,
           g.GRIPMFGR, CAST(g.DMFGRCODE AS smallint),
           g.GRIPBRAND, CAST(g.DBRANDCODE AS smallint),
           g.GRIPMODEL, CAST(g.DMODELCODE AS smallint),
           g.GRIPMATL, CAST(g.DMATERIAL AS smallint),
           NULL, 0,
           NULL, NULL, g.INPUTNO
    FROM [Input].[Grip] g
    WHERE g.PLAYERNAME = @PLAYER AND g.SID = @SID AND g.[FIRST DAY] = @FIRSTDAY

    -- ===== APPAREL (one row per concept, straight off [Input].[All]) =====
    UNION ALL
    SELECT @PLAYER, @SID, @FIRSTDAY, 'BALL', 1,
           NULL, 0, NULL, 0, BALLBRAND, CAST(DBALLBRAND AS smallint),
           BALLMODEL, CAST(DBALLMODEL AS smallint), NULL, 0, NULL, 0,
           NULL, NULL, INPUTNO
    FROM [Input].[All]
    WHERE PLAYERNAME = @PLAYER AND SID = @SID AND [FIRST DAY] = @FIRSTDAY

    UNION ALL
    SELECT @PLAYER, @SID, @FIRSTDAY, 'GLOVES', 1,
           NULL, 0, NULL, 0, GLOVEBRAND, CAST(DGLOVEBRAND AS smallint),
           NULL, 0, NULL, 0, NULL, 0, NULL, NULL, INPUTNO
    FROM [Input].[All]
    WHERE PLAYERNAME = @PLAYER AND SID = @SID AND [FIRST DAY] = @FIRSTDAY

    UNION ALL
    SELECT @PLAYER, @SID, @FIRSTDAY, 'SHOES', 1,
           NULL, 0, NULL, 0, SHOEBRAND, CAST(DSHOEBRAND AS smallint),
           NULL, 0, NULL, 0, NULL, 0, NULL, NULL, INPUTNO
    FROM [Input].[All]
    WHERE PLAYERNAME = @PLAYER AND SID = @SID AND [FIRST DAY] = @FIRSTDAY

    UNION ALL
    SELECT @PLAYER, @SID, @FIRSTDAY, 'HEADGR', 1,
           NULL, 0, NULL, 0, HEADGEARBRAND, CAST(DHEADGEARBRAND AS smallint),
           NULL, 0, NULL, 0, NULL, 0, NULL, NULL, INPUTNO
    FROM [Input].[All]
    WHERE PLAYERNAME = @PLAYER AND SID = @SID AND [FIRST DAY] = @FIRSTDAY

    UNION ALL
    SELECT @PLAYER, @SID, @FIRSTDAY, 'BAG', 1,
           NULL, 0, NULL, 0, BAGBRAND, CAST(DBAGBRAND AS smallint),
           NULL, 0, NULL, 0, NULL, 0, NULL, NULL, INPUTNO
    FROM [Input].[All]
    WHERE PLAYERNAME = @PLAYER AND SID = @SID AND [FIRST DAY] = @FIRSTDAY

    UNION ALL
    SELECT @PLAYER, @SID, @FIRSTDAY, 'CADDYHAT', 1,
           NULL, 0, NULL, 0, CADDYHEADBRAND, CAST(DCADDYHEADBRAND AS smallint),
           NULL, 0, NULL, 0, NULL, 0, NULL, NULL, INPUTNO
    FROM [Input].[All]
    WHERE PLAYERNAME = @PLAYER AND SID = @SID AND [FIRST DAY] = @FIRSTDAY

    UNION ALL
    SELECT @PLAYER, @SID, @FIRSTDAY, 'SPIKES', 1,
           NULL, 0, NULL, 0, SPIKEBRAND, CAST(DSPIKEBRAND AS smallint),
           SPIKEMODEL, CAST(DSPIKEMODEL AS smallint), NULL, 0, NULL, 0,
           NULL, NULL, INPUTNO
    FROM [Input].[All]
    WHERE PLAYERNAME = @PLAYER AND SID = @SID AND [FIRST DAY] = @FIRSTDAY

    -- ===== MISC1/2/3 -- driven by Input.survey_items' per-tournament concept
    --      assignment, only emitted when that slot is actually active =====
    UNION ALL
    SELECT @PLAYER, @SID, @FIRSTDAY, 'MISC1', 1,
           NULL, 0, NULL, 0,
           CASE @Misc1Concept
               WHEN 'PlayerShirt' THEN SHIRTBRAND
               WHEN 'Sunglasses' THEN GLASSESBRAND
               WHEN 'RangefinderPlayer' THEN RANGEPLAYERBRAND
               WHEN 'RangefinderCaddie' THEN RANGECADDIEBRAND
               WHEN 'Raingear' THEN RAINGEARBRAND
               WHEN 'Raincover' THEN RAINCOVERBRAND
               WHEN 'Towel' THEN TOWELBRAND
               WHEN 'TravelBag' THEN TRAVELBAGBRAND
               WHEN 'LaunchMonitor' THEN LAUNCHMONITORBRAND
           END,
           CAST(CASE @Misc1Concept
               WHEN 'PlayerShirt' THEN DSHIRTBRAND
               WHEN 'Sunglasses' THEN DGLASSESBRAND
               WHEN 'RangefinderPlayer' THEN DRANGEPLAYERBRAND
               WHEN 'RangefinderCaddie' THEN DRANGECADDIEBRAND
               WHEN 'Raingear' THEN DRAINGEARBRAND
               WHEN 'Raincover' THEN DRAINCOVERBRAND
               WHEN 'Towel' THEN DTOWELBRAND
               WHEN 'TravelBag' THEN DTRAVELBAGBRAND
               WHEN 'LaunchMonitor' THEN DLAUNCHMONITORBRAND
           END AS smallint),
           NULL, 0, NULL, 0, NULL, 0,
           NULL, NULL, INPUTNO
    FROM [Input].[All]
    WHERE PLAYERNAME = @PLAYER AND SID = @SID AND [FIRST DAY] = @FIRSTDAY
      AND @Misc1Concept IS NOT NULL

    UNION ALL
    SELECT @PLAYER, @SID, @FIRSTDAY, 'MISC2', 1,
           NULL, 0, NULL, 0,
           CASE @Misc2Concept
               WHEN 'PlayerShirt' THEN SHIRTBRAND
               WHEN 'Sunglasses' THEN GLASSESBRAND
               WHEN 'RangefinderPlayer' THEN RANGEPLAYERBRAND
               WHEN 'RangefinderCaddie' THEN RANGECADDIEBRAND
               WHEN 'Raingear' THEN RAINGEARBRAND
               WHEN 'Raincover' THEN RAINCOVERBRAND
               WHEN 'Towel' THEN TOWELBRAND
               WHEN 'TravelBag' THEN TRAVELBAGBRAND
               WHEN 'LaunchMonitor' THEN LAUNCHMONITORBRAND
           END,
           CAST(CASE @Misc2Concept
               WHEN 'PlayerShirt' THEN DSHIRTBRAND
               WHEN 'Sunglasses' THEN DGLASSESBRAND
               WHEN 'RangefinderPlayer' THEN DRANGEPLAYERBRAND
               WHEN 'RangefinderCaddie' THEN DRANGECADDIEBRAND
               WHEN 'Raingear' THEN DRAINGEARBRAND
               WHEN 'Raincover' THEN DRAINCOVERBRAND
               WHEN 'Towel' THEN DTOWELBRAND
               WHEN 'TravelBag' THEN DTRAVELBAGBRAND
               WHEN 'LaunchMonitor' THEN DLAUNCHMONITORBRAND
           END AS smallint),
           NULL, 0, NULL, 0, NULL, 0,
           NULL, NULL, INPUTNO
    FROM [Input].[All]
    WHERE PLAYERNAME = @PLAYER AND SID = @SID AND [FIRST DAY] = @FIRSTDAY
      AND @Misc2Concept IS NOT NULL

    UNION ALL
    SELECT @PLAYER, @SID, @FIRSTDAY, 'MISC3', 1,
           NULL, 0, NULL, 0,
           CASE @Misc3Concept
               WHEN 'PlayerShirt' THEN SHIRTBRAND
               WHEN 'Sunglasses' THEN GLASSESBRAND
               WHEN 'RangefinderPlayer' THEN RANGEPLAYERBRAND
               WHEN 'RangefinderCaddie' THEN RANGECADDIEBRAND
               WHEN 'Raingear' THEN RAINGEARBRAND
               WHEN 'Raincover' THEN RAINCOVERBRAND
               WHEN 'Towel' THEN TOWELBRAND
               WHEN 'TravelBag' THEN TRAVELBAGBRAND
               WHEN 'LaunchMonitor' THEN LAUNCHMONITORBRAND
           END,
           CAST(CASE @Misc3Concept
               WHEN 'PlayerShirt' THEN DSHIRTBRAND
               WHEN 'Sunglasses' THEN DGLASSESBRAND
               WHEN 'RangefinderPlayer' THEN DRANGEPLAYERBRAND
               WHEN 'RangefinderCaddie' THEN DRANGECADDIEBRAND
               WHEN 'Raingear' THEN DRAINGEARBRAND
               WHEN 'Raincover' THEN DRAINCOVERBRAND
               WHEN 'Towel' THEN DTOWELBRAND
               WHEN 'TravelBag' THEN DTRAVELBAGBRAND
               WHEN 'LaunchMonitor' THEN DLAUNCHMONITORBRAND
           END AS smallint),
           NULL, 0, NULL, 0, NULL, 0,
           NULL, NULL, INPUTNO
    FROM [Input].[All]
    WHERE PLAYERNAME = @PLAYER AND SID = @SID AND [FIRST DAY] = @FIRSTDAY
      AND @Misc3Concept IS NOT NULL
END
GO
