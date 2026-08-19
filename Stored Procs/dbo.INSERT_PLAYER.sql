IF OBJECT_ID('dbo.INSERT_PLAYER') IS NOT NULL
    DROP PROCEDURE [dbo].[INSERT_PLAYER];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[INSERT_PLAYER]
	-- Add the parameters for the stored procedure here
	@PLAYERNAME varchar(70),
	@SID integer,
	@CATEGORY varchar(1),
	@FIRSTDAY date,
	@LASTDAY date,
	@EXTRA varchar(150) = ''

	

        
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @MAXPKEY INT;
	DECLARE @INPUTNO INT = 0;
	DECLARE @SEX varchar(1);
	DECLARE @TOUR varchar(1);
	DECLARE @SURVEYORNOTE varchar(max);

--manually does the pkey
SET @MAXPKEY = (SELECT MAX(PKEY) FROM Player_master.PLAYERNAMES);

--gets the inputno to preserve it in the case of adding names after a tournament has been input partially already
SELECT @INPUTNO = COALESCE(INPUTNO, 0) FROM Player_Master.PLAYERNAMES WHERE PLAYERNAME = @PLAYERNAME and SID = @SID and FIRSTDAY = @FIRSTDAY

SELECT top 1 @SEX = SEX, @TOUR = Player_Master.TOURNAMENTS_TABLE.TYPE FROM Player_Master.TOURNAMENTS_TABLE WHERE SID = @SID and [FIRST DAY] = @FIRSTDAY

--pulls forward category and surveyor note from the player's most recent prior event; category gets overridden below for amateur tournaments, surveyor note doesn't
SELECT top 1 @CATEGORY = CATEGORY, @SURVEYORNOTE = SurveyorNote FROM Player_Master.PLAYERNAMES WHERE PLAYERNAME = @PLAYERNAME and FIRSTDAY < @FIRSTDAY order by FIRSTDAY desc

if @TOUR = 'AMATEUR'
	set @CATEGORY = 'A'



--removes the name first to re-insert it
DELETE FROM Player_Master.PLAYERNAMES where PLAYERNAME = @PLAYERNAME and SID = @SID and FIRSTDAY = @FIRSTDAY

--reinserts it
  INSERT INTO Player_Master.PLAYERNAMES (PKEY, INFIELD, PLAYERNAME, SOUNDEX, EXTRA, CATEGORY, SEX, SID, FIRSTDAY, LASTDAY, MADECUT, WINNINGS, rankorder, INPUTNO, PRINTNO, SurveyorNote)

VALUES (
    @MAXPKEY + 1,
    --infield
    '',
    case when CHARINDEX('~', @PLAYERNAME) >1 
		then SUBSTRING(@PLAYERNAME, 1, CHARINDEX('~', @PLAYERNAME) - 1)
		else @PLAYERNAME end,
    --soundex
    NULL,
    --extra
    @EXTRA,
    --category
    @CATEGORY,
    --SEX
    @SEX,
    @SID, @FIRSTDAY, @LASTDAY,
    --madecut
    '',
    --winnings
    NULL,
    --rankorder
    NULL,
    --inputno
    @INPUTNO,
    --printno
    0,
    @SURVEYORNOTE);

--SCOPE_IDENTITY() must be selected here, inside this procedure's own scope, to reflect
--the INSERT above -- a caller doing [EXEC INSERT_PLAYER; SELECT SCOPE_IDENTITY();] from
--its own batch always gets NULL, since the EXEC call is a separate scope from the caller.
SELECT SCOPE_IDENTITY();

END
GO
