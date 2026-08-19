IF OBJECT_ID('Input.finalize_tournament_old') IS NOT NULL
    DROP PROCEDURE [Input].[finalize_tournament_old];
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- ==========================================
create PROCEDURE [Input].[finalize_tournament_old]
	-- Add the parameters for the stored procedure here
	@SID integer,
	@FIRSTDAY date,
	@AUTHORIZEDBY varchar(50)

AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


--run first fo avoid duplicate finalizations (i.e. in the case of a change)
execute Input.un_finalize_tournament @SID, @FIRSTDAY, @AUTHORIZEDBY


update Player_Master.TOURNAMENTS_TABLE set ISFLASH = 0 where SID = @SID and [FIRST DAY] = @FIRSTDAY


 -- Pre-compute once instead of repeating 7 times inside each INSERT
      SELECT MIN(INPUTNO) AS INPUTNO2, PLAYERNAME AS PLAYERNAME2
      INTO #PlayerMinInput
      FROM Player_Master.PLAYERNAMES
      WHERE SID = @SID AND [FIRSTDAY] = @FIRSTDAY
      GROUP BY PLAYERNAME;

--woods
INSERT INTO Player_Master.[Wood Detail]

SELECT PKey, PLAYERNAME, SID, [FIRST DAY], ISDRIVER, NULL, CLUBCODE, DCLUBCODE, BRAND, DBRANDCODE, MODEL, DMODELCODE, MATERIAL, DMATERIAL, SIZE, DSIZECODE, MISC, DMISCCODE, NULL, NULL, NULL, NULL FROM (
SELECT * FROM #PlayerMinInput inputnotable
LEFT OUTER JOIN
(
SELECT [PKey]
      ,[PLAYERNAME]
      ,[SID]
      ,[FIRST DAY],
      ISDRIVER
      ,[CLUBCODE]
      ,[DCLUBCODE]
      ,brand.[Mfgr Code] AS BRAND
      ,[DBRANDCODE]
      ,model.[Model Code] AS MODEL
      ,[DMODELCODE]
      ,matl.[Matl Code] AS MATERIAL
      ,[DMATERIAL]
      ,size.[Size Code] AS SIZE
      ,[DSIZECODE]
      ,misc.[Misc Code] AS MISC
      ,[DMISCCODE]
      ,[INPUTNO]
      
  FROM [DARRELL_MASTER].[Input].[Wood] a
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] brand ON BRAND = "Mfgr Descr"
  LEFT OUTER JOIN LKP.[Model Codes and Descr] model on MODEL = "Model Descr"
  LEFT OUTER JOIN LKP.[Material Codes and Descript] matl on MATERIAL = "Matl Descr"
  LEFT OUTER JOIN LKP.[Size Codes and Description] size on SIZE = [Size Descr]
  LEFT OUTER JOIN LKP.[Miscellaneous Codes and Des] misc on MISC = "Misc Descr"
  
  where SID = @SID and [FIRST DAY] = @FIRSTDAY) data
  on inputnotable.PLAYERNAME2 = data.PLAYERNAME and inputnotable.INPUTNO2 = data.INPUTNO
) x where PLAYERNAME IS NOT NULL


-- wedges

insert into Player_Master.[Wedge Detail]

SELECT PKey, PLAYERNAME, SID, [FIRST DAY], CLUBCODE, DCLUBCODE, BRAND, DBRANDCODE, MODEL, DMODELCODE, [TYPE], DTYPECODE, MATERIAL, DMATERIAL, SIZE, DSIZECODE, MISC, DMISCCODE, NULL, NULL, NULL, NULL FROM (
SELECT * FROM #PlayerMinInput inputnotable
LEFT OUTER JOIN
(
SELECT [PKey]
      ,[PLAYERNAME]
      ,[SID]
      ,[FIRST DAY]
      ,[CLUBCODE]
      ,[DCLUBCODE]
      ,brand.[Mfgr Code] AS BRAND
      ,[DBRANDCODE]
      ,model.[Model Code] AS MODEL
      ,[DMODELCODE]
      ,type.[Type Code] AS "TYPE"
      ,DTYPECODE
      ,matl.[Matl Code] AS MATERIAL
      ,[DMATERIAL]
      ,size.[Size Code] AS SIZE
      ,[DSIZECODE]
      ,misc.[Misc Code] AS MISC
      ,[DMISCCODE]
      ,[INPUTNO]
      
  FROM [DARRELL_MASTER].[Input].[Wedge] a
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] brand ON BRAND = "Mfgr Descr"
  LEFT OUTER JOIN LKP.[Model Codes and Descr] model on MODEL = "Model Descr"
  LEFT OUTER JOIN LKP.[Material Codes and Descript] matl on MATERIAL = "Matl Descr"
  LEFT OUTER JOIN LKP.[Size Codes and Description] size on SIZE = [Size Descr]
  LEFT OUTER JOIN LKP.[Miscellaneous Codes and Des] misc on MISC = "Misc Descr"
  LEFT OUTER JOIN LKP.[Type Codes and Description] type on [TYPE] = "Type Descr"
  
  where SID = @SID and [FIRST DAY] = @FIRSTDAY) data
  on inputnotable.PLAYERNAME2 = data.PLAYERNAME and inputnotable.INPUTNO2 = data.INPUTNO
) x where PLAYERNAME IS NOT NULL


