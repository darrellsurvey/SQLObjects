DROP PROCEDURE IF EXISTS [dbo].[viewer_get_reports];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- ==========================================
CREATE PROCEDURE [dbo].[viewer_get_reports]
	-- Add the parameters for the stored procedure here
	@COMPANY varchar(50),
	@TOUR varchar(20),
	@YEAR int,
	@TOURNEYNAME varchar(100)--,
	--@loginid varchar(100)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		IF @COMPANY = 'DARRELL SURVEY'
	
	BEGIN
		Select "Report Name" from Billing.AllOrdersYTD
		where [Type] = @TOUR and YEAR([First Day]) = @YEAR and [tournament name] = @TOURNEYNAME
		GROUP BY "Report Name" order by "Report Name";
	end
	else
	begin
		Select "Report Name" from Billing.AllOrdersYTD
		where Company = @COMPANY and [Type] = @TOUR and YEAR([First Day]) = @YEAR and [tournament name] = @TOURNEYNAME
		GROUP BY "Report Name" order by "Report Name";
	end
end
	
	
	
/*	
Select "Report Name" from Billing.AllOrdersYTD a
LEFT OUTER JOIN Player_Master.TOURNAMENTS_TABLE b ON YEAR(a."FIRST DAY") = YEAR(b."First Day") AND TD = SID
where Company = @COMPANY and b.[Type] = @TOUR and YEAR(b.[First Day]) = @YEAR and b.[tournament name] = @TOURNEYNAME and b.[Type] IS NOT NULL
GROUP BY "Report Name" order by "Report Name";
*/
GO
