IF OBJECT_ID('LKP.Fix_CombineModelNames') IS NOT NULL
    DROP PROCEDURE [LKP].[Fix_CombineModelNames];
GO

-- =============================================
-- Author:		Alex R.
-- Create date: 11/1/2013
-- Description:	Changes Model Names when fixing incorrect spell
-- =============================================
CREATE PROCEDURE [LKP].[Fix_CombineModelNames]
	@Correct nvarchar(50),
	@CorrectCode nvarchar(4),
	@Wrong nvarchar(50),
	@WrongCode nvarchar(4),
	@WrongBrand nvarchar(50)

	
AS
BEGIN
	SET NOCOUNT OFF;
	declare @RunCount integer = 0
	declare @WrongBrandCode nvarchar(4)
	
	select @WrongBrandCode = [Mfgr Code] from LKP.[Manufacturer Codes and Desc] where [Mfgr Descr] = @WrongBrand


	begin try
		begin tran

			print 'Updating Input_1'
			update [DARRELL_MASTER].[dbo].[INPUT_1] set MISC1 = @Correct where MISC1 = @Wrong and [model] = @WrongBrand
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating Input.All.Ball'
			update Input.[All] set ballmodel = @Correct WHERE ballMODEL = @Wrong and BALLBRAND = @WrongBrand
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating Input.All.Spike'
			update Input.[All] set spikemodel = @Correct WHERE spikeMODEL = @Wrong and spikeBRAND = @WrongBrand
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating Input.Grip'
			update Input.Grip set gripmodel = @Correct WHERE gripMODEL = @Wrong and GRIPBRAND = @WrongBrand
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating Input.Iron'
			update Input.Iron set model = @Correct WHERE MODEL = @Wrong and BRAND =  @WrongBrand
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating Input.Putter'
			update Input.Putter set model = @Correct WHERE MODEL = @Wrong and BRAND =  @WrongBrand
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating Input.Shaft'
			update Input.Shaft set SHAFTMODEL = @Correct WHERE SHAFTMODEL = @Wrong and shaftBRAND =  @WrongBrand
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating Input.Wedge'
			update Input.Wedge set model = @Correct WHERE MODEL = @Wrong and BRAND =  @WrongBrand
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating Input.Wood'
			update Input.Wood set model = @Correct WHERE MODEL = @Wrong and BRAND =  @WrongBrand
			Set @RunCount = @RunCount + @@Rowcount
			



			print 'Updating PMF.All.ball'
			update Player_Master.[All] set ballmodel = @CorrectCode WHERE ballMODEL = @WrongCode and BALLBRAND =  @WrongBrandCode
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating PMF.All.spike'
			update Player_Master.[All] set spikemodel = @CorrectCode WHERE spikeMODEL = @WrongCode and SPIKEBRAND  =  @WrongBrandCode
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating PMF.grip'
			update Player_Master.[Grip Detail] set [Grip Model Code] = @CorrectCode WHERE [Grip Model Code] = @WrongCode and [Grip Brand Code]  =  @WrongBrandCode
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating PMF.Iron'
			update Player_Master.[Iron Detail] set [Iron Model Code] = @CorrectCode WHERE [Iron Model Code] = @WrongCode and [Iron Brand Code] =  @WrongBrandCode
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating PMF.putter'
			update Player_Master.[Putter Detail] set [Putter Model Code] = @CorrectCode WHERE [Putter Model Code] = @WrongCode and [Putter Brand Code]  =  @WrongBrandCode
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating PMF.shaft'
			update Player_Master.[Shaft Detail] set [Shaft Model Code]  = @CorrectCode WHERE [Shaft Model Code] = @WrongCode and [Shaft Brand Code] =  @WrongBrandCode
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating PMF.wedge'
			update Player_Master.[Wedge Detail] set [Wedge Model Code]  = @CorrectCode WHERE [Wedge Model Code] = @WrongCode and [Wedge Brand Code]  =  @WrongBrandCode
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Updating PMF.Wood'
			update Player_Master.[Wood Detail] set [Wood Model Code] = @CorrectCode WHERE [Wood Model Code] = @WrongCode and [Wood Brand Code] =  @WrongBrandCode
			Set @RunCount = @RunCount + @@Rowcount
			
			print 'Deleting from LKp.Brand/Model'
			delete from LKP.[Brand/Model Codes with Equip] where [Model Code] = @WrongCode and [Mfgr Code] = @WrongBrandCode
			Set @RunCount = @RunCount + @@Rowcount
			
			if (select COUNT(*)  FROM [LKP].[Brand/Model Codes with Equip] where [Model Code]  = @WrongCode) = 0
				-- we cannot delete bad model code if there are more brands associated with it
				begin
					print 'Deleting from LKp.Model'
					delete from LKP.[Model Codes and Descr] where [Model Code] = @WrongCode
					Set @RunCount = @RunCount + @@Rowcount
				end;

		--rollback tran
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
