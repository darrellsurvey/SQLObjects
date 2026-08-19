DROP PROCEDURE IF EXISTS [dbo].[REPORTS_TOURNEYINFO];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[REPORTS_TOURNEYINFO]
	-- Add the parameters for the stored procedure here
	@FIRSTDAY date,
	@SID int
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	
	SELECT 
SID, "TYPE", SEX, "TOURNAMENT NAME", CLUB, "CLUB OPTIONAL", LOCATION, KEYWORDS, "FIRST DAY", "LAST DAY"

FROM [Player_Master].TOURNAMENTS_TABLE
WHERE "FIRST DAY" = @FIRSTDAY AND SID = @SID
END
GO
