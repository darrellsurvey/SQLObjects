DROP FUNCTION IF EXISTS [Consumer].[EquipmentWhereCase];
GO

CREATE function [Consumer].[EquipmentWhereCase] (@Equipment nvarchar(20))
returns varchar(50)
with execute as caller
as
begin
	DECLARE @query AS nvarchar(50) = ' '
			
	if @Equipment = 'Wedge' SET @query = @query + ' and [CLUB_CODE] <> ''PW'''
	if @Equipment in ('Wood - Driver', 'Shaft - Driver') SET @query = @query + ' and [CLUB_CODE] = 1 '
	if @Equipment in ('Wood - Fairway', 'Shaft - Fairway') SET @query = @query + ' and [CLUB_CODE] <> 1 and [CLUB_CODE] <> 12 '
	if @Equipment in ('Wood - Hybrid', 'Shaft - Hybrid') SET @query = @query + ' and [CLUB_CODE] = 12 '
		
return @query
	
END;
GO
