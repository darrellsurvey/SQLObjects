DROP PROCEDURE IF EXISTS [Consumer].[rptMultiCountry_EquipmentAge];
GO

CREATE procedure [Consumer].[rptMultiCountry_EquipmentAge]
(@CategoryQuery as Varchar(50),
@LoginId as varchar(20))

as
begin
set nocount on;

	Declare @get_column_names_only bit = 0
	if @get_column_names_only = 1 
		select 1 as [year], 'b' as [Country], 1 as Sort, 'c' as Equip, 3 as CountryAvg, 4 as WorldAvg
 
	declare @query as varchar(3000)
	Declare @CompanyId tinyint = 0
	select @CompanyId = CompanyId from DARRELL_MASTER.web.Login_info c where c.USERNAME = @LoginId

	set @query = '
;with cte_a as (
Select SurveyYear, COUNTRY, Season
 from (SELECT distinct ROW_NUMBER() over(partition by country order by country, SurveyYear desc) as n ,
			SurveyYear,COUNTRY, SeasonId as Season
			FROM Consumer.Billing
			where SeasonId = 3 '

if @CompanyId <> 75 set @query = @query + ' and CustomerId = ' + cast(@CompanyId as varchar(3))

set @query = @query + '	group by SurveyYear,COUNTRY,SeasonId) a
 where n = 1)


SELECT distinct p.[year],p.COUNTRY, 1 as sort, ''Iron'' as Equip
		,avg([YEARS]*1.0) over (partition by p.COUNTRY, p.season) as CountryAvg
		,avg([YEARS]*1.0) over () as WorldAvg
  FROM ' + consumer.EquipmentTableCase('Iron') + ' b
  inner join Consumer.PlayerProfile p on b.PlayerProfileId = p.PlayerProfileId 
  inner join cte_a  on p.[YEAR]  = cte_a.[SurveyYear] and p.SEASON = cte_a.SEASON and p.COUNTRY = cte_a.COUNTRY 
  where BRAND is not null ' + consumer.EquipmentWhereCase('Iron') + ' ' + @CategoryQuery + ' 
 Union All
SELECT distinct  p.[year],p.COUNTRY, 2 as sort, ''Putter'' as Equip
		,avg([YEARS]*1.0) over (partition by p.COUNTRY, p.season) as CountryAvg
		,avg([YEARS]*1.0) over () as WorldAvg
  FROM ' + consumer.EquipmentTableCase('Putter') + ' b
  inner join Consumer.PlayerProfile p on b.PlayerProfileId = p.PlayerProfileId 
  inner join cte_a  on p.[YEAR]  = cte_a.[SurveyYear] and p.SEASON = cte_a.SEASON and p.COUNTRY = cte_a.COUNTRY 
  where BRAND is not null ' + consumer.EquipmentWhereCase('Putter') + ' ' + @CategoryQuery + ' 
 Union All
SELECT distinct  p.[year],p.COUNTRY, 3 as sort, ''Driver'' as Equip
		,avg([YEARS]*1.0) over (partition by p.COUNTRY, p.season) as CountryAvg
		,avg([YEARS]*1.0) over () as WorldAvg
  FROM ' + consumer.EquipmentTableCase('Wood - Driver') + ' b
  inner join Consumer.PlayerProfile p on b.PlayerProfileId = p.PlayerProfileId 
  inner join cte_a  on p.[YEAR]  = cte_a.[SurveyYear] and p.SEASON = cte_a.SEASON and p.COUNTRY = cte_a.COUNTRY 
  where BRAND is not null ' + consumer.EquipmentWhereCase('Wood - Driver') + ' ' + @CategoryQuery + ' 
 Union All
SELECT distinct  p.[year],p.COUNTRY, 4 as sort, ''Fairway Wd'' as Equip
		,avg([YEARS]*1.0) over (partition by p.COUNTRY, p.season) as CountryAvg
		,avg([YEARS]*1.0) over () as WorldAvg
  FROM ' + consumer.EquipmentTableCase('Wood - Fairway') + ' b
  inner join Consumer.PlayerProfile p on b.PlayerProfileId = p.PlayerProfileId 
  inner join cte_a  on p.[YEAR]  = cte_a.[SurveyYear] and p.SEASON = cte_a.SEASON and p.COUNTRY = cte_a.COUNTRY 
  where BRAND is not null ' + consumer.EquipmentWhereCase('Wood - Fairway') + ' ' + @CategoryQuery + ' 
 Union All
SELECT distinct  p.[year],p.COUNTRY, 5 as sort, ''Hybrid'' as Equip
		,avg([YEARS]*1.0) over (partition by p.COUNTRY, p.season) as CountryAvg
		,avg([YEARS]*1.0) over () as WorldAvg
  FROM ' + consumer.EquipmentTableCase('Wood - Hybrid') + ' b
  inner join Consumer.PlayerProfile p on b.PlayerProfileId = p.PlayerProfileId 
  inner join cte_a  on p.[YEAR]  = cte_a.[SurveyYear] and p.SEASON = cte_a.SEASON and p.COUNTRY = cte_a.COUNTRY 
  where BRAND is not null ' + consumer.EquipmentWhereCase('Wood - Hybrid') + ' ' + @CategoryQuery 

		
		
print(@query)					 
execute(@query);

end;
GO
