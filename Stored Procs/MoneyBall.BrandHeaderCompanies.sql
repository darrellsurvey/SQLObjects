IF OBJECT_ID('MoneyBall.BrandHeaderCompanies') IS NOT NULL
    DROP PROCEDURE [MoneyBall].[BrandHeaderCompanies];
GO

CREATE procedure [MoneyBall].[BrandHeaderCompanies]
@Company varchar(20),
@Year integer

as

declare @Placement as integer
declare @Company1 as varchar(20)
declare @Company2 as varchar(20)

set nocount on;

SELECT @Placement = [YearRank] FROM [DARRELL_MASTER].[MoneyBall].[BrandDSRank]
  where Brand = @Company and [YearPlayed] = @Year

if @Placement = 1 
	-- if given brand is #1 then what are brands in place 2 and 3
	begin
		SELECT @Company1 = Brand FROM [DARRELL_MASTER].[MoneyBall].[BrandDSRank]
			where YearRank = @Placement + 1 and [YearPlayed] = @Year
		SELECT @Company2 = Brand FROM [DARRELL_MASTER].[MoneyBall].[BrandDSRank]
			where YearRank = @Placement + 2 and [YearPlayed] = @Year
	end
else
	-- if given brand is not #1 then what are brands in one place before or after
	begin 
		SELECT @Company1 = Brand FROM [DARRELL_MASTER].[MoneyBall].[BrandDSRank]
			where YearRank = @Placement - 1 and [YearPlayed] = @Year
		SELECT @Company2 = Brand FROM [DARRELL_MASTER].[MoneyBall].[BrandDSRank]
			where YearRank = @Placement + 1 and [YearPlayed] = @Year
	end

select 1 as ReportPlacement, @Company as Brand union all
select 2 as ReportPlacement, @Company1 as Brand union all
select 3 as ReportPlacement, @Company2 as Brand
GO
