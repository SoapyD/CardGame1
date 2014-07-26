function setBoards()
    board = {};
    for i=0, GameInfo.world_height do
        --cardtext = ""
        board[i] = {}
        for j=0, GameInfo.world_width do
            local tempSpace;
            table.insert(board[i],tempSpace);
            --cardtext = cardtext .. i .. "," .. j .. "||";

            board[i].x = ((j) * 350)
            board[i].y = ((i) * 350)

            --board[i].item_area =display.newRoundedRect( 
            --    board[i].x, board[i].y, 50, 50, 1 )
            --board[i].item_area:setFillColor( colorsRGB.RGB("blue") )
            --camera:add(board[i].item_area, 1, false)
        end
        --print(cardtext)
    end
end

function LoadTable(filename,x,y)
    local group = display.newGroup()
    -- width, height, x, y
    local table_item = display.newImage(group, "Images/" .. filename, 
        x, y)  

    table_item.camera_x = 0
    table_item.camera_y = 0

    table_item:addEventListener( "touch", MultiTouch )
    table_item:addEventListener( "touch", scrollTable )
    camera:add(table_item, 8, true)
    GameInfo.table_items[ table.getn(GameInfo.table_items)+1 ] = table_item
end

function MultiTouch( event )
		local t = event.target
		local phase = event.phase

        local add = true
        for i = 1, table.getn(GameInfo.touches) do

            local x_diff = GameInfo.touches[i].x - event.x
            local y_diff = GameInfo.touches[i].y - event.y

            --if (x_diff ~= nil and y_diff ~= nil) then
            if ((x_diff < 50 and x_diff > -50) or
                (y_diff < 50 and y_diff > -50)) then
                add = false
            end
            --print("x diff: " .. x_diff .. " y_diff: " .. y_diff .. " add: " , add)

        end
        --print(table.getn(GameInfo.touches) )
        if (table.getn(GameInfo.touches) > 0) then
            local x_diff = GameInfo.touches[1].x - event.x
            local y_diff = GameInfo.touches[1].y - event.y
            --print("diff  x: " .. x_diff .. " y: " .. y_diff)
            --print("info  x: " .. GameInfo.touches[1].x .. " y: " .. GameInfo.touches[1].y)
            --print("event x: " .. event.x .. " y: " .. event.y)
        end
        if (add == true) then
		  GameInfo.touches[ table.getn(GameInfo.touches)+1 ] = event
        end
        --print("end size: " .. table.getn(GameInfo.touches) )
		return true
end


function scrollTable( event )
        local t = event.target
        local phase = event.phase

        if "began" == phase then
            -- Make target the top-most object
            local parent = t.parent
            --parent:insert( t )
            display.getCurrentStage():setFocus( t )
            t.isFocus = true
            -- Store initial position
            t.x0 = -camera.scrollX + ((display.contentWidth / 2) / camera.xScale)
            t.y0 = -camera.scrollY + ((display.contentHeight / 2) / camera.yScale)
            t.xdif = event.x
            t.ydif = event.y

        elseif t.isFocus then
            if "moved" == phase then

            off_x = t.xdif - event.x
            off_y = t.ydif - event.y
            t.xdif = event.x
            t.ydif = event.y

            t.x0 =  t.x0 + (off_x / GameInfo.zoom)
            t.y0 =  t.y0 + (off_y / GameInfo.zoom)

            local new_pos = {}
            new_pos.x =  t.x0
            new_pos.y =  t.y0 

            GameInfo.new_camera_pos.x = t.x0
            GameInfo.new_camera_pos.y = t.y0

            local stage = display.getCurrentStage()
            stage:setFocus( nil )
            end
        end
        return true
end