IF OBJECT_ID('Input.un_finalize_tournament') IS NOT NULL
    DROP PROCEDURE [Input].[un_finalize_tournament];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- ==========================================
CREATE PROCEDURE [Input].[un_finalize_tournament]
	-- Add the parameters for the stored procedure here
	@SID integer,
	@FIRSTDAY date,
	@AUTHORIZEDBY varchar(50)

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;





delete from Player_Master.[All] where [FIRST DAY] = @FIRSTDAY and SID = @SID;
delete from Player_Master.[Iron Detail] where [FIRST DAY] = @FIRSTDAY and [Survey ID] = @SID;
delete from Player_Master.[Wood Detail] where [FIRST DAY] = @FIRSTDAY and [Survey ID] = @SID;
delete from Player_Master.[Putter Detail] where [FIRST DAY] = @FIRSTDAY and [Survey ID] = @SID;
delete from Player_Master.[Wedge Detail] where [FIRST DAY] = @FIRSTDAY and [Survey ID] = @SID;
delete from Player_Master.[Shaft Detail] where [FIRST DAY] = @FIRSTDAY and [Survey ID] = @SID;
delete from Player_Master.[Grip Detail] where [FIRST DAY] = @FIRSTDAY and [Survey ID] = @SID;
	

END
GO
