DROP PROCEDURE IF EXISTS [Consumer].[rptNewTotal];
GO

CREATE procedure [Consumer].[rptNewTotal]
@Country varchar(20),
@Equipment varchar(20),
@NewNumber as bit = 1,
@TotalNumber as Bit = 1,
@Year as varchar(500),
@Model as bit = 0


as
begin

set nocount on;

declare @sql as nvarchar(max)
declare @sqlBegin as nvarchar(max)
declare @sqlNew as nvarchar(max)
declare @sqlTotal as nvarchar(max)
declare @Finalsql as nvarchar(max)

Declare @get_column_names_only bit = 0
if @get_column_names_only = 1
SELECT 2014 as [YEAR], 1 AS [SEASON], 'b' as [BRAND], 'c' AS TotalType,
	1 as Total,
	1 as Male, 1 as Female,
	1 as Age1, 1 as Age2, 1 as Age3, 1 as Age4, 1 as Age5, 1 as Age6,
	1 as Handicap1, 1 as Handicap2, 1 as Handicap3, 1 as Handicap4, 1 as Handicap5,
	1 as FrequencyCourse1, 1 as FrequencyCourse2, 1 as FrequencyCourse3, 1 as FrequencyCourse4, 1 as FrequencyCourse5, 1 as FrequencyCourse6,
	1 as FrequencyRange1, 1 as FrequencyRange2, 1 as FrequencyRange3, 1 as FrequencyRange4,	1 as FrequencyRange5, 1 as FrequencyRange6,
	1 as YearsOfExperience1, 1 as YearsOfExperience2, 1 as YearsOfExperience3, 1 as YearsOfExperience4, 1 as YearsOfExperience5, 1 as YearsOfExperience6,
	1 as Course, 1 as DrivingRange


Set @sqlBegin = ' SELECT [YEAR], [SEASON], '
if @Model = 1
	Set @sqlBegin = @sqlBegin + ' isnull([model], ''unspec.'')  + '' ('' + [BRAND] + '')'' as '


Set @sql = ' count(*) as Total,
	sum(case when [Sex] = 1 then 1 else 0 end) as Male,
	sum(case when [Sex] = 2 then 1 else 0 end) as Female,
	sum(case when [Age] = 1 then 1 else 0 end) as Age1,
	sum(case when [Age] = 2 then 1 else 0 end) as Age2,
	sum(case when [Age] = 3 then 1 else 0 end) as Age3,
	sum(case when [Age] = 4 then 1 else 0 end) as Age4,
	sum(case when [Age] = 5 then 1 else 0 end) as Age5,
	sum(case when [Age] = 6 then 1 else 0 end) as Age6,
	sum(case when [Handicap] < 6 then 1 else 0 end) as Handicap1,
	sum(case when [Handicap] between 6 and 10 then 1 else 0 end) as Handicap2,
	sum(case when [Handicap] between 11 and 15 then 1 else 0 end) as Handicap3,
	sum(case when [Handicap] between 16 and 20 then 1 else 0 end) as Handicap4,
	sum(case when [Handicap] > 20 then 1 else 0 end) as Handicap5,
	sum(case when OFTEN_PLAY  = 1 then 1 else 0 end) as FrequencyCourse1,
	sum(case when OFTEN_PLAY  = 2 then 1 else 0 end) as FrequencyCourse2,
	sum(case when OFTEN_PLAY  = 3 then 1 else 0 end) as FrequencyCourse3,
	sum(case when OFTEN_PLAY  = 4 then 1 else 0 end) as FrequencyCourse4,
	sum(case when OFTEN_PLAY  = 5 then 1 else 0 end) as FrequencyCourse5,
	sum(case when OFTEN_PLAY  = 6 then 1 else 0 end) as FrequencyCourse6,
	sum(case when OFTEN_PLAY_DR  = 1 then 1 else 0 end) as FrequencyRange1,
	sum(case when OFTEN_PLAY_DR  = 2 then 1 else 0 end) as FrequencyRange2,
	sum(case when OFTEN_PLAY_DR  = 3 then 1 else 0 end) as FrequencyRange3,
	sum(case when OFTEN_PLAY_DR  = 4 then 1 else 0 end) as FrequencyRange4,
	sum(case when OFTEN_PLAY_DR  = 5 then 1 else 0 end) as FrequencyRange5,
	sum(case when OFTEN_PLAY_DR  = 6 then 1 else 0 end) as FrequencyRange6,
	sum(case when LONG_PLAYED  = 1 then 1 else 0 end) as YearsOfExperience1,
	sum(case when LONG_PLAYED  = 2 then 1 else 0  end) as YearsOfExperience2,
	sum(case when LONG_PLAYED  = 3 then 1 else 0  end) as YearsOfExperience3,
	sum(case when LONG_PLAYED  = 4 then 1 else 0  end) as YearsOfExperience4,
	sum(case when LONG_PLAYED  = 5 then 1 else 0  end) as YearsOfExperience5,
	sum(case when LONG_PLAYED  = 6 then 1 else 0  end) as YearsOfExperience6,
	sum(case when COURSE  = 1 then 1 else 0 end) as Course,
	sum(case when COURSE  = 2 then 1 else 0 end) as DrivingRange
  FROM ' + [DARRELL_MASTER].Consumer.EquipmentTableCase(@Equipment) + ' eq
  inner join Consumer.PlayerProfile p
  on p.PlayerProfileId = eq.PlayerProfileId 
  where COUNTRY = ''' + @Country + ''' and BRAND is not null and (' + @Year + ') ' 
 -- if @Model = 1
	--Set @sql = @sql + ' and Model is not null '
  
  Set @sql = @sql + [DARRELL_MASTER].Consumer.EquipmentWhereCase(@Equipment);
  
	
if @NewNumber = 1 
		set @sqlNew = @sqlBegin + ' [BRAND], ''New'' AS TotalType, ' + @sql + ' and eq.YEARS < 2 group by [YEAR], SEASON, [BRAND] '
if @TotalNumber = 1 
		set @sqlTotal = @sqlBegin + ' [BRAND], ''Total'' AS TotalType, ' +  @sql + ' group by [YEAR],  SEASON, [BRAND] '

If @Model = 1
	begin
		set @sqlNew = @sqlNew + ', isnull([model], ''unspec.'') '
		set @sqlTotal = @sqlTotal + ', isnull([model], ''unspec.'') '
	end

if @NewNumber = 1 and @TotalNumber = 1
	set @Finalsql = @sqlNew + ' union all ' + @sqlTotal
if @TotalNumber = 0    
	set @Finalsql = @sqlNew
if @NewNumber = 0  
	set @Finalsql = @sqlTotal

print @Finalsql

--select len(@Finalsql)

execute sp_executesql @Finalsql;

  
end
GO
