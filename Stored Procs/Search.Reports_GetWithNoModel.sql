DROP PROCEDURE IF EXISTS [Search].[Reports_GetWithNoModel];
GO

CREATE PROCEDURE [Search].[Reports_GetWithNoModel]
	@Company varchar(50),
	@Loginid varchar(50),
	@PageType varchar(50)
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
	WHERE [type] = @PageType 
	AND Display <> 'MODEL'
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
	AND Display <> 'MODEL'
	AND WebReport.AllOrSpecificUsers='S'
	AND login_info.USERNAME = @loginid
	    
	ORDER BY Sort
END
GO
