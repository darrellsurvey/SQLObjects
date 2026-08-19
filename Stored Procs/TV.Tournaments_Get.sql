DROP PROCEDURE IF EXISTS [TV].[Tournaments_Get];
GO

CREATE PROCEDURE [TV].[Tournaments_Get]
 @COMPANY nvarchar(50),
 @LoginId nvarchar(50) = '',
 @Year int = 2013,
 @Tour nvarchar(50)
as
BEGIN
 -- SET NOCOUNT ON added to prevent extra result sets from
 -- interfering with SELECT statements.
 SET NOCOUNT ON;
 
 IF @COMPANY = 'DARRELL SURVEY' 
  SELECT DISTINCT tournament.TntNid as SID, 
   TournamentName = tournament.TntName,
   FirstDay = tournament.TntFirstDay,
   TournamentDateAndName = RIGHT('0' + CAST(MONTH(tournament.TntFirstDay) as nvarchar), 2) 
                   + '/' + RIGHT('0' + CAST(DAY(tournament.TntFirstDay) as nvarchar), 2)
                + ' - ' + tournament.TntName
  FROM  TV.TVAudit tournament with (nolock)
  WHERE YEAR(tournament.TntFirstDay ) = @Year 
    and tournament.[Tour] = @Tour
  ORDER BY tournament.TntFirstDay  DESC
  
 ELSE
  SELECT DISTINCT tournament.TntNid as SID, 
   TournamentName = tournament.TntName,
   FirstDay = tournament.TntFirstDay,
   TournamentDateAndName = RIGHT('0' + CAST(MONTH(tournament.TntFirstDay) as nvarchar), 2) 
                   + '/' + RIGHT('0' + CAST(DAY(tournament.TntFirstDay) as nvarchar), 2)
                + ' - ' + tournament.TntName
  FROM  TV.TVAudit tournament with (nolock)
--  INNER JOIN Billing.AllOrdersYTD orders with (nolock)
--     on tournament.TntNid = orders.[TD] 
--    and tournament.TntFirstDay = orders.[First Day]
  WHERE YEAR(tournament.TntFirstDay ) = @Year 
    and tournament.[Tour] = @Tour
--    and orders.Company = @COMPANY 
  ORDER BY tournament.TntFirstDay  DESC
 END
GO
