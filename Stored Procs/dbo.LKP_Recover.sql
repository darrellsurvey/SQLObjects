IF OBJECT_ID('dbo.LKP_Recover') IS NOT NULL
    DROP PROCEDURE [dbo].[LKP_Recover];
GO

-- =============================================
-- Author:		Colin
-- Create date: 2011-10-11
-- Description:	Re-generates all missing brand and model code in LKP tables from Player Master files
-- =============================================
CREATE PROCEDURE [dbo].[LKP_Recover] 
	-- Add the parameters for the stored procedure here
	@p1 int = 0, 
	@p2 int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


DECLARE @testtable TABLE
(id int IDENTITY(1,1) PRIMARY KEY, [Brand Code] varchar(10), [Model Code] varchar(10), [Type] varchar(50))

INSERT INTO @testtable ([Brand Code], [Model Code], Type)

SELECT [Wood Brand Code], [Wood Model Code], 'Wood' FROM Player_Master.[Wood Detail] 
GROUP BY [Wood Brand Code], [Wood Model Code]

INSERT INTO @testtable

SELECT [wedge Brand Code], [wedge Model Code], 'wedge' FROM Player_Master.[wedge Detail] 
GROUP BY [wedge Brand Code], [wedge Model Code]

INSERT INTO @testtable

SELECT [iron Brand Code], [iron Model Code], 'iron' FROM Player_Master.[iron Detail] 
GROUP BY [iron Brand Code], [iron Model Code]

INSERT INTO @testtable

SELECT [shaft Brand Code], [shaft Model Code], 'shaft'  FROM Player_Master.[shaft Detail] 
GROUP BY [shaft Brand Code], [shaft Model Code]

INSERT INTO @testtable

SELECT [putter Brand Code], [putter Model Code], 'putter'  FROM Player_Master.[putter Detail] 
GROUP BY [putter Brand Code], [putter Model Code]

INSERT INTO @testtable

SELECT [grip Brand Code], [grip Model Code], 'grip'   FROM Player_Master.[grip Detail] 
GROUP BY [grip Brand Code], [grip Model Code]

INSERT INTO @testtable

SELECT BALLBRAND, BALLMODEL, 'Ball'  FROM Player_Master.[ALL] 
GROUP BY BALLBRAND, BALLMODEL

INSERT INTO @testtable

SELECT BAGBRAND, '-', 'Bag'  FROM Player_Master.[ALL] 
GROUP BY BAGBRAND

INSERT INTO @testtable

SELECT GLOVEBRAND, '-', 'Glove'  FROM Player_Master.[ALL]
GROUP BY GLOVEBRAND

INSERT INTO @testtable

SELECT SHOEBRAND, '-', 'Shoe'  FROM Player_Master.[ALL]
GROUP BY SHOEBRAND

INSERT INTO @testtable

SELECT SPIKEBRAND, SPIKEMODEL, 'Spike' FROM Player_Master.[ALL]
GROUP BY SPIKEBRAND, SPIKEMODEL

INSERT INTO @testtable

SELECT SHIRTBRAND, '-', 'Shirt' FROM Player_Master.[ALL]
GROUP BY SHIRTBRAND

INSERT INTO @testtable

SELECT HEADGEARBRAND, '-', 'Headgear' FROM Player_Master.[ALL]
GROUP BY HEADGEARBRAND;



INSERT INTO LKP.[Brand/Model Codes with Equip] ([PKey], [Mfgr Code]
      ,[Model Code]
      ,[Changed]
      ,[By]
      ,[Ball]
      ,[Iron]
      ,[Wedge]
      ,[Wood]
      ,[Putter]
      ,[Shaft]
      ,[Grip]
      ,[Glove]
      ,[Shoes]
      ,[Headgr]
      ,[Bag]
      ,[Shirt]
      ,[Spikes], [active_flag])
   
  SELECT
   
      '1234', [Brand Code]
      ,[Model Code]
      ,GETDATE()
      ,'Colin'
      ,CASE WHEN ([brand code] IN (SELECT [Brand Code] FROM @testtable WHERE [type] = 'Ball') AND [model code] IN (SELECT [model Code] FROM @testtable WHERE [type] = 'Ball')) THEN 'X' END AS BALL,
      CASE WHEN ([brand code] IN (SELECT [Brand Code] FROM @testtable WHERE [type] = 'Iron') AND [model code] IN (SELECT [model Code] FROM @testtable WHERE [type] = 'Iron')) THEN 'X' END AS IRON,
      CASE WHEN ([brand code] IN (SELECT [Brand Code] FROM @testtable WHERE [type] = 'Wedge') AND [model code] IN (SELECT [model Code] FROM @testtable WHERE [type] = 'Wedge')) THEN 'X' END AS WEDGE,
      CASE WHEN ([brand code] IN (SELECT [Brand Code] FROM @testtable WHERE [type] = 'Wood') AND [model code] IN (SELECT [model Code] FROM @testtable WHERE [type] = 'Wood')) THEN 'X' END AS WOOD,
      CASE WHEN ([brand code] IN (SELECT [Brand Code] FROM @testtable WHERE [type] = 'Putter') AND [model code] IN (SELECT [model Code] FROM @testtable WHERE [type] = 'Putter')) THEN 'X' END AS PUTTER,
      CASE WHEN ([brand code] IN (SELECT [Brand Code] FROM @testtable WHERE [type] = 'Shaft') AND [model code] IN (SELECT [model Code] FROM @testtable WHERE [type] = 'Shaft')) THEN 'X' END AS SHAFT,
      CASE WHEN ([brand code] IN (SELECT [Brand Code] FROM @testtable WHERE [type] = 'Grip') AND [model code] IN (SELECT [model Code] FROM @testtable WHERE [type] = 'Grip')) THEN 'X' END AS GRIP,
      CASE WHEN ([brand code] IN (SELECT [Brand Code] FROM @testtable WHERE [type] = 'Glove') AND [model code] IN (SELECT [model Code] FROM @testtable WHERE [type] = 'Glove')) THEN 'X' END AS GLOVE,
      CASE WHEN ([brand code] IN (SELECT [Brand Code] FROM @testtable WHERE [type] = 'Shoe') AND [model code] IN (SELECT [model Code] FROM @testtable WHERE [type] = 'Shoe')) THEN 'X' END AS SHOE,
      CASE WHEN ([brand code] IN (SELECT [Brand Code] FROM @testtable WHERE [type] = 'Headgear') AND [model code] IN (SELECT [model Code] FROM @testtable WHERE [type] = 'Headgear')) THEN 'X' END AS HEADGEAR,
      CASE WHEN ([brand code] IN (SELECT [Brand Code] FROM @testtable WHERE [type] = 'Bag') AND [model code] IN (SELECT [model Code] FROM @testtable WHERE [type] = 'Bag')) THEN 'X' END AS BAG,
      CASE WHEN ([brand code] IN (SELECT [Brand Code] FROM @testtable WHERE [type] = 'Shirt') AND [model code] IN (SELECT [model Code] FROM @testtable WHERE [type] = 'Shirt')) THEN 'X' END AS SHIRT,
      CASE WHEN ([brand code] IN (SELECT [Brand Code] FROM @testtable WHERE [type] = 'Spike') AND [model code] IN (SELECT [model Code] FROM @testtable WHERE [type] = 'Spike')) THEN 'X' END AS SPIKE,
      '1'

     
 from @testtable
 
 WHERE [Brand code]+[model code] in 
