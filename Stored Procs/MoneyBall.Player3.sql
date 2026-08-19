IF OBJECT_ID('MoneyBall.Player3') IS NOT NULL
    DROP PROCEDURE [MoneyBall].[Player3];
GO

Create procedure [MoneyBall].[Player3]
@PlayerName varchar(40),
@PGASeason integer,
@Login varchar(20)

as
begin

set nocount on;

declare @DSRank as integer
Select @DSRank = dsrank from MoneyBall.WebsiteDataPlayer1 where  PGASeason = @PGASeason and PlayerName = @PlayerName

Select * from MoneyBall.WebsiteDataPlayer1 where  PGASeason = @PGASeason and dsrank between @DSRank -4 and @DSRank+4


end
GO
