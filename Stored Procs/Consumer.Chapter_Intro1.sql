DROP PROCEDURE IF EXISTS [Consumer].[Chapter_Intro1];
GO

CREATE procedure [Consumer].[Chapter_Intro1]
(@Country varchar(10),
@Year integer,
@Season integer)

as 
Begin

--exec [Consumer].[Chapter_Intro1] 'USA', 2019,3

SELECT 'Total Players' as Equipment, 'Total Players' as EquipmentDetail, COUNT(*) as [Total], '' as [New] FROM [DARRELL_MASTER].[Consumer].[PlayerProfile] 
where PlayerProfileId in (select PlayerProfileId from Consumer.PlayerProfile where [YEAR] = @year and COUNTRY = @country and SEASON = @season)
union all

SELECT 'Ball' as Equipment, 'Ball' as EquipmentDetail, COUNT(*) as [Total], '' as [New] FROM [DARRELL_MASTER].[Consumer].[Ball] 
where not brand is null and PlayerProfileId in (select PlayerProfileId from Consumer.PlayerProfile where [YEAR] = @year and COUNTRY = @country and SEASON = @season)

union all
SELECT 'Iron' as Equipment, 'Iron' as EquipmentDetail, COUNT(*) as [Total], COUNT(case when [Years] < 2 then 1 end) as [New] FROM [DARRELL_MASTER].[Consumer].[Iron] 
where not brand is null and PlayerProfileId in (select PlayerProfileId from Consumer.PlayerProfile where [YEAR] = @year and COUNTRY = @country and SEASON = @season)

union all
SELECT 'Iron Shaft' as Equipment, 'Iron Shafts' as EquipmentDetail, COUNT(*) as [Total], COUNT(case when [Years] < 2 then 1 end) as [New] FROM [DARRELL_MASTER].[Consumer].[IronShaft] 
where not brand is null and PlayerProfileId in (select PlayerProfileId from Consumer.PlayerProfile where [YEAR] = @year and COUNTRY = @country and SEASON = @season)

union all
SELECT 'Wood - Driver' as Equipment, 'Drivers' as EquipmentDetail, COUNT(*) as [Total], COUNT(case when [Years] < 2 then 1 end) as [New] FROM [DARRELL_MASTER].[Consumer].[Wood]
where not brand is null and PlayerProfileId in (select PlayerProfileId from Consumer.PlayerProfile where [YEAR] = @year and COUNTRY = @country and SEASON = @season) and CLUB_CODE = 1

union all
SELECT 'Shaft - Driver' as Equipment, 'Driver Shafts' as EquipmentDetail, COUNT(*) as [Total], COUNT(case when [Years] < 2 then 1 end) as [New] FROM [DARRELL_MASTER].[Consumer].[WoodShaft]  
where PlayerProfileId in (select PlayerProfileId from Consumer.PlayerProfile where [YEAR] = @year and COUNTRY = @country and SEASON = @season) and CLUB_CODE = 1

union all
SELECT 'Wood - Fairway' as Equipment, 'Fairway Woods' as EquipmentDetail, COUNT(*) as [Total], COUNT(case when [Years] < 2 then 1 end) as [New] FROM [DARRELL_MASTER].[Consumer].[Wood]
where not brand is null and PlayerProfileId in (select PlayerProfileId from Consumer.PlayerProfile where [YEAR] = @year and COUNTRY = @country and SEASON = @season) and not CLUB_CODE in (1, 12)

union all
SELECT 'Shaft - Fairway' as Equipment, 'Fairway Shafts' as EquipmentDetail, COUNT(*) as [Total], COUNT(case when [Years] < 2 then 1 end) as [New] FROM [DARRELL_MASTER].[Consumer].[WoodShaft]  
where PlayerProfileId in (select PlayerProfileId from Consumer.PlayerProfile where [YEAR] = @year and COUNTRY = @country and SEASON = @season) and not CLUB_CODE in (1, 12)

union all
SELECT 'Wood - Hybrid' as Equipment, 'Hybrids' as EquipmentDetail, COUNT(*) as [Total], COUNT(case when [Years] < 2 then 1 end) as [New] FROM [DARRELL_MASTER].[Consumer].[Wood]
where not brand is null and PlayerProfileId in (select PlayerProfileId from Consumer.PlayerProfile where [YEAR] = @year and COUNTRY = @country and SEASON = @season) and CLUB_CODE = 12

