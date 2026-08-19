IF OBJECT_ID('LKP.IPNumber_fn') IS NOT NULL
    DROP FUNCTION [LKP].[IPNumber_fn];
GO

CREATE FUNCTION [LKP].[IPNumber_fn]
(
	@IPAddress varchar(20)
)
RETURNS bigint
AS
BEGIN

  DECLARE @IPNumber bigint
--  SET @IPNumber = CAST(PARSENAME(@IPAddress, 4) as bigint) *16777216 

  SET @IPNumber = 
    CAST(PARSENAME(@IPAddress, 4) as bigint) *16777216
  + CAST(PARSENAME(@IPAddress, 3) as bigint) *65536 
  + CAST(PARSENAME(@IPAddress, 2) as bigint) *256 
  + CAST(PARSENAME(@IPAddress, 1) as bigint) 
      
  RETURN @IPNumber 

END
GO
