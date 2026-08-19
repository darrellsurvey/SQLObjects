IF OBJECT_ID('MoneyBall.SponsoredPlayerOld') IS NOT NULL
    DROP FUNCTION [MoneyBall].[SponsoredPlayerOld];
GO

CREATE FUNCTION [MoneyBall].[SponsoredPlayer]
                 ( @Company varchar(50), @PGASeason integer)
RETURNS table
AS
RETURN (
select * from (
select distinct PlayerName, PGAseason from MoneyBall.CompanyPlayerContract where PGASeason = 2017 and Company = @Company union 
select distinct PlayerName, PGAseason from MoneyBall.WebsiteData5 where PGASeason <> 2017 and Brand = @Company) a where PGASeason = @PGASeason
);
GO
