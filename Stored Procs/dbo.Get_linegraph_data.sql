IF OBJECT_ID('dbo.Get_linegraph_data') IS NOT NULL
    DROP PROCEDURE [dbo].[Get_linegraph_data];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Get_linegraph_data]
	-- Add the parameters for the stored procedure here
	@COMPANY varchar(50),
	@TOUR varchar(60),
	@REPORTNAME varchar(35),
	@T_NUM int = 5
	
	
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE @LINE_TABLE dbo.line_table_data

DECLARE @COUNTER INT = 0
DECLARE @TNAME1 VARCHAR(50), @FIRSTDAY1 DATE, @SID1 INT

WHILE (@COUNTER < @T_NUM)
BEGIN

SELECT TOP 1 @TNAME1 = [Tournament Name], @FIRSTDAY1 = [FIRST DAY], @SID1 = SID FROM Player_Master.TOURNAMENTS_TABLE WHERE [TYPE] = @TOUR AND ISFLASH = 0 AND SID NOT IN (SELECT DISTINCT(SID) FROM @LINE_TABLE) ORDER BY [FIRST DAY] DESC
INSERT INTO @LINE_TABLE (MANUFACTURER, [Count], TOTAL) EXECUTE dbo.get_topsheet @COMPANY, @TNAME1, @FIRSTDAY1, @REPORTNAME
UPDATE @LINE_TABLE SET [FIRST DAY] = @FIRSTDAY1, SID = @SID1, [TYPE] = @TOUR, M = MONTH(@FIRSTDAY1), D = DAY(@FIRSTDAY1), Y = YEAR(@FIRSTDAY1) WHERE SID IS NULL

SET @COUNTER = @COUNTER + 1
END

SELECT * FROM @LINE_TABLE ORDER BY [FIRST DAY] ASC, SID, [COUNT] DESC


END
GO
