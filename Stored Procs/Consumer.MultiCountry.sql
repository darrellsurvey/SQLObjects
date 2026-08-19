IF OBJECT_ID('Consumer.MultiCountry') IS NOT NULL
    DROP PROCEDURE [Consumer].[MultiCountry];
GO

CREATE procedure [Consumer].[MultiCountry]
(@Equip as varchar(25),
@CategoryQuery as Varchar(50),
@LoginId as varchar(20))
as
begin
set nocount on;

	Declare @get_column_names_only bit = 0
	if @get_column_names_only = 1 
		select 1 as [year], 'b' as [Country], 'c' as Brand, 2 as BrandTotal, 3 as BrandTotalPercent
 
	declare @query as varchar(1000)
	Declare @CompanyId tinyint = 0
	select @CompanyId = CompanyId from DARRELL_MASTER.web.Login_info c where c.USERNAME = @LoginId
	
	
	set @query = '
;with cte_a as (
Select SurveyYear, COUNTRY, Season
 from (SELECT distinct ROW_NUMBER() over(partition by country order by country, SurveyYear desc) as n ,
			SurveyYear,COUNTRY, SeasonId as Season
			FROM Consumer.Billing
			where SeasonId > 1 '

if @CompanyId <> 75 set @query = @query + ' and CustomerId = ' + cast(@CompanyId as varchar(3))

set @query = @query + '	group by SurveyYear,COUNTRY,SeasonId) a
 where n = 1)



SELECT  p.[year]
		,p.COUNTRY
		,[BRAND]
		,COUNT ([BRAND]) as BrandTotal
		,COUNT ([BRAND]) * 100.0 / SUM(COUNT ([BRAND])) over (partition by p.[year],p.COUNTRY, p.season) as BrandTotalPercent
  FROM ' + consumer.EquipmentTableCase(@equip) + ' b
  inner join Consumer.PlayerProfile p on b.PlayerProfileId = p.PlayerProfileId 
  inner join cte_a  on p.[YEAR]  = cte_a.[SurveyYear] and p.SEASON = cte_a.SEASON and p.COUNTRY = cte_a.COUNTRY 
  where BRAND is not null ' + consumer.EquipmentWhereCase(@equip) + ' '+ @CategoryQuery + '
  group by p.[year]
		,p.COUNTRY
		,p.season
		,[BRAND]'
		
		
print(@query)					 
execute(@query);

end;
GO
