DROP PROCEDURE IF EXISTS [TV].[Week_One_Brand_Equip];
GO

CREATE PROCEDURE [TV].[Week_One_Brand_Equip]
(@Year int,
 @SID int,
 @Brand varchar(50))
AS
BEGIN


SELECT sum([Duration]) as RoundTime
	  ,(SELECT sum([Duration]) FROM [DARRELL_MASTER].[TV].[TVAudit] z
			where TntNid = @SID and YEAR([TntFirstDay]) = @year and z.Brand = @Brand and z.Equip=a.Equip) as TotalTime
      ,[Brand]
      ,[Round]
      ,TntName
      ,Equip
  FROM [DARRELL_MASTER].[TV].[TVAudit] a
  where TntNid = @SID and YEAR([TntFirstDay]) = @year and a.Brand = @Brand
  group by Brand, [Round], TntName, Equip
  order by TotalTime desc
END
GO
