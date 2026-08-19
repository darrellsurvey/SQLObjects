IF OBJECT_ID('dbo.REMOVE_PLAYER') IS NOT NULL
    DROP PROCEDURE [dbo].[REMOVE_PLAYER];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[REMOVE_PLAYER]
	-- Add the parameters for the stored procedure here
	@PLAYERNAME varchar(70),
	@SID integer,
	@FIRSTDAY date
        
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DELETE FROM Player_Master.PLAYERNAMES WHERE PLAYERNAME = @PLAYERNAME AND SID = @SID AND FIRSTDAY = @FIRSTDAY;
	
	delete from Input.[All] where SID = @SID and [FIRST DAY]= @FIRSTDAY and PLAYERNAME = @PLAYERNAME;
	delete from Input.Grip where SID = @SID and [FIRST DAY]= @FIRSTDAY and PLAYERNAME = @PLAYERNAME;
	delete from Input.Iron where SID = @SID and [FIRST DAY]= @FIRSTDAY and PLAYERNAME = @PLAYERNAME;
	delete from Input.Putter where SID = @SID and [FIRST DAY]= @FIRSTDAY and PLAYERNAME = @PLAYERNAME;
	delete from Input.Shaft where SID = @SID and [FIRST DAY]= @FIRSTDAY and PLAYERNAME = @PLAYERNAME;
	delete from Input.Wedge where SID = @SID and [FIRST DAY]= @FIRSTDAY and PLAYERNAME = @PLAYERNAME;
	delete from Input.Wood where SID = @SID and [FIRST DAY]= @FIRSTDAY and PLAYERNAME = @PLAYERNAME;

	delete from Player_Master.[All] where SID = @SID and [FIRST DAY]= @FIRSTDAY and PLAYERNAME = @PLAYERNAME;
	delete from Player_Master.[Grip Detail] where [Survey ID] = @SID and [FIRST DAY]= @FIRSTDAY and [Name] = @PLAYERNAME;
	delete from Player_Master.[Iron Detail] where [Survey ID] = @SID and [FIRST DAY]= @FIRSTDAY and [Name] = @PLAYERNAME;
	delete from Player_Master.[Putter Detail] where [Survey ID] = @SID and [FIRST DAY]= @FIRSTDAY and [Name] = @PLAYERNAME;
	delete from Player_Master.[Shaft Detail] where [Survey ID] = @SID and [FIRST DAY]= @FIRSTDAY and [Name] = @PLAYERNAME;
	delete from Player_Master.[Wedge Detail] where [Survey ID] = @SID and [FIRST DAY]= @FIRSTDAY and [Name] = @PLAYERNAME;
	delete from Player_Master.[Wood Detail] where [Survey ID] = @SID and [FIRST DAY]= @FIRSTDAY and [Name] = @PLAYERNAME;


END
GO
