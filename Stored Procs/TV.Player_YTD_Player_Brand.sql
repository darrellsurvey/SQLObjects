IF OBJECT_ID('TV.Player_YTD_Player_Brand') IS NOT NULL
    DROP PROCEDURE [TV].[Player_YTD_Player_Brand];
GO

CREATE PROCEDURE [TV].[Player_YTD_Player_Brand]
(@Year int,
 @Tour nvarchar(50))
AS
BEGIN

select top 40 
		rank() over(order by sum(a.[Duration]) desc) as BrandRank
		,a.PlayerName
		,b.[Brand]
FROM [DARRELL_MASTER].[TV].[TVAudit] a
inner join 
	(SELECT sum([Duration]) as TotalTime
		  ,[PlayerName]
	      ,[Brand]
	      ,row_number() over(partition by brand order by sum([Duration]) desc) as NumUno
		FROM [DARRELL_MASTER].[TV].[TVAudit]
		where YEAR([TntFirstDay]) = @year and [Tour] = @Tour
		group by PlayerName, brand) b
on a.Brand = b.Brand
where b.NumUno = 1 and YEAR([TntFirstDay]) = @year and [Tour] = @Tour
group by a.PlayerName, b.brand
order by BrandRank asc
    
END
GO
