


-- =============================================
-- author:		<author,,name>
-- create date: <create date,,>
-- description:	<description,,>
-- =============================================
CREATE procedure [VIEW].[LoopSourcesFactDonglesMonth]

as
begin

     set nocount on;	
	 
	 declare @stamp table ( dongle_id int, yearmth int )
	 insert into @stamp	select dongle_id, yearmth from [VIEW].[fact_sources]
	
	 declare @dongle int
	 declare @yearmth int 
	 declare dongle_cursor cursor for select dongle_id from @stamp 
	 
	 open dongle_cursor
	 fetch next from dongle_cursor into @dongle
	 
	 while @@FETCH_STATUS = 0  
     begin  
          print @dongle
		  
		  declare yearmth_cursor cursor for select yearmth from @stamp where dongle_id = @dongle	  

		  open yearmth_cursor
	      fetch next from yearmth_cursor into @yearmth
	      while @@FETCH_STATUS = 0
		  begin 
		       print @yearmth

			--   exec [V20232].[fact_queue_name] @dongle,@yearmth

		       fetch next from yearmth_cursor into @yearmth 
		  end
		  close yearmth_cursor  
          deallocate yearmth_cursor

          fetch next from dongle_cursor into @dongle 
     end

     close dongle_cursor  
     deallocate dongle_cursor
end
GO

