IF OBJECT_ID('LKP.Fix_ChangeBrandModelAssociation') IS NOT NULL
    DROP PROCEDURE [LKP].[Fix_ChangeBrandModelAssociation];
GO

-- =============================================
-- Author:		Alex R.
-- Create date: 11/1/2013
-- Description:	Change Brand/Model associations
-- =============================================
CREATE PROCEDURE [LKP].[Fix_ChangeBrandModelAssociation]
	@CorrectBrand nvarchar(50),
	@CorrectBrandCode nvarchar(4),
	@Model nvarchar(50),
	@ModelCode nvarchar(4),
	@WrongBrand nvarchar(50)
AS
BEGIN
	SET NOCOUNT OFF;
	declare @RunCount integer = 0
	declare @WrongBrandCode nchar(4)
	
	select @WrongBrandCode = [Mfgr Code] from LKP.[Manufacturer Codes and Desc] where [Mfgr Descr] = @WrongBrand


	begin try
		begin tran

			print 'Updating Input_1'
			update [DARRELL_MASTER].[dbo].[INPUT_1] set Model = @CorrectBrand where MISC1 = @Model and [model] = @WrongBrand
			Set @RunCount = @RunCount + @@Rowcount
			
			--for shafts/grips need to update manufactrer as well
			print 'Updating Input_1'
			update [DARRELL_MASTER].[dbo].[INPUT_1] set Brand = @CorrectBrand where MISC1 = @Model and Brand = @WrongBrand and (ITEM like '%SHAFT' or ITEM like '%GRIP')
			Set @RunCount = @RunCount + @@Rowcount

			
			print 'Updating Input.All.Ball'
			update Input.[All] set BALLBRAND  = @CorrectBrand WHERE ballMODEL = @Model and BALLBRAND = @WrongBrand
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating Input.All.Spike'
			update Input.[All] set SPIKEBRAND = @CorrectBrand WHERE spikeMODEL = @Model and SPIKEBRAND  = @WrongBrand
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating Input.Grip'
			update Input.Grip set GRIPBRAND = @CorrectBrand, GRIPMFGR = @CorrectBrand WHERE gripMODEL = @Model and GRIPBRAND = @WrongBrand
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating Input.Iron'
			update Input.Iron set BRAND = @CorrectBrand WHERE MODEL = @Model and BRAND = @WrongBrand
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating Input.Putter'
			update Input.Putter set BRAND = @CorrectBrand WHERE MODEL = @Model and BRAND = @WrongBrand
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating Input.Shaft'
			update Input.Shaft set SHAFTBRAND = @CorrectBrand, SHAFTMFGR = @CorrectBrand WHERE SHAFTMODEL = @Model and SHAFTBRAND = @WrongBrand
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating Input.Wedge'
			update Input.Wedge set BRAND = @CorrectBrand WHERE MODEL = @Model and BRAND = @WrongBrand
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating Input.Wood'
			update Input.Wood set BRAND = @CorrectBrand WHERE MODEL = @Model and BRAND = @WrongBrand
			Set @RunCount = @RunCount + @@Rowcount
			



			print 'Updating PMF.All.ball'
			update Player_Master.[All] set BALLBRAND = @CorrectBrandCode WHERE ballMODEL = @ModelCode and BALLBRAND = @WrongBrandCode
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating PMF.All.spike'
			update Player_Master.[All] set SPIKEBRAND = @CorrectBrandCode WHERE spikeMODEL = @ModelCode and SPIKEBRAND = @WrongBrandCode
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating PMF.grip'
			update Player_Master.[Grip Detail] set [Grip Brand Code] = @CorrectBrandCode, [Grip Mfgr Code] = @CorrectBrandCode WHERE [Grip Model Code] = @ModelCode and [Grip Brand Code] = @WrongBrandCode
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating PMF.Iron'
			update Player_Master.[Iron Detail] set [Iron Brand Code] = @CorrectBrandCode WHERE [Iron Model Code] = @ModelCode and [Iron Brand Code] = @WrongBrandCode
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating PMF.putter'
			update Player_Master.[Putter Detail] set [Putter Brand Code] = @CorrectBrandCode WHERE [Putter Model Code] = @ModelCode and [Putter Brand Code] = @WrongBrandCode
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating PMF.shaft'
			update Player_Master.[Shaft Detail] set [Shaft Brand Code] = @CorrectBrandCode, [Shaft Mfgr Code] = @CorrectBrandCode WHERE [Shaft Model Code] = @ModelCode and [Shaft Brand Code] = @WrongBrandCode
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating PMF.wedge'
			update Player_Master.[Wedge Detail] set [Wedge Brand Code] = @CorrectBrandCode WHERE [Wedge Model Code] = @ModelCode and [Wedge Brand Code] = @WrongBrandCode
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating PMF.Wood'
			update Player_Master.[Wood Detail] set [Wood Brand Code] = @CorrectBrandCode WHERE [Wood Model Code] = @ModelCode and [Wood Brand Code] = @WrongBrandCode
			Set @RunCount = @RunCount + @@Rowcount


			if (select COUNT(*)  FROM [LKP].[Brand/Model Codes with Equip] where [Model Code] = @ModelCode and [Mfgr Code] = @CorrectBrandCode) > 0 
				begin
					delete from [LKP].[Brand/Model Codes with Equip] where [Model Code] = @ModelCode and [Mfgr Code] = @WrongBrandCode
					print 'deleted wrong code from LKp.Brand/Model'
					Set @RunCount = @RunCount + @@Rowcount
				end
			  else 
				begin
					Update LKP.[Brand/Model Codes with Equip] set [Mfgr Code] = @CorrectBrandCode where [Model Code] = @ModelCode and [Mfgr Code] = @WrongBrandCode
					print 'Updated wrong code in LKp.Brand/Model'
					Set @RunCount = @RunCount + @@Rowcount
				end;
			
		--rollback tran; 
		--set @RunCount = 99999
		commit tran; print 'commit'
	end try
	
	begin catch 
		rollback tran
		print 'rollback'
		print error_message()
		set @RunCount = 99999
	end catch
	return @RunCount
END
GO
