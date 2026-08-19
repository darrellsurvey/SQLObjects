IF OBJECT_ID('Consumer.spGetEquipment') IS NOT NULL
    DROP PROCEDURE [Consumer].[spGetEquipment];
GO

create procedure Consumer.spGetEquipment
(@LoginId as varchar(15) = '')
as begin
set nocount on;

select * from Consumer.Equipment 

end
GO
