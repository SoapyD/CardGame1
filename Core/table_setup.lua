function setBoards()
    board = {};
    for i=0, 16 do
        --cardtext = ""
        board[i] = {}
        for j=0, 16 do
            local tempSpace;
            table.insert(board[i],tempSpace);
            --cardtext = cardtext .. i .. "," .. j .. "||";

            board[i].x = ((j) * 250)
            board[i].y = ((i) * 250)

            board[i].item_area =display.newRoundedRect( 
                board[i].x, board[i].y, 50, 50, 1 )
            board[i].item_area:setFillColor( colorsRGB.RGB("blue") )
            camera:add(board[i].item_area, 1, false)
        end
        --print(cardtext)
    end
end

function LoadTable(filename,x,y)
    local group = display.newGroup()
    -- width, height, x, y
    local table_item = display.newImage(group, "Images/" .. filename, 
        x, y)  

    table_item:addEventListener( "touch", MultiTouch )
    camera:add(table_item, 8, true)
    GameInfo.table_items[ table.getn(GameInfo.table_items)+1 ] = table_item
    --camera:setFocus(table_item)
    --camera.damping = 0
    --camera:track() 
end

function MultiTouch( event )
		local t = event.target
		local phase = event.phase

		GameInfo.touches[ table.getn(GameInfo.touches)+1 ] = event
		return true
end
