


-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE FUNCTION [VIEW].[V2_GetLanguage]
(
    -- Add the parameters for the function here
    @d int
)
RETURNS int
AS
BEGIN
    
    DECLARE @l int

    -- Add the T-SQL statements to compute the return value here
    SET @l = (SELECT 1 FROM [VIEW].[DongleConfig] WHERE cast(substring(dongleid,2,10) as INT) = @d)

    -- Return the result of the function
    RETURN isnull(@l,1)
END
GO

