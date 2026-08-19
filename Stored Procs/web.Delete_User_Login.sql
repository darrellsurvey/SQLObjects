DROP PROCEDURE IF EXISTS [web].[Delete_User_Login];
GO

--EXECUTE dbo.web_get_tourneys 'TITLEIST', 'PGA', 2011, 'Charles'

-- =============================================
-- Author:		Alex
-- Create date: 8/21/2012
-- Description:	Delete Web User
-- ==========================================
Create PROCEDURE [web].[Delete_User_Login]
	-- Add the parameters for the stored procedure here
	@USERNAME varchar(50)
	
AS	
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	
	INSERT INTO [DARRELL_MASTER].[web].[Login_info_deleted]
           ([USERNAME],[PW],[PERMLEVEL],[DASHCOUNT],[FIRST NAME],[LAST NAME],[COMPANY],[GROUP_ID], [EMAIL],[IP LIMIT],[ACCESSCOUNT],[ADDEDBY],[ADDEDON])
     select [USERNAME],[PW],[PERMLEVEL],[DASHCOUNT],[FIRST NAME],[LAST NAME],[COMPANY],[GROUP_ID], [EMAIL],[IP LIMIT],[ACCESSCOUNT],'Alex',GETDATE()
           from [DARRELL_MASTER].[web].[Login_info] where USERNAME = @USERNAME
	
	insert into [DARRELL_MASTER].[Billing].[user_levels_deleted]
			(username, [year], [tour], view_lvl, company)
		SELECT username, [year], [tour], view_lvl, company
		from [DARRELL_MASTER].[Billing].[user_levels] where USERNAME = @USERNAME
	
	INSERT INTO [DARRELL_MASTER].[web].[Login_viewerinfo_deleted]
           ([USERNAME],[PW],[PERMLEVEL],[DASHCOUNT],[FIRST NAME],[LAST NAME],[COMPANY],[EMAIL],[IP LIMIT],[ACCESSCOUNT],[ADDEDBY],[ADDEDON])
     select [USERNAME],[PW],[PERMLEVEL],[DASHCOUNT],[FIRST NAME],[LAST NAME],[COMPANY],[EMAIL],[IP LIMIT],[ACCESSCOUNT],'Alex',GETDATE()
           from [DARRELL_MASTER].[web].[Login_viewerinfo] where USERNAME = @USERNAME
	
	
	Delete from [DARRELL_MASTER].[web].[Login_info] where USERNAME = @USERNAME
	Delete from [DARRELL_MASTER].[web].[Login_viewerinfo] where USERNAME = @USERNAME
	Delete from [DARRELL_MASTER].[Billing].[user_levels] where USERNAME = @USERNAME


	END
GO
