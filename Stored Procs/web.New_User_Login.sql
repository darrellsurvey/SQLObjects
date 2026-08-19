IF OBJECT_ID('web.New_User_Login') IS NOT NULL
    DROP PROCEDURE [web].[New_User_Login];
GO

--EXECUTE dbo.web_get_tourneys 'TITLEIST', 'PGA', 2011, 'Charles'

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- ==========================================
CREATE PROCEDURE [web].[New_User_Login]
	-- Add the parameters for the stored procedure here
	@USERNAME varchar(50),
	@PASSWORD varchar(50),
	@PERMLEVEL int,
	@VIEWER bit,
    @FIRSTNAME  varchar(50),
	@LASTNAME  varchar(50),
	@COMPANY  varchar(50),
	@EMAIL  varchar(50) = ''
	
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	Declare @GROUPID int
	set @GROUPID = (SELECT [GROUP_ID] FROM [DARRELL_MASTER].[LKP].[Company_Groups] where COMPANY = @COMPANY )
		
	INSERT INTO [DARRELL_MASTER].[web].[Login_info]
           ([USERNAME],[PW],[PERMLEVEL],[DASHCOUNT],[FIRST NAME],[LAST NAME],[COMPANY],[GROUP_ID] 
           ,[EMAIL],[IP LIMIT],[ACCESSCOUNT],[ADDEDBY],[ADDEDON])
     VALUES
           (@USERNAME,@PASSWORD,@PERMLEVEL,3,@FIRSTNAME,@LASTNAME,@COMPANY,@GROUPID
           ,@EMAIL,3,1,'Alex',GETDATE())

	
	insert into [DARRELL_MASTER].[Billing].[user_levels]
			(username, [year], [tour], view_lvl, company)
				SELECT distinct @USERNAME , year([First Day]) ,[Type] , 
				CASE @Viewer WHEN 0 THEN 1 ELSE 0 END, @COMPANY
 				FROM [DARRELL_MASTER].[Billing].AllOrdersYTD
					where Company = @COMPANY and [First Day]>'01/01/2010'
		
	
	if @VIEWER = 1
		begin
			INSERT INTO [DARRELL_MASTER].[web].[Login_viewerinfo]
				([USERNAME],[PW],[PERMLEVEL],[DASHCOUNT],[FIRST NAME],[LAST NAME],[COMPANY]
		  		,[EMAIL],[ACCESSCOUNT],[ADDEDBY],[ADDEDON])
			VALUES
				(@USERNAME,@PASSWORD,1,0,@FIRSTNAME,@LASTNAME,@COMPANY,@EMAIL,0,'Alex',GETDATE())
	   	end
	
	

	END
GO
