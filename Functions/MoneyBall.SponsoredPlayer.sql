DROP FUNCTION IF EXISTS [MoneyBall].[SponsoredPlayer];
GO

create FUNCTION [MoneyBall].[SponsoredPlayer]
                 (@Company varchar(50), @PGASeason integer, @Majors bit)
RETURNS @SponsoredPlayer table(PlayerName varchar(50), PGASeason int)
AS
begin

	if @Majors = 0
		begin
			if @Company = 'NIKE'
				begin
					insert into @SponsoredPlayer select * from (
						select distinct PlayerName, PGAseason from MoneyBall.CompanyPlayerContract where PGASeason = 2017 and Company = @Company union 
						select distinct PlayerName, PGAseason from MoneyBall.WebsiteData5 where PGASeason <> 2017 and Brand = @Company union
						select distinct PlayerName, PGAseason from MoneyBall.WebsiteDataPlayer1 WHERE DSRank < 26 AND PGASeason = @PGASeason) a 
					where PGASeason = @PGASeason
				end
			else
				begin
					insert into @SponsoredPlayer select * from (
						select distinct PlayerName, PGAseason from MoneyBall.WebsiteData5 where PGASeason = @PGASeason and Brand = @Company union
						select distinct PlayerName, PGAseason from MoneyBall.WebsiteDataPlayer1 WHERE DSRank < 26 AND PGASeason = @PGASeason) a 
					where PGASeason = @PGASeason
				end
		end
	else
		begin
			if @Company = 'NIKE'
				begin 
					insert into @SponsoredPlayer select * from (
						select distinct PlayerName, PGAseason from MoneyBall.CompanyPlayerContract where PGASeason = 2017 and Company = @Company union 
						select distinct PlayerName, PGAseason from MoneyBall.WebsiteData5 where PGASeason <> 2017 and Brand = @Company union
						select distinct PlayerName, PGAseason from MoneyBall.WebsiteDataPlayer1Majors WHERE DSRank < 26 AND PGASeason = @PGASeason) a 
					where PGASeason = @PGASeason
				end
			else
				begin
					insert into @SponsoredPlayer select * from (
						select distinct PlayerName, PGAseason from MoneyBall.WebsiteData5 where PGASeason = @PGASeason and Brand = @Company union
						select distinct PlayerName, PGAseason from MoneyBall.WebsiteDataPlayer1Majors WHERE DSRank < 26 AND PGASeason = @PGASeason) a 
					where PGASeason = @PGASeason
				end		
	end
	return
end
GO
