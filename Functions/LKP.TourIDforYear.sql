IF OBJECT_ID('LKP.TourIDforYear') IS NOT NULL
    DROP FUNCTION [LKP].[TourIDforYear];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [LKP].[TourIDforYear]
(
	@TourID int,
	@year int
)
RETURNS Integer
AS
BEGIN

DECLARE @RESULT int

SELECT @RESULT = [TourId] 
FROM [DARRELL_MASTER].[LKP].[Tour] 
where [Year] = @year and TourMasterId = 
			(SELECT [TourMasterId] FROM [DARRELL_MASTER].[LKP].[Tour] 
					where [TourId] = @TourID)

RETURN @RESULT

END
GO
