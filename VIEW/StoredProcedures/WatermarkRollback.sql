


-- =============================================
-- Author:      <Kia Thomsen>
-- Create Date: <04.03.2022>
-- Description: <SP for rolling back the delta load, when an error in the pipeline has occured. The SP rolles back the watermark for all dongles for a specific table)
-- =============================================
CREATE PROCEDURE [VIEW].[WatermarkRollback]
(
	@Table VARCHAR(500)
)

AS
BEGIN
    
    SET NOCOUNT ON

	UPDATE [VIEW].LoadConfig
    SET WatermarkValue = OldWatermarkValue
	WHERE SRC_tab = @Table

END
GO

