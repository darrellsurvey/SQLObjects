DROP PROCEDURE IF EXISTS [dbo].[viewer_get_years];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- ==========================================
CREATE PROCEDURE [dbo].[viewer_get_years]
	-- Add the parameters for the stored procedure here
	@COMPANY varchar(50),
	@TOUR varchar(20)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    /*
	
	IF @COMPANY = 'DARRELL'
	
	BEGIN
	SELECT DISTINCT(YEAR("FIRST DAY")) as 'Year' from Player_Master.TOURNAMENTS_TABLE
		order by YEAR("FIRST DAY") DESC
	END
	
	ELSE
	
	BEGIN
	SELECT DISTINCT(YEAR("FIRST DAY")) as 'Year'  from Player_Master.TOURNAMENTS_TABLE WHERE YEAR([FIRST DAY]) > 2004
		order by YEAR("FIRST DAY") DESC
	END
	*/
	

	IF @COMPANY = 'DARRELL SURVEY'
	
	BEGIN
	SELECT DISTINCT(YEAR("FIRST DAY")) as 'Year' from Billing.AllOrdersYTD
		where [Type]= @Tour
		order by YEAR("FIRST DAY") DESC
	END
	
	ELSE
	
	BEGIN
	SELECT DISTINCT(YEAR("FIRST DAY")) as 'Year'  from Billing.AllOrdersYTD
		WHERE [Type]= @Tour and Company=@COMPANY and YEAR([First Day]) > 2004
		order by YEAR("FIRST DAY") DESC
	END



END
GO
