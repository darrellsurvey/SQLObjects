IF OBJECT_ID('dbo.CustomSearch_Listbox') IS NOT NULL
    DROP PROCEDURE [dbo].[CustomSearch_Listbox];
GO

-- =============================================
-- Author:		Colin
-- Create date: 2011-10-31
-- Description:	Populates the listbox on the custom search webpage
-- =============================================
CREATE PROCEDURE [dbo].[CustomSearch_Listbox] 
	-- Add the parameters for the stored procedure here

	@Tour nvarchar(300),
	@EquipType nvarchar(20),
	@date1 datetime,
	@date2 datetime,
	@ItemFilter nvarchar(20)

AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF (@ItemFilter = 'Brand')
BEGIN

	IF (@EquipType = 'Ball')
		SELECT  d.[Mfgr Descr] AS 'Brand'
		FROM Player_Master.[All] a
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY] AND a.[SID] = c.[SID]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.BALLBRAND = d.[Mfgr Code]
			WHERE @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			GROUP BY d.[Mfgr Descr]
			ORDER BY d.[Mfgr Descr]
			

	IF @EquipType = 'Iron' 
		SELECT  d.[Mfgr Descr] AS 'Brand'
		FROM Player_Master.[Iron Detail] a
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY] AND a.[Survey ID] = c.[SID]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Iron Brand Code] = d.[Mfgr Code]
			WHERE @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			GROUP BY d.[Mfgr Descr]
			ORDER BY d.[Mfgr Descr]
			
	IF @EquipType = 'Utility Iron' 
		SELECT  d.[Mfgr Descr] AS 'Brand'
		FROM Player_Master.[Iron Detail] a
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY] AND a.[Survey ID] = c.[SID]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Iron Brand Code] = d.[Mfgr Code]
			WHERE @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2 AND a.[Iron Club Code] LIKE '%^'
			GROUP BY d.[Mfgr Descr]
			ORDER BY d.[Mfgr Descr]

	IF @EquipType = 'Wedge' 
		SELECT  e.[Mfgr Descr] AS 'Brand'
		FROM Player_Master.[Wedge Detail] a
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY] AND a.[Survey ID] = c.[SID]
		JOIN LKP.[Manufacturer Codes and Desc] e ON a.[Wedge Brand Code] = e.[Mfgr Code]
			WHERE @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			GROUP BY e.[Mfgr Descr]
			ORDER BY e.[Mfgr Descr]

	IF @EquipType = 'Driver' 
		SELECT  d.[Mfgr Descr] AS 'Brand'
		FROM Player_Master.[Wood Detail] a
		INNER JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY] AND a.[Survey ID] = c.[SID]
		INNER JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Wood Brand Code] = d.[Mfgr Code]
			WHERE (@tour LIKE '%~' + c.[type] + '~%') AND (a.[First Day] BETWEEN @date1 AND @date2)
			AND (ISDRIVER = 1)
			GROUP BY d.[Mfgr Descr]
			ORDER BY d.[Mfgr Descr]

	IF @EquipType = 'Fairway Wood' 
		SELECT d.[Mfgr Descr] AS 'Brand'
		FROM Player_Master.[Wood Detail] a
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY] AND a.[Survey ID] = c.[SID]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Wood Brand Code] = d.[Mfgr Code]
			WHERE((@tour LIKE '%~' + c.[type] + '~%') AND (a.[First Day] BETWEEN @date1 AND @date2)
			AND (a.ISDRIVER IS NULL OR a.ISDRIVER = 0))
			GROUP BY d.[Mfgr Descr]
			ORDER BY d.[Mfgr Descr]
			
	IF @EquipType = 'Hybrid' 
		SELECT d.[Mfgr Descr] AS 'Brand'
		FROM Player_Master.[Wood Detail] a
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY] AND a.[Survey ID] = c.[SID]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Wood Brand Code] = d.[Mfgr Code]
			WHERE((@tour LIKE '%~' + c.[type] + '~%') AND (a.[First Day] BETWEEN @date1 AND @date2)
			AND (a.ISDRIVER IS NULL OR a.ISDRIVER = 0) AND a.[Wood Club Code] = 'HYB')
			GROUP BY d.[Mfgr Descr]
			ORDER BY d.[Mfgr Descr]

	IF @EquipType = 'Putter' 
		SELECT e.[Mfgr Descr] AS 'Brand'
		FROM [Player_Master].[Putter Detail] a 
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY] AND a.[Survey ID] = c.[SID]
		JOIN LKP.[Manufacturer Codes and Desc] e ON a.[Putter Brand Code] = e.[Mfgr Code]
			WHERE ((@tour LIKE '%~' + c.[type] + '~%') AND (a.[First Day] BETWEEN @date1 AND @date2)) 
			GROUP BY e.[Mfgr Descr]
			ORDER BY e.[Mfgr Descr]

	IF @EquipType = 'Bag' 
		SELECT  d.[Mfgr Descr] AS 'Brand'
		FROM Player_Master.[All] a
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY] AND a.[SID] = c.[SID]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.BAGBRAND = d.[Mfgr Code]
			WHERE (@tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2)
			GROUP BY d.[Mfgr Descr]
			ORDER BY d.[Mfgr Descr]

	IF @EquipType = 'Glove' 
		SELECT  d.[Mfgr Descr] AS 'Brand'
		FROM Player_Master.[All] a
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY] AND a.[SID] = c.[SID]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.GLOVEBRAND = d.[Mfgr Code]
			WHERE @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			GROUP BY d.[Mfgr Descr]
			ORDER BY d.[Mfgr Descr]

	IF @EquipType = 'Headgear' 
		SELECT d.[Mfgr Descr] AS 'Brand'
		FROM Player_Master.[All] a
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY] AND a.[SID] = c.[SID]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.HEADGEARBRAND = d.[Mfgr Code]
			WHERE @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			GROUP BY d.[Mfgr Descr]
			ORDER BY d.[Mfgr Descr]

	IF @EquipType = 'Shoe' 
		SELECT d.[Mfgr Descr] AS 'Brand'
		FROM Player_Master.[All] a
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY] AND a.[SID] = c.[SID]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.SHOEBRAND = d.[Mfgr Code]
			WHERE @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			GROUP BY d.[Mfgr Descr]
			ORDER BY d.[Mfgr Descr]

	IF @EquipType = 'Spike' 
		SELECT  d.[Mfgr Descr] AS 'Brand'
		FROM Player_Master.[All] a
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY] AND a.[SID] = c.[SID]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.SPIKEBRAND = d.[Mfgr Code]
			WHERE @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			GROUP BY d.[Mfgr Descr]
			ORDER BY d.[Mfgr Descr]

	IF @EquipType = 'Iron Shaft' 
		SELECT  d.[Mfgr Descr] AS 'Brand'
		FROM Player_Master.[Shaft Detail] a
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY] AND a.[Survey ID] = c.[SID]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Shaft Brand Code] = d.[Mfgr Code]
			WHERE @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			AND a.[Shaft Equip Type] = 'IRON'
			GROUP BY d.[Mfgr Descr]
			ORDER BY d.[Mfgr Descr]
			
			
	IF @EquipType = 'Wedge Shaft' 
		SELECT  d.[Mfgr Descr] AS 'Brand'
		FROM Player_Master.[Shaft Detail] a
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY] 
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Shaft Brand Code] = d.[Mfgr Code]
			WHERE @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			AND a.[Shaft Equip Type] = 'WEDG' AND a.[Survey ID] = c.[SID]
			GROUP BY d.[Mfgr Descr]
			ORDER BY d.[Mfgr Descr]
	
	IF @EquipType = 'Wood Shaft' 
		SELECT  d.[Mfgr Descr] AS 'Brand'
		FROM Player_Master.[Shaft Detail] a
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY] AND a.[Survey ID] = c.[SID]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Shaft Brand Code] = d.[Mfgr Code]
			WHERE @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			AND a.[Shaft Equip Type] = 'WOOD'
			GROUP BY d.[Mfgr Descr]
			ORDER BY d.[Mfgr Descr]
		
	IF @EquipType = 'Iron Grip' 
		SELECT d.[Mfgr Descr] AS 'Brand'
		FROM Player_Master.[Grip Detail] a
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY] AND a.[Survey ID] = c.[SID]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Grip Brand Code] = d.[Mfgr Code]
			WHERE (@tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2)
			AND a.[Grip Equip Type] = 'IRON'
			GROUP BY d.[Mfgr Descr]
			ORDER BY d.[Mfgr Descr]
			
	IF @EquipType = 'Wedge Grip' 
		SELECT d.[Mfgr Descr] AS 'Brand'
		FROM Player_Master.[Grip Detail] a
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY] AND a.[Survey ID] = c.[SID]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Grip Brand Code] = d.[Mfgr Code]
			WHERE (@tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2)
			AND a.[Grip Equip Type] = 'WEDG'
			GROUP BY d.[Mfgr Descr]
			ORDER BY d.[Mfgr Descr]

	IF @EquipType = 'Wood Grip' 
		SELECT d.[Mfgr Descr] AS 'Brand'
		FROM Player_Master.[Grip Detail] a
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY] AND a.[Survey ID] = c.[SID]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Grip Brand Code] = d.[Mfgr Code]
			WHERE (@tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2)
			AND a.[Grip Equip Type] = 'WOOD'
			GROUP BY d.[Mfgr Descr]
			ORDER BY d.[Mfgr Descr]

	IF @EquipType = 'Putter Grip' 
		SELECT d.[Mfgr Descr] AS 'Brand'
		FROM Player_Master.[Grip Detail] a
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY] AND a.[Survey ID] = c.[SID]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Grip Brand Code] = d.[Mfgr Code]
			WHERE (@tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2)
			AND a.[Grip Equip Type] = 'PUTT'
			GROUP BY d.[Mfgr Descr]
			ORDER BY d.[Mfgr Descr]

	ELSE PRINT 'ERROR: Var @EquipType not found'	
