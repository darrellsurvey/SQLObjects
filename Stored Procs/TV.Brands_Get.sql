IF OBJECT_ID('TV.Brands_Get') IS NOT NULL
    DROP PROCEDURE [TV].[Brands_Get];
GO

CREATE PROCEDURE [TV].[Brands_Get]
	@Company nvarchar(50),
	@LoginId nvarchar(50),
	@Year int,
	@TournamentSID int
AS
begin
	SET NOCOUNT ON;
	SELECT distinct Brand
	from TV.TVAudit with (nolock)
	WHERE YEAR(TntFirstDay) = @Year
	  and TntNid = @TournamentSID
	order by Brand
end
GO
