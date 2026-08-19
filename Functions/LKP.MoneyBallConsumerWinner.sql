IF OBJECT_ID('LKP.MoneyBallConsumerWinner') IS NOT NULL
    DROP FUNCTION [LKP].[MoneyBallConsumerWinner];
GO

create Function lkp.MoneyBallConsumerWinner
(	@year integer,
	@Tour varchar(20))
returns varchar(50)

as begin

declare @return varchar(50)

;with CTE_ConsumerPrep as (
select [YEAR], form, [BRAND], 1 as BrandTotal 
from [DARRELL_MASTER].[Consumer].[Bag] where  left([YEAR], 4) = @year
union 
select [YEAR], form, [BRAND], 1 as BrandTotal 
from [DARRELL_MASTER].[Consumer].[Ball] where  left([YEAR], 4) = @year
union 
select [YEAR], form, [BRAND], 1 as BrandTotal 
from [DARRELL_MASTER].[Consumer].[Glove] where  left([YEAR], 4) = @year
union 
select [YEAR], form, [BRAND], 1 as BrandTotal 
from [DARRELL_MASTER].[Consumer].[Headgear] where  left([YEAR], 4) = @year
union 
select [YEAR], form, [BRAND], 1 as BrandTotal 
from [DARRELL_MASTER].[Consumer].[Iron] where  left([YEAR], 4) = @year
union 
select [yEAR], form, [BRAND], 1 as BrandTotal 
from [DARRELL_MASTER].[Consumer].[Putter] where  left([YEAR], 4) = @year
union 
select [YEAR], form, [BRAND], 1 as BrandTotal 
from [DARRELL_MASTER].[Consumer].[Shirt] where  left([YEAR], 4) = @year
union 
select [YEAR], form, [BRAND], 1 as BrandTotal 
from [DARRELL_MASTER].[Consumer].[Shoe] where  left([YEAR], 4) = @year
union 
select [YEAR], form, [BRAND], 1 as BrandTotal 
from [DARRELL_MASTER].[Consumer].[Iron] where  left([YEAR], 4) = @year
union 
select [YEAR], form, [BRAND], 1 as BrandTotal 
from [DARRELL_MASTER].[Consumer].[Wedge] where  left([YEAR], 4) = @year
union 
select [YEAR], form, [BRAND], 1 as BrandTotal 
from [DARRELL_MASTER].[Consumer].[Wood] where  left([YEAR], 4) = @year),


CTE_Consumer as (
select left([YEAR],4) as YearPlayed, brand, 
sum(BrandTotal) as ConsumerNew
from cte_ConsumerPrep
group by [YEAR], brand)


SELECT top 1 @return = BRAND
  FROM CTE_Consumer
  order by ConsumerNew desc

return @return

end
GO
