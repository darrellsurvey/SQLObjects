DROP PROCEDURE IF EXISTS [dbo].[TOURNAMENT_INSERT];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[TOURNAMENT_INSERT]
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
	@ADDEDBY varchar(50)
	

        
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
DECLARE @ISFLASH int = 2
Declare @TourID int

SELECT @TourID = [TourId]
  FROM [DARRELL_MASTER].[LKP].[Tour]
  where TourName = @TOUR and [Year] = Year(@FIRSTDAY)

INSERT INTO Player_Master.TOURNAMENTS_TABLE 
	    (SID, 
	    TYPE, 
	    SEX, 
	    [TOURNAMENT NAME], 
	    CLUB, 
	    [CLUB OPTIONAL], 
	    LOCATION, 
	    KEYWORDS, 
	    [FIRST DAY], 
	    [LAST DAY], 
	    ADDEDBY, 
	    ADDEDON, 
	    ORIG_TYPE, 
	    ISFLASH,
	    TourId, 
	    active_flag)
VALUES (@SID, 
		@TOUR, 
		@SEX, 
		@TOURNAMENTNAME, 
		@CLUB, 
		@CLUBOPTIONAL, 
		@LOCATION, 
		@KEYWORDS, 
		@FIRSTDAY, 
		@LASTDAY, 
		@ADDEDBY, 
		GETDATE(), 
		@TOUR, 
		@ISFLASH,
		@TourID, 
		1); 

END
GO
