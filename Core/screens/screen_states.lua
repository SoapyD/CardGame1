
local internal_state = 1
local timer = 0

function Screen_Loop()


--	

    local CheckState = switch { 
    	[1] = function()	--T
    		Show_CharacterScreen()
    		internal_state = internal_state + 1
    		end,
    	[2] = function()	--
    		--GameInfo.gamestate = GameInfo.gamestate + 1


    			local complete_count = 0
	    		--KEEP A TRACK ON THE PLAYER NAMES
			    for i = 1, table.getn(GameInfo.player_list) do
			      local player = GameInfo.player_list[i]

			      if (player.character_name ~= "") then
			      	complete_count = complete_count + 1
			      end
			    end

			    if (complete_count >= 2) then
			    	internal_state = internal_state + 1
			    end
    		end,
    	[3] = function()	--
                SetupButtons();

                local group = display.newGroup() --BRING SCREEN ELEMENTS TO THE FRONT OF SCREEN
                group:insert(GameInfo.screen_elements2.image)
                TitleText:toFront()
                group:insert(MsgBox)
                MsgText:toFront()

                --GameInfo.screen_elements2.image:toFront()
                Show_EndTable()
				timer = 60 * 5
				internal_state = internal_state + 1  
				--TitleText.text = "GAME STARTING"	
    		end,
    	[4] = function()	--
    			TitleText.text = "GAME STARTING... " .. math.round(timer / 60)

    			if (timer <= 0) then
    				timer = 0
    				internal_state = internal_state + 1
    			end
				timer = timer - 1			
    		end,
    	[5] = function()	--
    			Hide_CharacterScreen()
				run_main_loop() --NEEDS TO RUN ONCE IN THE LOAD GAME LOOP
				internal_state = internal_state + 1  			
    		end,

    	[6] = function()	--
                local HandsSet = SetHands()
                if (HandsSet == true) then
                  GameInfo.gamestate = GameInfo.gamestate + 1
                  Hide_EndTable()
                end    		
    		end,
    	[7] = function()	--
    			gamestate.gamestate = GameInfo.gamestate + 1
    		end,
	   	default = function () print( "ERROR - gamestate not within screen_loop states") end,
	}

	CheckState:case(internal_state)

    appWarpClient.Loop()

end