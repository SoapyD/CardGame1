
function Hide_VariableTable()
    GameInfo.screen_elements.image.isVisible  = false

    --GET RID OF THE BUTTON ICONS
    for i=1, table.getn(GameInfo.or_screen.buttons) do
        local button = GameInfo.or_screen.buttons[i]
        button.icon.button_text:removeSelf()
        button.icon:removeSelf()
        --button.icon.isVisible = false
    end
    --GET RID OF THE REST OF THE BUTTON INFO
    GameInfo.or_screen.buttons = {}

    TitleText.text = ""
    GameInfo.pause_main = false
    CheckActionPos(false)

    if (finalise_button ~= nil) then
        finalise_button.text.text = finalise_button.default_text
        check_FinalisationButton(GameInfo.current_player)
    end
end

function Show_VariableTable(actionlist)
    GameInfo.screen_elements.image.isVisible  = true

    for i=1, table.getn(GameInfo.or_screen.buttons) do
        local button = GameInfo.or_screen.buttons[i]
        button.icon.isVisible = true
    end

    TitleText.text = "Choose An Action"
    GameInfo.pause_main = true

    local start_y = 350

    for i=1, table.getn(actionlist) do

        local button_info = {}
        local y_pos = start_y + ((i-1) * 150)
        AddOptionButton(button_info,GameInfo.width / 2,y_pos,"red",actionlist[i],1);

        GameInfo.or_screen.buttons[table.getn(GameInfo.or_screen.buttons) + 1] = button_info
    end


    if (finalise_button ~= nil) then
        finalise_button.isVisible = false
        finalise_button.text.isVisible = false   
    end
end


function OptionButton_Presses( event )
    local t = event.target
    local phase = event.phase

    if "began" == phase then
        
        local parent = t.parent
        parent:insert( t )
        display.getCurrentStage():setFocus( t ) 
        t.isFocus = true

    elseif t.isFocus then
        if "moved" == phase then

        elseif "ended" == phase then
            display.getCurrentStage():setFocus( nil )

            --print(t.type)

            appWarpClient.sendUpdatePeers(
                tostring("MSG_CODE") .. " " ..
                tostring("add_variable_action") .. " " ..
                tostring(GameInfo.username) .. " " .. 
                tostring(t.type))

            local stage = display.getCurrentStage()
            stage:setFocus( nil )

        end
    end

    return true
end


function LoadOptions()
    local group = display.newGroup()
    -- width, height, x, y
    local draw_item = {}

    draw_item.buttons = {}

    GameInfo.or_screen = draw_item
    --Hide_VariableTable()
    --Show_VariableTable()
end

function AddOptionButton(draw_card,x,y,colour,type,type_int)

    local icon = display.newRoundedRect( 
        x, y, 400, 125, 1 )
            icon:setFillColor( colorsRGB.RGB(colour) )
            icon.strokeWidth = 6
            icon:setStrokeColor( 200,200,200,255 )

    icon:addEventListener( "touch", OptionButton_Presses )
    icon.item_loaded = false
    icon.type = type
    icon.type_int = type_int


    icon.button_text = display.newText( type, x, y, native.systemFontBold, 48 )
    statusText2:setFillColor( 0, 0, 0 )

    draw_card.icon = icon
end

function CheckVariableActions(sub_action)

    local actionlist ={}

    local CheckState = switch { 
        ["health_limb"] = function()    --
            actionlist[table.getn(actionlist) + 1] = "health"
            actionlist[table.getn(actionlist) + 1] = "limb2"
            end,
        ["damage_discard"] = function()    --
            actionlist[table.getn(actionlist) + 1] = "damage"
            actionlist[table.getn(actionlist) + 1] = "discard2"
            end,
            default = function () print("ERROR - state not within option sublist check") end,
        }

    CheckState:case(sub_action)  
    Show_VariableTable(actionlist)

end

function Add_VariableAction(username, action_type)
    local saved_action = GameInfo.actions
    local new_actions = {}
    local action_pos = Get_ActionState()

    --new_actions[1] =  saved_action[action_pos]
    local new_pos = 1
    for i = 1, table.getn(saved_action) do
        new_actions[new_pos] = saved_action[i]
        new_pos = new_pos + 1

        if (i == action_pos) then
            local val_set = false
            local CheckState = switch { 
                ["damage"] = function()    --
                    --NEEDS TO SEND "MOD_HEALTH" TO WARPLISTENER
                    new_actions[new_pos] = set_action("health_delay", "", -9, 1)
                    new_actions[new_pos].type = "health_delay"
                    val_set = true
                    end,
                ["health"] = function()    --
                    --NEEDS TO SEND "MOD_HEALTH" TO WARPLISTENER
                    new_actions[new_pos] = set_action("health_delay", "", 10, 0)
                    new_actions[new_pos].type = "health_delay"
                    val_set = true
                    end,
                ["limb2"] = function()    --
                    new_actions[new_pos] = set_action("limb", "", 2, 0)
                    new_actions[new_pos].type = "limb"
                    val_set = true
                    end,
                ["discard2"] = function()    --
                    new_actions[new_pos] = set_action("discard", "", 2, 1)
                    new_actions[new_pos].type = "discard"
                    val_set = true
                    end,
                    default = function () print("ERROR - state not within variable options") end,
            }

            CheckState:case(action_type)

            if (val_set == true) then
              new_pos = new_pos + 1    
            end           
        end
    end

    GameInfo.actions = new_actions

    if (username == GameInfo.username) then
      Hide_VariableTable()
    end
end