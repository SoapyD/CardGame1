
function Check_ButtonOptions(t,button_function,value)
    local CheckState = switch { 
        ["connection_type"] = function()
        		set_connectiontype(value)
        		Hide_GameTypeScreen()
        		GameInfo.gamestate = GameInfo.gamestate + 1
            end,
        ["discard to heal"] = function()
        	--BLANK BECAUSE THIS IS ACTUALLY DEALT WITH IN CARD_FUNCTIONS
            end,
        ["cripple_arm"] = function()

                local limb_info = Get_LimbTable_Info()

                QueueMessage(
                tostring("cripple_limb") .. " " .. 
                tostring(GameInfo.username) .. " " ..
                tostring(limb_info.limb_modifier) .. " " ..
                tostring(button_function) .. " " ..
                tostring(limb_info.applied_to)) 
            end,
        ["cripple_leg"] = function()

                local limb_info = Get_LimbTable_Info()

                QueueMessage(
                tostring("cripple_limb") .. " " .. 
                tostring(GameInfo.username) .. " " ..
                tostring(limb_info.limb_modifier) .. " " ..
                tostring(button_function) .. " " ..
                tostring(limb_info.applied_to)) 
            end,
        [""] = function()
            end,

        default = function () print( "ERROR - connection_state not within switch") end,
    }
    CheckState:case(button_function)

    print("BUTTON FUNCTIONS:" .. button_function)
end