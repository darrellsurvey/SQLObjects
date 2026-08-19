DROP PROCEDURE IF EXISTS [Search].[Tours_GetByYears];
GO

CREATE PROCEDURE [Search].[Tours_GetByYears]
	@COMPANY varchar(50),
	@loginid varchar(50) = '',
	@YearFrom int,
	@YearTo int
AS
begin
	SET NOCOUNT ON;

	IF @COMPANY = 'DARRELL SURVEY'
	SELECT TourId=[Type], 
           TourName=[Type] 
	from Billing.AllOrdersYTD 
	WHERE YEAR([FIRST DAY]) between @YearFrom and @YearTo 
	GROUP BY [Type]
	order by 
		CASE
		when [Type] = 'PGA' then 1
		when [Type] = 'WEB.COM' then 2
		when [Type] = 'NATIONWIDE' then 3
		when [Type] = 'CHAMPIONS' then 4
		when [Type] = 'LPGA' then 5
		when [Type] = 'JGTO' then 6
		when [Type] = 'JLPGA' then 7
		when [Type] = 'CLPGA' then 8
		when [Type] = 'ONEASIA' then 9
		when [Type] = 'AMATEUR' then 10
		else 11
		END
	ELSE
		SELECT TourId=[Tour], 
               TourName=[Tour] 
		from Billing.user_levels ul
		inner join Billing.AllOrdersYTD b
		on ul.Company = b.Company and ul.year = Year(b.[FIRST DAY]) and ul.tour = b.TYPE
		WHERE ul.[YEAR]  between @YearFrom and @YearTo 
		AND username = @loginid 
		GROUP BY TOUR
		order by 
			CASE
			when TOUR = 'PGA' then 1
			when TOUR = 'WEB.COM' then 2
			when TOUR = 'NATIONWIDE' then 3
			when TOUR = 'CHAMPIONS' then 4
			when TOUR = 'LPGA' then 5
			when TOUR = 'JGTO' then 6
			when TOUR = 'JLPGA' then 7
			when TOUR = 'CLPGA' then 8
			when TOUR = 'ONEASIA' then 9
			when TOUR = 'AMATEUR' then 10
			else 11
			END	
		end
GO
