IF OBJECT_ID('TV.Player_YTD_Brand_Model') IS NOT NULL
    DROP PROCEDURE [TV].[Player_YTD_Brand_Model];
GO

/****** Script for SelectTopNRows command from SSMS  ******/
CREATE PROCEDURE [TV].[Player_YTD_Brand_Model]
(@Year int,
 @Tour nvarchar(50))
AS
BEGIN

SELECT sum([Duration]) as ModelTime
	  ,b.PlayerTotal
	  ,C.brandTotal
      ,a.[PlayerName]
      ,a.Brand
      ,[Model]
  FROM [DARRELL_MASTER].[TV].[TVAudit] a
  inner join 
	(SELECT top 25 sum(duration) as PlayerTotal, playername from [DARRELL_MASTER].[TV].[TVAudit] WHERE YEAR([TntFirstDay]) = @year and [Tour] = @Tour group by PlayerName order by PlayerTotal desc) b
  on a.PlayerName = b.PlayerName
  inner join 
	(SELECT sum(duration) as brandTotal, playername, brand from [DARRELL_MASTER].[TV].[TVAudit] where YEAR([TntFirstDay]) = @year and [Tour] = @Tour group by PlayerName, brand) C
  on a.PlayerName = c.PlayerName
  and a.Brand = C.Brand
  where YEAR([TntFirstDay]) = @year and [Tour] = @Tour
  group by a.[PlayerName], a.brand, model, PlayerTotal, C.brandTotal
  order by b.PlayerTotal desc, C.brandTotal desc, ModelTime desc
  
  
  
 END
GO
