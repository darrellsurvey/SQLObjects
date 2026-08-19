DROP VIEW IF EXISTS [dbo].[FlashDetail];
GO

CREATE VIEW dbo.FlashDetail
AS
SELECT     TOP (100) PERCENT e.SID, e.[FIRST DAY], e.PLAYERNAME, e.Equipment, e.Flag, e.ClubCode, e.Manufacturer, e.Brand, e.Model, e.Degree, e.Material
FROM         (SELECT     INPUTNO, SID, [FIRST DAY], PLAYERNAME, 'BALL' AS Equipment, NULL AS Flag, NULL AS ClubCode, '' AS Manufacturer, BALLBRAND AS Brand, 
                                              BALLMODEL AS Model, NULL AS Degree, NULL AS Material
                       FROM          Input.[All] AS b
                       UNION ALL
                       SELECT     INPUTNO, SID, [FIRST DAY], PLAYERNAME, 'GLOVE' AS Equipment, NULL AS Flag, NULL AS ClubCode, '' AS Manufacturer, GLOVEBRAND AS Brand, NULL 
                                             AS Model, NULL AS Degree, NULL AS Material
                       FROM         Input.[All]
                       UNION ALL
                       SELECT     INPUTNO, SID, [FIRST DAY], PLAYERNAME, 'SHOE' AS Equipment, NULL AS Flag, NULL AS ClubCode, '' AS Manufacturer, SHOEBRAND AS Brand, NULL 
                                             AS Model, NULL AS Degree, NULL AS Material
                       FROM         Input.[All] AS All_3
                       UNION ALL
                       SELECT     INPUTNO, SID, [FIRST DAY], PLAYERNAME, 'HEADGEAR' AS Equipment, NULL AS Flag, NULL AS ClubCode, '' AS Manufacturer, 
                                             HEADGEARBRAND AS Brand, NULL AS Model, NULL AS Degree, NULL AS Material
                       FROM         Input.[All] AS All_2
                       UNION ALL
                       SELECT     INPUTNO, SID, [FIRST DAY], PLAYERNAME, 'BAG' AS Equipment, NULL AS Flag, NULL AS ClubCode, '' AS Manufacturer, BAGBRAND AS Brand, NULL 
                                             AS Model, NULL AS Degree, NULL AS Material
                       FROM         Input.[All] AS All_1
                       UNION ALL
                       SELECT     INPUTNO, SID, [FIRST DAY], PLAYERNAME, 'IRON' AS Equipment, ISSET AS Flag, CLUBCODE AS ClubCode, '' AS Manufacturer, BRAND AS Brand, 
                                             MODEL AS Model, NULL AS Degree, MATERIAL AS Material
                       FROM         Input.Iron
                       UNION ALL
                       SELECT     INPUTNO, SID, [FIRST DAY], PLAYERNAME, 'PUTTER' AS Equipment, NULL AS Flag, NULL AS ClubCode, '' AS Manufacturer, BRAND AS Brand, 
                                             MODEL AS Model, NULL AS Degree, MATERIAL AS Material
                       FROM         Input.Putter
                       UNION ALL
                       SELECT     INPUTNO, SID, [FIRST DAY], PLAYERNAME, 'WEDGE' AS Equipment, NULL AS Flag, CLUBCODE AS ClubCode, '' AS Manufacturer, BRAND AS Brand, 
                                             MODEL AS Model, TYPE AS Degree, MATERIAL AS Material
                       FROM         Input.Wedge
                       UNION ALL
                       SELECT     INPUTNO, SID, [FIRST DAY], PLAYERNAME, 'WOOD' AS Equipment, ISDRIVER AS Flag, CLUBCODE AS ClubCode, '' AS Manufacturer, BRAND AS Brand, 
                                             MODEL AS Model, SIZE AS Degree, MATERIAL AS Material
                       FROM         Input.Wood
                       UNION ALL
                       SELECT     INPUTNO, SID, [FIRST DAY], PLAYERNAME, 'SHAFT' AS Equipment, NULL AS Flag, SHAFTCLUBCODE AS ClubCode, SHAFTMFGR AS Manufacturer, 
                                             SHAFTBRAND AS Brand, SHAFTMODEL AS Model, SHAFTFLEX AS Degree, SHAFTMATL AS Material
                       FROM         Input.Shaft
                       UNION ALL
                       SELECT     INPUTNO, SID, [FIRST DAY], PLAYERNAME, 'GRIP' AS Equipment, NULL AS Flag, GRIPCLUBCODE AS ClubCode, GRIPMFGR AS Manufacturer, 
                                             GRIPBRAND AS Brand, GRIPMODEL AS Model, '' AS Degree, GRIPMATL AS Material
                       FROM         Input.Grip) AS e INNER JOIN
                          (SELECT     PLAYERNAME, SID, FIRSTDAY, MAX(INPUTNO) AS INPUTNO
                            FROM          Player_Master.PLAYERNAMES
                            WHERE      (FIRSTDAY > DATEADD(day, - 7, { fn NOW() })) AND (INPUTNO > 0)
                            GROUP BY PLAYERNAME, SID, FIRSTDAY) AS n ON n.FIRSTDAY = e.[FIRST DAY] AND n.SID = e.SID AND n.PLAYERNAME = e.PLAYERNAME AND 
                      n.INPUTNO = e.INPUTNO
ORDER BY e.[FIRST DAY] DESC, e.SID, e.PLAYERNAME
GO
