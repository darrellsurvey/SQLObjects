IF OBJECT_ID('Input.generate_billing') IS NOT NULL
    DROP PROCEDURE [Input].[generate_billing];
GO

CREATE PROCEDURE [Input].[generate_billing]
	-- Add the parameters for the stored procedure here
	@SID integer,
	@FIRSTDAY date,
	@AUTHORIZEDBY varchar(50),
	@TOUR as varchar(20) = '',
	@TOURNAMENT as varchar(50) = '',
	@LASTDAY as date = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

set @tour = (SELECT [TYPE] fROM [DARRELL_MASTER].[Player_Master].[TOURNAMENTS_TABLE] where SID = @SID and [FIRST DAY] = @FIRSTDAY)
set @TOURNAMENT = (SELECT [TOURNAMENT NAME] fROM [DARRELL_MASTER].[Player_Master].[TOURNAMENTS_TABLE] where SID = @SID and [FIRST DAY] = @FIRSTDAY)
set @LASTDAY = (SELECT [LAST DAY] fROM [DARRELL_MASTER].[Player_Master].[TOURNAMENTS_TABLE] where SID = @SID and [FIRST DAY] = @FIRSTDAY)


IF (SELECT COUNT(*) FROM Billing.AllOrdersYTD WHERE TD = @SID and [First Day] = @FIRSTDAY) = 0
Insert into Billing.allordersytd  
           ([Company]
           ,[Type]
           ,[Tournament Name]
           ,[TD]
           ,[First Day]
           ,[Last Day]
           ,[Report Name]
           ,[Rep_ID])
SELECT [rule_entity], 
		@TOUR,
		@TOURNAMENT,
		@SID,
		@FIRSTDAY,
		@LASTDAY,
		[report],
		rule_id 
  FROM [Billing].[permissions]
  where tour = @TOUR 
		and (sid is null or sid = @SID) 
		and [year] = year(@FIRSTDAY)
		

END
GO
