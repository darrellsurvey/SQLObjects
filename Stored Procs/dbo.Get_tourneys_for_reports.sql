DROP PROCEDURE IF EXISTS [dbo].[Get_tourneys_for_reports];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_tourneys_for_reports]
	-- Add the parameters for the stored procedure here
	@COMPANY varchar(50)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
Select [Tournament Name], [First Day] from Billing.AllOrdersYTD where Company = @COMPANY and datediff(year, [First Day], Getdate()) <= 1 GROUP BY [Tournament Name], [First Day] order by [Tournament Name], [First Day] DESC;

END



--execute dbo.Get_tourneys_for_reports 'TITLEIST'
--Select [Tournament Name], [First Day] from Billing.AllOrdersYTD where Company = 'TITLEIST' and datediff(year, [First Day], Getdate()) <= 1 GROUP BY [Tournament Name], [First Day] order by [Tournament Name], [First Day] DESC;
GO
