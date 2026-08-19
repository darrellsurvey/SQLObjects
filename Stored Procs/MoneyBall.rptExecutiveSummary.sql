IF OBJECT_ID('MoneyBall.rptExecutiveSummary') IS NOT NULL
    DROP PROCEDURE [MoneyBall].[rptExecutiveSummary];
GO

CREATE procedure [MoneyBall].[rptExecutiveSummary]
@Brand varchar(20),
@Equipment varchar(20),
@Year as Int,
@CheckBoxValues varchar(max)


as
begin

set nocount on;

--exec [MoneyBall].[rptExecutiveSummary] 'Ping', 'Driver', 2020, @CheckBoxValues = '''Tour;BrandTotalUse'',''Tour;BrandTotalUsePercent'',''Tour;BrandUniquePlayerUse'',''Tour;BrandUniquePlayerUsePercent'',''Tour;TournamentsWon'',''Tour;TournamentsWonPercent'',''Tour;TournamentsTop10'',''Tour;TournamentsTop10Percent'',''Tour;MoneyWon'',''Tour;MoneyYTDPercent'',''TV;DSPoints'',''TV;DSPointsPercent'',''TV;DSRankTop10'',''TV;DSRankTop25'',''TV;DSRank26to50'',''TV;DSRank51to100'',''TV;DSRank101to150'',''TV;DSRank151to200'',''Majors;DSPoints'',''Majors;DSPointsPercent'',''Majors;MoneyWon'',''Majors;MoneyWonPercent'',''Majors;TournamentsWon'',''Majors;TournamentsWonPercent'',''Majors;TournamentsTop10'',''Majors;TournamentsTop10Percent'',''Amateur;BrandTotalUse'',''Amateur;BrandTotalUsePercent'',''Amateur;BrandUniquePlayerUse'',''Amateur;BrandUniquePlayerUsePercent'',''JRAmateur;BrandTotalUse'',''JRAmateur;BrandTotalUsePercent'',''JRAmateur;BrandUniquePlayerUse'',''JRAmateur;BrandUniquePlayerUsePercent'',''NCAA;BrandTotalUse'',''NCAA;BrandTotalUsePercent'',''NCAA;BrandUniquePlayerUse'',''NCAA;BrandUniquePlayerUsePercent'',''ConsumerUSA;PercentAll'',''ConsumerUSA;PercentAllNew'',''ConsumerUSA;PercentHandicap0to5'',''ConsumerUSA;PercentHandicap6to10'',''ConsumerUSA;PercentHandicap11to20'',''ConsumerUSA;PercentHandicap21Plus'',''ConsumerUSA;PercentAgeUnder30'',''ConsumerUSA;PercentAge30to49'',''ConsumerUSA;PercentAge50Plus'',''ConsumerJapan;PercentAll'',''ConsumerJapan;PercentAllNew'',''ConsumerJapan;PercentHandicap0to5'',''ConsumerJapan;PercentHandicap6to10'',''ConsumerJapan;PercentHandicap11to20'',''ConsumerJapan;PercentHandicap21Plus'',''ConsumerJapan;PercentAgeUnder30'',''ConsumerJapan;PercentAge30to49'',''ConsumerJapan;PercentAge50Plus'',''ConsumerChina;PercentAll'',''ConsumerChina;PercentAllNew'',''ConsumerChina;PercentHandicap0to5'',''ConsumerChina;PercentHandicap6to10'',''ConsumerChina;PercentHandicap11to20'',''ConsumerChina;PercentHandicap21Plus'',''ConsumerChina;PercentAgeUnder30'',''ConsumerChina;PercentAge30to49'',''ConsumerChina;PercentAge50Plus'',''ConsumerSEA;PercentAll'',''ConsumerSEA;PercentAllNew'',''ConsumerSEA;PercentHandicap0to5'',''ConsumerSEA;PercentHandicap6to10'',''ConsumerSEA;PercentHandicap11to20'',''ConsumerSEA;PercentHandicap21Plus'',''ConsumerSEA;PercentAgeUnder30'',''ConsumerSEA;PercentAge30to49'',''ConsumerSEA;PercentAge50Plus'''
--exec [MoneyBall].[rptExecutiveSummary] 'Ping', 'Driver', 2020, @CheckBoxValues = '''Tour!BrandTotalUse'',''Tour!BrandTotalUsePercent'',''Tour!BrandUniquePlayerUse'''
--exec [MoneyBall].[rptExecutiveSummary] 'Ping', 'Driver', 2020, @CheckBoxValues = ''''''


