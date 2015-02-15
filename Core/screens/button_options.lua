
function Check_ButtonOptions(button_function,value)
    local CheckState = switch { 
        ["connection_type"] = function()
        		set_connectiontype(value)
        		Hide_GameTypeScreen()
        		GameInfo.gamestate = GameInfo.gamestate + 1
            end,
        ["discard to heal"] = function()
        	--BLANK BECAUSE THIS IS ACTUALLY DEALT WITH IN CARD_FUNCTIONS
            end,
        [""] = function()
            end,

        default = function () print( "ERROR - connection_state not within switch") end,
    }
    CheckState:case(button_function)

    print("BUTTON FUNCTIONS:" .. button_function)
end