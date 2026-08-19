DROP PROCEDURE IF EXISTS [MoneyBall].[Player1];
GO

CREATE procedure [MoneyBall].[Player1]
@PlayerName varchar(40),
@PGASeason integer,
@Login varchar(20)

as
begin

set nocount on;

Select * from MoneyBall.WebsiteDataPlayer1 where PGASeason = @PGASeason and PlayerName = @PlayerName  
  

end
GO
