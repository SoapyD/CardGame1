local widget = require("widget")


function Test()

	--myButtons = {}
	local box1 = cButtonClass:new(50,10,100,100,10,255,0,128,1);

	local button_array =
	{
		box1,
	}

	GenerateButton(button_array, false);
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

		--button:addEventListener( "touch", onPress )

	  -- assign ids to buttons and insert in table
	  button.id = tostring(item.id)
	  GameInfo.myButtons[button.id] = button
	  print("button id:", button.id)
	  print("button x:", GameInfo.myButtons[button.id].x) 
	end
end

function onPress( event )
	local t = event.target
	local phase = event.phase

	if "began" == phase then
		
		local parent = t.parent
		parent:insert( t )
		display.getCurrentStage():setFocus( t )	
		t.isFocus = true

	elseif t.isFocus then
		if "ended" == phase then
			display.getCurrentStage():setFocus( nil )
			t.isFocus = false
			print("PRESS WORKED!")
		end
	end

	return true
end

function onTouch( event )
		local t = event.target
		local phase = event.phase

		if (t.finalised == false) then
			if "began" == phase then
				-- Make target the top-most object
				local parent = t.parent
				parent:insert( t )
				display.getCurrentStage():setFocus( t )
				t.isFocus = true
				-- Store initial position
				t.x0 = event.x - t.x
				t.y0 = event.y - t.y
				t.moved = true
				t.touched = true

				GameInfo.hand.hide = true
				print("touched")
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
		      		--appWarpClient.sendUpdatePeers(tostring(t.id) .. " " .. tostring(t.x).." ".. tostring(t.y))
					appWarpClient.sendUpdatePeers(tostring(t.filename) .. " " .. tostring(t.x).." ".. tostring(t.y))

					if (t.drawn == false) then
						t.isVisible = false	
					end
					t.moved = false
				end
			end
		end
		return true
end

function LoadCard(filename,x,y)
	local group = display.newGroup()
    -- width, height, x, y
    local icon = display.newImage(group, "Images/" .. filename, 
        x, y)

    icon:addEventListener( "touch", onTouch )
    --icon:addEventListener( "touch", onPress )
    --icon:scale( 0.35, 0.35 )

    id = table.getn(GameInfo.cards)+1

    GameInfo.cards[id] = icon
    GameInfo.cards[id].touched = false
    GameInfo.cards[id].id = id 
    GameInfo.cards[id].filename = filename
    GameInfo.cards[id].drawn = false
    GameInfo.cards[id].finalised = false
	--local box1 = cButtonClass:new(icon.x,icon.y,100,100,10,255,0,128,1);
	--local button_array =
	--{
	--	box1,
	--}
	--GenerateButton(button_array, true);
 
	--camera:add(icon, 4, true)
	--camera:setFocus(icon)
	--camera:track()
	

end


function AddCard(filename,x,y)
	local group = display.newGroup()
    -- width, height, x, y
    local icon = display.newImage(group, "Images/" .. filename, 
        x, y)

    icon:addEventListener( "touch", onTouch )
    icon:addEventListener( "tap" , tapRotateLeftButton )

    icon:scale( 0.75, 0.75 )

    id = table.getn(GameInfo.table_cards)+1

    GameInfo.table_cards[id] = icon
    GameInfo.table_cards[id].touched = false
    GameInfo.table_cards[id].id = id 
    GameInfo.table_cards[id].filename = filename
    GameInfo.table_cards[id].drawn = true
    GameInfo.table_cards[id].rotation = 0
    GameInfo.table_cards[id].finalised = false

    GameInfo.current_card_int = id

    --ADD THE CARD TO THE CAMERA BUT DON'T MAKE IT THE FOCUS YET
    camera:add(GameInfo.table_cards[id], 4, true)
    if(id - 1 > 0) then
    	camera:setFocus(GameInfo.table_cards[id - 1])
    end
end

--ALLOW THE CARDS PLACED ON THE TABLE TO BE ROTATED IF CLICKED ON
function tapRotateLeftButton( e )
    local t = e.target

    if (t.finalised == false) then
	    if ( t.rotation == 0 or t.rotation == -90 or 
	    	t.rotation == -180 or t.rotation == -270) then
	    	transition.to(t, {time=250, 
	    	rotation= t.rotation -90.0, onComplete=updaterotation(t)})
		end
	end
end

local test_int = 0

function updaterotation(t)
	--do nothing on completion
end