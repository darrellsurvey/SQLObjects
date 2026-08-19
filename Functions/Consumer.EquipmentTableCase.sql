DROP FUNCTION IF EXISTS [Consumer].[EquipmentTableCase];
GO

CREATE function [Consumer].[EquipmentTableCase] 
(
@Equipment varchar(20)
--,@Country varchar(20)
)
returns varchar(30)
with execute as caller
AS
begin
	DECLARE @query AS nvarchar(MAX) = ' Consumer.['

	if @Equipment in ('Ball', 'Iron', 'Wedge', 'Putter', 'Bag', 'Glove', 'Headgear', 'Wood', 'Shoe', 'Shirt') 
		SET @query = @query + @Equipment + ']'

	if @Equipment in ('Wood - All', 'Wood - Driver', 'Wood - Fairway', 'Wood - Hybrid')
		SET @query = @query + 'Wood]'

	if @Equipment = 'Shaft - Iron' 
		begin
			--if @Country = 'USA' or @Country = 'Japan' 
			--	begin 
			--		SET @query = @query + 'IronShaftSteel]'
			--	end
			--else
			--	begin
					SET @query = @query + 'IronShaft]'
				--end
		end

	if @Equipment in ('Shaft - Wood', 'Shaft - Driver', 'Shaft - Fairway', 'Shaft - Hybrid')
		SET @query = @query + 'WoodShaft]'
		
	return @query
	
END
GO
