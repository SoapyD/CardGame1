
local main_loop_state = 1
local end_round_state = 1
local end_timer = 0

function set_MainState(state_value)
	main_loop_state = state_value
	print("MAIN STATE: "  .. main_loop_state)
end


function run_main_loop()
	
	GameInfo.print_string = ""

	GameInfo.frame_num= GameInfo.frame_num + 1;
    if (GameInfo.frame_num > 60) then
    	GameInfo.frame_num = 0
    end

    Run_PlayerText()

    --GameInfo.end_game = false
    --print(main_loop_state)
    if (GameInfo.end_game == false) then

    local CheckState = switch { 
        [1] = function()
				print("Round Initiation!!!!")
				--Show_FOTable("", true)
				--main_loop_state = main_loop_state + 1
				main_loop_state = 5
            end,
        [2] = function() --START-GAME FACEOFF, DETERMINES ROUND'S STARTING PLAYER
				Show_FOTable("", true)
				main_loop_state = main_loop_state + 1
            end,

        [3] = function() --NORMAL GAME LOOP
				GameLoop()
            end,


        [4] = function() --SECOND GAME LOOP FOR PRE-GAME ACTIONS, RESETS TO NORMAL WHEN COMPLETE
				GameLoop()

				local action_state = Get_ActionState()
				--print(action_state)
				if (table.getn(GameInfo.actions) < action_state) then
	            	GameInfo.actions = {}
	            	ResetActionState()
	              	ResetActionInternalState()
	              	main_loop_state = 2
	              	print("THE STATE HAS NOW RESET   " .. action_state)			
				end
            end,
        [5] = function() --PRE-GAME ACTIONS
        --CONTAINS ANYTHING THAT NEEDS TO BE RUN BEFORE A GAME BEGINS,
        --DRAW/DISCARD CARDS ETC. ALL I NEED TO DO IS CUE THE ACTIONS

        		--GameInfo.saved_actions[1] = "discard"
        		--print("THIS SHITE IS BEING SET")
        		local arr_pos = 0

        		if (GameInfo.saved_actions ~= nil) then
	        		for i=1, table.getn(GameInfo.saved_actions) do

						arr_pos = table.getn(GameInfo.actions) + 1

		                local CheckState = switch {
		                    ["add_card"] = function()    --
		                    	local card = GameInfo.selected_card
		                    	LoadCard2(card.filename,card.sheet,card.sprite,0,0)
		                    	GameInfo.selected_card = {}
		                        end,		                	
		                    ["draw"] = function()    --
					            GameInfo.actions[arr_pos] = set_action("draw", "", 1, 0)
					            GameInfo.actions[arr_pos].type = "draw"
		                        end,
		                    ["discard"] = function()    --
			            		GameInfo.actions[arr_pos] = set_action("discard", "", 1, 1)
			            		GameInfo.actions[arr_pos].type = "discard"
		                        end,
		                    default = function () print("ERROR - state not within pre game actions") end,
		                }

		                CheckState:case(GameInfo.saved_actions[i])   		
			        end
	            end

        		--CHECK TO SEE IF THE PLAYER HAS ANY CRIPPLED LIMBS
        		--GIVE HIM THE ABILITY TO DISCARD A CARD TO ADD A LIMB ACTION

			    for i=1, table.getn(GameInfo.player_list) do

			    	local against = 1 --DONATES THE OTHER PLAYER
			    	local action = "heal_limb1"

					if (GameInfo.player_list[GameInfo.current_player].username == 
						GameInfo.player_list[i].username) then
						against = 0 --DIRECT AT THE CURRENT PLAYER
						action = "heal_limb0"
					end
					print("AGAINST: " .. against)
		        	arr_pos = table.getn(GameInfo.actions) + 1
		            GameInfo.actions[arr_pos] = set_action("limb_discard", action, 1, against)
		            GameInfo.actions[arr_pos].type = "limb_discard"
				end


	            main_loop_state = 4 --SECONDARY LOOP

				GameInfo.saved_actions = {}
            end,

        default = function () print( "ERROR - sub_type not within main_loop_state") end,
    }

    CheckState:case(main_loop_state)

	else
		--end_game == true SECTION
		--print("END GAME")
		ResetGame()

	end --end_game == false function end 

	if (GameInfo.end_round == true) then

    local CheckState2 = switch { 
        [1] = function()
				--GameInfo.round_damage = 0
        		end_timer = 60 * 3
        		end_round_state = end_round_state + 1
            end,
        [2] = function()
        		end_timer = end_timer - 1
        		if (end_timer <= 0) then
        			end_round_state = end_round_state + 1
        		end
            end,
        [3] = function() --START-GAME FACEOFF, DETERMINES ROUND'S STARTING PLAYER
				local Round_Ended = EndRound()
				if (Round_Ended == true) then
					GameInfo.end_round = false
				end
            end,

        default = function () print( "ERROR - sub_type not within main_loop_state") end,
    }

    CheckState2:case(end_round_state)

	end

    --CHECK THE NETWORK CONNECTION
    appWarpClient.Loop()

end



function GameLoop()
    --BOUNDS NEEDED TO KEEP THE SYNCING OF SCREEN AND GAME SPACES TOGETHER
    --USED TO KEEP CARDS WITHIN THE TABLE BOUNDS
	boundX1 = -camera.scrollX
	boundX2 = -camera.scrollX + (display.contentWidth / camera.xScale)
	boundY1 = -camera.scrollY
	boundY2 = -camera.scrollY + (display.contentHeight / camera.yScale)


    --INPUTS AND MAIN FUNCTIONS FOR THE GAME
 	run_button_loop()
 	run_card_loop()
 	CheckZoom()

    --RUN THE ACTION LIST LOOP, A SET OF ADVANCING NAMES AND INTERNAL STATES
 	CheckActionState()
 	action_CounterLoop()

 	--SOME TEMPORARY DRAWN BUTTONS I'M USING TO TEST THE CAMERA AND IT'S SPACING
	button1.x = -camera.scrollX
	button1.y = -camera.scrollY
	button2.x = -camera.scrollX + (display.contentWidth / camera.xScale)
	button2.y = -camera.scrollY
	button3.x = -camera.scrollX 
	button3.y = -camera.scrollY + (display.contentHeight / camera.yScale)
	button4.x = -camera.scrollX + (display.contentWidth / camera.xScale)
	button4.y = -camera.scrollY + (display.contentHeight / camera.yScale)

	if ( table.getn(GameInfo.touches) >= 1) then
		button1.x = (GameInfo.touches[1].x  / camera.xScale) - camera.scrollX
		button1.y = (GameInfo.touches[1].y  / camera.yScale) - camera.scrollY
		
	end 
	if ( table.getn(GameInfo.touches) >= 2) then	
		button2.x = (GameInfo.touches[2].x  / camera.xScale) - camera.scrollX
		button2.y = (GameInfo.touches[2].y  / camera.yScale) - camera.scrollY
	end 

	local pos_String = ""
	for i = 1, table.getn(GameInfo.touches) do
		pos_String = pos_String .. "x: " .. GameInfo.touches[i].x .. "y: " .. GameInfo.touches[i].y .. "\n"
	end

	GameInfo.touches = {}	


	statusText.text = GameInfo.print_string
	statusText.x = statusText.width / 2
	statusText.y = bar.y + (bar.height / 2) - statusText.height / 2

	statusText2.text = GameInfo.print_string2
	statusText2.x = statusText2.width / 2
	statusText2.y = bar2.y + (bar2.height / 2) - statusText2.height / 2
end

