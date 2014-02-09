
--local x_space = 250
--local y_space = 250

local x_space = 125
local y_space = 125

function run_card_loop()

    --KEEP THE CARD ALONG THE HAND BAR IF THEY'RE NOT BEING CARRIED
    hide = false
	for i = 1, table.getn(GameInfo.cards) do
		local hand_card = GameInfo.cards[i]
		if(hand_card.touched == false) then
	    	hand_card.x = GameInfo.hand.x - (GameInfo.hand.width / 2) + (hand_card.width / 2)
	    	hand_card.x = hand_card.x + (GameInfo.cards[i].width * (i -1))
	     	hand_card.x = hand_card.x + (10 * (i -1))   	
	    	hand_card.y = GameInfo.hand.y
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
    		print("worked")
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
	for i = 1, table.getn(GameInfo.table_cards) do
		current_card = GameInfo.table_cards[i]

		if ( current_card.rotation <= -360 ) then
			current_card.rotation = 0
		end

		--ONLY APPLY THIS CODE WHEN THE CARD ISN'T ROTATING
		if ( current_card.saved_rotation == current_card.rotation) then
			--TWO DIFFERENT TYPES OF POSITION DEPENDING ON THE ORIENTATION OF THE CARD
			local used_x = current_card.x
			local used_y = current_card.y

			--if ( current_card.rotation == 0 or current_card.rotation == -180 ) then
				x_itts = used_x / x_space
				y_itts = used_y / y_space

				x_itts = math.round(x_itts)
				y_itts = math.round(y_itts)

				current_card.x = (x_itts * x_space) --+ (x_space / 2)
				current_card.y = (y_itts * y_space) --+ (y_space / 2)
				--print("x:", x_itts, " y:", y_itts, "|")												
			--else
				--x_itts = (used_x - (x_space / 2)) / x_space
				--y_itts = (used_y - (y_space / 2)) / y_space

				--x_itts = math.round(x_itts)
				--y_itts = math.round(y_itts)

				--current_card.x = (x_itts * x_space) + (x_space / 2) --+ (x_space / 2)
				--current_card.y = (y_itts * y_space) + (y_space / 2) --+ (y_space / 2)
				--print("x:", x_itts, " y:", y_itts, "|")
			--end
		end

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
	end

end