DROP PROCEDURE IF EXISTS [MoneyBall].[Fill_WebsiteDataPlayer9];
GO

-- =============================================
-- Author:		Alex Roytman
-- Create date: 02/15/2023
-- Description:	
-- =============================================

CREATE procedure [MoneyBall].[Fill_WebsiteDataPlayer9]
(
	@Tour varchar(25),
	@PGASeason integer,
	@SportTourId tinyint,
	@LastFullTournamentEnd date
)
AS
Begin -- WebsiteDataPlayer9
Print 'Begin WebsiteDataPlayer9';
	
delete from MoneyBall.WebsiteDataPlayer9 where PGASeason = @PGASeason and SportTourId = @SportTourId


begin tran
insert into MoneyBall.WebsiteDataPlayer9 (PGASeason, PlayerName, TournamentId, Equipment, Brand, Model, ClubNumber, Degree, SpecialFlag, PKey, SportTourId) 
 
select  PGASeason, PlayerName, TournamentId, 'Ball' as Equipment, Brand, isnull(Model, '-') as Model, '' as ClubNumber, '' as Degree, 0 as SpecialFlag, 1 as PKey, @SportTourId from dbo.[ball] where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) union all
select  PGASeason, PlayerName, TournamentId, 'Iron' as Equipment, Brand, isnull(Model, '-') as Model, [CLUB NUMBER] as ClubNumber, '' as Degree, isset as SpecialFlag, rank() over(Partition by PlayerName, TournamentId order by Pkey) as PKey, @SportTourId from dbo.[irons] where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) union all
select  PGASeason, PlayerName, TournamentId, 'Wood' as Equipment, Brand, isnull(Model, '-') as Model, case when len([CLUB NUMBER]) = 7 then left([Club Number],1) 
																										   when [CLUB NUMBER] = 'HYBRID' then 'HYB'
																										   when [CLUB NUMBER] = 'RAYLOR' then 'RYLR'
																										   when [CLUB NUMBER] = 'HEAVEN' then 'HVN'
																										   else [CLUB NUMBER]
																									 end as ClubNumber, 
																									 case when left(SIZE, 1) = '+' then right(Size, len(size) - 2) 
																										  else Size
																								     end as Degree, isdriver as SpecialFlag, rank() over(Partition by PlayerName, TournamentId order by Pkey) as PKey, @SportTourId from dbo.[woods] where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) union all
select  PGASeason, PlayerName, TournamentId, 'Shoes' as Equipment, Brand, isnull(Model, '-') as Model, '' as ClubNumber, '' as Degree, 0 as SpecialFlag, 1 as PKey, @SportTourId from dbo.[Shoes] where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) union all
select  PGASeason, PlayerName, TournamentId, 'Shirt' as Equipment, Brand, isnull(Model, '-') as Model, '' as ClubNumber, '' as Degree, 0 as SpecialFlag, 1 as PKey, @SportTourId from dbo.[Shirts] where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) union all
select  PGASeason, PlayerName, TournamentId, 'Putter' as Equipment, Brand, isnull(Model, '-') as Model, '' as ClubNumber, '' as Degree, 0 as SpecialFlag, rank() over(Partition by PlayerName, TournamentId order by Pkey) as PKey, @SportTourId from dbo.[Putters] where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) union all
select  PGASeason, PlayerName, TournamentId, 'Wedge' as Equipment, Brand, isnull(Model, '-') as Model, [CLUB NUMBER] as ClubNumber, SIZE as Degree, 0 as SpecialFlag, rank() over(Partition by PlayerName, TournamentId order by Pkey) as PKey, @SportTourId from dbo.[Wedges] where PGASeason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355))) union all

select  PGASeason, w.PlayerName, w.TournamentId, 'Driver|Shaft' as Equipment, w.Brand + '(' + w.Model + ') | ' + s.Brand + '(' + s.Model + ')' as Brand, '' as Model, case when len([CLUB NUMBER]) = 7 then left([Club Number],1) 
																										   when [CLUB NUMBER] = 'HYBRID' then 'HYB'
																										   when [CLUB NUMBER] = 'RAYLOR' then 'RYLR'
																										   when [CLUB NUMBER] = 'HEAVEN' then 'HVN'
																										   else [CLUB NUMBER]
																									 end as ClubNumber, 
																									 case when left(SIZE, 1) = '+' then right(Size, len(size) - 2) 
																										  else Size
																								     end as Degree, w.isdriver as SpecialFlag, rank() over(Partition by w.PlayerName, w.TournamentId order by w.Pkey) as Pkey, @SportTourId
	from dbo.[woods] w inner join (SELECT playername,[BRAND],[MODEL],[TournamentId],pkey FROM [dbo].[Shafts] where pgaseason = @PGASeason and EQUIPMENT = 'wood' and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))) s
	on w.TournamentId = s.TournamentId and w.PLAYERNAME = s.playername and w.pkey = s.PKey
	where w.PGASeason = @PGASeason and w.[FIRST DAY] < @LastFullTournamentEnd and w.TOUR = @Tour and w.isdriver = 1 and ((@Sporttourid <> 58 and w.TOUR = @Tour) or (@Sporttourid = 58 and w.SID in (26,351,353,355)))

union all

select  PGASeason, w.PlayerName, w.TournamentId, 'Driver|Ball' as Equipment, w.Brand + '(' + w.Model + ') | ' + s.Brand + '(' + s.Model + ')' as Brand, '' as Model,case when len([CLUB NUMBER]) = 7 then left([Club Number],1) 
																										   when [CLUB NUMBER] = 'HYBRID' then 'HYB'
																										   when [CLUB NUMBER] = 'RAYLOR' then 'RYLR'
																										   when [CLUB NUMBER] = 'HEAVEN' then 'HVN'
																										   else [CLUB NUMBER]
																									 end as ClubNumber, 
																									 case when left(SIZE, 1) = '+' then right(Size, len(size) - 2) 
																										  else Size
																								     end as Degree, w.isdriver as SpecialFlag, rank() over(Partition by w.PlayerName, w.TournamentId order by w.Pkey) as Pkey, @SportTourId
	from dbo.[woods] w inner join (SELECT playername,[BRAND],[MODEL],[TournamentId] FROM [dbo].[ball] where pgaseason = @PGASeason and [FIRST DAY] < @LastFullTournamentEnd and ((@Sporttourid <> 58 and TOUR = @Tour) or (@Sporttourid = 58 and SID in (26,351,353,355)))) s
	on w.TournamentId = s.TournamentId and w.PLAYERNAME = s.playername
	where w.PGASeason = @PGASeason and w.[FIRST DAY] < @LastFullTournamentEnd and w.TOUR = @Tour and w.isdriver = 1 and ((@Sporttourid <> 58 and w.TOUR = @Tour) or (@Sporttourid = 58 and w.SID in (26,351,353,355)))

commit tran

Print 'Finished WebsiteDataPlayer9';
end  -- WebsiteDataPlayer9
GO
