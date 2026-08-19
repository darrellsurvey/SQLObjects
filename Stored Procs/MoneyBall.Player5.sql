IF OBJECT_ID('MoneyBall.Player5') IS NOT NULL
    DROP PROCEDURE [MoneyBall].[Player5];
GO

Create procedure [MoneyBall].[Player5]
@PlayerName varchar(40),
@PGASeason integer,
@Login varchar(20)

as
begin

set nocount on;

Select * from MoneyBall.WebsiteDataPlayerTourEquipment where PGASeason = @PGASeason and PlayerName = @PlayerName  
  

end
GO
