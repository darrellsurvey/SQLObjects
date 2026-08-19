IF OBJECT_ID('Consumer.Billing') IS NOT NULL
    DROP VIEW [Consumer].[Billing];
GO

CREATE VIEW Consumer.Billing
AS
SELECT        oc.ConsumerOrderId, Billing.Customer.CompanyName, oc.CustomerId, g.GROUP_ID, sm.SurveyYear, sc.Country, sc.CountryId, ss.Name AS SeasonName, 
                         ss.Id AS SeasonId
FROM            Billing.OrderConsumer AS oc INNER JOIN
                         Consumer.SurveyMaster AS sm ON oc.SurveyMasterId = sm.SurveyMasterId INNER JOIN
                         Consumer.Country AS sc ON sm.CountryId = sc.CountryId INNER JOIN
                         Consumer.Season AS ss ON sm.SeasonId = ss.Id INNER JOIN
                         LKP.Company_Groups AS g ON oc.CustomerId = g.CompanyID INNER JOIN
                         Billing.Customer ON oc.CustomerId = Billing.Customer.CustomerId AND oc.CustomerId = Billing.Customer.CustomerId
GO
