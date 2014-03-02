local widget = require("widget")

function Remove_CurrentCard()
	local current_card = GameInfo.table_cards[GameInfo.current_card_int]
	current_card:removeSelf()
	camera:remove(GameInfo.table_cards[GameInfo.current_card_int])
	table.remove(GameInfo.table_cards, GameInfo.current_card_int)

	print("card removed")
	GameInfo.current_card_int = -1

end

function Restore_HandCard()
	local current_card = GameInfo.table_cards[GameInfo.current_card_int]

	for i = 1, table.getn(GameInfo.cards) do
		local hand_card = GameInfo.cards[i]

		if (hand_card.unique_id == current_card.unique_id and
			current_card.finalised == false) then

			local screen_x = (current_card.x + camera.scrollX) * camera.xScale
			local screen_y = (current_card.y + camera.scrollY) * camera.yScale 						
			hand_card.x = screen_x
			hand_card.y = screen_y		

			hand_card.isVisible = true
			hand_card.touched = false	
		end
	end
end


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