union all
SELECT 'Shaft - Hybrid' as Equipment, 'Hybrid Shafts' as EquipmentDetail, COUNT(*) as [Total], COUNT(case when [Years] < 2 then 1 end) as [New] FROM [DARRELL_MASTER].[Consumer].[WoodShaft]  
where PlayerProfileId in (select PlayerProfileId from Consumer.PlayerProfile where [YEAR] = @year and COUNTRY = @country and SEASON = @season) and CLUB_CODE = 12

union all
SELECT 'Wedge' as Equipment, 'Wedges' as EquipmentDetail, COUNT(*) as [Total], COUNT(case when [Years] < 2 then 1 end) as [New] FROM [DARRELL_MASTER].[Consumer].[wedge] 
where not brand is null and PlayerProfileId in (select PlayerProfileId from Consumer.PlayerProfile where [YEAR] = @year and COUNTRY = @country and SEASON = @season) and CLUB_CODE <> 'PW'

union all
SELECT 'Putter' as Equipment, 'Putters' as EquipmentDetail, COUNT(*) as [Total], COUNT(case when [Years] < 2 then 1 end) as [New] FROM [DARRELL_MASTER].[Consumer].[putter] 
where not brand is null and PlayerProfileId in (select PlayerProfileId from Consumer.PlayerProfile where [YEAR] = @year and COUNTRY = @country and SEASON = @season)

union all
SELECT 'Bag' as Equipment, 'Bags' as EquipmentDetail, COUNT(*) as [Total], COUNT(case when [Years] < 2 then 1 end) as [New] FROM [DARRELL_MASTER].[Consumer].[Bag]
where not brand is null and PlayerProfileId in (select PlayerProfileId from Consumer.PlayerProfile where [YEAR] = @year and COUNTRY = @country and SEASON = @season)

union all
SELECT 'Glove' as Equipment, 'Gloves' as EquipmentDetail, COUNT(*) as [Total], COUNT(case when [Years] < 2 then 1 end) as [New] FROM [DARRELL_MASTER].[Consumer].[Glove] 
where PlayerProfileId in (select PlayerProfileId from Consumer.PlayerProfile where [YEAR] = @year and COUNTRY = @country and SEASON = @season)

union all
SELECT 'Shoe' as Equipment, 'Shoes' as EquipmentDetail, COUNT(*) as [Total], COUNT(case when [Years] < 2 then 1 end) as [New] FROM [DARRELL_MASTER].[Consumer].[Shoe] 
where not brand is null and PlayerProfileId in (select PlayerProfileId from Consumer.PlayerProfile where [YEAR] = @year and COUNTRY = @country and SEASON = @season)

union all
SELECT 'Shirt' as Equipment, 'Shirts' as EquipmentDetail, COUNT(*) as [Total], '' as [New] FROM [DARRELL_MASTER].[Consumer].[Shirt]
where not brand is null and PlayerProfileId in (select PlayerProfileId from Consumer.PlayerProfile where [YEAR] = @year and COUNTRY = @country and SEASON = @season)

union all
SELECT 'Headgear' as Equipment, 'Headgear' as EquipmentDetail, COUNT(*) as [Total], '' as [New] FROM [DARRELL_MASTER].[Consumer].[Headgear] 
where not brand is null and PlayerProfileId in (select PlayerProfileId from Consumer.PlayerProfile where [YEAR] = @year and COUNTRY = @country and SEASON = @season)

union all
SELECT 'Regions' as Equipment, 'Regions' as EquipmentDetail, COUNT(distinct REGION) as [Total], '' as [New] FROM [DARRELL_MASTER].[Consumer].[PlayerProfile] 
where PlayerProfileId in (select PlayerProfileId from Consumer.PlayerProfile where [YEAR] = @year and COUNTRY = @country and SEASON = @season)

union all
SELECT 'Golf Courses' as Equipment, 'Golf Courses' as EquipmentDetail, COUNT(distinct LEFT(form,2)) as [Total], '' as [New] FROM [DARRELL_MASTER].[Consumer].[PlayerProfile] 
where PlayerProfileId in (select PlayerProfileId from Consumer.PlayerProfile where [YEAR] = @year and COUNTRY = @country and SEASON = @season)

end
GO
