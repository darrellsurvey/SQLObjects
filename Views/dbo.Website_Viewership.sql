IF OBJECT_ID('dbo.Website_Viewership') IS NOT NULL
    DROP VIEW [dbo].[Website_Viewership];
GO

CREATE VIEW dbo.Website_Viewership
AS
SELECT     web.Log_website.YEAR, web.Log_website.TOUR, web.Log_website.[TOURNAMENT NAME], web.Log_website.[REPORT NAME], web.Log_website.LOG_EVENT, 
                      web.Log_website.LOG_TIME, web.Login_info.COMPANY, web.Login_info.[LAST NAME], web.Login_info.[FIRST NAME], web.Log_website.IP_ADDRESS
FROM         web.Log_website INNER JOIN
                      web.Login_info ON web.Log_website.USERNAME = web.Login_info.USERNAME
GO
