IF OBJECT_ID('MoneyBall.Fill_WebsiteDataPlayer9Caddie') IS NOT NULL
    DROP PROCEDURE [MoneyBall].[Fill_WebsiteDataPlayer9Caddie];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	
-- =============================================

Create procedure [MoneyBall].[Fill_WebsiteDataPlayer9Caddie]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS
Begin -- WebsiteDataPlayer9Caddie
Print 'Begin WebsiteDataPlayer9Caddie';
	
delete from MoneyBall.WebsiteDataPlayer9Caddie where PGASeason = @PGASeason and SportTourId = @SportTourId


begin tran
insert into MoneyBall.WebsiteDataPlayer9Caddie (PGASeason, PlayerName, TournamentId, Equipment, Brand, SportTourId) 
select  PGASeason, PlayerName, TournamentId, 'Shirt' as Equipment, Brand, @SportTourId from dbo.[Shirts] where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and TOUR = @Tour

commit tran

Print 'Finished WebsiteDataPlayer9';
end  -- WebsiteDataPlayer9
GO