-- irons

insert into Player_Master.[Iron Detail] 

SELECT PKey, PLAYERNAME, SID, [FIRST DAY], ISSET, NULL, CLUBCODE, DCLUBCODE, BRAND, DBRANDCODE, MODEL, DMODELCODE, [TYPE], DTYPECODE, MATERIAL, DMATERIAL, SIZE, DSIZECODE, NULL, NULL, NULL, NULL FROM (
SELECT * FROM #PlayerMinInput inputnotable
LEFT OUTER JOIN
(
SELECT [PKey]
      ,[PLAYERNAME]
      ,[SID]
      ,[FIRST DAY]
      ,ISSET
      ,[CLUBCODE]
      ,[DCLUBCODE]
      ,brand.[Mfgr Code] AS BRAND
      ,[DBRANDCODE]
      ,model.[Model Code] AS MODEL
      ,[DMODELCODE]
      ,type.[Type Code] AS "TYPE"
      ,DTYPECODE
      ,matl.[Matl Code] AS MATERIAL
      ,[DMATERIAL]
      ,size.[Size Code] AS SIZE
      ,[DSIZECODE]
      --,misc.[Misc Code] AS MISC
      --,[DMISCCODE]
      ,[INPUTNO]
      
  FROM [DARRELL_MASTER].[Input].[Iron] a
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] brand ON BRAND = "Mfgr Descr"
  LEFT OUTER JOIN LKP.[Model Codes and Descr] model on MODEL = "Model Descr"
  LEFT OUTER JOIN LKP.[Material Codes and Descript] matl on MATERIAL = "Matl Descr"
  LEFT OUTER JOIN LKP.[Size Codes and Description] size on SIZE = [Size Descr]
  --LEFT OUTER JOIN LKP.[Miscellaneous Codes and Des] misc on MISC = "Misc Descr"
  LEFT OUTER JOIN LKP.[Type Codes and Description] type on [MISC] = "Type Descr"
  
  where SID = @SID and [FIRST DAY] = @FIRSTDAY) data
  on inputnotable.PLAYERNAME2 = data.PLAYERNAME and inputnotable.INPUTNO2 = data.INPUTNO
) x where PLAYERNAME IS NOT NULL


-- putter

insert into Player_Master.[Putter Detail]

SELECT PKey, PLAYERNAME, SID, [FIRST DAY], CLUBCODE, DSEQUENCENO, BRAND, DBRANDCODE, MODEL, DMODELCODE, [TYPE], DTYPECODE, MATERIAL, DMATERIAL, SIZE, DSIZECODE, NULL, NULL, NULL, NULL FROM (
SELECT * FROM #PlayerMinInput inputnotable
LEFT OUTER JOIN
(
SELECT [PKey]
      ,[PLAYERNAME]
      ,[SID]
      ,[FIRST DAY]
      ,[CLUBCODE]
      ,DSEQUENCENO
      ,brand.[Mfgr Code] AS BRAND
      ,[DBRANDCODE]
      ,model.[Model Code] AS MODEL
      ,[DMODELCODE]
      ,type.[Type Code] AS "TYPE"
      ,DTYPECODE
      ,matl.[Matl Code] AS MATERIAL
      ,[DMATERIAL]
      ,size.[Size Code] AS SIZE
      ,[DSIZECODE]
      --,misc.[Misc Code] AS MISC
      --,[DMISCCODE]
      ,[INPUTNO]
      
  FROM [DARRELL_MASTER].[Input].[Putter] a
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] brand ON BRAND = "Mfgr Descr"
  LEFT OUTER JOIN LKP.[Model Codes and Descr] model on MODEL = "Model Descr"
  LEFT OUTER JOIN LKP.[Material Codes and Descript] matl on MATERIAL = "Matl Descr"
  LEFT OUTER JOIN LKP.[Size Codes and Description] size on SIZE = [Size Descr]
  --LEFT OUTER JOIN LKP.[Miscellaneous Codes and Des] misc on MISC = "Misc Descr"
  LEFT OUTER JOIN LKP.[Type Codes and Description] type on [TYPE] = "Type Descr"
  
  where SID = @SID and [FIRST DAY] = @FIRSTDAY) data
  on inputnotable.PLAYERNAME2 = data.PLAYERNAME and inputnotable.INPUTNO2 = data.INPUTNO
) x where PLAYERNAME IS NOT NULL


