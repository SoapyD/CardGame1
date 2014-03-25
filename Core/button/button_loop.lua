
function run_button_loop()

    --STOCK THE TAB GOING HIGHER THAN HAND AND BAR HEIGHT OR LOWER THAN SCREEN EDGE
	if(tab.y < GameInfo.height - (tab.height / 2) - bar.height - GameInfo.hand.height ) then
		tab.y = GameInfo.height - (tab.height / 2) - bar.height - GameInfo.hand.height
	end
	if(tab.y > GameInfo.height - (tab.height / 2)) then
		tab.y = GameInfo.height - (tab.height / 2)
	end

	--MAKE THE HAND HIDE AWAY IF THE PLAYER IS CURRENTLY HOLDING A CARD
	if ( GameInfo.hand.hide == true) then
		if (tab.y < GameInfo.height - (tab.height / 2)) then
			tab.y = tab.y + 50

			if(tab.y > GameInfo.height - (tab.height / 2)) then
				tab.y = GameInfo.height - (tab.height / 2)
				GameInfo.hand.hide  = false
			end
		end		
	end

	if ( GameInfo.hand.show == true) then
		tab.y = tab.y - 50

		if(tab.y < GameInfo.height - GameInfo.hand.height - bar.height - boxheight / 2) then
			tab.y = GameInfo.height - GameInfo.hand.height - bar.height - boxheight / 2
			GameInfo.hand.show = false
		end	
	end

	--local max_x = 250
	--if ( table.getn(GameInfo.cards) > 0) then
	--	max_x = GameInfo.cards[table.getn(GameInfo.cards)].x
	--end


	--STOP THE BAR GOING BEYOND THE PORTRAIT OR FAR RIGHT OF THE SCREEN
	--if(bar.x < GameInfo.width - (bar.width / 2) ) then
	--	bar.x = GameInfo.width - (bar.width / 2)
	--end

	--ALL WRONG!!!!!!!!!!!
	local max_x = 250
    local pos_count = -1
	for i = 1, table.getn(GameInfo.cards) do
		local hand_card = GameInfo.cards[i]
    	if(hand_card.touched == false or hand_card.moved == true) then
    		pos_count = i
    	end
    end
    local bar_start = bar.x - (bar.width / 2)
    --local card_diff = (GameInfo.cards[pos_count].x - GameInfo.cards[pos_count].width / 2) - bar_start
    

    --print("card diff" .. card_diff)
    max_x = GameInfo.width  - (bar.width / 2)
    --max_x = bar_start + card_diff
    --max_x = GameInfo.cards[pos_count].x - 10

	if(bar.x <= max_x) then
		bar.x = max_x 
	end
	if(bar.x > GameInfo.portrait_start + (bar.width / 2) ) then
		bar.x = GameInfo.portrait_start + (bar.width / 2) 
	end

	--LOCK THE BAR.Y TO THE TAB.Y ALLOWING IT BE LOWERED BELOW SCREEN
    bar.y = tab.y  + (tab.height / 2) + (bar.height / 2)
    finalise_button.y = tab.y
    --LOCK THE HAND.X TO THE SCROLL BAR.X POSITION
	GameInfo.hand.x = bar.x
	GameInfo.hand.y = bar.y + (bar.height / 2) + (GameInfo.hand.height / 2)

end