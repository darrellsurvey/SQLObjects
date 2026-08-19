IF OBJECT_ID('dbo.Custom_Search') IS NOT NULL
    DROP PROCEDURE [dbo].[Custom_Search];
GO

-- =============================================
-- Author:		Colin
-- Create date: 10/21/2011
-- Description:	Generates tables for custom search on the website
-- =============================================
CREATE PROCEDURE [dbo].[Custom_Search] 
	-- Add the parameters for the stored procedure here
@loginID nvarchar(50), 
@company nvarchar(50),	
@tour nvarchar(300), 
@date1 datetime, 
@date2 datetime, 
@EquipType nvarchar(20), 
@player nvarchar(50), 
@brand nvarchar(50), 
@model nvarchar(50)


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF ((@player IS NOT NULL) OR (@brand IS NOT NULL)OR (@model IS NOT NULL))
BEGIN
 if @company = 'DARRELL SURVEY'
	begin
	IF (@EquipType = 'Ball')
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[PLAYERNAME] AS 'Player', d.[Mfgr Descr] AS 'Brand', b.[model descr] AS 'Model'
		FROM Player_Master.[All] a
		JOIN LKP.[Model Codes and Descr] b ON a.ballmodel = b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.BALLBRAND = d.[Mfgr Code]
			WHERE (a.[PLAYERNAME] = @player OR d.[Mfgr Descr] = @brand OR d.[Mfgr Descr] +' - '+ b.[Model Descr] = @model)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2 AND a.[SID] = c.[SID]
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.PLAYERNAME, d.[Mfgr Descr]

	IF @EquipType = 'Iron' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', a.[Iron Club Code] AS 'Club', d.[Mfgr Descr] AS 'Brand', b.[model descr] AS 'Model'
		FROM Player_Master.[Iron Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Iron Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Iron Brand Code] = d.[Mfgr Code]
			WHERE (a.[NAME] = @player OR d.[Mfgr Descr] = @brand OR d.[Mfgr Descr] +' - '+ b.[Model Descr] = @model)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2 AND a.[Survey ID] = c.[SID]
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.NAME, d.[Mfgr Descr]
			
	IF @EquipType = 'Utility Iron' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', a.[Iron Club Code] AS 'Club', d.[Mfgr Descr] AS 'Brand', b.[model descr] AS 'Model'
		FROM Player_Master.[Iron Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Iron Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Iron Brand Code] = d.[Mfgr Code]
			WHERE (a.[NAME] = @player OR d.[Mfgr Descr] = @brand OR d.[Mfgr Descr] +' - '+ b.[Model Descr] = @model)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2 AND a.[Survey ID] = c.[SID] AND a.[Iron Club Code] LIKE '%^'
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.NAME, d.[Mfgr Descr]


	IF @EquipType = 'Wedge' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', a.[Wedge Club Code] AS 'Club', e.[Mfgr Descr] AS 'Brand', b.[model descr] AS 'Model', d.[Type Descr] AS 'Loft'
		FROM Player_Master.[Wedge Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Wedge Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN [Type Codes and Description] d ON a.[Wedge Type Code] = d.[Type Code]
		JOIN LKP.[Manufacturer Codes and Desc] e ON a.[Wedge Brand Code] = e.[Mfgr Code]
			WHERE (a.[NAME] = @player OR e.[Mfgr Descr] = @brand  OR e.[Mfgr Descr] +' - '+ b.[Model Descr] = @model)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2 AND a.[Survey ID] = c.[SID]
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.NAME, e.[Mfgr Descr] 

	IF @EquipType = 'Driver' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', a.[Wood Club Code] AS 'Club', d.[Mfgr Descr] AS 'Brand', b.[model descr] AS 'Model', a.[Wood Size Code] AS 'Loft'
		FROM Player_Master.[Wood Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Wood Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Wood Brand Code] = d.[Mfgr Code]
			WHERE ((a.[NAME] = @player) OR (d.[Mfgr Descr] = @brand) OR (d.[Mfgr Descr] +' - '+ b.[Model Descr] = @model))
			AND ((@tour LIKE '%~' + c.[type] + '~%') AND (a.[First Day] BETWEEN @date1 AND @date2)  
			AND (ISDRIVER = 1)) AND a.[Survey ID] = c.[SID]
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.NAME, d.[Mfgr Descr]

	IF @EquipType = 'Fairway Wood' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', a.[Wood Club Code] AS 'Club', d.[Mfgr Descr] AS 'Brand', b.[model descr] AS 'Model', a.[Wood Size Code] AS 'Loft'
		FROM Player_Master.[Wood Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Wood Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Wood Brand Code] = d.[Mfgr Code]
			WHERE ((a.[NAME] = @player) OR (d.[Mfgr Descr] = @brand) OR (d.[Mfgr Descr] +' - '+ b.[Model Descr] = @model))
			AND ((@tour LIKE '%~' + c.[type] + '~%') AND (a.[Survey ID] = c.[SID]) AND (a.ISDRIVER IS NULL OR a.ISDRIVER = 0))  
			AND (a.[First Day] BETWEEN @date1 AND @date2)
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.NAME, d.[Mfgr Descr]
						
	IF @EquipType = 'Hybrid' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', a.[Wood Club Code] AS 'Club', d.[Mfgr Descr] AS 'Brand', b.[model descr] AS 'Model', a.[Wood Size Code] AS 'Loft'
		FROM Player_Master.[Wood Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Wood Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Wood Brand Code] = d.[Mfgr Code]
			WHERE ((a.[NAME] = @player) OR (d.[Mfgr Descr] = @brand) OR (d.[Mfgr Descr] +' - '+ b.[Model Descr] = @model))
			AND ((@tour LIKE '%~' + c.[type] + '~%') AND (a.[Survey ID] = c.[SID]) AND (a.ISDRIVER IS NULL OR a.ISDRIVER = 0) AND a.[Wood Club Code] = 'HYB')  
			AND (a.[First Day] BETWEEN @date1 AND @date2)
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.NAME, d.[Mfgr Descr]

	IF @EquipType = 'Putter' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', e.[Mfgr Descr] AS 'Brand', b.[model descr] AS 'Model', COALESCE(a.[Putter Size Code], '-') AS 'Length'
		FROM [Player_Master].[Putter Detail] a 
		JOIN LKP.[Model Codes and Descr] b ON a.[Putter Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] e ON a.[Putter Brand Code] = e.[Mfgr Code]
			WHERE ((a.[NAME] = @player) OR (e.[Mfgr Descr] = @brand)  OR (e.[Mfgr Descr] +' - '+ b.[Model Descr] = @model))
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[Survey ID] = c.[SID] AND a.[First Day] BETWEEN @date1 AND @date2
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.NAME, e.[Mfgr Descr] 

	IF @EquipType = 'Bag' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[PLAYERNAME] AS 'Player', d.[Mfgr Descr] AS 'Brand'
		FROM Player_Master.[All] a
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.BAGBRAND = d.[Mfgr Code]
			WHERE (a.[PLAYERNAME] = @player OR d.[Mfgr Descr] = @brand  )
			AND (@tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2) AND a.[SID] = c.[SID]
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.PLAYERNAME, d.[Mfgr Descr]

	IF @EquipType = 'Glove' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[PLAYERNAME] AS 'Player', d.[Mfgr Descr] AS 'Brand'
		FROM Player_Master.[All] a
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.GLOVEBRAND = d.[Mfgr Code]
			WHERE (a.[PLAYERNAME] = @player OR d.[Mfgr Descr] = @brand)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2 AND a.[SID] = c.[SID]
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.PLAYERNAME, d.[Mfgr Descr]

	IF @EquipType = 'Headgear' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[PLAYERNAME] AS 'Player', d.[Mfgr Descr] AS 'Brand'
		FROM Player_Master.[All] a
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.HEADGEARBRAND = d.[Mfgr Code]
			WHERE (a.[PLAYERNAME] = @player OR d.[Mfgr Descr] = @brand)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2 AND a.[SID] = c.[SID]
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.PLAYERNAME, d.[Mfgr Descr]

	IF @EquipType = 'Shoe' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[PLAYERNAME] AS 'Player', d.[Mfgr Descr] AS 'Brand'
		FROM Player_Master.[All] a
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.SHOEBRAND = d.[Mfgr Code]
			WHERE (a.[PLAYERNAME] = @player OR d.[Mfgr Descr] = @brand)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2 AND a.[SID] = c.[SID]
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.PLAYERNAME, d.[Mfgr Descr]

	IF @EquipType = 'Spike' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[PLAYERNAME] AS 'Player', d.[Mfgr Descr] AS 'Brand'
		FROM Player_Master.[All] a
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.SPIKEBRAND = d.[Mfgr Code]
			WHERE (a.[PLAYERNAME] = @player OR d.[Mfgr Descr] = @brand)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2 AND a.[SID] = c.[SID]
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.PLAYERNAME, d.[Mfgr Descr]

	IF @EquipType = 'Iron Shaft' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', a.[Shaft Club Code] AS 'Club', d.[Mfgr Descr] AS 'Brand', b.[model descr] AS 'Model'
		FROM Player_Master.[Shaft Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Shaft Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Shaft Brand Code] = d.[Mfgr Code]
			WHERE (a.[NAME] = @player OR d.[Mfgr Descr] = @brand  OR d.[Mfgr Descr] +' - '+ b.[Model Descr] = @model)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			AND a.[Shaft Equip Type] = 'IRON' AND a.[Survey ID] = c.[SID]
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.NAME, d.[Mfgr Descr]
			

	IF @EquipType = 'Wedge Shaft' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', a.[Shaft Club Code] AS 'Club', d.[Mfgr Descr] AS 'Brand', b.[model descr] AS 'Model'
		FROM Player_Master.[Shaft Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Shaft Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY] AND a.[Survey ID] = c.[SID]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Shaft Brand Code] = d.[Mfgr Code]
			WHERE (a.[NAME] = @player OR d.[Mfgr Descr] = @brand  OR d.[Mfgr Descr] +' - '+ b.[Model Descr] = @model)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			AND a.[Shaft Equip Type] = 'WEDG'
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.NAME, d.[Mfgr Descr]

	IF @EquipType = 'Wood Shaft' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', a.[Shaft Club Code] AS 'Club', d.[Mfgr Descr] AS 'Brand', b.[model descr] AS 'Model'
		FROM Player_Master.[Shaft Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Shaft Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Shaft Brand Code] = d.[Mfgr Code]
			WHERE (a.[NAME] = @player OR d.[Mfgr Descr] = @brand  OR d.[Mfgr Descr] +' - '+ b.[Model Descr] = @model)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			AND a.[Shaft Equip Type] = 'WOOD' AND a.[Survey ID] = c.[SID]
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.NAME, d.[Mfgr Descr]
			
	/*
	IF @EquipType = 'Putter Shaft' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', d.[Mfgr Descr] AS 'Brand', a.[Shaft Club Code] AS 'Club', b.[model descr] AS 'Model'
		FROM Player_Master.[Shaft Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Shaft Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Shaft Brand Code] = d.[Mfgr Code]
			WHERE (a.[NAME] = @player OR a.[Shaft Brand Code] = @brand  OR d.[Mfgr Descr] +' - '+ b.[Model Descr] = @model)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			AND a.[Shaft Equip Type] = 'PUTT'
			ORDER BY a.[First Day] DESC, a.Name, d.[Mfgr Descr]
	*/
		
	IF @EquipType = 'Iron Grip' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', a.[Grip Club Code] AS 'Club', d.[Mfgr Descr] AS 'Brand', b.[model descr] AS 'Model'
		FROM Player_Master.[Grip Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Grip Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Grip Brand Code] = d.[Mfgr Code]
			WHERE (a.[NAME] = @player OR d.[Mfgr Descr] = @brand  OR d.[Mfgr Descr] +' - '+ b.[Model Descr] = @model)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			AND a.[Grip Equip Type] = 'IRON' AND a.[Survey ID] = c.[SID]
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.NAME, d.[Mfgr Descr]

	IF @EquipType = 'Wedge Grip'
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', a.[Grip Club Code] AS 'Club', d.[Mfgr Descr] AS 'Brand', b.[model descr] AS 'Model'
		FROM Player_Master.[Grip Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Grip Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Grip Brand Code] = d.[Mfgr Code]
		WHERE (a.[NAME] = @player OR d.[Mfgr Descr] = @brand  OR d.[Mfgr Descr] +' - '+ b.[Model Descr] = @model)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			AND a.[Grip Equip Type] = 'WEDG' AND a.[Survey ID] = c.[SID]
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.NAME, d.[Mfgr Descr]

	IF @EquipType = 'Wood Grip'
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', a.[Grip Club Code] AS 'Club', d.[Mfgr Descr] AS 'Brand', b.[model descr] AS 'Model'
		FROM Player_Master.[Grip Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Grip Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Grip Brand Code] = d.[Mfgr Code]
			WHERE (a.[NAME] = @player OR a.[Grip Brand Code] = @brand  OR d.[Mfgr Descr] +' - '+ b.[Model Descr] = @model)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			AND a.[Grip Equip Type] = 'WOOD' AND a.[Survey ID] = c.[SID]
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.NAME, d.[Mfgr Descr]

	IF @EquipType = 'Putter Grip' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', d.[Mfgr Descr] AS 'Brand', b.[model descr] AS 'Model'
		FROM Player_Master.[Grip Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Grip Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Grip Brand Code] = d.[Mfgr Code]
			WHERE (a.[NAME] = @player OR d.[Mfgr Descr] = @brand  OR d.[Mfgr Descr] +' - '+ b.[Model Descr] = @model)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			AND a.[Grip Equip Type] = 'PUTT' AND a.[Survey ID] = c.[SID]
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.NAME, d.[Mfgr Descr]
		
	ELSE PRINT 'ERROR: Var @EquipType not found'	
	end
	else
	begin

