IF OBJECT_ID('MoneyBall.CompanyPlayerList') IS NOT NULL
    DROP PROCEDURE [MoneyBall].[CompanyPlayerList];
GO

CREATE procedure [MoneyBall].[CompanyPlayerList]
@LoginName varchar(20),
@PGASeason integer

as
begin

-- exec moneyball.companyplayerlist 'Callaway', 2017

declare @Company as varchar(40)
declare @UserLevel as tinyint
--declare @UserType as varchar(10)
declare @ComapnyListExists as smallint = 0

set nocount on;

SELECT @Company = Company,
		@UserLevel = 0--,
		--@UserType = UserType 
FROM [DARRELL_MASTER].[MoneyBall].[WebsiteUser] where LoginName = @LoginName

select @ComapnyListExists = COUNT(*) from MoneyBall.CompanyPlayerContract where Company = @Company and PGASeason = @PGASeason

if @ComapnyListExists > 0 
	begin
		select p1.PlayerName as name, LOWER(REPLACE(p1.PlayerName, ', ', '')) as linkname, LOWER(REPLACE(p1.PlayerName, ', ', '__')) as imagename, coalesce(cast(p1.DSRank as varchar(5)), '') as rank, coalesce(p1.DSPoints, 0) as metricvalue, 'DS (30s) x1000' as metriclabel from MoneyBall.WebsiteDataPlayer1 p1 inner join MoneyBall.CompanyPlayerContract pc 
		on p1.PlayerName = pc.PlayerName and p1.PGASeason = pc.PGASeason
		where pc.Company = @Company and pc.PGASeason = @PGASeason
		order by isnull(DSRank, 9999), p1.PlayerName
	end
else
	begin
		select p1.PlayerName as name, LOWER(REPLACE(p1.PlayerName, ', ', '')) as linkname, LOWER(REPLACE(p1.PlayerName, ', ', '__')) as imagename, coalesce(cast(p1.DSRank as varchar(5)), '') as rank, coalesce(p1.DSPoints, 0) as metricvalue, 'DS (30s) x1000' as metriclabel from MoneyBall.WebsiteDataPlayer1 p1 inner join MoneyBall.WebsiteData5 d5
		on p1.PlayerName = d5.PlayerName and p1.PGASeason = d5.PGASeason
		where d5.Brand = @Company and d5.PGASeason = @PGASeason
		order by isnull(DSRank, 9999), p1.PlayerName
	end
end
GO
