DROP PROCEDURE IF EXISTS [CR_Reports].[Tourney_info];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [CR_Reports].[Tourney_info]
	-- Add the parameters for the stored procedure here
	
	@FIRSTDAY date,
	@SID int

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


SELECT [SID],
      [TYPE],
      [SEX],
      [TOURNAMENT NAME],
      [CLUB],
      [CLUB OPTIONAL],
      [LOCATION],
      [KEYWORDS],
      [FIRST DAY],
      [LAST DAY],
      --hardcoded date we switched over
      COUNT_OF_PRO = (SELECT COUNT(PLAYERNAME) FROM Player_Master.PLAYERNAMES 
      WHERE SID = @SID and FIRSTDAY = @FIRSTDAY and CATEGORY = 'P' 
      and ([FIRST DAY] < '3/20/2011' OR INPUTNO > 0)),
      COUNT_OF_AM = (SELECT COUNT(PLAYERNAME) FROM Player_Master.PLAYERNAMES 
      WHERE SID = @SID and FIRSTDAY = @FIRSTDAY and CATEGORY = 'A' 
      and ([FIRST DAY] < '3/20/2011' OR INPUTNO > 0))
      
  FROM [Player_Master].[TOURNAMENTS_TABLE]

WHERE "FIRST DAY" = @FIRSTDAY AND SID = @SID


END
GO
