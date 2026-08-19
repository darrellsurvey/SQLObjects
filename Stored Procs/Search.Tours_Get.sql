IF OBJECT_ID('Search.Tours_Get') IS NOT NULL
    DROP PROCEDURE [Search].[Tours_Get];
GO

CREATE  PROCEDURE [Search].[Tours_Get]
	@COMPANY varchar(50),
	@loginid varchar(50) = '',
	@YEAR int = 0
	
AS
begin
	SET NOCOUNT ON;
	if @COMPANY = 'CLEVELAND' 
			set @COMPANY = 'SREXON'
	IF @YEAR = 0 
	begin
		SELECT @YEAR = YEAR(GETDATE()) -2
		
	
		IF @COMPANY = 'DARRELL SURVEY'
			SELECT TourId=[Type], 
                   TourName=[Type] 
			from Billing.AllOrdersYTD with (nolock)
			WHERE YEAR([FIRST DAY]) >= @YEAR 
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
				on ul.Company = b.Company and ul.year = Year(b.[FIRST DAY])
				WHERE ul.[year] >= @YEAR AND username = @loginid 
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
		END
	else
		begin
			IF @COMPANY = 'DARRELL SURVEY'
			SELECT TourId=[Type], 
                   TourName=[Type] 
			from Billing.AllOrdersYTD 
			WHERE YEAR([FIRST DAY]) = @YEAR 
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
				on ul.Company = b.Company and ul.year = Year(b.[FIRST DAY])
				WHERE ul.[year] = @YEAR AND username = @loginid 
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
	
end
GO
