DROP VIEW IF EXISTS [Proof].[MissingDriver];
GO

CREATE VIEW Proof.MissingDriver
AS
SELECT     TOP (100) PERCENT Name, [Survey ID], [First Day], SUM(ISNULL(ISDRIVER, 0)) AS DR
FROM         Player_Master.[Wood Detail] AS w
GROUP BY Name, [Survey ID], [First Day]
HAVING      (SUM(ISNULL(ISDRIVER, 0)) = 0)
ORDER BY [First Day] DESC
GO
