DROP PROCEDURE IF EXISTS [dbo].[TOURNAMENT_UPDATE];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[TOURNAMENT_UPDATE]
	-- Add the parameters for the stored procedure here
	@SID integer,
	@TOUR varchar(20),
	@SEX varchar(15),
	@TOURNAMENTNAME varchar(70),
	@CLUB varchar(70),
	@CLUBOPTIONAL varchar(70),
	@LOCATION varchar(70),
	@KEYWORDS varchar(50),
	@FIRSTDAY date,
	@LASTDAY date,
	@ADDEDBY varchar(50),
	@ACTIVEFLAG int
	

        
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @ISFLASH int = 2
		
	SELECT @ISFLASH = ISFLASH FROM Player_Master.TOURNAMENTS_TABLE WHERE [SID] = @SID AND YEAR([FIRST DAY]) = YEAR(@FIRSTDAY);
	
update Player_Master.TOURNAMENTS_TABLE 
set TYPE=@TOUR, 
	SEX=@SEX, 
	[TOURNAMENT NAME]=@TOURNAMENTNAME, 
	CLUB=@CLUB, 
	[CLUB OPTIONAL]=@CLUBOPTIONAL, 
	LOCATION=@LOCATION, 
	KEYWORDS=@KEYWORDS, 
	[FIRST DAY]=@FIRSTDAY, 
	[LAST DAY]=@LASTDAY, 
	ADDEDBY=@ADDEDBY, 
	ADDEDON=GETDATE(), 
	ORIG_TYPE=@TOUR, 
	ISFLASH=@ISFLASH, 
	active_flag=@ACTIVEFLAG
where SID = @SID and year([FIRST DAY])= year(@FIRSTDAY)
    

--updates any data that may have been input already
  update Player_Master.PLAYERNAMES set FIRSTDAY = @FIRSTDAY where SID = @SID and YEAR([firstday]) = YEAR(@FIRSTDAY)
  
  update INPUT_1 set [FIRST DAY] = @FIRSTDAY where SID = @SID and YEAR([FIRST DAY]) = 2011
  
  update Input.[all] set [FIRST DAY] = @FIRSTDAY where SID = @SID and YEAR([FIRST DAY]) = YEAR(@FIRSTDAY)
  update Input.Grip set [FIRST DAY] = @FIRSTDAY where SID = @SID and YEAR([FIRST DAY]) = YEAR(@FIRSTDAY)
  update Input.Iron set [FIRST DAY] = @FIRSTDAY where SID = @SID and YEAR([FIRST DAY]) = YEAR(@FIRSTDAY)
  update Input.Putter set [FIRST DAY] = @FIRSTDAY where SID = @SID and YEAR([FIRST DAY]) = YEAR(@FIRSTDAY)
  update Input.Shaft set [FIRST DAY] = @FIRSTDAY where SID = @SID and YEAR([FIRST DAY]) = YEAR(@FIRSTDAY)
  update Input.Wedge set [FIRST DAY] = @FIRSTDAY where SID = @SID and YEAR([FIRST DAY]) = YEAR(@FIRSTDAY)
  update Input.Wood set [FIRST DAY] = @FIRSTDAY where SID = @SID and YEAR([FIRST DAY]) = YEAR(@FIRSTDAY)

--update PMF

  update player_master.[all] set [FIRST DAY] = @FIRSTDAY where SID = @SID and YEAR([FIRST DAY]) = YEAR(@FIRSTDAY)
  update player_master.[Grip Detail] set [FIRST DAY] = @FIRSTDAY where [Survey ID] = @SID and YEAR([FIRST DAY]) = YEAR(@FIRSTDAY)
  update player_master.[Iron Detail] set [FIRST DAY] = @FIRSTDAY where [Survey ID] = @SID and YEAR([FIRST DAY]) = YEAR(@FIRSTDAY)
  update player_master.[Putter Detail] set [FIRST DAY] = @FIRSTDAY where [Survey ID] = @SID and YEAR([FIRST DAY]) = YEAR(@FIRSTDAY)
  update player_master.[Shaft Detail] set [FIRST DAY] = @FIRSTDAY where [Survey ID] = @SID and YEAR([FIRST DAY]) = YEAR(@FIRSTDAY)
  update player_master.[Wedge Detail] set [FIRST DAY] = @FIRSTDAY where [Survey ID] = @SID and YEAR([FIRST DAY]) = YEAR(@FIRSTDAY)
  update player_master.[Wood Detail] set [FIRST DAY] = @FIRSTDAY where [Survey ID] = @SID and YEAR([FIRST DAY]) = YEAR(@FIRSTDAY)

--update billing

update Billing.AllOrdersYTD set [Tournament Name] = @TOURNAMENTNAME, [First Day] = @FIRSTDAY, [Last Day] = @LASTDAY, Type = @TOUR
where TD = @SID and YEAR([first day]) = YEAR(@FIRSTDAY)

END
GO
