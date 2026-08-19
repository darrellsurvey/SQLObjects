DROP PROCEDURE IF EXISTS [MoneyBall].[uspWebsiteUserLogin];
GO

CREATE PROCEDURE MoneyBall.uspWebsiteUserLogin
    @pLoginName NVARCHAR(254),
    @pPassword NVARCHAR(50),
    @responseMessage NVARCHAR(250)='' OUTPUT
AS
BEGIN

    SET NOCOUNT ON

    DECLARE @userID INT

    IF EXISTS (SELECT TOP 1 WebsiteUserId FROM MoneyBall.WebsiteUser WHERE LoginName=@pLoginName)
    BEGIN
        SET @userID=(SELECT WebsiteUserId FROM MoneyBall.WebsiteUser WHERE LoginName=@pLoginName AND PasswordHash=HASHBYTES('SHA1', @pPassword+CAST(Salt AS NVARCHAR(36))))

       IF(@userID IS NULL)
           SET @responseMessage='Incorrect password'
       ELSE 
           SET @responseMessage='User successfully logged in'
    END
    ELSE
       SET @responseMessage='Invalid login'

END
GO
