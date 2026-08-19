IF OBJECT_ID('OptOut.link_helper2') IS NOT NULL
    DROP PROCEDURE [OptOut].[link_helper2];
GO

CREATE PROCEDURE [OptOut].[link_helper2]
AS
BEGIN
    SET NOCOUNT ON;

    MERGE [OptOut].[LinkManager] AS tgt
    USING (
        SELECT
            sn.PlayerName,
            u.feedname,
            sn.Equipment,
            sn.Brand,
            sn.Model,
            sn.ClubNumber,
            -- If duplicates exist in BrandLinks with different URLs, take the last one alphabetically
            MAX(u.link_url) AS link_url
        FROM [OptOut].[SelectionNew] sn
        INNER JOIN [OptOut].[BrandLinks] bl
            ON  sn.Brand = bl.brand
            AND COALESCE(sn.Equipment, '') = COALESCE(bl.equipment, '')
            AND COALESCE(sn.Model,     '') = COALESCE(bl.model,     '')
            AND (
                    bl.clubnumber IS NULL
                    OR
                    LTRIM(RTRIM(COALESCE(sn.ClubNumber, ''))) = LTRIM(RTRIM(bl.clubnumber))
                )
            AND sn.Season = 1900
        CROSS APPLY (
            VALUES
                ('player',  NULLIF(bl.player_url,  '')),
                ('default', NULLIF(bl.default_url, ''))
        ) u (feedname, link_url)
        GROUP BY
            sn.PlayerName,
            u.feedname,
            sn.Equipment,
            sn.Brand,
            sn.Model,
            sn.ClubNumber
    ) AS src
        ON  tgt.PlayerName = src.PlayerName
        AND tgt.feedname   = src.feedname
        AND COALESCE(tgt.Equipment,   '') = COALESCE(src.Equipment,   '')
        AND COALESCE(tgt.Brand,       '') = COALESCE(src.Brand,       '')
        AND COALESCE(tgt.Model,       '') = COALESCE(src.Model,       '')
        AND LTRIM(RTRIM(COALESCE(tgt.ClubNumber, ''))) =
                LTRIM(RTRIM(COALESCE(src.ClubNumber, '')))
    WHEN MATCHED THEN
        UPDATE SET tgt.link_url = src.link_url
    WHEN NOT MATCHED BY TARGET THEN
        INSERT (PlayerName, feedname, Equipment, Brand, Model, ClubNumber, link_url)
        VALUES (src.PlayerName, src.feedname, src.Equipment, src.Brand,
                src.Model, src.ClubNumber, src.link_url);

END
GO
