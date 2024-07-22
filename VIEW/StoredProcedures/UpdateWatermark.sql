
CREATE PROC [VIEW].[UpdateWatermark]
    @NewWatermark nvarchar(50) = '0',
	@OldWaterMark nvarchar(50) = null,
    @SRC_schema NVARCHAR(128),
	@SRC_tab NVARCHAR(128) 
	
AS
BEGIN
	BEGIN TRANSACTION
 
		UPDATE [VIEW].LoadConfig
		WITH (UPDLOCK, HOLDLOCK)
		SET WatermarkValue = @NewWatermark,
			OldWatermarkValue = @OldWatermark,
			MetaUpdatedTime = CAST( SWITCHOFFSET(GETDATE(), DATEPART(TZOFFSET, GETDATE())) AS datetime) --local time update
		WHERE SRC_schema = @SRC_schema and SRC_tab = @SRC_tab

	COMMIT TRANSACTION
END
GO

