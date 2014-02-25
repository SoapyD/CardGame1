
--local x_space = 250
--local y_space = 250

local x_space = 350
local y_space = 350

function run_card_loop()

    --KEEP THE CARD ALONG THE HAND BAR IF THEY'RE NOT BEING CARRIED
    hide = false
    local pos_count = 0
	for i = 1, table.getn(GameInfo.cards) do
		local hand_card = GameInfo.cards[i]
		if(hand_card.touched == false) then
	    	hand_card.x = GameInfo.hand.x - (GameInfo.hand.width / 2) + (hand_card.width / 2)
	    	hand_card.x = hand_card.x + (GameInfo.cards[i].width * pos_count) --(i -1))
	     	hand_card.x = hand_card.x + (10 * pos_count) --(i -1))   	
	    	hand_card.y = GameInfo.hand.y
	    --else
	    --	print("not in hand")
    	end
    	if(hand_card.touched == false or hand_card.moved == true) then
    		pos_count = pos_count + 1
    	end

    	--if(hand_card.moved == true) then
    	--	hide = true
    	--end
    	local screen_x = (hand_card.x) * camera.xScale
    	local screen_y = (hand_card.y) * camera.yScale  


    	if(hand_card.moved == true) then   		   		
    			print_string = print_string .. "\nScreenX:" .. screen_x
    			print_string = print_string .. "\nScreenY:" .. screen_y  
    		if ( screen_y > 600) then
    			--hide = false
    			GameInfo.hand.hide = false
    			GameInfo.hand.show = true
    		else
    			GameInfo.hand.hide = true
    		end   		
    	end

    	--THIS ALLOW FOR THE NON PLACED CARD TO GO BACK IN THE PLAYERS HAND
    	--IF THE CARD IS BELOW A CERTAIN HEIGHT ON THE SCREEN
    	if(hand_card.touched == true and hand_card.moved == false
    		and screen_y > 600) then  	
    		hand_card.touched = false
    		hand_card.isVisible = true
    		--hand_card.x = screen_x
    		--hand_card.y = screen_y
    		print(hand_card.y)
    	end

	end
	--if ( hide == false) then
	--	GameInfo.hand.hide = false
	--end

	--TABLE_CARD LOOP
	--for i = 1, table.getn(GameInfo.table_cards) do
	if ( GameInfo.current_card_int ~= -1) then
		--current_card = GameInfo.table_cards[i]
		local current_card = GameInfo.table_cards[GameInfo.current_card_int]

		--ONLY APPLY THIS CODE WHEN THE CARD ISN'T ROTATING
		if ( current_card.saved_rotation == current_card.rotation) then
			--TWO DIFFERENT TYPES OF POSITION DEPENDING ON THE ORIENTATION OF THE CARD
			local used_x = current_card.x
			local used_y = current_card.y

			x_itts = used_x / x_space
			y_itts = used_y / y_space

			x_itts = math.round(x_itts)
			y_itts = math.round(y_itts)

			current_card.x = (x_itts * x_space)
			current_card.y = (y_itts * y_space)
		end

		--///////////////////////////////////////////////////////BOUNDING CODE
		--NOT ENTIRELY ELEGENT FOR BOTH DIRECTIONS BUT IT DOES THE JOB.
		if(current_card.finalised == false) then
			if (current_card.x - (current_card.width / 2) <= boundX1) then
				current_card.x =  boundX1 + (current_card.width / 2)
			end
			if (current_card.x + (current_card.width / 2) >= boundX2) then
				current_card.x =  boundX2 - (current_card.width / 2)
			end
			if (current_card.y - (current_card.height / 2) <= boundY1) then
				current_card.y =  boundY1 + (current_card.height / 2)
			end
			if (current_card.y + (current_card.height / 2) >= boundY2) then
				current_card.y =  boundY2 - (current_card.height / 2)
			end
		end

		current_card.saved_rotation = current_card.rotation

		--///////////////////////////////////////////////////////HAND CHECK CODE
		local remove_id = false

		for i = 1, table.getn(GameInfo.cards) do
			local hand_card = GameInfo.cards[i]

			if (hand_card.unique_id == current_card.unique_id and
				current_card.finalised == false) then

			    local screen_x = (current_card.x + camera.scrollX) * camera.xScale
			    local screen_y = (current_card.y + camera.scrollY) * camera.yScale 						
				hand_card.x = screen_x
				hand_card.y = screen_y		

				local max_hight = display.contentHeight - (300 * GameInfo.zoom)--600 / GameInfo.zoom

    			print_string = print_string .. "\nScreenX:" .. screen_x
    			print_string = print_string .. "\nScreenY:" .. screen_y
    			print_string = print_string .. "\nTrigger:" .. max_hight
            	--GameInfo.hand.show = true
            	--GameInfo.hand.hide = true

				if ( hand_card.y > max_hight) then
					hand_card.isVisible = true
					hand_card.touched = false
					GameInfo.hand.show = true
					GameInfo.hand.hide = false
					remove_id = true
				else
					hand_card.isVisible = false
					if (tab.hide_once == true) then
						GameInfo.hand.hide = true
						tab.hide_once = false
					end
				end 		
			end
		end

		if ( remove_id == true) then
			Remove_CurrentCard()
		end
	--end
	end

end