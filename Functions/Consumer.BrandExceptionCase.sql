DROP FUNCTION IF EXISTS [Consumer].[BrandExceptionCase];
GO

CREATE function [Consumer].[BrandExceptionCase] ()
returns varchar(500)
with execute as caller
as
begin
	DECLARE @query AS nvarchar(500) = ' ''All Other'',
							''All Others'',
							''Use Any'', 
							''Don`t Know'',
							''Don`t Have'',
							''Club Crest'', 
							''Custom'', 
							''Any'',
							''Component'',
							''All Others/Don`t Know'',
							''None'',
							''T-Shirt'', 	
							''Keep Same Brand & Model'' '

return @query

--''None'',
--''T-Shirt'', 							
	
END;
GO
