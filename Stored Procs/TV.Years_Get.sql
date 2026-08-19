DROP PROCEDURE IF EXISTS [TV].[Years_Get];
GO

CREATE PROCEDURE [TV].[Years_Get]
	@COMPANY nvarchar(50),
	@loginid nvarchar(50) = ''
AS
begin
	SET NOCOUNT ON;
	
	if @COMPANY = 'DARRELL SURVEY'
		begin
			SELECT distinct year([TntFirstDay]) as [Year] FROM TV.TVAudit with (nolock)
			WHERE TntFirstDay is not null
			order by [Year] desc
		end
	else
		begin
			SELECT distinct top(2) year([TntFirstDay]) as [Year] FROM TV.TVAudit with (nolock)
			WHERE TntFirstDay is not null
			order by [Year] desc

		end
end
GO
