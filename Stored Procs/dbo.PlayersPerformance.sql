IF OBJECT_ID('dbo.PlayersPerformance') IS NOT NULL
    DROP PROCEDURE [dbo].[PlayersPerformance];
GO

-- =============================================
-- Author:		Alex
-- Create date: 2019-08-08
-- Description:	Players page / Performance submenue
-- =============================================

create PROCEDURE [dbo].[PlayersPerformance]
	-- Add the parameters for the stored procedure here
	@user varchar(100) = '',
	@company varchar(100) = '',
	@PGASeason int,
	@PlayerName varchar(100)
	

AS
BEGIN

	SET NOCOUNT ON;

		SELECT [TOURNAMENT NAME], 
				[FIRST DAY],
				isnull([Tie], '') + ISNULL([Cut], '') + isnull(cast([Finish Position] as varchar(4)), '') as [Finish Position],
				[Tour Ranking]
				,[Official Money]			
				,[Round 1]
				,[Round 2]
				,[Round 3]
				,[Round 4]
  		        ,[Driving Accuracy]
				,[Driving Distance]
				,[Greens in Reg]
				,[Putting Avg]
  FROM [MoneyBall].[WebsiteDataPlayer5]
  where [PLAYER NAME] = @PlayerName and PGASeason = @PgaSeason
 order by   [FIRST DAY] desc
END
GO
