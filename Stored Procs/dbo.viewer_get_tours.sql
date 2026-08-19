DROP PROCEDURE IF EXISTS [dbo].[viewer_get_tours];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- ==========================================
CREATE PROCEDURE [dbo].[viewer_get_tours]
	-- Add the parameters for the stored procedure here
	@COMPANY varchar(50)

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	

	IF @COMPANY = 'DARRELL SURVEY'
	
	BEGIN
		Select [Type] from Billing.AllOrdersYTD
		GROUP BY [Type]
		order by 
		CASE
			when [Type] = 'PGA' then 1
			when [Type] = 'NATIONWIDE' then 2
			when [Type] = 'CHAMPIONS' then 3
			when [Type] = 'LPGA' then 4
			when [Type] = 'JGTO' then 5
			when [Type] = 'JLPGA' then 6
			when [Type] = 'CLPGA' then 7
			when [Type] = 'ONEASIA' then 8
			when [Type] = 'AMATEUR' then 9
			else 10
		END
	END
	ELSE
	BEGIN
		Select [Type] from Billing.AllOrdersYTD
		where Company = @COMPANY and YEAR([First Day]) > 2004
		GROUP BY [Type]
		order by 
		CASE
			when [Type] = 'PGA' then 1
			when [Type] = 'NATIONWIDE' then 2
			when [Type] = 'CHAMPIONS' then 3
			when [Type] = 'LPGA' then 4
			when [Type] = 'JGTO' then 5
			when [Type] = 'JLPGA' then 6
			when [Type] = 'CLPGA' then 7
			when [Type] = 'ONEASIA' then 8
			when [Type] = 'AMATEUR' then 9
			else 10
		END
	END



/*
Select b.[Type] from Billing.AllOrdersYTD a
LEFT OUTER JOIN Player_Master.TOURNAMENTS_TABLE b ON YEAR(a."FIRST DAY") = YEAR(b."First Day") AND TD = SID
where Company = @COMPANY and b.[Type] IS NOT NULL
GROUP BY b.[Type]
order by 
CASE
when b.[Type] = 'PGA' then 1
when b.[Type] = 'NATIONWIDE' then 2
when b.[Type] = 'CHAMPIONS' then 3
when b.[Type] = 'LPGA' then 4
when b.[Type] = 'JGTO' then 5
when b.[Type] = 'JLPGA' then 6
when b.[Type] = 'AMATEUR' then 7
else 8
END

select TOUR from Billing.permissions where rule_entity = @COMPANY and permission = 1
GROUP BY TOUR
order by 
CASE
when TOUR = 'PGA' then 1
when TOUR = 'NATIONWIDE' then 2
when TOUR = 'CHAMPIONS' then 3
when TOUR = 'LPGA' then 4
when TOUR = 'JGTO' then 5
when TOUR = 'JLPGA' then 6
when TOUR = 'AMATEUR' then 7
else 8
END
*/
end
GO
