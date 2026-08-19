IF OBJECT_ID('TV.Tours_Get') IS NOT NULL
    DROP PROCEDURE [TV].[Tours_Get];
GO

CREATE PROCEDURE [TV].[Tours_Get]
	@COMPANY varchar(50),
	@loginid varchar(50) = '',
	@Year int
AS
begin
	SET NOCOUNT ON;
	SELECT [TourID]=[Tour], [TourName]=[Tour] 
	from TV.TVAudit with (nolock)
	where YEAR(TntFirstDay) = @Year
	group by [Tour]
	order by 
		CASE
		when [Tour] = 'PGA' then 1
		when [Tour] = 'EPGA' then 2
		when [Tour] = 'JGTO' then 6
		when [Tour] = 'JLPGA' then 7
		else 11
		END
end
GO
