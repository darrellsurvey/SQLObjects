IF OBJECT_ID('Consumer.Chapter_Intro4') IS NOT NULL
    DROP PROCEDURE [Consumer].[Chapter_Intro4];
GO

CREATE procedure [Consumer].[Chapter_Intro4]
(@Country as varchar(20),
@Year as int,
@Season as tinyint,
@YearsBack as tinyint)

as

begin
set nocount on;

--exec [Consumer].[Chapter_Intro4] 'USA',2019,3,4

select * from (

select p.[year], Season, 'Hybrid' as Equip, 
  sum(case when years < 2 then 1 else 0 end) * 100.0 / sum(COUNT(*)) over (partition by [Year]) as TotalNew, 
  3 as Sort
  FROM  Consumer.[Wood] eq
  inner join Consumer.PlayerProfile p on p.PlayerProfileId = eq.PlayerProfileId 
  where COUNTRY = @Country and BRAND is not null and 
  [YEAR] between @Year - @YearsBack and @Year AND SEASON = @Season  and [CLUB_CODE] = 12  
  group by [YEAR],  SEASON
  union all
  select p.[year], Season, 'Driver' as Equip, 
  sum(case when years < 2 then 1 else 0 end) * 100.0 / sum(COUNT(*)) over (partition by [Year]) as TotalNew, 
  2 as Sort
  FROM  Consumer.[Wood] eq
  inner join Consumer.PlayerProfile p on p.PlayerProfileId = eq.PlayerProfileId 
  where COUNTRY = @Country and BRAND is not null and 
  [YEAR] between @Year - @YearsBack and @Year AND SEASON = @Season  and [CLUB_CODE] = 1  group by [YEAR],  SEASON
  union all
  select p.[year], Season, 'Iron' as Equip, 
  sum(case when years < 2 then 1 else 0 end) * 100.0 / sum(COUNT(*)) over (partition by [Year]) as TotalNew, 
  1 as Sort
  FROM  Consumer.[Iron] eq
  inner join Consumer.PlayerProfile p on p.PlayerProfileId = eq.PlayerProfileId 
  where COUNTRY = @Country and BRAND is not null and 
  [YEAR] between @Year - @YearsBack and @Year AND SEASON = @Season     group by [YEAR],  SEASON
  union all
  select p.[year], Season, 'Putter' as Equip, 
  sum(case when years < 2 then 1 else 0 end) * 100.0 / sum(COUNT(*)) over (partition by [Year]) as TotalNew, 
  5 as Sort
  FROM  Consumer.[Putter] eq
  inner join Consumer.PlayerProfile p on p.PlayerProfileId = eq.PlayerProfileId 
  where COUNTRY = @Country and BRAND is not null and 
  [YEAR] between @Year - @YearsBack and @Year AND SEASON = @Season  group by [YEAR],  SEASON
  union all
  select p.[year], Season, 'Fairway Wd' as Equip, 
  sum(case when years < 2 then 1 else 0 end) * 100.0 / sum(COUNT(*)) over (partition by [Year]) as TotalNew, 
  4 as Sort
  FROM  Consumer.[Wood] eq
  inner join Consumer.PlayerProfile p on p.PlayerProfileId = eq.PlayerProfileId 
  where COUNTRY = @Country and BRAND is not null and 
  [YEAR] between @Year - @YearsBack and @Year AND SEASON = @Season    and [CLUB_CODE] <> 1 and [CLUB_CODE] <> 12  group by [YEAR],  SEASON
   union all
  select p.[year], Season, 'Bag' as Equip, 
  sum(case when years < 2 then 1 else 0 end) * 100.0 / sum(COUNT(*)) over (partition by [Year]) as TotalNew, 
  6 as Sort
  FROM  Consumer.[Bag] eq
  inner join Consumer.PlayerProfile p on p.PlayerProfileId = eq.PlayerProfileId 
  where COUNTRY = @Country and BRAND is not null and  
  [YEAR] between @Year - @YearsBack and @Year AND SEASON = @Season    group by [YEAR],  SEASON) a
  
  order by [Year] desc, Sort 


end
GO
