DROP PROCEDURE IF EXISTS [MoneyBall].[Player2];
GO

CREATE procedure [MoneyBall].[Player2]
@PlayerName varchar(40),
@PGASeason integer,
@Login varchar(20)

as
begin

set nocount on;

Select * from MoneyBall.WebsiteDataPlayer2 where PGASeason = @PGASeason and PlayerName = @PlayerName  
  

end
GO
