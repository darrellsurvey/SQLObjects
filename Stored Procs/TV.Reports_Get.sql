DROP PROCEDURE IF EXISTS [TV].[Reports_Get];
GO

CREATE PROCEDURE [TV].[Reports_Get]
	@COMPANY varchar(50),
	@loginid varchar(50),
	@PageType varchar(10)	
AS
begin
	SET NOCOUNT ON;
	SELECT	WebReport.ReportId, 
			WebReport.[ReportName], 
			WebReport.ReportPath, 
			WebReport.AllOrSpecificItems, 
			WebReport.AllOrSpecificUsers, 
			WebReport.Sort, 
			WebReport.Display	
	from [LKP].[WebReport] as WebReport with (nolock)
	WHERE [type] = @pageType 
	AND WebReport.AllOrSpecificUsers='A'
	
    UNION
    
	SELECT	WebReport.ReportId, 
			WebReport.[ReportName], 
			WebReport.ReportPath, 
			WebReport.AllOrSpecificItems, 
			WebReport.AllOrSpecificUsers, 
			WebReport.Sort, 
			WebReport.Display
	from [LKP].[WebReport] as WebReport with (nolock)
	INNER JOIN [LKP].[UserWebReport] with (nolock)
    ON WebReport.ReportId = [LKP].[UserWebReport].ReportId
    INNER JOIN web.login_info
    ON [LKP].[UserWebReport].UserId = web.login_info.[index] 
	WHERE [type] = @pageType 
	AND WebReport.AllOrSpecificUsers='S'
	AND login_info.USERNAME = @loginid
	
	ORDER BY Sort
end
GO
