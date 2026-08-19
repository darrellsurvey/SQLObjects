DROP PROCEDURE IF EXISTS [Billing].[Tournaments_Get];
GO

CREATE PROCEDURE [Billing].[Tournaments_Get]
	@TourId int
as
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
		SELECT Distinct tournament.TournamentID, tournament.SID, 
			TournamentName = tournament.[TOURNAMENT NAME],
			FirstDay = tournament.[First Day],
			TournamentDateAndName = RIGHT('0' + CAST(MONTH(tournament.[First Day]) as nvarchar), 2) 
			                + '/' + RIGHT('0' + CAST(DAY(tournament.[First Day]) as nvarchar), 2)
				            + ' - ' + tournament.[TOURNAMENT NAME]
		FROM  Player_Master.TOURNAMENTS_TABLE tournament with (nolock)
		WHERE tournament.TourId = @TourId
 		ORDER BY tournament.[First Day] 
		
	END
GO
