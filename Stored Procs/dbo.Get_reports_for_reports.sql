DROP PROCEDURE IF EXISTS [dbo].[Get_reports_for_reports];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_reports_for_reports]
	-- Add the parameters for the stored procedure here
	@COMPANY varchar(50),
	@TOURNAMENT varchar(75)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
Select [Report Name] from Billing.AllOrdersYTD where Company = @COMPANY and [Tournament Name] = @TOURNAMENT GROUP BY [Report Name] order by [Report Name];
END
GO