/************************************************/

IF (@EquipType = 'Ball')

SELECT c.[TYPE] AS 'Tour', 
	c.[TOURNAMENT NAME] AS 'Tournament', 
	a.[FIRST DAY] AS 'Date', 
	a.[PLAYERNAME] AS 'Player', 
	d.[Mfgr Descr] AS 'Brand', 
	b.[model descr] AS 'Model'
FROM Player_Master.[All] a
	INNER JOIN LKP.[Model Codes and Descr] b ON a.ballmodel = b.[Model Code]
	INNER JOIN LKP.[Manufacturer Codes and Desc] d ON a.BALLBRAND = d.[Mfgr Code]
	INNER JOIN (
			SELECT [Tournament Name], [type], [first day], TD 
			FROM darrell_master.Billing.AllOrdersYTD 
			WHERE Company = @company 
			AND [First Day] BETWEEN @date1 and @date2
			AND @tour LIKE '%~' + [type] + '~%' 
			group by [Tournament Name], [type], [first day], TD) c 
			ON a.[FIRST DAY] = c.[FIRST DAY] and a.[SID] = c.TD
WHERE (a.[PLAYERNAME] = @player 
		OR d.[Mfgr Descr] = @brand 
		OR d.[Mfgr Descr] +' - '+ b.[Model Descr] = @model)
