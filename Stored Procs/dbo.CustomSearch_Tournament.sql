DROP PROCEDURE IF EXISTS [dbo].[CustomSearch_Tournament];
GO

-- =============================================
-- Author:		Colin
-- Create date: 2011-11-4
-- Description:	Populates the tournament dropdown box on the custom search webpage
-- =============================================
CREATE PROCEDURE [dbo].[CustomSearch_Tournament] 
	-- Add the parameters for the stored procedure here
	@tour nvarchar(20) = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  
     CONVERT( varchar, [FIRST DAY], 107)+ ' - ' +[TOURNAMENT NAME] + ' - ' + [LOCATION]
  FROM [DARRELL_MASTER].[Player_Master].[TOURNAMENTS_TABLE]
  WHERE (@tour LIKE '%~' + [type] + '~%') AND ([FIRST DAY] <= GETDATE() AND YEAR([FIRST DAY]) >= YEAR(GETDATE()) - 1) AND (active_flag = 1) 
  ORDER BY [FIRST DAY] DESC
END
GO
