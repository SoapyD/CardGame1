function onStrafe( event )
		local t = event.target
		local phase = event.phase
		if "began" == phase then
			-- Make target the top-most object
			local parent = t.parent
			--parent:insert( t )
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

				--t.y = event.y - t.y0
			elseif "ended" == phase or "cancelled" == phase then
				display.getCurrentStage():setFocus( nil )
				t.isFocus = false
			end
		end
		return true
end

function onStrafe_vert( event )
		local t = event.target
		local phase = event.phase
		if "began" == phase then
			-- Make target the top-most object
			local parent = t.parent
			--parent:insert( t )
			display.getCurrentStage():setFocus( t )
			t.isFocus = true
			-- Store initial position
			--t.x0 = event.x - t.x
			t.y0 = event.y - t.y
			tab.hide_once = true
		elseif t.isFocus then
			if "moved" == phase then
				-- Make object move (we subtract t.x0,t.y0 so that moves are
				-- relative to initial grab point, rather than object "snapping").
				--t.x = event.x - t.x0
				t.y = event.y - t.y0
			elseif "ended" == phase or "cancelled" == phase then
				display.getCurrentStage():setFocus( nil )
				t.isFocus = false
			end
		end
		return true
end

function finishCard( event )
	local t = event.target
	local phase = event.phase

	if "began" == phase then
		
		local parent = t.parent
		parent:insert( t )
		display.getCurrentStage():setFocus( t )	
		finalise_button.text:toFront()
		t.isFocus = true

	elseif t.isFocus then
		if "ended" == phase then
			display.getCurrentStage():setFocus( nil )
			t.isFocus = false
			--EndTurn(current_card)
			local CheckState = switch { 
				[1] = function()    --NORMAL CARD FINALISATION: SEND CARD DETAILS, PASS TURN
						id = GameInfo.current_card_int
						if(id ~= -1) then
							camera.damping = 10

							local current_card = GameInfo.table_cards[id]

							appWarpClient.sendUpdatePeers(
								tostring("position") .. " " ..
								tostring(current_card.unique_id) .. " " ..
								tostring(current_card.filename) .. " " ..
								tostring(current_card.sheet) .. " " .. 
								tostring(current_card.sprite) .. " " .. 								 
								tostring(current_card.x).." ".. 
								tostring(current_card.y))

							appWarpClient.sendUpdatePeers(
								tostring("rotation") .. " " ..
								tostring(current_card.unique_id) .. " " .. 
								tostring(GameInfo.username) .. " " ..		
								tostring(current_card.rotation))
						end
			        end,
			    [2] = function()    --FACEOFF FINALISATION

			    		for i=1, table.getn(GameInfo.player_list) do
							if (GameInfo.username == GameInfo.player_list[i].username) then
								if ( GameInfo.player_list[i].faceoff_card ~= "") then
				        			print("this is the end of the finalisation")
										appWarpClient.sendUpdatePeers(
											tostring("pass_faceoff") .. " " ..
											tostring(GameInfo.username) .. " " ..		
											tostring(GameInfo.player_list[i].faceoff_card))

									--STOP PLAYERS FROM ADDING ANOTHER CARD AFTER ITS BEEN PLACED
									GameInfo.pause_main = true
									run_popup("FaceOff Card Set")
									Check_FaceOff_End()
								end
							end
						end		        	
			        end,

			    [3] = function()    --COUNTER SETUP

	      				local cant_counter = true
	      				local no_counter_message = ""
	      				local current_card = GameInfo.table_cards[table.getn(GameInfo.table_cards)]
	      				local current_card_info = retrieve_card(current_card.filename)


			    		for i=1, table.getn(GameInfo.player_list) do
							if (GameInfo.username == GameInfo.player_list[i].username) then

							for i = 1, table.getn(GameInfo.cards) do
									local hand_card = GameInfo.cards[i]
									local card_info = retrieve_card(hand_card.filename)
									local counter_card = false

									--check to see if the player has a counter card
  									if ( table.getn(card_info.actions) > 0) then
   	 									for i=1, table.getn(card_info.actions) do
      										local action = card_info.actions[i]
      										print("action: " .. action.name .. " , " .. action.sub_action)
      										if (action.name == "counter") then

											    Check_Ab = switch { 
											        ["w_or_a"] = function (x)
											        			if (current_card_info.card_value == 1 or
											        				current_card_info.card_value == 5) then
											        				--print("CAN CANCEL CARD!!!!!!   " .. current_card_info.card_value)
											        				cant_counter = false
											        			end 
											                end,
												   	default = function () 
											                print( "ERROR - not a counter sub action") 
											                cant_counter = false
											                end,
												}

												Check_Ab:case(action.sub_action)
      										end
      									end
      								end
			    				end
			    			end
			    		end

			    		if (cant_counter == true) then
			    			no_counter_message = "Can't Counter Card Type"
			    		end

				    	--CHECK TO SEE IF THE CURRENT HAS SPECIAL "CAN'T COUNTER" RULE
	      				--print("card name: " .. current_card.filename)
						if ( table.getn(current_card_info.actions) > 0) then
						    for i=1, table.getn(current_card_info.actions) do
						        local action = current_card_info.actions[i]
						        --print("action name is: " .. action.name)
						        if (action.name == "no_counter") then
						            cant_counter = true
						            --print("CAN'T COUNTER!!!")
						            no_counter_message = "Card Can't be Countered"
						        end
						   	end
						end

						if (cant_counter == false) then
	        				set_cardPausestate(6)
	        			else
	        				--run_popup("Card Can't be Countered")
	        				print(no_counter_message)
	        			end
			        end,
			    [4] = function()    --COUNTER
			    		--print("COUNTER FINISHED!")
			    		for i=1, table.getn(GameInfo.player_list) do
							if (GameInfo.username == GameInfo.player_list[i].username) then
								if ( GameInfo.player_list[i].faceoff_card ~= "") then

									local card_info = retrieve_card(GameInfo.player_list[i].faceoff_card)
									local counter_card = false

									--check to see if the player has a counter card
  									if ( table.getn(card_info.actions) > 0) then
   	 									for i=1, table.getn(card_info.actions) do
      										local action = card_info.actions[i]

      										if (action.name == "counter") then
      											counter_card = true
      										end
      									end
      								end

      								if (counter_card == true) then

										appWarpClient.sendUpdatePeers(
											tostring("counter") .. " " .. 
											tostring(GameInfo.username) .. " " .. 
											tostring(GameInfo.cards[GameInfo.faceoff_int].filename) .. " " .. 
											tostring(GameInfo.cards[GameInfo.faceoff_int].sheet) .. " " .. 
											tostring(GameInfo.cards[GameInfo.faceoff_int].sprite) .. " " .. 
											tostring(GameInfo.cards[GameInfo.faceoff_int].unique_id))

										GameInfo.pause_main = true
			    						AddCounterCard(GameInfo.username, GameInfo.player_list[i].faceoff_card)
			    					else
			    						run_popup("Card Not a Counter Card")
			    					end
			    				end
			    			end
			    		end
			        end,
			    [5] = function()    --COPY CARD
			    		run_popup("copying card.")
						local card_sent = false
						if (GameInfo.selected_card ~= nil) then
							if (GameInfo.selected_card.filename ~= nil) then

							    id = table.getn(GameInfo.cards)+1
							    unique_id = GameInfo.username .. "_" .. GameInfo.selected_card.filename .. "_" .. id

								appWarpClient.sendUpdatePeers(
									tostring("hide_current") .. " " ..
									tostring(GameInfo.username) .. " " ..
									tostring(unique_id) .. " " ..
									tostring(GameInfo.selected_card.filename) .. " " ..
									tostring(GameInfo.selected_card.sheet) .. " " ..
									tostring(GameInfo.selected_card.sprite) .. " " ..									
									tostring(GameInfo.selected_card.x) .. " " ..
									tostring(GameInfo.selected_card.y))

								--THE SEND THAT DATA TO THE OTHER PLAYER.
								--NEEDS TO BE DONE AS DIFFERENT COUNTER RULES APPLY TO THE ATTACKER / DEFENDER
								appWarpClient.sendUpdatePeers(
									tostring("position") .. " " ..
									tostring(unique_id) .. " " ..
									tostring(GameInfo.selected_card.filename) .. " " .. 
									tostring(current_card.x).." ".. 
									tostring(current_card.y))

								GameInfo.selected_card = {}
								card_sent = true

								--RESET THE FINALISATION BUTTON BACK TO NORMAL
								GameInfo.finalise_state = 1
								finalise_button.text.text = finalise_button.default_text
							end
						end

						if (card_sent == false) then
							run_popup("please select card to copy first")
						end
			        end,	  
			    [6] = function()    --END DISCARD
		            appWarpClient.sendUpdatePeers(
		                tostring("hide_discard") .. " " .. 
		                tostring(GameInfo.username)) 
			        end,	      
			    default = function () print( "ERROR - state not within finalisation states") end,
			    }

			CheckState:case(GameInfo.finalise_state)
			--run_popup("final state: " .. GameInfo.finalise_state)
		end
	end

	return true
