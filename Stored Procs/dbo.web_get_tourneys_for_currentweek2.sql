DROP PROCEDURE IF EXISTS [dbo].[web_get_tourneys_for_currentweek2];
GO

-- =============================================
-- Author:		Alex
-- Create date: 
-- Description:	provide tournament list for current week and mobile page
-- =============================================
CREATE PROCEDURE [dbo].[web_get_tourneys_for_currentweek2]
	-- Add the parameters for the stored procedure here
	-- Add the parameters for the stored procedure here
	@COMPANY varchar(50),
	@loginid varchar(50)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @COMPANY = 'DARRELL SURVEY'
		SELECT [Tournament Name], 
		CAST(MONTH([FIRST DAY]) AS NVARCHAR) + '/' +
	CAST(DAY([First Day]) AS NVARCHAR) + '/' +
	CAST(YEAR([FIRST DAY]) AS NVARCHAR)
	AS 'FIRST DAY',
			CAST(MONTH([LAST DAY]) AS NVARCHAR) + '/' +
	CAST(DAY([LAST DAY]) AS NVARCHAR) + '/' +
	CAST(YEAR([LAST DAY]) AS NVARCHAR)
	AS 'LAST DAY',
	[TYPE] as TOUR, TD AS SID, YEAR([First Day]) AS YEAR,
		CONVERT(varchar(5),[first day],1) + ' - ' + [TYPE] + ' - ' + [Tournament Name] AS WEBNAME,
		[first day] as fd
	FROM Billing.AllOrdersYTD
		WHERE (DATEDIFF(DAY, [First Day], GETDATE()) BETWEEN -2 and 6)
		GROUP BY [TOURNAMENT NAME], [FIRST DAY], [LAST DAY], TYPE, td 
		ORDER BY fd DESC,
				CASE
			when [Type] = 'PGA' then 1
			when [Type] = 'WEB.COM' then 2
			when [Type] = 'NATIONWIDE' then 2
			when [Type] = 'CHAMPIONS' then 3
			when [Type] = 'LPGA' then 4
			when [Type] = 'JGTO' then 5
			when [Type] = 'JLPGA' then 6
			when [Type] = 'CLPGA' then 7
			when [Type] = 'ONEASIA' then 8
			when [Type] = 'AMATEUR' then 9
			else 10
		end
		
	ELSE
		SELECT [Tournament Name],
		CAST(MONTH([FIRST DAY]) AS NVARCHAR) + '/' +
	CAST(DAY([First Day]) AS NVARCHAR) + '/' +
	CAST(YEAR([FIRST DAY]) AS NVARCHAR)
	AS 'FIRST DAY',
				CAST(MONTH([LAST DAY]) AS NVARCHAR) + '/' +
	CAST(DAY([LAST DAY]) AS NVARCHAR) + '/' +
	CAST(YEAR([LAST DAY]) AS NVARCHAR)
	AS 'LAST DAY',
	[TYPE] as TOUR, TD as SID, YEAR([First Day]) AS YEAR,
			CONVERT(varchar(5),[first day],1) +  ' - ' + [TYPE] + ' - ' + [Tournament Name] AS WEBNAME,
			[first day] as fd
	FROM Billing.allordersytd a
	inner join 
		(select [tour] from [Billing].[user_levels] where username = @loginid and [year] = year(getdate())) b on a.[Type] = b.tour
		WHERE DATEDIFF(DAY, [First Day], GETDATE()) BETWEEN -2 and 6 and a.Company = @company
		GROUP BY [TOURNAMENT NAME], [FIRST DAY], [LAST DAY], TYPE, td
		ORDER BY fd DESC, 
			CASE
			when [Type] = 'PGA' then 1
			when [Type] = 'WEB.COM' then 2
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
GO
