
local x_space = 187.5
local y_space = 187.5
local x_land = 187.5
local y_land = 187.5


function run_card_loop()

    --KEEP THE CARD ALONG THE HAND BAR IF THEY'RE NOT BEING CARRIED
    hide = false
	for i = 1, table.getn(GameInfo.cards) do
		if(GameInfo.cards[i].touched == false) then
	    	GameInfo.cards[i].x = GameInfo.hand.x - (GameInfo.hand.width / 2) + (GameInfo.cards[i].width / 2)
	    	GameInfo.cards[i].x = GameInfo.cards[i].x + (GameInfo.cards[i].width * (i -1))
	     	GameInfo.cards[i].x = GameInfo.cards[i].x + (10 * (i -1))   	
	    	GameInfo.cards[i].y = GameInfo.hand.y
    	end
    	if(GameInfo.cards[i].moved == true) then
    		hide = true
    	end
	end
	if ( hide == false) then
		GameInfo.hand.hide = false
	end

	--TABLE_CARD LOOP
	for i = 1, table.getn(GameInfo.table_cards) do
		current_card = GameInfo.table_cards[i]

		if ( current_card.rotation <= -360 ) then
			current_card.rotation = 0
		end

		--ONLY APPLY THIS CODE WHEN THE CARD ISN'T ROTATING
		if ( current_card.saved_rotation == current_card.rotation) then
			--TWO DIFFERENT TYPES OF POSITION DEPENDING ON THE ORIENTATION OF THE CARD
			if ( current_card.rotation == 0 or current_card.rotation == -180 ) then
				x_pos = current_card.x
				y_pos = current_card.y

				x_itts = x_pos / x_space
				y_itts = y_pos / y_space

				x_itts = math.round(x_itts)
				y_itts = math.round(y_itts)

				current_card.x = (x_itts * x_space) --+ (x_space / 2)
				current_card.y = (y_itts * y_space) --+ (y_space / 2)
				--print("x:", x_itts, " y:", y_itts, "|")

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
			else
				x_pos = current_card.x
				y_pos = current_card.y

				x_itts = (x_pos - 93.75) / x_land
				y_itts = (y_pos - 93.75) / y_land

				x_itts = math.round(x_itts)
				y_itts = math.round(y_itts)

				current_card.x = (x_itts * x_land) + 93.75 --+ (x_space / 2)
				current_card.y = (y_itts * y_land) + 93.75 --+ (y_space / 2)
				--print("x:", x_itts, " y:", y_itts, "|")
			end
		end

		current_card.saved_rotation = current_card.rotation
	end

end