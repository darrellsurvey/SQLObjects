DROP PROCEDURE IF EXISTS [Consumer].[spGetEquipment];
GO

create procedure Consumer.spGetEquipment
(@LoginId as varchar(15) = '')
as begin
set nocount on;

select * from Consumer.Equipment 

end
GO
