DROP PROCEDURE IF EXISTS [dbo].[web_get_years];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- ==========================================
CREATE PROCEDURE [dbo].[web_get_years]
	-- Add the parameters for the stored procedure here
	@COMPANY varchar(50),
	@loginid varchar(20) = ''
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @COMPANY = 'DARRELL SURVEY'
	
	BEGIN
	SELECT DISTINCT(YEAR([First Day])) as [Year] 
	  FROM Billing.AllOrdersYTD with (nolock)
      WHERE YEAR([FIRST DAY]) > YEAR(GETDATE()) - 10
      AND [First Day] is not null
	  order by YEAR([First Day]) DESC
	END
	
	ELSE
	
	BEGIN
	SELECT DISTINCT(YEAR("FIRST DAY")) as [Year]
	  FROM Billing.AllOrdersYTD with (nolock)
		WHERE YEAR([FIRST DAY]) > YEAR(GETDATE()) -3 
        AND [First Day] is not null
		AND Company = @COMPANY
		order by YEAR("FIRST DAY") DESC
	END
	
	-- select * from billing.allordersytd
	
END
GO