end


function check_FinalisationButton(player)

  if ( GameInfo.username ~= GameInfo.player_list[player].username) then
    finalise_button.isVisible = false
    finalise_button.text.isVisible = false


	for i = 1, table.getn(GameInfo.cards) do
		local hand_card = GameInfo.cards[i]

		if (hand_card.isVisible == true) then
			local card_info = retrieve_card(hand_card.filename)

			if ( table.getn(card_info.actions) > 0) then
				for i=1, table.getn(card_info.actions) do
			    	local action = card_info.actions[i]
			    	--print("checked action: " .. action.name)
			    	if (action.name == "counter") then
			    		--print("has counter card")
			    		finalise_button.isVisible = true
			    		finalise_button.text.isVisible = true
						finalise_button.text.text = "counter"
						print("counter string set")
			    		
						if ( GameInfo.username ~= GameInfo.player_list[player].username) then
							GameInfo.finalise_state = 3
						else
							GameInfo.finalise_state = 1
							finalise_button.text.text = finalise_button.default_text
						end
			    	end
			    end
			end
		end
	end 

  else
    --finalise_button.isVisible = true
    --finalise_button.text.isVisible = true

    --SET TO FALSE SO PLAYER CAN'T ACCIDENTLY END A TURN WITHOUT PLACING A CARD
    GameInfo.finalise_state = 1
    finalise_button.isVisible = false
    finalise_button.text.isVisible = false    
    finalise_button.text.text = finalise_button.default_text

    --run_popup("finalisation button checked: " .. player)
  end 

end