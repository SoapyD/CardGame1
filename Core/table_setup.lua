function LoadTable(filename,x,y)
	local group = display.newGroup()
    -- width, height, x, y
    GameInfo.table_item = display.newImage(group, "Images/" .. filename, 
        (GameInfo.width / 1), (GameInfo.height / 1))  

    GameInfo.table_item:addEventListener( "touch", MultiTouch )
    camera:add(GameInfo.table_item, 1, true)
    camera:setFocus(GameInfo.table_item)
    --camera:track()
end

function MultiTouch( event )
		local t = event.target
		local phase = event.phase

		GameInfo.touches[ table.getn(GameInfo.touches)+1 ] = event
		return true
end
