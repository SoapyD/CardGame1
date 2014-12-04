

function Show_GameTypeScreen()

    TitleText.text = "Select Game Type"

    for i=1, 2 do

            local button_name = ""

            local CheckState = switch { 
                [1] = function()    --
                    button_name = "Quick Match"
                    end,
                [2] = function()    --
                    button_name = "Find Match"
                    end,
                [3] = function()    --
                    button_name = "Create Match"
                    end,
                [4] = function()    --
                    button_name = "Single Player"
                    end,
                    default = function () print("ERROR - state not within variable options") end,
            }

            CheckState:case(i)


        local button_info = {}
        local x_pos = (GameInfo.width / 2)
        local y_pos = 350 + ((i-1) * 150)
        local button_width = 400
        local button_height = 125

        Add_GameType_Button(button_info,i,x_pos,y_pos,button_width,button_height,"white",button_name,1);
    end

    Show_GameTypeButtons()
    set_ButtonFunctions("connection_type")
end