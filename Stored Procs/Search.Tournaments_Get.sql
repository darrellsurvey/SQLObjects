DROP PROCEDURE IF EXISTS [Search].[Tournaments_Get];
GO

CREATE PROCEDURE [Search].[Tournaments_Get]
	@COMPANY nvarchar(50),
	@LoginId nvarchar(50) = '',
	@Year int,
	@Tour nvarchar(50)
as
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF @COMPANY = 'DARRELL SURVEY' 
		SELECT Distinct tournament.SID, 
			TournamentName = tournament.[TOURNAMENT NAME],
			FirstDay = tournament.[First Day],
			TournamentDateAndName = RIGHT('0' + CAST(MONTH(tournament.[First Day]) as nvarchar), 2) 
			                + '/' + RIGHT('0' + CAST(DAY(tournament.[First Day]) as nvarchar), 2)
				            + ' - ' + tournament.[TOURNAMENT NAME]
		FROM  Player_Master.TOURNAMENTS_TABLE tournament with (nolock)
		INNER JOIN Billing.AllOrdersYTD orders with (nolock)
		   on tournament.[SID] = orders.[TD] 
		  and tournament.[FIRST DAY] = orders.[First Day]
		WHERE YEAR(tournament.[First Day] ) = @Year 
		  and tournament.[Type] = @Tour
		ORDER BY tournament.[First Day]  DESC
		
	ELSE
		SELECT DISTINCT tournament.SID, 
			TournamentName = tournament.[TOURNAMENT NAME],
			FirstDay = tournament.[First Day],
			TournamentDateAndName = RIGHT('0' + CAST(MONTH(tournament.[First Day]) as nvarchar), 2) 
			                + '/' + RIGHT('0' + CAST(DAY(tournament.[First Day]) as nvarchar), 2)
				            + ' - ' + tournament.[TOURNAMENT NAME]
		FROM  Player_Master.TOURNAMENTS_TABLE tournament with (nolock)
		INNER JOIN Billing.AllOrdersYTD orders with (nolock)
		   on tournament.[SID] = orders.[TD] 
		  and tournament.[FIRST DAY] = orders.[First Day]
		WHERE YEAR(tournament.[First Day] ) = @Year 
		  and tournament.[Type] = @Tour
		  and orders.Company = @COMPANY 
		ORDER BY tournament.[First Day]  DESC
	END
GO
