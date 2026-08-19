DROP PROCEDURE IF EXISTS [dbo].[web_get_reports];
GO

CREATE PROCEDURE [dbo].[web_get_reports]
	@COMPANY varchar(50),
	@TOUR varchar(20),
	@YEAR int,
	@TOURNEYNAME varchar(100),
	@loginid varchar(50)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;
	
    IF @COMPANY = 'DARRELL SURVEY'
		begin
			SELECT distinct [Report Name] as [ReportName]
			from Billing.AllOrdersYTD b
			inner join LKP.Report r
			on b.ReportId = r.ReportId  
			where YEAR([first day]) = @YEAR 
			and [Tournament Name] = @TOURNEYNAME 
			AND [type] = @TOUR
			and r.ReportType = 1
			union
			SELECT [ReportName] FROM [DARRELL_MASTER].[LKP].[Report]
			where ReportId in (1,2,3,4,5,6,7,9,10,11,13,14,15,16,17,18,22,29,32,35,38,39)
			ORDER BY [Report Name] 
		end
	else
		begin
			SELECT [Report Name] as [ReportName]
			from Billing.AllOrdersYTD b 
			inner join LKP.Report r
			on b.ReportId = r.ReportId   
			where Company = @COMPANY 
			and YEAR([first day]) = @YEAR 
			and [Tournament Name] = @TOURNEYNAME 
			AND [type] = @TOUR
			and r.ReportType = 1
			ORDER BY [Report Name] 
		end
	END
GO