-- all

insert into Player_Master.[all]

SELECT [SID]
      ,NULL
      ,[PLAYERNAME]
      ,[BALLBRAND]
      ,[DBALLBRAND]
      ,[BALLMODEL]
      ,[DBALLMODEL]
      ,[BALLMATERIAL]
      ,[DBALLMATERIAL]
      ,[BALLMISC]
      ,[DBALLMISC]
      ,[BAGBRAND]
      ,[DBAGBRAND]
      ,[GLOVEBRAND]
      ,[DGLOVEBRAND]
      ,[SHOEBRAND]
      ,[DSHOEBRAND]
      ,[SPIKEBRAND]
      ,[DSPIKEBRAND]
      ,[SPIKEMODEL]
      ,[DSPIKEMODEL]
      ,[SHIRTBRAND]
      ,[DSHIRTBRAND]
      ,[HEADGEARBRAND]
      ,[DHEADGEARBRAND]
      ,[CADDYHEADBRAND]
      ,[DCADDYHEADBRAND]
      ,NULL
      ,NULL
      ,SUNGLASSESBRAND 
      ,DGLASSESBRAND 
      ,RANGEPLAYERBRAND
      ,DRANGEPLAYERBRAND
      ,RANGECADDIEBRAND
      ,DRANGECADDIEBRAND
      ,NULL --raingear
      ,NULL
      ,NULL	--raincover
      ,NULL
      ,[TOWELBRAND]	--towel
      ,[DTOWELBRAND]
      ,[TRAVELBAGBRAND]
      ,[DTRAVELBAGBRAND]
      ,[LAUNCHMONITORBRAND]
      ,[DLAUNCHMONITORBRAND]
      ,NULL
      ,NULL
      ,NULL
      ,NULL
      ,NULL
      ,NULL
      ,NULL
      ,[FIRST DAY]
      FROM (
SELECT * FROM #PlayerMinInput inputnotable
LEFT OUTER JOIN
(
SELECT [PLAYERNAME]
      ,[SID]
      ,[FIRST DAY]
      ,ballbrand.[Mfgr Code] AS BALLBRAND
      ,[DBALLBRAND]
      ,ballmodel.[Model Code] AS BALLMODEL
      ,[DBALLMODEL]
      ,ballmatl.[Matl Code] AS BALLMATERIAL
      ,[DBALLMATERIAL]
      ,ballmisc.[Misc Code] AS BALLMISC
      ,[DBALLMISC]
      ,bagbrand.[Mfgr Code] AS BAGBRAND
      ,[DBAGBRAND]
      ,glovebrand.[Mfgr Code] AS GLOVEBRAND
      ,[DGLOVEBRAND]
      ,shoebrand.[Mfgr Code] AS SHOEBRAND
      ,[DSHOEBRAND]
      ,spikebrand.[Mfgr Code] AS SPIKEBRAND
      ,[DSPIKEBRAND]
      ,spikemodel.[Model Code] AS SPIKEMODEL
      ,[DSPIKEMODEL]
      ,shirtbrand.[Mfgr Code] AS SHIRTBRAND
      ,[DSHIRTBRAND]
      ,headgearbrand.[Mfgr Code] AS HEADGEARBRAND
      ,[DHEADGEARBRAND]
      ,caddyheadbrand.[Mfgr Code] AS CADDYHEADBRAND
      ,[DCADDYHEADBRAND]
      ,sunglassesbrand.[Mfgr Code] AS SUNGLASSESBRAND
      ,[DGLASSESBRAND]
      ,towelbrand.[Mfgr Code] AS TOWELBRAND
      ,[DTOWELBRAND]
      ,rangeplayerbrand.[Mfgr Code] as RANGEPLAYERBRAND
      ,DRANGEPLAYERBRAND
      ,rangecaddiebrand.[Mfgr Code] as RANGECADDIEBRAND
      ,DRANGECADDIEBRAND
	  ,travelbagbrand.[Mfgr Code] AS TRAVELBAGBRAND
      ,[DTRAVELBAGBRAND]
      ,lmbrnd.[Mfgr Code] AS LAUNCHMONITORBRAND
      ,[DLAUNCHMONITORBRAND]
      ,[INPUTNO]
      
  FROM [DARRELL_MASTER].[Input].[All] a
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] ballbrand ON BALLBRAND = ballbrand."Mfgr Descr"
  LEFT OUTER JOIN LKP.[Model Codes and Descr] ballmodel on BALLMODEL = ballmodel."Model Descr"
  LEFT OUTER JOIN LKP.[Material Codes and Descript] ballmatl on BALLMATERIAL = "Matl Descr"
  LEFT OUTER JOIN LKP.[Miscellaneous Codes and Des] ballmisc on BALLMISC = "Misc Descr"
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] bagbrand ON BAGBRAND = bagbrand."Mfgr Descr"
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] glovebrand ON GLOVEBRAND = glovebrand."Mfgr Descr"
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] shoebrand ON SHOEBRAND = shoebrand."Mfgr Descr"
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] spikebrand ON SPIKEBRAND = spikebrand."Mfgr Descr"
  LEFT OUTER JOIN LKP.[Model Codes and Descr] spikemodel on SPIKEMODEL = spikemodel."Model Descr"
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] shirtbrand ON SHIRTBRAND = shirtbrand."Mfgr Descr"
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] headgearbrand ON HEADGEARBRAND = headgearbrand."Mfgr Descr"
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] sunglassesbrand ON GLASSESBRAND = sunglassesbrand."Mfgr Descr"
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] caddyheadbrand ON CADDYHEADBRAND = caddyheadbrand."Mfgr Descr"
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] towelbrand ON TOWELBRAND = towelbrand."Mfgr Descr"
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] rangeplayerbrand ON RANGEPLAYERBRAND = rangeplayerbrand."Mfgr Descr"
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] rangecaddiebrand ON RANGECADDIEBRAND = rangecaddiebrand."Mfgr Descr"
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] travelbagbrand ON TRAVELBAGBRAND = travelbagbrand."Mfgr Descr"
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] lmbrnd ON LAUNCHMONITORBRAND = lmbrnd."Mfgr Descr"
  where SID = @SID and [FIRST DAY] = @FIRSTDAY) data
  on inputnotable.PLAYERNAME2 = data.PLAYERNAME and inputnotable.INPUTNO2 = data.INPUTNO
) x where PLAYERNAME IS NOT NULL