(	SELECT a.[Brand Code]+a.[Model Code] FROM @testtable a
		LEFT JOIN LKP.[Brand/Model Codes with Equip] b
		On a.[Brand Code] = b.[Mfgr Code] AND a.[Model Code] = b.[Model Code] 
	WHERE ((b.[Mfgr Code] IS NULL) or (b.[Model Code] IS NULL)))

GROUP BY [brand code], [model code]



INSERT INTO LKP.[Manufacturer Codes and Desc] 
( [Mfgr Code]
      ,[Changed]
      ,[By]
      ,[Ball]
      ,[Iron]
      ,[Wedge]
      ,[Wood]
      ,[Putter]
      ,[Shaft]
      ,[Grip]
      ,[Glove]
      ,[Shoes]
      ,[Headgr]
      ,[Bag]
      ,[Shirt]
      ,[Spikes], [active_flag])
    
    
      
  SELECT
   
       [Brand Code]
      ,GETDATE()
      ,'Colin'
      ,CASE WHEN ([brand code] IN (SELECT [Brand Code] FROM @testtable WHERE [type] = 'Ball') ) THEN 'X' END AS BALL,
      CASE WHEN ([brand code] IN (SELECT [Brand Code] FROM @testtable WHERE [type] = 'Iron') ) THEN 'X' END AS IRON,
      CASE WHEN ([brand code] IN (SELECT [Brand Code] FROM @testtable WHERE [type] = 'Wedge') ) THEN 'X' END AS WEDGE,
      CASE WHEN ([brand code] IN (SELECT [Brand Code] FROM @testtable WHERE [type] = 'Wood') ) THEN 'X' END AS WOOD,
      CASE WHEN ([brand code] IN (SELECT [Brand Code] FROM @testtable WHERE [type] = 'Putter') ) THEN 'X' END AS PUTTER,
      CASE WHEN ([brand code] IN (SELECT [Brand Code] FROM @testtable WHERE [type] = 'Shaft') ) THEN 'X' END AS SHAFT,
      CASE WHEN ([brand code] IN (SELECT [Brand Code] FROM @testtable WHERE [type] = 'Grip') ) THEN 'X' END AS GRIP,
      CASE WHEN ([brand code] IN (SELECT [Brand Code] FROM @testtable WHERE [type] = 'Glove') ) THEN 'X' END AS GLOVE,
      CASE WHEN ([brand code] IN (SELECT [Brand Code] FROM @testtable WHERE [type] = 'Shoe') ) THEN 'X' END AS SHOE,
      CASE WHEN ([brand code] IN (SELECT [Brand Code] FROM @testtable WHERE [type] = 'Headgear') ) THEN 'X' END AS HEADGEAR,
      CASE WHEN ([brand code] IN (SELECT [Brand Code] FROM @testtable WHERE [type] = 'Bag') ) THEN 'X' END AS BAG,
      CASE WHEN ([brand code] IN (SELECT [Brand Code] FROM @testtable WHERE [type] = 'Shirt') ) THEN 'X' END AS SHIRT,
      CASE WHEN ([brand code] IN (SELECT [Brand Code] FROM @testtable WHERE [type] = 'Spike') ) THEN 'X' END AS SPIKE,
      '1'

     
 from @testtable
 
 WHERE [Brand code] in 
(	SELECT a.[Brand Code] FROM @testtable a
		LEFT JOIN LKP.[Manufacturer Codes and Desc] b
		On a.[Brand Code] = b.[Mfgr Code] 
	WHERE (b.[Mfgr Code] IS NULL) AND (a.[Brand Code] IS NOT NULL) )

GROUP BY [brand code];



INSERT INTO LKP.[Model Codes and Descr] ([Model Code], Changed, [By])

SELECT [model code], GETDATE(), 'Colin' 
FROM @testtable
Where [Model Code] in 
	(SELECT a.[model code] FROM @testtable a LEFT JOIN LKP.[Model Codes and Descr] b
	ON a.[Model Code] = b.[Model Code] WHERE b.[Model Code] IS NULL) 
	


END
GO
