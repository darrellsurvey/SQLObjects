IF OBJECT_ID('dbo.WebLogIn') IS NOT NULL
    DROP VIEW [dbo].[WebLogIn];
GO

CREATE VIEW dbo.WebLogIn
AS
SELECT     web.Login_info.COMPANY, web.Login_info.[FIRST NAME], web.Login_info.[LAST NAME], web.Log_website.IP_ADDRESS, web.Log_website.YEAR, 
                      web.Log_website.TOUR, web.Log_website.[TOURNAMENT NAME], web.Log_website.[REPORT NAME], web.Log_website.LOG_EVENT, 
                      web.Log_website.LOG_TIME
FROM         web.Log_website INNER JOIN
                      web.Login_info ON web.Log_website.USERNAME = web.Login_info.USERNAME
GO
