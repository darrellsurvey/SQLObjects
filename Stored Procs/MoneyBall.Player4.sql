DROP PROCEDURE IF EXISTS [MoneyBall].[Player4];
GO

CREATE procedure [MoneyBall].[Player4]
@PlayerName varchar(40),
@PGASeason integer,
@Login varchar(20)

as
begin

set nocount on;

Select * from MoneyBall.WebsiteDataPlayer4 where PGASeason = @PGASeason and PlayerName = @PlayerName  
  

end
GO