ORDER BY a.[FIRST DAY] desc, c.[Type], a.PLAYERNAME


/************************************************/


	IF @EquipType = 'Iron' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', a.[Iron Club Code] AS 'Club', d.[Mfgr Descr] AS 'Brand', b.[model descr] AS 'Model'
		FROM Player_Master.[Iron Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Iron Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Iron Brand Code] = d.[Mfgr Code]
			WHERE (a.[NAME] = @player OR d.[Mfgr Descr] = @brand OR d.[Mfgr Descr] +' - '+ b.[Model Descr] = @model)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2 AND a.[Survey ID] = c.[SID]
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE Company = @company AND [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.NAME, d.[Mfgr Descr]
			
	IF @EquipType = 'Utility Iron' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', a.[Iron Club Code] AS 'Club', d.[Mfgr Descr] AS 'Brand', b.[model descr] AS 'Model'
		FROM Player_Master.[Iron Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Iron Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Iron Brand Code] = d.[Mfgr Code]
			WHERE (a.[NAME] = @player OR d.[Mfgr Descr] = @brand OR d.[Mfgr Descr] +' - '+ b.[Model Descr] = @model)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2 AND a.[Survey ID] = c.[SID] AND a.[Iron Club Code] LIKE '%^'
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE Company = @company AND [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.NAME, d.[Mfgr Descr]


	IF @EquipType = 'Wedge' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', a.[Wedge Club Code] AS 'Club', e.[Mfgr Descr] AS 'Brand', b.[model descr] AS 'Model', d.[Type Descr] AS 'Loft'
		FROM Player_Master.[Wedge Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Wedge Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN [Type Codes and Description] d ON a.[Wedge Type Code] = d.[Type Code]
		JOIN LKP.[Manufacturer Codes and Desc] e ON a.[Wedge Brand Code] = e.[Mfgr Code]
			WHERE (a.[NAME] = @player OR e.[Mfgr Descr] = @brand  OR e.[Mfgr Descr] +' - '+ b.[Model Descr] = @model)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2 AND a.[Survey ID] = c.[SID]
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE Company = @company AND [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.NAME, e.[Mfgr Descr] 

	IF @EquipType = 'Driver' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', a.[Wood Club Code] AS 'Club', d.[Mfgr Descr] AS 'Brand', b.[model descr] AS 'Model', a.[Wood Size Code] AS 'Loft'
		FROM Player_Master.[Wood Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Wood Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Wood Brand Code] = d.[Mfgr Code]
			WHERE ((a.[NAME] = @player) OR (d.[Mfgr Descr] = @brand) OR (d.[Mfgr Descr] +' - '+ b.[Model Descr] = @model))
			AND ((@tour LIKE '%~' + c.[type] + '~%') AND (a.[First Day] BETWEEN @date1 AND @date2)  
			AND (ISDRIVER = 1)) AND a.[Survey ID] = c.[SID]
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE Company = @company AND [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.NAME, d.[Mfgr Descr]

	IF @EquipType = 'Fairway Wood' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', a.[Wood Club Code] AS 'Club', d.[Mfgr Descr] AS 'Brand', b.[model descr] AS 'Model', a.[Wood Size Code] AS 'Loft'
		FROM Player_Master.[Wood Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Wood Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Wood Brand Code] = d.[Mfgr Code]
			WHERE ((a.[NAME] = @player) OR (d.[Mfgr Descr] = @brand) OR (d.[Mfgr Descr] +' - '+ b.[Model Descr] = @model))
			AND ((@tour LIKE '%~' + c.[type] + '~%') AND (a.[Survey ID] = c.[SID]) AND (a.ISDRIVER IS NULL OR a.ISDRIVER = 0))  
			AND (a.[First Day] BETWEEN @date1 AND @date2)
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE Company = @company AND [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.NAME, d.[Mfgr Descr]
						
	IF @EquipType = 'Hybrid' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', a.[Wood Club Code] AS 'Club', d.[Mfgr Descr] AS 'Brand', b.[model descr] AS 'Model', a.[Wood Size Code] AS 'Loft'
		FROM Player_Master.[Wood Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Wood Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Wood Brand Code] = d.[Mfgr Code]
			WHERE ((a.[NAME] = @player) OR (d.[Mfgr Descr] = @brand) OR (d.[Mfgr Descr] +' - '+ b.[Model Descr] = @model))
			AND ((@tour LIKE '%~' + c.[type] + '~%') AND (a.[Survey ID] = c.[SID]) AND (a.ISDRIVER IS NULL OR a.ISDRIVER = 0) AND a.[Wood Club Code] = 'HYB')  
			AND (a.[First Day] BETWEEN @date1 AND @date2)
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE Company = @company AND [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.NAME, d.[Mfgr Descr]

	IF @EquipType = 'Putter' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', e.[Mfgr Descr] AS 'Brand', b.[model descr] AS 'Model', COALESCE(a.[Putter Size Code], '-') AS 'Length'
		FROM [Player_Master].[Putter Detail] a 
		JOIN LKP.[Model Codes and Descr] b ON a.[Putter Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] e ON a.[Putter Brand Code] = e.[Mfgr Code]
			WHERE ((a.[NAME] = @player) OR (e.[Mfgr Descr] = @brand)  OR (e.[Mfgr Descr] +' - '+ b.[Model Descr] = @model))
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[Survey ID] = c.[SID] AND a.[First Day] BETWEEN @date1 AND @date2
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE Company = @company AND [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.NAME, e.[Mfgr Descr] 

	IF @EquipType = 'Bag' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[PLAYERNAME] AS 'Player', d.[Mfgr Descr] AS 'Brand'
		FROM Player_Master.[All] a
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.BAGBRAND = d.[Mfgr Code]
			WHERE (a.[PLAYERNAME] = @player OR d.[Mfgr Descr] = @brand  )
			AND (@tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2) AND a.[SID] = c.[SID]
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE Company = @company AND [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.PLAYERNAME, d.[Mfgr Descr]

	IF @EquipType = 'Glove' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[PLAYERNAME] AS 'Player', d.[Mfgr Descr] AS 'Brand'
		FROM Player_Master.[All] a
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.GLOVEBRAND = d.[Mfgr Code]
			WHERE (a.[PLAYERNAME] = @player OR d.[Mfgr Descr] = @brand)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2 AND a.[SID] = c.[SID]
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE Company = @company AND [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.PLAYERNAME, d.[Mfgr Descr]

	IF @EquipType = 'Headgear' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[PLAYERNAME] AS 'Player', d.[Mfgr Descr] AS 'Brand'
		FROM Player_Master.[All] a
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.HEADGEARBRAND = d.[Mfgr Code]
			WHERE (a.[PLAYERNAME] = @player OR d.[Mfgr Descr] = @brand)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2 AND a.[SID] = c.[SID]
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE Company = @company AND [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.PLAYERNAME, d.[Mfgr Descr]

	IF @EquipType = 'Shoe' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[PLAYERNAME] AS 'Player', d.[Mfgr Descr] AS 'Brand'
		FROM Player_Master.[All] a
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.SHOEBRAND = d.[Mfgr Code]
			WHERE (a.[PLAYERNAME] = @player OR d.[Mfgr Descr] = @brand)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2 AND a.[SID] = c.[SID]
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE Company = @company AND [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.PLAYERNAME, d.[Mfgr Descr]

	IF @EquipType = 'Spike' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[PLAYERNAME] AS 'Player', d.[Mfgr Descr] AS 'Brand'
		FROM Player_Master.[All] a
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.SPIKEBRAND = d.[Mfgr Code]
			WHERE (a.[PLAYERNAME] = @player OR d.[Mfgr Descr] = @brand)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2 AND a.[SID] = c.[SID]
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE Company = @company AND [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.PLAYERNAME, d.[Mfgr Descr]

	IF @EquipType = 'Iron Shaft' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', a.[Shaft Club Code] AS 'Club', d.[Mfgr Descr] AS 'Brand', b.[model descr] AS 'Model'
		FROM Player_Master.[Shaft Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Shaft Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Shaft Brand Code] = d.[Mfgr Code]
			WHERE (a.[NAME] = @player OR d.[Mfgr Descr] = @brand  OR d.[Mfgr Descr] +' - '+ b.[Model Descr] = @model)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			AND a.[Shaft Equip Type] = 'IRON' AND a.[Survey ID] = c.[SID]
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE Company = @company AND [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.NAME, d.[Mfgr Descr]
			

	IF @EquipType = 'Wedge Shaft' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', a.[Shaft Club Code] AS 'Club', d.[Mfgr Descr] AS 'Brand', b.[model descr] AS 'Model'
		FROM Player_Master.[Shaft Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Shaft Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY] AND a.[Survey ID] = c.[SID]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Shaft Brand Code] = d.[Mfgr Code]
			WHERE (a.[NAME] = @player OR d.[Mfgr Descr] = @brand  OR d.[Mfgr Descr] +' - '+ b.[Model Descr] = @model)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			AND a.[Shaft Equip Type] = 'WEDG'
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE Company = @company AND [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.NAME, d.[Mfgr Descr]

	IF @EquipType = 'Wood Shaft' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', a.[Shaft Club Code] AS 'Club', d.[Mfgr Descr] AS 'Brand', b.[model descr] AS 'Model'
		FROM Player_Master.[Shaft Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Shaft Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Shaft Brand Code] = d.[Mfgr Code]
			WHERE (a.[NAME] = @player OR d.[Mfgr Descr] = @brand  OR d.[Mfgr Descr] +' - '+ b.[Model Descr] = @model)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			AND a.[Shaft Equip Type] = 'WOOD' AND a.[Survey ID] = c.[SID]
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE Company = @company AND [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.NAME, d.[Mfgr Descr]
			
	/*
	IF @EquipType = 'Putter Shaft' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', d.[Mfgr Descr] AS 'Brand', a.[Shaft Club Code] AS 'Club', b.[model descr] AS 'Model'
		FROM Player_Master.[Shaft Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Shaft Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Shaft Brand Code] = d.[Mfgr Code]
			WHERE (a.[NAME] = @player OR a.[Shaft Brand Code] = @brand  OR d.[Mfgr Descr] +' - '+ b.[Model Descr] = @model)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			AND a.[Shaft Equip Type] = 'PUTT'
			ORDER BY a.[First Day] DESC, a.Name, d.[Mfgr Descr]
	*/
		
	IF @EquipType = 'Iron Grip' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', a.[Grip Club Code] AS 'Club', d.[Mfgr Descr] AS 'Brand', b.[model descr] AS 'Model'
		FROM Player_Master.[Grip Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Grip Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Grip Brand Code] = d.[Mfgr Code]
			WHERE (a.[NAME] = @player OR d.[Mfgr Descr] = @brand  OR d.[Mfgr Descr] +' - '+ b.[Model Descr] = @model)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			AND a.[Grip Equip Type] = 'IRON' AND a.[Survey ID] = c.[SID]
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE Company = @company AND [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.NAME, d.[Mfgr Descr]

	IF @EquipType = 'Wedge Grip'
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', a.[Grip Club Code] AS 'Club', d.[Mfgr Descr] AS 'Brand', b.[model descr] AS 'Model'
		FROM Player_Master.[Grip Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Grip Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Grip Brand Code] = d.[Mfgr Code]
		WHERE (a.[NAME] = @player OR d.[Mfgr Descr] = @brand  OR d.[Mfgr Descr] +' - '+ b.[Model Descr] = @model)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			AND a.[Grip Equip Type] = 'WEDG' AND a.[Survey ID] = c.[SID]
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE Company = @company AND [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.NAME, d.[Mfgr Descr]

	IF @EquipType = 'Wood Grip'
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', a.[Grip Club Code] AS 'Club', d.[Mfgr Descr] AS 'Brand', b.[model descr] AS 'Model'
		FROM Player_Master.[Grip Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Grip Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Grip Brand Code] = d.[Mfgr Code]
			WHERE (a.[NAME] = @player OR a.[Grip Brand Code] = @brand  OR d.[Mfgr Descr] +' - '+ b.[Model Descr] = @model)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			AND a.[Grip Equip Type] = 'WOOD' AND a.[Survey ID] = c.[SID]
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE Company = @company AND [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.NAME, d.[Mfgr Descr]

	IF @EquipType = 'Putter Grip' 
		SELECT c.[TYPE] AS 'Tour', c.[TOURNAMENT NAME] AS 'Tournament', a.[FIRST DAY] AS 'Date', a.[NAME] AS 'Player', d.[Mfgr Descr] AS 'Brand', b.[model descr] AS 'Model'
		FROM Player_Master.[Grip Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Grip Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Grip Brand Code] = d.[Mfgr Code]
			WHERE (a.[NAME] = @player OR d.[Mfgr Descr] = @brand  OR d.[Mfgr Descr] +' - '+ b.[Model Descr] = @model)
			AND @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			AND a.[Grip Equip Type] = 'PUTT' AND a.[Survey ID] = c.[SID]
			AND c.[TOURNAMENT NAME] IN (SELECT DISTINCT([Tournament Name]) FROM Billing.AllOrdersYTD WHERE Company = @company AND [First Day] BETWEEN @date1 and @date2)
			ORDER BY a.[FIRST DAY] ASC, a.NAME, d.[Mfgr Descr]
		
	ELSE PRINT 'ERROR: Var @EquipType not found'	
	
	end
END	
ELSE PRINT 'ERROR: Selection constraint empty'

	
END
GO
