local x_space = 350
local y_space = 350

function run_card_loop()
--print("considering height")
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
    	end
    	if(hand_card.touched == false or hand_card.moved == true) then
    		pos_count = pos_count + 1
    	end

    	local screen_x = (hand_card.x) * camera.xScale
    	local screen_y = (hand_card.y) * camera.yScale  


    	if(hand_card.moved == true) then  		   		
    		if ( screen_y > 600) then
    			GameInfo.hand.hide = false
    			GameInfo.hand.show = true
    		else
    			GameInfo.hand.hide = true
    		end   		
    	end

    	--print("touched: " , hand_card.touched , " moved: " , hand_card.moved)

    	--THIS ALLOW FOR THE NON PLACED CARD TO GO BACK IN THE PLAYERS HAND
    	--IF THE CARD IS BELOW A CERTAIN HEIGHT ON THE SCREEN
    	if(hand_card.touched == true and hand_card.moved == false
    		and screen_y > 600) then  	
    		hand_card.touched = false
    		hand_card.isVisible = true
    	end

	end

	--TABLE_CARD LOOP
	if ( GameInfo.current_card_int ~= -1) then
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
	end

    if (table.getn(GameInfo.player_list) >= 2) then

		local p1_text = ""
		local p2_text = ""

    	--if(GameInfo.player_list[1].username == GameInfo.username) then
			--p1_text = p1_text .. "PLAYER1:"
			local health = "" .. GameInfo.player_list[1].health
			local armour = "" .. GameInfo.player_list[1].armour
			local arms = "" .. GameInfo.player_list[1].arms
			local legs = "" .. GameInfo.player_list[1].legs
		    --GameInfo.print_string = GameInfo.print_string .. "\nHP:" .. health .. " AR:" ..armour
		    --GameInfo.print_string = GameInfo.print_string .. "\nA:" .. arms .. " L:" .. legs  
		    p1_text = p1_text .. " HP:" .. health .. " AR:" ..armour
		    p1_text = p1_text .. " A:" .. arms .. " L:" .. legs

		--else

			--p2_text = p2_text .. "PLAYER2:"
			health = "" .. GameInfo.player_list[2].health
			armour = "" .. GameInfo.player_list[2].armour
			arms = "" .. GameInfo.player_list[2].arms
			legs = "" .. GameInfo.player_list[2].legs
		    --GameInfo.print_string = GameInfo.print_string .. "\nHP:" .. health .. " AR:" ..armour
		    --GameInfo.print_string = GameInfo.print_string .. "\nA:" .. arms .. " L:" .. legs  
		    p2_text = p2_text .. " HP:" .. health .. " AR:" ..armour
		    p2_text = p2_text .. " A:" .. arms .. " L:" .. legs		
		--end

		if(GameInfo.player_list[1].username == GameInfo.username) then
			GameInfo.print_string = "You: " .. p1_text
			GameInfo.print_string2 = "Enemy: " .. p2_text
		else
			GameInfo.print_string = "You: " .. p2_text
			GameInfo.print_string2 = "Enemy: " .. p1_text
		end
	end



end