DROP PROCEDURE IF EXISTS [dbo].[get_player_names_for_xing];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[get_player_names_for_xing]
	-- Add the parameters for the stored procedure here
AS
BEGIN

select Distinct([PlayerName]) FROM [DARRELL_MASTER].[Player_Master].[All]
Where year([First Day]) > year(GETDATE())-3
Order by [PlayerName]





End
GO