declare @sql as nvarchar(max)
--declare @Brand varchar(25) = 'PING'
--declare @Equipment varchar(25) = 'Driver'
--declare CheckBoxValues varchar(max) = '''Tour;BrandTotalUse''','''Tour;BrandTotalUsePercent''','''Tour;BrandUniquePlayerUse''','''Tour;BrandUniquePlayerUsePercent''','''Tour;TournamentsWon''','''Tour;TournamentsWonPercent''','''Tour;TournamentsTop10''','''Tour;TournamentsTop10Percent''','''Tour;MoneyWon''','''Tour;MoneyYTDPercent''','''TV;DSPoints''','''TV;DSPointsPercent''','''TV;DSRankTop10''','''TV;DSRankTop25''','''TV;DSRank26to50''','''TV;DSRank51to100''','''TV;DSRank101to150''','''TV;DSRank151to200''','''Majors;DSPoints''','''Majors;DSPointsPercent''','''Majors;MoneyWon''','''Majors;MoneyWonPercent''','''Majors;TournamentsWon''','''Majors;TournamentsWonPercent''','''Majors;TournamentsTop10''','''Majors;TournamentsTop10Percent''','''Amateur;BrandTotalUse''','''Amateur;BrandTotalUsePercent''','''Amateur;BrandUniquePlayerUse''','''Amateur;BrandUniquePlayerUsePercent''','''JRAmateur;BrandTotalUse''','''JRAmateur;BrandTotalUsePercent''','''JRAmateur;BrandUniquePlayerUse''','''JRAmateur;BrandUniquePlayerUsePercent''','''NCAA;BrandTotalUse''','''NCAA;BrandTotalUsePercent''','''NCAA;BrandUniquePlayerUse''','''NCAA;BrandUniquePlayerUsePercent''','''ConsumerUSA;PercentAll''','''ConsumerUSA;PercentAllNew''','''ConsumerUSA;PercentHandicap0to5''','''ConsumerUSA;PercentHandicap6to10''','''ConsumerUSA;PercentHandicap11to20''','''ConsumerUSA;PercentHandicap21Plus''','''ConsumerUSA;PercentAgeUnder30''','''ConsumerUSA;PercentAge30to49''','''ConsumerUSA;PercentAge50Plus''','''ConsumerJapan;PercentAll''','''ConsumerJapan;PercentAllNew''','''ConsumerJapan;PercentHandicap0to5''','''ConsumerJapan;PercentHandicap6to10''','''ConsumerJapan;PercentHandicap11to20''','''ConsumerJapan;PercentHandicap21Plus''','''ConsumerJapan;PercentAgeUnder30''','''ConsumerJapan;PercentAge30to49''','''ConsumerJapan;PercentAge50Plus''','''ConsumerChina;PercentAll''','''ConsumerChina;PercentAllNew''','''ConsumerChina;PercentHandicap0to5''','''ConsumerChina;PercentHandicap6to10''','''ConsumerChina;PercentHandicap11to20''','''ConsumerChina;PercentHandicap21Plus''','''ConsumerChina;PercentAgeUnder30''','''ConsumerChina;PercentAge30to49''','''ConsumerChina;PercentAge50Plus''','''ConsumerSEA;PercentAll''','''ConsumerSEA;PercentAllNew''','''ConsumerSEA;PercentHandicap0to5''','''ConsumerSEA;PercentHandicap6to10''','''ConsumerSEA;PercentHandicap11to20''','''ConsumerSEA;PercentHandicap21Plus''','''ConsumerSEA;PercentAgeUnder30''','''ConsumerSEA;PercentAge30to49''','''ConsumerSEA;PercentAge50Plus''


Declare @get_column_names_only bit = 0
if @get_column_names_only = 1
SELECT 2014 as RowIndex, 1 AS HasSubLevel, 'b' as Column1, 1 AS Column2, 1 AS Column3, 1 AS Column4, 1 AS Column5, 'a' as CheckBoxValues, 'a' as DataFormat


Set @sql = '

;with cte1 as (SELECT DataBlock, [Header],[UserData], PGASeason FROM [MoneyBall].[WebsiteData14] where brand = ''' + @Brand + ''' and equipment = ''' + @Equipment + '''),
cteHeader as (
select ''Tour'' as DataBlock, ''BrandTotalUse'' as header, 5 as sort union all
select ''Tour'' as DataBlock, ''BrandTotalUsePercent'' as header, 6 as sort union all
select ''Tour'' as DataBlock, ''BrandUniquePlayerUse'' as header, 7 as sort union all
select ''Tour'' as DataBlock, ''BrandUniquePlayerUsePercent'' as header, 8 as sort union all
select ''Tour'' as DataBlock, ''TournamentsWon'' as header, 9 as sort union all
select ''Tour'' as DataBlock, ''TournamentsWonPercent'' as header, 10 as sort union all
select ''Tour'' as DataBlock, ''TournamentsTop10'' as header, 11 as sort union all
select ''Tour'' as DataBlock, ''TournamentsTop10Percent'' as header, 12 as sort union all
select ''Tour'' as DataBlock, ''MoneyWon'' as header, 13 as sort union all
select ''Tour'' as DataBlock, ''MoneyYTDPercent'' as header, 14 as sort union all
select ''TV'' as DataBlock, ''DSPoints'' as header, 16 as sort union all
select ''TV'' as DataBlock, ''DSPointsPercent'' as header, 17 as sort union all
select ''TV'' as DataBlock, ''DSRankTop10'' as header, 18 as sort union all
select ''TV'' as DataBlock, ''DSRankTop25'' as header, 20 as sort union all
select ''TV'' as DataBlock, ''DSRank26to50'' as header, 21 as sort union all
select ''TV'' as DataBlock, ''DSRank51to100'' as header, 22 as sort union all
select ''TV'' as DataBlock, ''DSRank101to150'' as header, 23 as sort union all
select ''TV'' as DataBlock, ''DSRank151to200'' as header, 24 as sort union all
select ''Majors'' as DataBlock, ''DSPoints'' as header, 25 as sort union all
select ''Majors'' as DataBlock, ''DSPointsPercent'' as header, 26 as sort union all
select ''Majors'' as DataBlock, ''MoneyWon'' as header, 27 as sort union all
select ''Majors'' as DataBlock, ''MoneyWonPercent'' as header, 28 as sort union all
select ''Majors'' as DataBlock, ''TournamentsWon'' as header, 29 as sort union all
select ''Majors'' as DataBlock, ''TournamentsWonPercent'' as header, 30 as sort union all
select ''Majors'' as DataBlock, ''TournamentsTop10'' as header, 31 as sort union all
select ''Majors'' as DataBlock, ''TournamentsTop10Percent'' as header, 32 as sort union all
select ''Amateur'' as DataBlock, ''BrandTotalUse'' as header, 34 as sort union all
select ''Amateur'' as DataBlock, ''BrandTotalUsePercent'' as header, 35 as sort union all
select ''Amateur'' as DataBlock, ''BrandUniquePlayerUse'' as header, 36 as sort union all
select ''Amateur'' as DataBlock, ''BrandUniquePlayerUsePercent'' as header, 37 as sort union all
select ''JRAmateur'' as DataBlock, ''BrandTotalUse'' as header, 39 as sort union all
select ''JRAmateur'' as DataBlock, ''BrandTotalUsePercent'' as header, 40 as sort union all
select ''JRAmateur'' as DataBlock, ''BrandUniquePlayerUse'' as header, 41 as sort union all
select ''JRAmateur'' as DataBlock, ''BrandUniquePlayerUsePercent'' as header, 42 as sort union all
select ''NCAA'' as DataBlock, ''BrandTotalUse'' as header, 44 as sort union all
select ''NCAA'' as DataBlock, ''BrandTotalUsePercent'' as header, 45 as sort union all
select ''NCAA'' as DataBlock, ''BrandUniquePlayerUse'' as header, 46 as sort union all
select ''NCAA'' as DataBlock, ''BrandUniquePlayerUsePercent'' as header, 47 as sort union all
select ''ConsumerUSA'' as DataBlock, ''PercentAll'' as header, 49 as sort union all
select ''ConsumerUSA'' as DataBlock, ''PercentAllNew'' as header, 50 as sort union all
select ''ConsumerUSA'' as DataBlock, ''PercentHandicap0to5'' as header, 51 as sort union all
select ''ConsumerUSA'' as DataBlock, ''PercentHandicap6to10'' as header, 52 as sort union all
select ''ConsumerUSA'' as DataBlock, ''PercentHandicap11to20'' as header, 53 as sort union all
select ''ConsumerUSA'' as DataBlock, ''PercentHandicap21Plus'' as header, 54 as sort union all
select ''ConsumerUSA'' as DataBlock, ''PercentAgeUnder30'' as header, 55 as sort union all
select ''ConsumerUSA'' as DataBlock, ''PercentAge30to49'' as header, 56 as sort union all
select ''ConsumerUSA'' as DataBlock, ''PercentAge50Plus'' as header, 57 as sort union all
select ''ConsumerJapan'' as DataBlock, ''PercentAll'' as header, 59 as sort union all
select ''ConsumerJapan'' as DataBlock, ''PercentAllNew'' as header, 60 as sort union all
select ''ConsumerJapan'' as DataBlock, ''PercentHandicap0to5'' as header, 61 as sort union all
select ''ConsumerJapan'' as DataBlock, ''PercentHandicap6to10'' as header, 62 as sort union all
select ''ConsumerJapan'' as DataBlock, ''PercentHandicap11to20'' as header, 63 as sort union all
select ''ConsumerJapan'' as DataBlock, ''PercentHandicap21Plus'' as header, 64 as sort union all
select ''ConsumerJapan'' as DataBlock, ''PercentAgeUnder30'' as header, 65 as sort union all
select ''ConsumerJapan'' as DataBlock, ''PercentAge30to49'' as header, 66 as sort union all
select ''ConsumerJapan'' as DataBlock, ''PercentAge50Plus'' as header, 67 as sort union all
select ''ConsumerChina'' as DataBlock, ''PercentAll'' as header, 69 as sort union all
select ''ConsumerChina'' as DataBlock, ''PercentAllNew'' as header, 70 as sort union all
select ''ConsumerChina'' as DataBlock, ''PercentHandicap0to5'' as header, 71 as sort union all
select ''ConsumerChina'' as DataBlock, ''PercentHandicap6to10'' as header, 72 as sort union all
select ''ConsumerChina'' as DataBlock, ''PercentHandicap11to20'' as header, 73 as sort union all
select ''ConsumerChina'' as DataBlock, ''PercentHandicap21Plus'' as header, 74 as sort union all
select ''ConsumerChina'' as DataBlock, ''PercentAgeUnder30'' as header, 75 as sort union all
select ''ConsumerChina'' as DataBlock, ''PercentAge30to49'' as header, 76 as sort union all
select ''ConsumerChina'' as DataBlock, ''PercentAge50Plus'' as header, 77 as sort union all
select ''ConsumerSEA'' as DataBlock, ''PercentAll'' as header, 79 as sort union all
select ''ConsumerSEA'' as DataBlock, ''PercentAllNew'' as header, 80 as sort union all
select ''ConsumerSEA'' as DataBlock, ''PercentHandicap0to5'' as header, 81 as sort union all
select ''ConsumerSEA'' as DataBlock, ''PercentHandicap6to10'' as header, 82 as sort union all
select ''ConsumerSEA'' as DataBlock, ''PercentHandicap11to20'' as header, 83 as sort union all
select ''ConsumerSEA'' as DataBlock, ''PercentHandicap21Plus'' as header, 84 as sort union all
select ''ConsumerSEA'' as DataBlock, ''PercentAgeUnder30'' as header, 85 as sort union all
select ''ConsumerSEA'' as DataBlock, ''PercentAge30to49'' as header, 86 as sort union all
select ''ConsumerSEA'' as DataBlock, ''PercentAge50Plus'' as header, 87 as sort
),

cte_final as (
SELECT sort as RowIndex, 
		Case h.DataBlock 
			when ''Tour'' then ''PGA Usage''
			when ''TV'' then ''Brand Impressions''
			when ''JRAmateur'' then ''Amateur - Junior''
			when ''NCAA'' then ''Amateur - NCAA''
			when ''ConsumerUSA'' then ''Consumer - USA''
			when ''ConsumerJapan'' then ''Consumer - Japan''
			when ''ConsumerChina'' then ''Consumer - China''
			when ''ConsumerSEA'' then ''Consumer - SEA''
			else h.DataBlock
		end as HasSubLevel, 
		f.WebsiteHeader as Column1,
		y1.UserData as Column2, 
		y2.UserData as Column3, 
		y3.UserData as Column4, 
		y4.UserData as Column5,
		h.DataBlock + ''!'' + h.Header as CheckBoxValue,
		DataFormat
FROM cteHeader h 
inner join MoneyBall.WebsiteFormat f on DatabaseHeader = h.Header 
Left join (SELECT DataBlock, [Header],[UserData] FROM cte1 where PGASeason = ' + cast(@Year as char(4)) + ') y1 on h.header = y1.header and h.DataBlock = y1.DataBlock
Left join (SELECT DataBlock, [Header],[UserData] FROM cte1 where PGASeason = ' + cast(@Year - 1 as char(4))  + ') y2 on h.header = y2.header and h.DataBlock = y2.DataBlock
Left join (SELECT DataBlock, [Header],[UserData] FROM cte1 where PGASeason = ' + cast(@Year - 2 as char(4))  + ') y3 on h.header = y3.header and h.DataBlock = y3.DataBlock
Left join (SELECT DataBlock, [Header],[UserData] FROM cte1 where PGASeason = ' + cast(@Year - 3 as char(4))  + ') y4 on h.header = y4.header and h.DataBlock = y4.DataBlock
where h.DataBlock + ''!'' + h.Header not in (' + @CheckBoxValues + ')
)

select 4 as RowIndex, '''' as HasSubLevel, '''' as Column1, ''' + cast(@Year as char(4))  + ''' as Column2, ''' + cast(@Year - 1 as char(4))  + ''' as Column3, ''' + cast(@Year - 2 as char(4))  + ''' as Column4, ''' + cast(@Year - 3 as char(4))  + ''' as Column5, '''' as CheckBoxValue, ''##'' as DataFormat union all
SELECT * from cte_final where HasSubLevel = ''PGA Usage'' union all
--select 15 as RowIndex, '''' as HasSubLevel, ''Brand Impressions'' as Column1, '''' as Column2, '''' as Column3, '''' as Column4, '''' as Column5, '''' as CheckBoxValue union all
SELECT * from cte_final where HasSubLevel = ''Brand Impressions'' union all
--select 24 as RowIndex, '''' as HasSubLevel, ''Majors'' as Column1, '''' as Column2, '''' as Column3, '''' as Column4, '''' as Column5, '''' as CheckBoxValue union all
SELECT * from cte_final where HasSubLevel = ''Majors'' union all
--select 33 as RowIndex, '''' as HasSubLevel, ''Amateur'' as Column1, '''' as Column2, '''' as Column3, '''' as Column4, '''' as Column5, '''' as CheckBoxValue union all
SELECT * from cte_final where HasSubLevel = ''Amateur'' union all
--select 38 as RowIndex, '''' as HasSubLevel, ''Amateur - Junior'' as Column1, '''' as Column2, '''' as Column3, '''' as Column4, '''' as Column5, '''' as CheckBoxValue union all
SELECT * from cte_final where HasSubLevel = ''Amateur - Junior'' union all
--select 43 as RowIndex, '''' as HasSubLevel, ''Amateur - NCAA'' as Column1, '''' as Column2, '''' as Column3, '''' as Column4, '''' as Column5, '''' as CheckBoxValue union all
SELECT * from cte_final where HasSubLevel = ''Amateur - NCAA'' union all
--select 48 as RowIndex, '''' as HasSubLevel, ''Consumer - USA'' as Column1, '''' as Column2, '''' as Column3, '''' as Column4, '''' as Column5, '''' as CheckBoxValue union all
SELECT * from cte_final where HasSubLevel = ''Consumer - USA'' union all
--select 58 as RowIndex, '''' as HasSubLevel, ''Consumer - Japan'' as Column1, '''' as Column2, '''' as Column3, '''' as Column4, '''' as Column5, '''' as CheckBoxValue union all
SELECT * from cte_final where HasSubLevel = ''Consumer - Japan'' union all
--select 68 as RowIndex, '''' as HasSubLevel, ''Consumer - China'' as Column1, '''' as Column2, '''' as Column3, '''' as Column4, '''' as Column5, '''' as CheckBoxValue union all
SELECT * from cte_final where HasSubLevel = ''Consumer - China'' union all
--select 78 as RowIndex, '''' as HasSubLevel, ''Consumer - SEA'' as Column1, '''' as Column2, '''' as Column3, '''' as Column4, '''' as Column5, '''' as CheckBoxValue union all
SELECT * from cte_final where HasSubLevel = ''Consumer - SEA''
order by RowIndex'



--print @Finalsql

--select len(@Finalsql)

execute sp_executesql @sql;

  
end
GO
