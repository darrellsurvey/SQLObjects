DROP PROCEDURE IF EXISTS [Search].[EquipmentWhereCase];
GO

CREATE PROCEDURE [Search].[EquipmentWhereCase]
	(@Equipment nvarchar(20),
	 @Case nvarchar(MAX) OUTPUT)
AS
begin
	SET NOCOUNT ON;

	DECLARE @query AS nvarchar(MAX) = ' '
			

if @Equipment = 'Ball' SET @query = @query + ' where '
if @Equipment = 'Iron' SET @query = @query + ' where ISSET = 1 and '
if @Equipment = 'Iron - Utility' SET @query = @query + ' where [CLUB NUMBER] LIKE ''%^%'' and '
if @Equipment = 'Wedge' SET @query = @query + ' where [CLUB NUMBER] <> ''PW'' and '
if @Equipment = 'Wood - All' SET @query = @query + ' where '
if @Equipment = 'Wood - Driver' SET @query = @query + ' where isdriver = 1 and '
if @Equipment = 'Wood - Fairway' SET @query = @query + ' where isdriver <> 1 and [CLUB NUMBER] <> ''HYBRID'' and '
if @Equipment = 'Wood - Hybrid' SET @query = @query + ' where [CLUB NUMBER] = ''HYBRID'' and '
if @Equipment = 'Wood - 3 wood' SET @query = @query + ' where [CLUB NUMBER] in (''3'', ''3STRONG'') and '
if @Equipment = 'Putter' SET @query = @query + ' where '
if @Equipment = 'Bag' SET @query = @query + ' where '
if @Equipment = 'Glove' SET @query = @query + ' where '
if @Equipment = 'Headgear' SET @query = @query + ' where '
if @Equipment = 'Shoe' SET @query = @query + ' where '
if @Equipment = 'Shirt' SET @query = @query + ' where '
if @Equipment = 'Spikes' SET @query = @query + ' where '	
if @Equipment = 'Shaft - Iron' SET @query = @query + ' where BRAND <> ''-'' and SPEC_FLAG = 1 and '
if @Equipment = 'Shaft - Wedge' SET @query = @query + ' where '
if @Equipment = 'Shaft - Utility Iron' SET @query = @query + ' where BRAND <> ''-'' and [Club Number] like ''%^%'' and '
if @Equipment = 'Shaft - Wood' SET @query = @query + ' where '
if @Equipment = 'Shaft - Driver' SET @query = @query + ' where SPEC_FLAG = 1 and '
if @Equipment = 'Shaft - Fairway' SET @query = @query + ' where SPEC_FLAG <> 1 and [CLUB NUMBER] <> ''HYB'' and '
if @Equipment = 'Shaft - Hybrid' SET @query = @query + ' where [CLUB NUMBER] = ''HYB'' and '
if @Equipment = 'Grip - Iron' SET @query = @query + ' where BRAND <> ''-'' and '
if @Equipment = 'Grip - Wood' SET @query = @query + ' where BRAND <> ''-'' and '
if @Equipment = 'Grip - Driver' SET @query = @query + ' where BRAND <> ''-'' and SPEC_FLAG = 1 and '
if @Equipment = 'Grip - Fairway' SET @query = @query + ' where SPEC_FLAG <> 1 and [CLUB NUMBER] <> ''HYB'' and '
if @Equipment = 'Grip - Hybrid' SET @query = @query + ' where [CLUB NUMBER] = ''HYB'' and '
if @Equipment = 'Grip - Putter' SET @query = @query + ' where EQUIPMENT = ''PUTT'' and '
if @Equipment = 'Rangefinder' SET @query = @query + ' where '
		
Set @case = @query
	
END
GO
