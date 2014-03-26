
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
            end,
        --[2] = function()    --CHECK FOR DRAW TO FINISH
        		
        --    end,
        default = function () print( "ERROR - ruN_main_state not within switch") end,
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

function CheckActionState()

    local CheckState = switch { 
        ["draw"] = function()    --RUN THE DRAW LOOP
        		if (action_internal_state == 0) then
        			run_main_state = 1
        			action_internal_state = 1
        		end
            end,

        default = function () print( "ERROR - GameInfo Action not within switch") end,
    }

    if (table.getn(GameInfo.actions) > 0 and
    	GameInfo.username == GameInfo.player_list[GameInfo.current_player].username) then
    	CheckState:case(GameInfo.actions[action_state])
    	--print(GameInfo.actions[action_state])
	end
end