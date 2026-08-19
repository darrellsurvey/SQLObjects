DROP VIEW IF EXISTS [Consumer].[LastSurvey_byCountry];
GO

CREATE VIEW Consumer.LastSurvey_byCountry
AS
SELECT     [YEAR], COUNTRY, SeasonText AS Season, SampleSize AS [Players Surveyed]
FROM         (SELECT DISTINCT ROW_NUMBER() OVER (partition BY country
                       ORDER BY country, [year] DESC, [season] DESC) AS n, [year], COUNTRY, CASE Season WHEN 1 THEN 'Winter' 
									WHEN 2 THEN 'Spring' 
									WHEN 3 THEN 'Summer'
									WHEN 4 THEN 'Fall'  END AS SeasonText,
                      COUNT(country) AS SampleSize
FROM         Consumer.PlayerProfile
GROUP BY [year], COUNTRY, Season) a
WHERE     n = 1
GO