END	



--Model search--
IF (@ItemFilter = 'Model')
BEGIN

IF (@EquipType = 'Ball')
		SELECT  d.[Mfgr Descr] +' - '+ b.[model descr] AS 'Model'
		FROM Player_Master.[All] a
		JOIN LKP.[Model Codes and Descr] b ON a.ballmodel = b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.BALLBRAND = d.[Mfgr Code]
			WHERE @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2 AND a.[SID] = c.[SID]
			GROUP BY d.[Mfgr Descr] +' - '+ b.[model descr]
			ORDER BY d.[Mfgr Descr] +' - '+ b.[model descr]

	IF @EquipType = 'Iron' 
		SELECT  d.[Mfgr Descr] +' - '+ b.[model descr] AS 'Model'
		FROM Player_Master.[Iron Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Iron Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Iron Brand Code] = d.[Mfgr Code]
			WHERE @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2 AND a.[Survey ID] = c.[SID]
			GROUP BY d.[Mfgr Descr] +' - '+ b.[model descr]
			ORDER BY d.[Mfgr Descr] +' - '+ b.[model descr]
			
	IF @EquipType = 'Utility Iron' 
		SELECT  d.[Mfgr Descr] +' - '+ b.[model descr] AS 'Model'
		FROM Player_Master.[Iron Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Iron Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Iron Brand Code] = d.[Mfgr Code]
			WHERE @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2 AND a.[Survey ID] = c.[SID] AND a.[Iron Club Code] LIKE '%^'
			GROUP BY d.[Mfgr Descr] +' - '+ b.[model descr]
			ORDER BY d.[Mfgr Descr] +' - '+ b.[model descr]

	IF @EquipType = 'Wedge' 
		SELECT e.[Mfgr Descr] +' - '+ b.[model descr] AS 'Model'
		FROM Player_Master.[Wedge Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Wedge Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN [Type Codes and Description] d ON a.[Wedge Type Code] = d.[Type Code]
		JOIN LKP.[Manufacturer Codes and Desc] e ON a.[Wedge Brand Code] = e.[Mfgr Code]
			WHERE @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2 AND a.[Survey ID] = c.[SID]
			GROUP BY e.[Mfgr Descr] +' - '+ b.[model descr]
			ORDER BY e.[Mfgr Descr] +' - '+ b.[model descr]

	IF @EquipType = 'Driver' 
		SELECT d.[Mfgr Descr] +' - '+ b.[model descr] AS 'Model'
		FROM Player_Master.[Wood Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Wood Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Wood Brand Code] = d.[Mfgr Code]
			WHERE  ((@tour LIKE '%~' + c.[type] + '~%') AND (a.[First Day] BETWEEN @date1 AND @date2)  
			AND (ISDRIVER = 1)) AND a.[Survey ID] = c.[SID]
			GROUP BY d.[Mfgr Descr] +' - '+ b.[model descr]
			ORDER BY d.[Mfgr Descr] +' - '+ b.[model descr]

	IF @EquipType = 'Fairway Wood' 
		SELECT d.[Mfgr Descr] +' - '+ b.[model descr] AS 'Model'
		FROM Player_Master.[Wood Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Wood Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Wood Brand Code] = d.[Mfgr Code]
			WHERE ((@tour LIKE '%~' + c.[type] + '~%') AND (a.[Survey ID] = c.[SID]) AND (a.ISDRIVER IS NULL OR a.ISDRIVER = 0))  
			AND (a.[First Day] BETWEEN @date1 AND @date2)
			GROUP BY d.[Mfgr Descr] +' - '+ b.[model descr]
			ORDER BY d.[Mfgr Descr] +' - '+ b.[model descr]
			
	IF @EquipType = 'Fairway Wood' 
		SELECT d.[Mfgr Descr] +' - '+ b.[model descr] AS 'Model'
		FROM Player_Master.[Wood Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Wood Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Wood Brand Code] = d.[Mfgr Code]
			WHERE ((@tour LIKE '%~' + c.[type] + '~%') AND (a.[Survey ID] = c.[SID]) AND (a.ISDRIVER IS NULL OR a.ISDRIVER = 0) AND a.[Wood Club Code] = 'HYB')  
			AND (a.[First Day] BETWEEN @date1 AND @date2)
			GROUP BY d.[Mfgr Descr] +' - '+ b.[model descr]
			ORDER BY d.[Mfgr Descr] +' - '+ b.[model descr]
			
	IF @EquipType = 'Putter' 
		SELECT  e.[Mfgr Descr] +' - '+ b.[model descr] AS 'Model'
		FROM [Player_Master].[Putter Detail] a 
		JOIN LKP.[Model Codes and Descr] b ON a.[Putter Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] e ON a.[Putter Brand Code] = e.[Mfgr Code]
			WHERE  @tour LIKE '%~' + c.[type] + '~%' AND a.[Survey ID] = c.[SID] AND a.[First Day] BETWEEN @date1 AND @date2
			GROUP BY e.[Mfgr Descr] +' - '+ b.[model descr]
			ORDER BY e.[Mfgr Descr] +' - '+ b.[model descr]


	IF @EquipType = 'Iron Shaft' 
		SELECT d.[Mfgr Descr] +' - '+ b.[model descr] AS 'Model'
		FROM Player_Master.[Shaft Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Shaft Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Shaft Brand Code] = d.[Mfgr Code]
			WHERE @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			AND a.[Shaft Equip Type] = 'IRON' AND a.[Survey ID] = c.[SID]
			GROUP BY d.[Mfgr Descr] +' - '+ b.[model descr]
			ORDER BY d.[Mfgr Descr] +' - '+ b.[model descr]
			

	IF @EquipType = 'Wedge Shaft' 
		SELECT  d.[Mfgr Descr] +' - '+ b.[model descr] AS 'Model'
		FROM Player_Master.[Shaft Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Shaft Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY] AND a.[Survey ID] = c.[SID]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Shaft Brand Code] = d.[Mfgr Code]
			WHERE  @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			AND a.[Shaft Equip Type] = 'WEDG'
			GROUP BY d.[Mfgr Descr] +' - '+ b.[model descr]
			ORDER BY d.[Mfgr Descr] +' - '+ b.[model descr]

	IF @EquipType = 'Wood Shaft' 
		SELECT d.[Mfgr Descr] +' - '+ b.[model descr] AS 'Model'
		FROM Player_Master.[Shaft Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Shaft Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Shaft Brand Code] = d.[Mfgr Code]
			WHERE  @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			AND a.[Shaft Equip Type] = 'WOOD' AND a.[Survey ID] = c.[SID]
			GROUP BY d.[Mfgr Descr] +' - '+ b.[model descr]
			ORDER BY d.[Mfgr Descr] +' - '+ b.[model descr]
			
		
	IF @EquipType = 'Iron Grip' 
		SELECT d.[Mfgr Descr] +' - '+ b.[model descr] AS 'Model'
		FROM Player_Master.[Grip Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Grip Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Grip Brand Code] = d.[Mfgr Code]
			WHERE @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			AND a.[Grip Equip Type] = 'IRON' AND a.[Survey ID] = c.[SID]
			GROUP BY d.[Mfgr Descr] +' - '+ b.[model descr]
			ORDER BY d.[Mfgr Descr] +' - '+ b.[model descr]

	IF @EquipType = 'Wedge Grip'
		SELECT  d.[Mfgr Descr] +' - '+ b.[model descr] AS 'Model'
		FROM Player_Master.[Grip Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Grip Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Grip Brand Code] = d.[Mfgr Code]
		WHERE @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			AND a.[Grip Equip Type] = 'WEDG' AND a.[Survey ID] = c.[SID]
			GROUP BY d.[Mfgr Descr] +' - '+ b.[model descr]
			ORDER BY d.[Mfgr Descr] +' - '+ b.[model descr]

	IF @EquipType = 'Wood Grip'
		SELECT d.[Mfgr Descr] +' - '+ b.[model descr] AS 'Model'
		FROM Player_Master.[Grip Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Grip Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Grip Brand Code] = d.[Mfgr Code]
			WHERE @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			AND a.[Grip Equip Type] = 'WOOD' AND a.[Survey ID] = c.[SID]
			GROUP BY d.[Mfgr Descr] +' - '+ b.[model descr]
			ORDER BY d.[Mfgr Descr] +' - '+ b.[model descr]

	IF @EquipType = 'Putter Grip' 
		SELECT d.[Mfgr Descr] +' - '+ b.[model descr] AS 'Model'
		FROM Player_Master.[Grip Detail] a
		JOIN LKP.[Model Codes and Descr] b ON a.[Grip Model Code]= b.[Model Code]
		JOIN [Player_Master].TOURNAMENTS_TABLE c ON a.[FIRST DAY] = c.[FIRST DAY]
		JOIN LKP.[Manufacturer Codes and Desc] d ON a.[Grip Brand Code] = d.[Mfgr Code]
			WHERE @tour LIKE '%~' + c.[type] + '~%' AND a.[First Day] BETWEEN @date1 AND @date2
			AND a.[Grip Equip Type] = 'PUTT' AND a.[Survey ID] = c.[SID]
			GROUP BY d.[Mfgr Descr] +' - '+ b.[model descr]
			ORDER BY d.[Mfgr Descr] +' - '+ b.[model descr]
	
		
	ELSE PRINT 'ERROR: Var @EquipType not found'	
END
	
--Player Search--
IF (@ItemFilter = 'Player')
	SELECT PLAYERNAME FROM Player_Master.[All] a
	LEFT JOIN Player_Master.TOURNAMENTS_TABLE b ON a.[FIRST DAY] = b.[FIRST DAY] AND a.[SID] = b.[SID]
	WHERE @tour LIKE '%~' + b.[type] + '~%' AND a.[FIRST DAY] BETWEEN @date1 AND @date2
	GROUP BY a.PLAYERNAME
	ORDER BY a.PLAYERNAME
	
	

END
GO
