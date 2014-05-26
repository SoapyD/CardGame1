
function StealCards(card_number)

	local count = 0
	print("card is being stolen")

	for i = 1, table.getn(GameInfo.cards) do
		if (GameInfo.cards[i].isVisible == true) then
			count = count + 1
		end
	end

	local offset_count = 0
	if ( count > 0) then
		for i = 1, card_number do
			local randIndex = math.random(count - offset_count)
			local card = GameInfo.cards[randIndex]
			local card_type = string.sub(card.filename,1,1)
			card.isVisible = false

			appWarpClient.sendUpdatePeers(
				tostring("steal") .. " " ..
				tostring(GameInfo.username) .. " " ..		
				tostring(card.filename))

			offset_count = offset_count + 1
		end
	end

	run_popup( card_number .. " Cards Stolen")
end

function InjureEnemy()

    local apply_to = find_applied_to(0)
    local applied_player = GameInfo.player_list[apply_to]

    local shrap_val = -applied_player.armour
    applied_player.armour = 0

	appWarpClient.sendUpdatePeers(
		tostring("shrapnel") .. " " ..
		tostring(GameInfo.username) .. " " ..		
		tostring(shrap_val))

	run_popup( shrap_val .. " Shrapnel Damage")

end



local pause_state = 1
local pause_timer = 0

function advance_cardPausestate()
	pause_state = pause_state + 1
end

function set_cardPausestate(value)
	pause_state = value
end

function action_CounterLoop()

	if (GameInfo.player_list ~= nil) then
		if (table.getn(GameInfo.player_list) >= GameInfo.current_player) then
			if (GameInfo.username ~= GameInfo.player_list[GameInfo.current_player].username) then

			    CheckState = switch { 
			        [1] = function()    --WAIT FOR THE COMPLETE ACTION VALUE 
			        	--print("current: " .. GameInfo.current_player)
			            end,
			        [2] = function()    --SET A TIMER
			        		pause_timer = 3 * GameInfo.fps
			        		advance_cardPausestate()
			            end,
			        [3] = function()    --COUNT THROUGH THE TIMER
			        		pause_timer = pause_timer - 1
			        		if ( pause_timer <= 0) then
			        			pause_timer = 0
			        			advance_cardPausestate()
			        		end
			        		run_popup("COUNTER TIMER: " .. pause_timer)
			            end,
			        [4] = function()    --PASS THE COUNT BACK
			            appWarpClient.sendUpdatePeers(
	                    	tostring("finish_placement_pause") .. " " ..
	                    	tostring(GameInfo.username))
			            	advance_cardPausestate()
			            end,
			        [5] = function()    --END
			        	current_card = GameInfo.table_cards[table.getn(GameInfo.table_cards)]
			        	EndTurn(current_card)
			        	pause_state = 1
			            end,
			        [6] = function()    --COUNTER
			        	--run_popup("COUNTER!")
			        	Show_COTable()
						advance_cardPausestate()
			            end,
			        [7] = function()    --COUNTER LOOP

			            end,
			        default = function () print( "ERROR - SetCards_state not within counterer switch" .. pause_state) end,
			    }

			    CheckState:case(pause_state)
			else
			    CheckState2 = switch { 
			        [1] = function()    --WAIT FOR THE COMPLETE ACTION VALUE 
			            end,
			        [2] = function()    --COUNT THROUGH THE TIMER
			        		run_popup("PLACEMENT RETURNED")
			        		advance_cardPausestate()
			            end,
			        [3] = function()    --END
			        	current_card = GameInfo.table_cards[table.getn(GameInfo.table_cards)]
			        	EndTurn(current_card)
			        	pause_state = 1
			            end,
			        default = function () print( "ERROR - SetCards_state not within opponent switch" .. pause_state) end,
			        --default = function ()  end,
			    }

			    CheckState2:case(pause_state)
			end
		end
	end
end