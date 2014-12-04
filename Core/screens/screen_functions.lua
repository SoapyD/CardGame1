function Load_GameTypeScreen()
    local group = display.newGroup()
    -- width, height, x, y
    local draw_item = {}

    draw_item.player_info = {}
    draw_item.buttons = {}

    GameInfo.gametype_screen = draw_item
end

function Show_GameTypeButtons()
    GameInfo.screen_elements.image.isVisible  = true

    for i=1, table.getn(GameInfo.gametype_screen.buttons) do
        local button = GameInfo.gametype_screen.buttons[i]
        button.icon.isVisible = true
    end

    if (finalise_button ~= nil) then
        finalise_button.isVisible = false
        finalise_button.text.isVisible = false   
    end
end

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

function Add_GameType_Button(button_info,ID,x,y,width,height,colour,type,type_int)

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

    button_info.icon = icon

    button_info.ID = ID
    button_info.icon:addEventListener( "touch", GameType_Presses )
    GameInfo.gametype_screen.buttons[table.getn(GameInfo.gametype_screen.buttons) + 1] = button_info
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

            Hide_GameTypeScreen()

            Check_ButtonOptions(t.button_text.text)

            local stage = display.getCurrentStage()
            stage:setFocus( nil )
            t.button_text:toFront()
        end
    end

    return true
end