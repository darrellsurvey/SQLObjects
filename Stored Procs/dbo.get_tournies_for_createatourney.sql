DROP PROCEDURE IF EXISTS [dbo].[get_tournies_for_createatourney];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[get_tournies_for_createatourney]
	-- Add the parameters for the stored procedure here
        
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	

SELECT * FROM Player_Master.TOURNAMENTS_TABLE WHERE (DATEDIFF(month, [First day], getdate()) < 3 or DATEDIFF(month, [First day], getdate()) > -3)
and YEAR([First Day]) = YEAR(getdate()) ORDER BY [FIRST DAY] ASC



END
GO
