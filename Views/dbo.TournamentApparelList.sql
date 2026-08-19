IF OBJECT_ID('dbo.TournamentApparelList') IS NOT NULL
    DROP VIEW [dbo].[TournamentApparelList];
GO

CREATE VIEW dbo.TournamentApparelList
AS
SELECT     TOP (100) PERCENT g.PLAYERNAME, ISNULL(g.BRAND, '') AS GLOVES, ISNULL(s.BRAND, '') AS SHOES, ISNULL(h.BRAND, '') AS HAT, ISNULL(b.BRAND, '') AS BAG, 
                      ISNULL(c.BRAND, '') AS CADDIE, ISNULL(sg.BRAND, '') AS SUNGLASSES, ISNULL(k.BRAND, '') + '; ' + ISNULL(k.MODEL, '') AS SPIKES
FROM         dbo.Gloves AS g LEFT OUTER JOIN
                      dbo.Shoes AS s ON g.PLAYERNAME = s.PLAYERNAME AND g.[FIRST DAY] = s.[FIRST DAY] LEFT OUTER JOIN
                      dbo.Headgear AS h ON g.PLAYERNAME = h.PLAYERNAME AND g.[FIRST DAY] = h.[FIRST DAY] LEFT OUTER JOIN
                      dbo.Bag AS b ON g.PLAYERNAME = b.PLAYERNAME AND g.[FIRST DAY] = b.[FIRST DAY] LEFT OUTER JOIN
                      dbo.Caddie AS c ON g.PLAYERNAME = c.PLAYERNAME AND g.[FIRST DAY] = c.[FIRST DAY] LEFT OUTER JOIN
                      dbo.Sunglasses AS sg ON g.PLAYERNAME = sg.PLAYERNAME AND g.[FIRST DAY] = sg.[FIRST DAY] LEFT OUTER JOIN
                      dbo.Spikes AS k ON g.PLAYERNAME = k.PLAYERNAME AND g.[FIRST DAY] = k.[FIRST DAY] INNER JOIN
                          (SELECT     MAX([FIRST DAY]) AS FD, PLAYERNAME
                            FROM          dbo.Gloves AS g
                            WHERE      (PLAYERNAME IN
                                                       (SELECT     PLAYERNAME
                                                         FROM          Player_Master.PLAYERNAMES
                                                         WHERE      (SID = 22) AND (YEAR(FIRSTDAY) = 2013)))
                            GROUP BY PLAYERNAME) AS n ON g.PLAYERNAME = n.PLAYERNAME AND g.[FIRST DAY] = n.FD
ORDER BY g.PLAYERNAME
GO
