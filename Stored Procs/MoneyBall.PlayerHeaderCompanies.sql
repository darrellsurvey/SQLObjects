DROP PROCEDURE IF EXISTS [MoneyBall].[PlayerHeaderCompanies];
GO

Create procedure [MoneyBall].[PlayerHeaderCompanies]
@PlayerName varchar(20),
@Year integer

as

declare @Placement as integer
declare @Player1 as varchar(20)
declare @Player2 as varchar(20)

set nocount on;

SELECT @Placement = [YearRank] FROM [DARRELL_MASTER].[MoneyBall].[PlayerDSRank] p
  where p.PlayerName = @PlayerName and [YearPlayed] = @Year

if @Placement = 1 
	-- if given brand is #1 then what are brands in place 2 and 3
	begin
		SELECT @Player1 = PlayerName FROM [DARRELL_MASTER].[MoneyBall].[PlayerDSRank]
			where YearRank = @Placement + 1 and [YearPlayed] = @Year
		SELECT @Player2 = PlayerName FROM [DARRELL_MASTER].[MoneyBall].[PlayerDSRank]
			where YearRank = @Placement + 2 and [YearPlayed] = @Year
	end
else
	-- if given brand is not #1 then what are brands in one place before or after
	begin 
		SELECT @Player1 = PlayerName FROM [DARRELL_MASTER].[MoneyBall].[PlayerDSRank]
			where YearRank = @Placement - 1 and [YearPlayed] = @Year
		SELECT @Player2 = PlayerName FROM [DARRELL_MASTER].[MoneyBall].[PlayerDSRank]
			where YearRank = @Placement + 1 and [YearPlayed] = @Year
	end

select 1 as ReportPlacement, @PlayerName as Player union all
select 2 as ReportPlacement, @Player1 as Player union all
select 3 as ReportPlacement, @Player2 as Player
GO
