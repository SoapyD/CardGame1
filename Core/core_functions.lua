local widget = require("widget")


function Test()

	--myButtons = {}
	local box1 = cButtonClass:new(50,10,100,100,10,255,0,128,1);

	local button_array =
	{
		box1,
	}

	GenerateButton(button_array, true);
end

function GenerateButton(button_array, moveable)

		-- Iterate through arguments array and create rounded rects (vector objects) for each item
	for _,item in ipairs( button_array ) do
		local button = display.newRoundedRect( item.x, item.y, item.w, item.h, item.r )
		button:setFillColor( item.red, item.green, item.blue )
		button.strokeWidth = 6
		button:setStrokeColor( 200,200,200,255 )
		-- Make the button instance respond to touch events
		if (moveable == true) then
			button:addEventListener( "touch", onTouch )
		end
		
	  -- assign ids to buttons and insert in table
	  button.id = tostring(item.id)
	  GameInfo.myButtons[button.id] = button
	  print("button id:", button.id)
	  print("button x:", GameInfo.myButtons[button.id].x) 
	end

end

function onTouch( event )
		local t = event.target
		local phase = event.phase
		if "began" == phase then
			-- Make target the top-most object
			local parent = t.parent
			parent:insert( t )
			display.getCurrentStage():setFocus( t )
			t.isFocus = true
			-- Store initial position
			t.x0 = event.x - t.x
			t.y0 = event.y - t.y
		elseif t.isFocus then
			if "moved" == phase then
				-- Make object move (we subtract t.x0,t.y0 so that moves are
				-- relative to initial grab point, rather than object "snapping").
				t.x = event.x - t.x0
				t.y = event.y - t.y0
			elseif "ended" == phase or "cancelled" == phase then
				display.getCurrentStage():setFocus( nil )
				t.isFocus = false
	      print("moved button id ".. tostring(t.id))
	      -- send the update to others in the game room. space delimit the values and parse accordingly
	      -- in onUpdatePeersReceived notification
	      appWarpClient.sendUpdatePeers(tostring(t.id) .. " " .. tostring(t.x).." ".. tostring(t.y))
			end
		end
		return true
end

function LoadImage(filename,x,y)
	local group = display.newGroup()
    -- width, height, x, y
    local icon = display.newImage(group, "Images\\" .. filename, 
        x, y)

    GameInfo.images[table.getn(GameInfo.images)+1] = icon
end


