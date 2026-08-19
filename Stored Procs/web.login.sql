IF OBJECT_ID('web.login') IS NOT NULL
    DROP PROCEDURE [web].[login];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [web].[login]
	-- Add the parameters for the stored procedure here
	
	@USERNAME varchar(50)

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT *

FROM web.Login_info
LEFT OUTER JOIN [LKP].[Manufacturer Codes and Desc] ON COMPANY = [Mfgr Descr] 


WHERE USERNAME = @USERNAME

END
GO
