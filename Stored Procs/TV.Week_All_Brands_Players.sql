DROP PROCEDURE IF EXISTS [TV].[Week_All_Brands_Players];
GO

Create PROCEDURE [TV].[Week_All_Brands_Players]
(@Year int,
 @SID int)
AS
BEGIN

SELECT sum([Duration]) as RoundTimeTotal 
	  ,Count([Duration]) as RoundCountTotal 
      ,[Brand]
      ,[Round]
      ,TntName
      ,PlayerName
      ,Equip
  FROM [DARRELL_MASTER].[TV].[TVAudit] a
  where TntNid = @SID and YEAR([TntFirstDay]) = @year
  group by Brand, [Round], TntName ,PlayerName ,Equip
  order by Brand, PlayerName, RoundTimeTotal

  
END
GO
