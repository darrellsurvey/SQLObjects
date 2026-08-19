DROP PROCEDURE IF EXISTS [Billing].[GenerateBilling_sp];
GO

CREATE PROCEDURE [Billing].[GenerateBilling_sp]
	@SID integer,
	@FIRSTDAY date,
	@AUTHORIZEDBY varchar(50)
AS
BEGIN

  --SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
  SET NOCOUNT ON;

  DECLARE @TournamentName as varchar(50) 
  DECLARE @TournamentId integer
  DECLARE @LastDay as date 
  DECLARE @TourName as varchar(20) 
  DECLARE @TourId as integer

  set @TourName = (SELECT [TYPE] FROM [Player_Master].[TOURNAMENTS_TABLE] with (nolock) where SID = @SID and [FIRST DAY] = @FIRSTDAY)
  set @TourId = (SELECT TourId FROM [Player_Master].[TOURNAMENTS_TABLE] with (nolock) where SID = @SID and [FIRST DAY] = @FIRSTDAY)
  set @TournamentName = (SELECT [TOURNAMENT NAME] FROM [Player_Master].[TOURNAMENTS_TABLE] with (nolock) where SID = @SID and [FIRST DAY] = @FIRSTDAY)
  set @TournamentId = (SELECT TournamentId FROM [Player_Master].[TOURNAMENTS_TABLE] with (nolock) where SID = @SID and [FIRST DAY] = @FIRSTDAY)
  set @LastDay = (SELECT [LAST DAY] FROM [Player_Master].[TOURNAMENTS_TABLE] with (nolock) where SID = @SID and [FIRST DAY] = @FIRSTDAY)

--check if tournament exists 
  Declare @CountForTournamentId as integer
  SELECT @CountForTournamentId  = COUNT(TournamentId) 
    FROM Billing.OrderCompleted with (nolock) 
    WHERE TournamentId = @TournamentId

IF @CountForTournamentId = 0
  BEGIN
  Insert into Billing.OrderCompleted  
      (
      CustomerId,  
      [Company], --delete later
      --TourId, --delete later
      [Type], --delete later
      TournamentId,
      [Tournament Name], --delete later
      [TournamentSID],  --delete later
      [First Day], --delete later
      [Last Day], --delete later
      [Report Name], --delete later
      ReportId, 
      [Price],
      [Fee1Amount],
      [Fee1TypeId],
      [Fee2Amount],
      [Fee2TypeId],
      [Fee3Amount],
      [Fee3TypeId],
      PriceRuleId,
      OrderRuleId
      )
  SELECT  
			Billing.PriceRule.CustomerId, 
			Billing.OrderRule.CompanyName, --delete later
			--TourId = @TourId, --delete later
			TourName = @TourName, --delete later
			TournamentId = @TournamentId,
			TournamentName = @TournamentName, --delete later
			SID = @SID, --delete later
			FIRSTDAY = @FIRSTDAY,  --delete later
			LASTDAY = @LASTDAY,  --delete later
			Billing.OrderRule.[report],  --delete later
			Billing.PriceRule.ReportId,
			Billing.PriceRule.[Price],
			Billing.PriceRule.[Fee1Amount],
			Billing.PriceRule.[Fee1TypeId],
	 		Billing.PriceRule.[Fee2Amount],
			Billing.PriceRule.[Fee2TypeId],
			Billing.PriceRule.[Fee3Amount],
			Billing.PriceRule.[Fee3TypeId],
			Billing.PriceRule.PriceRuleId,
			Billing.OrderRule.OrderRuleId
  FROM Billing.OrderRule with (nolock)
  INNER JOIN Billing.PriceRule with (nolock) 
  ON Billing.OrderRule.PriceRuleId = Billing.PriceRule.PriceRuleId 
  
  WHERE Billing.OrderRule.TourId = @TourId 
		and (sid is null or sid = @SID) 
		and Billing.OrderRule.[year] = year(@FIRSTDAY) --implied in @TourId
		--added 10/28/2013
		and Billing.OrderRule.EffectiveDateFrom <= @FIRSTDAY
		and Billing.OrderRule.EffectiveDateTo >= @FIRSTDAY
		and Billing.OrderRule.IsActive = 1
		
  ORDER BY
		Billing.PriceRule.CustomerId, 
		Billing.PriceRule.ReportId
		
  END
END
GO
