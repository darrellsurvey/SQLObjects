IF OBJECT_ID('Search.EquipmentTableCase') IS NOT NULL
    DROP PROCEDURE [Search].[EquipmentTableCase];
GO

CREATE PROCEDURE [Search].[EquipmentTableCase]
	(@Equipment nvarchar(20),
	 @Case nvarchar(MAX) OUTPUT)
AS
begin
	SET NOCOUNT ON;

	DECLARE @query AS nvarchar(MAX) = ' dbo.'
			

if @Equipment = 'Ball' SET @query = @query + '[Ball] '
if @Equipment = 'Iron' SET @query = @query + '[Irons] '
if @Equipment = 'Iron - Utility' SET @query = @query + '[Irons] '
if @Equipment = 'Wedge' SET @query = @query + '[Wedges] '
if @Equipment = 'Wood - All' SET @query = @query + '[Woods] '
if @Equipment = 'Wood - Driver' SET @query = @query + '[Woods] '
if @Equipment = 'Wood - Fairway' SET @query = @query + '[Woods] '
if @Equipment = 'Wood - 3 wood' SET @query = @query + '[Woods] '
if @Equipment = 'Wood - Hybrid' SET @query = @query + '[Woods] '
if @Equipment = 'Putter' SET @query = @query + '[Putters] '
if @Equipment = 'Bag' SET @query = @query + '[Bag]'
if @Equipment = 'Glove' SET @query = @query + '[Gloves] '
if @Equipment = 'Headgear' SET @query = @query + '[Headgear] '
if @Equipment = 'Shoe' SET @query = @query + '[Shoes] '
if @Equipment = 'Shirt' SET @query = @query + '[Shirts] '
if @Equipment = 'Spikes' SET @query = @query + '[Spikes] '	
if @Equipment = 'Shaft - Iron' SET @query = @query + '[Shaft_Iron] '
if @Equipment = 'Shaft - Utility Iron' SET @query = @query + '[Shaft_Iron] '
if @Equipment = 'Shaft - Wedge' SET @query = @query + '[Shaft_Wedge] '
if @Equipment = 'Shaft - Wood' SET @query = @query + '[Shaft_Wood] '
if @Equipment = 'Shaft - Driver' SET @query = @query + '[Shaft_Wood] '
if @Equipment = 'Shaft - Fairway' SET @query = @query + '[Shaft_Wood] '
if @Equipment = 'Shaft - Hybrid' SET @query = @query + '[Shaft_Wood] '
if @Equipment = 'Grip - Iron' SET @query = @query + '[Grip_Iron] '
if @Equipment = 'Grip - Wood' SET @query = @query + '[Grip_Wood] '
if @Equipment = 'Grip - Driver' SET @query = @query + '[Grip_Wood] '
if @Equipment = 'Grip - Fairway' SET @query = @query + '[Grip_Wood] '
if @Equipment = 'Grip - Hybrid' SET @query = @query + '[Grip_Wood] '
if @Equipment = 'Grip - Putter' SET @query = @query + '[Grips] '
if @Equipment = 'Rangefinder' SET @query = @query + '[RangefindersPlayer] '
		
Set @case = @query + ' as bb '
	
END
GO
