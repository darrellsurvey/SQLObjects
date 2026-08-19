DROP PROCEDURE IF EXISTS [OptOut].[Selection_SetFeedAll];
GO

CREATE procedure [OptOut].[Selection_SetFeedAll]
@user varchar(100), 
@FeedControlID int, 
@isEnabled bit

as
begin

	update OptOut.FeedControls set IsEnabled = @isEnabled, lastchanged_on = getdate(), lastchanged_by = @user where 
		playername = (select top 1 playername from OptOut.FeedControls where FeedControlID = @FeedControlID)

end
GO
