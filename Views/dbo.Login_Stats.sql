IF OBJECT_ID('dbo.Login_Stats') IS NOT NULL
    DROP VIEW [dbo].[Login_Stats];
GO

CREATE VIEW dbo.Login_Stats
AS
SELECT        TOP (100) PERCENT web.Login_info.COMPANY, web.Login_info.[LAST NAME], web.Login_info.[FIRST NAME], web.Log_website.LOG_EVENT, 
                         web.Log_website.LOG_TIME
FROM            web.Log_website INNER JOIN
                         web.Login_info ON web.Log_website.USERNAME = web.Login_info.USERNAME
WHERE        (web.Log_website.LOG_EVENT = 'login')
ORDER BY web.Log_website.LOG_TIME DESC
GO
