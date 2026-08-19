IF OBJECT_ID('dbo.MoneyStats1') IS NOT NULL
    DROP VIEW [dbo].[MoneyStats1];
GO

CREATE VIEW dbo.MoneyStats1
AS
SELECT        Player_Master.TOURNAMENTS_TABLE.TYPE, Player_Master.TOURNAMENTS_TABLE.[FIRST DAY], Player_Master.TOURNAMENTS_TABLE.[TOURNAMENT NAME], 
                         Money.TourMoneyStats.[PLAYER NAME], Money.TourMoneyStats.[Tour Ranking], Money.TourMoneyStats.[Money YTD], Money.TourMoneyStats.Tie, 
                         Money.TourMoneyStats.Cut, Money.TourMoneyStats.[Finish Position], Money.TourMoneyStats.[Round 1], Money.TourMoneyStats.[Round 2], 
                         Money.TourMoneyStats.[Round 3], Money.TourMoneyStats.[Round 4], Money.TourMoneyStats.[Round 5], Money.TourMoneyStats.[Total Score], 
                         Money.TourMoneyStats.[Official Money], Money.TourMoneyStats.[Driving Accuracy], Money.TourMoneyStats.[Driving Distance], 
                         Money.TourMoneyStats.[Greens in Reg], Money.TourMoneyStats.[Putting Avg], Money.TourMoneyStats.[Sand Save], Money.TourMoneyStats.[Total Fwys Hit], 
                         Money.TourMoneyStats.[Total Driving Distance], Money.TourMoneyStats.[Total Drives], Money.TourMoneyStats.[Total Fwys Played], 
                         Money.TourMoneyStats.[Total GIRs], Money.TourMoneyStats.[Total GIR Putts], Money.TourMoneyStats.[Total Traps Hit], Money.TourMoneyStats.[Total Sand Saves], 
                         Money.TourMoneyStats.[Total Eagles], Money.TourMoneyStats.[Total Birdies], Money.TourMoneyStats.[Holes Played], Money.TourMoneyStats.Team, 
                         Money.TourMoneyStats.TeamMoneyWon, Money.TourMoneyStats.TeamMoneyYTD, Money.TourMoneyStats.PlayerTeamRank, 
                         Player_Master.TOURNAMENTS_TABLE.PGASeason, Money.TourMoneyStats.TournamentId
FROM            Money.TourMoneyStats INNER JOIN
                         Player_Master.TOURNAMENTS_TABLE ON Money.TourMoneyStats.TournamentId = Player_Master.TOURNAMENTS_TABLE.TournamentId
GO
