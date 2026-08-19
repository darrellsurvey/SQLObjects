DROP PROCEDURE IF EXISTS [dbo].[web_get_single_items];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- ==========================================
CREATE PROCEDURE [dbo].[web_get_single_items]
	-- Add the parameters for the stored procedure here
	@COMPANY varchar(50)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @COMPANY = 'DARRELL'
	BEGIN

		SELECT DISTINCT(ITEMNAME) AS ITEMNAME FROM LKP.Report_Lookup ORDER BY ITEMNAME

	END
	ELSE
	BEGIN
	
		SELECT DISTINCT(ITEMNAME) AS ITEMNAME FROM Billing.AllOrdersYTD a
		LEFT OUTER JOIN LKP.Report_Lookup b ON a.[Report Name] = b.REPORTNAME
		WHERE a.COMPANY = @COMPANY AND ITEMNAME IS NOT NULL AND REPORTITEM = 'Top'
		--GROUP BY ITEMNAME
		ORDER BY ITEMNAME
		
END
END
GO
