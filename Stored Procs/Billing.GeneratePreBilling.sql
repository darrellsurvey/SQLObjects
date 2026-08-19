IF OBJECT_ID('Billing.GeneratePreBilling') IS NOT NULL
    DROP PROCEDURE [Billing].[GeneratePreBilling];
GO

CREATE PROCEDURE [Billing].[GeneratePreBilling]
	@TournamentId integer

AS
BEGIN

  --SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
  SET NOCOUNT ON;

  DECLARE @TournamentName as varchar(50) 
  DECLARE @FirstDay as date
  DECLARE @LastDay as date 
  DECLARE @TourName as varchar(20) 
  DECLARE @TourId as integer
  DECLARE @SID as integer

  SELECT @TourName = [TYPE], 
		@TourId = TourId, 
		@TournamentName = [TOURNAMENT NAME], 
		@FirstDay = [FIRST DAY], 
		@LastDay = [LAST DAY],
		@SID = [sid] 
  FROM [Player_Master].[TOURNAMENTS_TABLE] where TournamentId = @TournamentId

--check if tournament exists 
IF (SELECT COUNT(TournamentId) FROM Billing.OrderCompleted WHERE TournamentId = @TournamentId) = 0
  BEGIN
  Insert into Billing.OrderPreBilling
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
  FROM Billing.OrderRule 
  INNER JOIN Billing.PriceRule  
  ON Billing.OrderRule.PriceRuleId = Billing.PriceRule.PriceRuleId 
  
  where Billing.OrderRule.TourId = @TourId 
		and (sid is null or sid = @SID) 
		and Billing.OrderRule.[year] = year(@FIRSTDAY) --implied in @TourId 
		and @FirstDay between Billing.OrderRule.EffectiveDateFrom and Billing.OrderRule.EffectiveDateTo
		and Billing.OrderRule.IsActive = 'True'
  ORDER BY
		Billing.PriceRule.CustomerId, 
		Billing.PriceRule.ReportId
		
  END
END
GO
