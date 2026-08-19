IF OBJECT_ID('OptOut.Selection_SetFeed') IS NOT NULL
    DROP PROCEDURE [OptOut].[Selection_SetFeed];
GO

CREATE procedure [OptOut].[Selection_SetFeed]
@user varchar(100), 
@FeedControlID int, 
@isEnabled bit

as
begin

	update OptOut.FeedControls set IsEnabled = @isEnabled, lastchanged_on = getdate(), lastchanged_by = @user where FeedControlID = @FeedControlID

end
GO
