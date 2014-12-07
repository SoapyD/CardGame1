
function Check_ButtonOptions(button_function,value)
    local CheckState = switch { 
        ["connection_type"] = function()
        		set_connectiontype(value)
            end,
        [""] = function()
            end,

        default = function () print( "ERROR - connection_state not within switch") end,
    }
    CheckState:case(button_function)
end