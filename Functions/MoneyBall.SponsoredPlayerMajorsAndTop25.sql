DROP FUNCTION IF EXISTS [MoneyBall].[SponsoredPlayerMajorsAndTop25];
GO

Create FUNCTION [MoneyBall].[SponsoredPlayerMajorsAndTop25]
                 ( @Company varchar(50), @PGASeason integer)
RETURNS table
AS
RETURN (
select * from (
select distinct PlayerName, PGAseason from MoneyBall.CompanyPlayerContract where PGASeason = 2017 and Company = @Company union 
select distinct PlayerName, PGAseason from MoneyBall.WebsiteData5 where PGASeason <> 2017 and Brand = @Company union
select distinct PlayerName, PGAseason from MoneyBall.WebsiteDataPlayer1Majors WHERE DSRank < 26 AND PGASeason = @PGASeason) a where PGASeason = @PGASeason
);
GO
