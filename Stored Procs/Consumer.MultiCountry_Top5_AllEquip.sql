IF OBJECT_ID('Consumer.MultiCountry_Top5_AllEquip') IS NOT NULL
    DROP PROCEDURE [Consumer].[MultiCountry_Top5_AllEquip];
GO

CREATE procedure [Consumer].[MultiCountry_Top5_AllEquip]
(@LoginId as varchar(20))
as
begin
set nocount on;

	Declare @get_column_names_only bit = 0
	if @get_column_names_only = 1 
		select 'a' as CountryText, 1 as [YEAR], 'c' as COUNTRY, 2 as Season, 3 as ColumnNumber
 
	declare @query as varchar(2000)
	Declare @CompanyId tinyint = 0
	select @CompanyId = CompanyId from DARRELL_MASTER.web.Login_info c where c.USERNAME = @LoginId
	
	
	set @query = '
;with cte_latest as (
Select SurveyYear, COUNTRY, Season
 from (SELECT distinct ROW_NUMBER() over(partition by country order by country, SurveyYear desc) as n ,
			SurveyYear,COUNTRY, SeasonId as Season
			FROM Consumer.Billing 
			Where SEASONid >1 '
if @CompanyId <> 75 set @query = @query + ' and CustomerId = ' + cast(@CompanyId as varchar(3))

set @query = @query + '	group by SurveyYear,COUNTRY,SeasonId) a
 where n = 1)

		
select cast([SurveyYear] as CHAR(4)) + '' - '' + COUNTRY +
case when season = 1 and country = ''USA'' then '' - Winter''
	 when season = 3 and country = ''USA'' then '' - Summer''
	 else ''''
end as CountryText, 
SurveyYear as [YEAR], COUNTRY, Season,
(ROW_NUMBER() over (order by COUNTRY, [SurveyYear] desc, season) + 1) % 2 as ColumnNumber
from cte_latest 
order by COUNTRY, [SurveyYear] desc, season '
		
print(@query)					 
execute(@query);

end;
GO
