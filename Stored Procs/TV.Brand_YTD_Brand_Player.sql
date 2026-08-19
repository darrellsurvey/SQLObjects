IF OBJECT_ID('TV.Brand_YTD_Brand_Player') IS NOT NULL
    DROP PROCEDURE [TV].[Brand_YTD_Brand_Player];
GO

CREATE PROCEDURE [TV].[Brand_YTD_Brand_Player]
(@Year int,
 @Tour nvarchar(50))
AS
BEGIN

select top 40 
		rank() over(order by sum(a.[Duration]) desc) as BrandRank
		,a.[Brand]
		,b.PlayerName
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
group by a.brand, b.PlayerName
order by BrandRank asc
    
END
GO