-- shafts


insert into Player_Master.[Shaft Detail]  

SELECT PKey, PLAYERNAME, SID, [FIRST DAY], SHAFTEQUIPTYPE, SHAFTCLUBCODE, DCLUBCODE, SHAFTMFGR, DMFGRCODE, SHAFTBRAND, DBRANDCODE, SHAFTMODEL, DMODELCODE, SHAFTFLEX, DSHAFTFLEX, [SHAFTTYPE], DTYPECODE, SHAFTMATL, DMATLCODE, NULL, NULL, NULL, NULL FROM (
SELECT * FROM #PlayerMinInput inputnotable
LEFT OUTER JOIN
(
SELECT [PKey]
      ,[PLAYERNAME]
      ,[SID]
      ,[FIRST DAY]
      ,[SHAFTEQUIPTYPE]
      ,[DEQUIPTYPE]
      ,[SHAFTCLUBCODE]
      ,[DCLUBCODE]
      ,mfgr.[Mfgr Code] AS SHAFTMFGR
      ,[DMFGRCODE]
      ,brand.[Mfgr Code] AS SHAFTBRAND
      ,[DBRANDCODE]
      ,model.[Model Code] AS SHAFTMODEL
      ,[DMODELCODE]
      ,flex.[Flex Code] AS SHAFTFLEX
      ,DSHAFTFLEX AS DSHAFTFLEX
      ,type.[Type Code] AS SHAFTTYPE
      ,[DTYPECODE]
      ,matl.[Matl Code] AS SHAFTMATL
      ,[DMATLCODE]
      ,[Mfgr Unknown]
      ,[INPUTNO]
  FROM [DARRELL_MASTER].[Input].[Shaft] a
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] mfgr ON SHAFTMFGR = mfgr."Mfgr Descr"
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] brand ON SHAFTBRAND = brand."Mfgr Descr"
  LEFT OUTER JOIN LKP.[Model Codes and Descr] model on SHAFTMODEL = "Model Descr"
  LEFT OUTER JOIN LKP.[Material Codes and Descript] matl on SHAFTMATL = "Matl Descr"
  LEFT OUTER JOIN LKP.[Type Codes and Description] type on [SHAFTTYPE] = "Type Descr"
  LEFT OUTER JOIN LKP.[Flex Codes and Desc] flex ON SHAFTFLEX = "Flex Descr"
  
  where SID = @SID and [FIRST DAY] = @FIRSTDAY) data
  on inputnotable.PLAYERNAME2 = data.PLAYERNAME and inputnotable.INPUTNO2 = data.INPUTNO
) x where PLAYERNAME IS NOT NULL


