IF OBJECT_ID('MoneyBall.uspAddWebsiteUser') IS NOT NULL
    DROP PROCEDURE [MoneyBall].[uspAddWebsiteUser];
GO

CREATE PROCEDURE [MoneyBall].[uspAddWebsiteUser]
    @pLogin NVARCHAR(50), 
    @pPassword NVARCHAR(50),
    @pFirstName NVARCHAR(40) = NULL, 
    @pLastName NVARCHAR(40) = NULL,
    @pCompany NVARCHAR(40) = NULL,
    @responseMessage NVARCHAR(250) OUTPUT
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @salt UNIQUEIDENTIFIER=NEWID()
    BEGIN TRY

        INSERT INTO MoneyBall.WebsiteUser (LoginName, PasswordHash, Salt, FirstName, LastName, Company)
        VALUES(@pLogin, HASHBYTES('SHA1', @pPassword+CAST(@salt AS NVARCHAR(36))), @salt, @pFirstName, @pLastName, @pCompany)

       SET @responseMessage='Success'

    END TRY
    BEGIN CATCH
        SET @responseMessage=ERROR_MESSAGE() 
    END CATCH

END
GO
