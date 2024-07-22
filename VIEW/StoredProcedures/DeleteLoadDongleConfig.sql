
-- =============================================
-- Author:      <Martin Krogh Hollænder>
-- Create Date: <06.03.2023>
-- Description: <This SP deletes dongles from the load dongle config table.>
-- =============================================
CREATE PROCEDURE [VIEW].[DeleteLoadDongleConfig] @Environment VARCHAR(64) = 'prod'

AS
BEGIN
    
    SET NOCOUNT ON

	DELETE FROM [VIEW].[LoadDongleConfig]
	WHERE Environment = @Environment
	

END
GO