-- grips


insert into Player_Master.[Grip Detail]  

SELECT PKey, PLAYERNAME, SID, [FIRST DAY], GRIPEQUIPTYPE, GRIPCLUBCODE, DCLUBCODE, GRIPMFGR, DMFGRCODE, GRIPBRAND, DBRANDCODE, GRIPMODEL, DMODELCODE, [GRIPTYPE], DTYPECODE, GRIPMATL, DMATERIAL, NULL, NULL, NULL, NULL FROM (
SELECT * FROM #PlayerMinInput inputnotable
LEFT OUTER JOIN
(
SELECT [PKey]
      ,[PLAYERNAME]
      ,[SID]
      ,[FIRST DAY]
      ,[GRIPEQUIPTYPE]
      ,[DEQUIPTYPE]
      ,[GRIPCLUBCODE]
      ,[DCLUBCODE]
      ,mfgr.[Mfgr Code] AS GRIPMFGR
      ,[DMFGRCODE]
      ,brand.[Mfgr Code] AS GRIPBRAND
      ,[DBRANDCODE]
      ,model.[Model Code] AS GRIPMODEL
      ,[DMODELCODE]
      ,type.[Type Code] AS GRIPTYPE
      ,[DTYPECODE]
      ,matl.[Matl Code] AS GRIPMATL
      ,[DMATERIAL]
      ,[INPUTNO]
  FROM [DARRELL_MASTER].[Input].[Grip] a
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] mfgr ON GRIPMFGR = mfgr."Mfgr Descr"
  LEFT OUTER JOIN LKP.[Manufacturer Codes and Desc] brand ON GRIPBRAND = brand."Mfgr Descr"
  LEFT OUTER JOIN LKP.[Model Codes and Descr] model on GRIPMODEL = "Model Descr"
  LEFT OUTER JOIN LKP.[Material Codes and Descript] matl on GRIPMATL = "Matl Descr"
  LEFT OUTER JOIN LKP.[Type Codes and Description] type on [GRIPTYPE] = "Type Descr"
  
  where SID = @SID and [FIRST DAY] = @FIRSTDAY) data
  on inputnotable.PLAYERNAME2 = data.PLAYERNAME and inputnotable.INPUTNO2 = data.INPUTNO
) x  where PLAYERNAME IS NOT NULL


--updates grips

update player_master.[Grip Detail] set [Grip Mfgr Code] = [Grip Brand Code] 
where ([Grip Mfgr Code] = '=' or [Grip Mfgr Code] = '-') and [Survey ID] = @SID and [FIRST DAY] = @FIRSTDAY

--updates shafts

update player_master.[Shaft Detail] set [Shaft Mfgr Code] = [Shaft Brand Code] 
where ([Shaft Mfgr Code] = '=' or [Shaft Mfgr Code] = '-') and [Survey ID] = @SID and [FIRST DAY] = @FIRSTDAY
	
	
END
GO
