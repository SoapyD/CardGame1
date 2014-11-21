
function run_button_loop()

    --STOCK THE TAB GOING HIGHER THAN HAND AND BAR HEIGHT OR LOWER THAN SCREEN EDGE
	if(tab.icon.y < GameInfo.height - (tab.height / 2) - bar.height - GameInfo.hand.height ) then
		tab.icon.y = GameInfo.height - (tab.height / 2) - bar.height - GameInfo.hand.height
	end
	if(tab.icon.y > GameInfo.height - (tab.height / 2)) then
		tab.icon.y = GameInfo.height - (tab.height / 2)
	end

	--MAKE THE HAND HIDE AWAY IF THE PLAYER IS CURRENTLY HOLDING A CARD
	if ( GameInfo.hand.hide == true) then
		if (tab.icon.y < GameInfo.height - (tab.height / 2)) then
			tab.icon.y = tab.icon.y + 50

			if(tab.icon.y > GameInfo.height - (tab.height / 2)) then
				tab.icon.y = GameInfo.height - (tab.height / 2)
				GameInfo.hand.hide  = false
			end
		end		
	end

	if ( GameInfo.hand.show == true) then
		tab.icon.y = tab.icon.y - 50

		if(tab.icon.y < GameInfo.height - GameInfo.hand.height - bar.height - boxheight / 2) then
			tab.icon.y = GameInfo.height - GameInfo.hand.height - bar.height - boxheight / 2
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
    local bar_start = bar.icon.x - (bar.width / 2)
    --local card_diff = (GameInfo.cards[pos_count].x - GameInfo.cards[pos_count].width / 2) - bar_start
    

    --print("card diff" .. card_diff)
    max_x = GameInfo.width  - (bar.width / 2)
    --max_x = bar_start + card_diff
    --max_x = GameInfo.cards[pos_count].x - 10

	if(bar.icon.x <= max_x) then
		bar.icon.x = max_x 
	end
	--if(bar.x > GameInfo.portrait_start + (bar.width / 2) ) then
	--	bar.x = GameInfo.portrait_start + (bar.width / 2) 
	--end

	if(bar.icon.x > (bar.width / 2) ) then
		bar.icon.x = (bar.width / 2) 
	end

	--LOCK THE BAR.Y TO THE TAB.Y ALLOWING IT BE LOWERED BELOW SCREEN
    bar.icon.y = tab.icon.y  + (tab.height / 2) + (bar.height / 2)
    bar3.y = tab.icon.y
    --finalise_button.y = tab.y
    --finalise_button.text.y = tab.y
    --LOCK THE HAND.X TO THE SCROLL BAR.X POSITION
	GameInfo.hand.x = bar.icon.x
	GameInfo.hand.y = bar.icon.y + (bar.height / 2) + (GameInfo.hand.height / 2)

end