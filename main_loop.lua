
local run_main_state = 0
local action_state = 1
local action_internal_state = 0

function run_main_loop()

	GameInfo.print_string = ""

	GameInfo.frame_num= GameInfo.frame_num + 1;
    if (GameInfo.frame_num > 60) then
    	GameInfo.frame_num = 0
    end

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

 	CheckActionState()

    local CheckState = switch { 
        [0] = function()    --MAIN GAME

            end,
        [1] = function()    --TURN ON THE DRAW CARDS SCREEN
        		Show_DrawTable()
        		--run_main_state = run_main_state + 1
            	run_main_state = 0
                --action_internal_state = 0
            end,
        [2] = function()    --TURN ON THE DISCARD CARDS SCREEN
                Show_DiscardTable()
                --run_main_state = run_main_state + 1
                run_main_state = 0
                --action_internal_state = 0
            end,
        [3] = function()    --TURN ON THE DISCARD CARDS SCREEN
                Show_LimbTable()
                --run_main_state = run_main_state + 1
                run_main_state = 0
                --action_internal_state = 0
            end,
        --[4] = function()    --STEAL THE CARDS THEN SEND THEM TO OTHER PLAYER
                --run_main_state = run_main_state + 1
         --       run_main_state = 0
                --action_internal_state = 0
        --    end,
        [14] = function()    --PASS TURN
                PassTurn()
                --run_main_state = run_main_state + 1
                run_main_state = 0
                print("ending turn")
                --action_internal_state = 0
            end,
        [15] = function()    --END ROUND
                EndRound()
                --run_main_state = run_main_state + 1
                --run_main_state = 0
                --action_internal_state = 0
            end,
        --[2] = function()    --CHECK FOR DRAW TO FINISH
        		
        --    end,
        default = function () print( "ERROR - run_main_state not within switch") end,
    }

    CheckState:case(run_main_state)


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

	--GameInfo.print_string = GameInfo.print_string .. "\nCameraX:" .. math.round(camera.scrollX)
	--GameInfo.print_string = GameInfo.print_string .. "\nCameraY:" .. math.round(camera.scrollY)

	GameInfo.touches = {}	
	--print("text: " .. GameInfo.print_string)
	statusText.text = GameInfo.print_string
	statusText.x = statusText.width / 2
	statusText.y = display.contentHeight - statusText.height / 2

    --CHECK THE NETWORK CONNECTION
    appWarpClient.Loop()

end

function ResetActionState()
    action_state = 1
end
function ResetActionInternalState()
    action_internal_state = 0
end

function CheckActionState()

    local Action = GameInfo.actions[action_state]

    local CheckState = switch { 
        ["draw"] = function()    --RUN THE DRAW LOOP
        		if (action_internal_state == 0) then
        			run_main_state = 1
        			action_internal_state = 1
                    SetDrawMax(Action.value)
        		end
            end,
        ["discard"] = function()    --RUN THE DISCARD LOOP
                if (action_internal_state == 0) then
                    run_main_state = 2
                    action_internal_state = 1
                    SetDiscardMax(Action.value)
                end
            end,
        ["limb"] = function()    --RUN THE LIMB LOOP
                if (action_internal_state == 0) then
                    run_main_state = 3
                    action_internal_state = 1
                    SetCrippleMax(Action.value)
                end
            end,
        ["steal"] = function()    --RUN THE STEAL FUNCTION
                if (action_internal_state == 0) then
                    run_main_state = 0
                    action_internal_state = 1
                    StealCards(Action.value)
                end
            end,
        ["shrapnel"] = function()    --RUN THE SHRAPNEL FUNCTION
                if (action_internal_state == 0) then
                    run_main_state = 0
                    action_internal_state = 1
                    InjureEnemy()
                end
            end,
        ["pass_turn"] = function()    --RUN THE PASS_TURN
                if (action_internal_state == 0) then
                    run_main_state = 14
                    action_internal_state = 1
                end
            end,
        ["end_round"] = function()    --RUN THE END_ROUND
                if (action_internal_state == 0) then
                    run_main_state = 15
                    action_internal_state = 1
                end
            end,
        default = function () print( "ERROR - GameInfo Action not within switch") end,
    }

    if (table.getn(GameInfo.actions) > 0 ) then
        --print("applied to" .. GameInfo.actions[action_state].applied_to)
    	if (GameInfo.actions[action_state].applied_to == 1 and
            GameInfo.username == GameInfo.player_list[GameInfo.current_player].username) then
    	   CheckState:case(GameInfo.actions[action_state].type)
        end
        if (GameInfo.actions[action_state].applied_to == 0 and
            GameInfo.username ~= GameInfo.player_list[GameInfo.current_player].username) then
           CheckState:case(GameInfo.actions[action_state].type)
        end
        if (GameInfo.actions[action_state].applied_to == -1) then
            --print("-1 used")
           CheckState:case(GameInfo.actions[action_state].type)
        end
	end
end

function CheckActionPos(network_used)
    local list_size = table.getn(GameInfo.actions)

    if (list_size > 0) then
        --print("list size:" .. list_size .. " action_state:" .. action_state)
        if (action_state < list_size) then
            action_state = action_state + 1
        else
            GameInfo.actions = {}
        end

        if ( network_used == false) then
            appWarpClient.sendUpdatePeers(
                tostring("MSG_CODE") .. " " ..
            tostring("advance_actions") .. " " .. 
            tostring(username)) 
        end

        ResetActionInternalState()
    end
    --print("NEW ACTION POS: " .. action_state)
end