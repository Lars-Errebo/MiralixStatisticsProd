

-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE FUNCTION [VIEW].[V2_Translate]
(
    @lan int, @column nvarchar(100), @ref nvarchar(100), @lookup nvarchar(100)   
)
RETURNS nvarchar(100)
AS
BEGIN
    DECLARE @t nvarchar(100)

	SET @t = '';

    SET @t = case when @lan = 1 then (select isnull([trans_1],@lookup) from [V2].[fix_translations] where columnname = @column and columnlookup = @lookup and reference = @ref)  
				  when @lan = 2 then (select isnull([trans_2],@lookup) from [V2].[fix_translations] where columnname = @column and columnlookup = @lookup and reference = @ref)
	              when @lan = 3 then (select isnull([trans_3],@lookup) from [V2].[fix_translations] where columnname = @column and columnlookup = @lookup and reference = @ref)
	              when @lan = 4 then (select isnull([trans_4],@lookup) from [V2].[fix_translations] where columnname = @column and columnlookup = @lookup and reference = @ref)
			 end 
   
    RETURN isnull(@t,@lookup)
END
GO

