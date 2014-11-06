
function Hide_GameTypeScreen()

    GameInfo.screen_elements.image.isVisible  = false

    --GET RID OF THE BUTTON ICONS
    GameInfo.gametype_screen.buttons = Kill_Button(GameInfo.gametype_screen.buttons)

    TitleText.text = ""
    GameInfo.pause_main = false

    if (finalise_button ~= nil) then
        finalise_button.text.text = finalise_button.default_text
        check_FinalisationButton(GameInfo.current_player)
    end

    GameInfo.gamestate = GameInfo.gamestate + 1
end

--function Kill_Button(buttons)
--    for i=1, table.getn(buttons) do
--        local button = buttons[i]
--        button.icon.button_text:removeSelf()
--        button.icon:removeSelf()
--    end
    --GET RID OF THE REST OF THE BUTTON INFO
--    buttons = {}

--    return buttons;
--end


function Show_GameTypeScreen()
    GameInfo.screen_elements.image.isVisible  = true

    for i=1, table.getn(GameInfo.gametype_screen.player_info) do
        local button = GameInfo.gametype_screen.player_info[i]
        button.icon.isVisible = true
    end
    for i=1, table.getn(GameInfo.gametype_screen.buttons) do
        local button = GameInfo.gametype_screen.buttons[i]
        button.icon.isVisible = true
    end

    TitleText.text = "Select Game Type"
    --GameInfo.gamestate = GameInfo.gamestate + 1

    for i=1, 1 do

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
        Add_GameType_Button(button_info,x_pos,y_pos,400,125,"white",button_name,1);
        button_info.ID = i
        button_info.icon:addEventListener( "touch", GameType_Presses )
        GameInfo.gametype_screen.buttons[table.getn(GameInfo.gametype_screen.buttons) + 1] = button_info
    end

    if (finalise_button ~= nil) then
        finalise_button.isVisible = false
        finalise_button.text.isVisible = false   
    end
end


function Load_GameTypeScreen()
    local group = display.newGroup()
    -- width, height, x, y
    local draw_item = {}

    draw_item.player_info = {}
    draw_item.buttons = {}

    GameInfo.gametype_screen = draw_item
    --Hide_VariableTable()
    --Show_CharacterScreen()
end

function Add_GameType_Button(draw_card,x,y,width,height,colour,type,type_int)

    local icon = display.newRoundedRect( 
        x, y, width, height, 1 )
            icon:setFillColor( colorsRGB.RGB(colour) )
            icon.strokeWidth = 6
            icon:setStrokeColor( 200,200,200,255 )

    icon.item_loaded = false
    icon.type = type
    icon.type_int = type_int


    icon.button_text = display.newText( type, x, y, native.systemFontBold, 48 )
    icon.button_text:setFillColor( colorsRGB.RGB("black") )
    icon.button_text.text = type

    draw_card.icon = icon
end

function GameType_Presses( event )
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

            --QueueMessage(
            --tostring("set_character") .. " " ..
            --tostring(GameInfo.username) .. " " .. 
            --tostring(t.type)) 
            --
            Hide_GameTypeScreen()
            --print("PRESSED")

            local stage = display.getCurrentStage()
            stage:setFocus( nil )
            t.button_text:toFront()
        end
    end

    return true
end