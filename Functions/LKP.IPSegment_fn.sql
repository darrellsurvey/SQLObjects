DROP FUNCTION IF EXISTS [LKP].[IPSegment_fn];
GO

CREATE FUNCTION [LKP].[IPSegment_fn]
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
      
  RETURN @IPNumber 

END
GO
