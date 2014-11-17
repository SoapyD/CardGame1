

function Hide_CharacterScreen()

    GameInfo.screen_elements.image.isVisible  = false

    --GET RID OF THE BUTTON ICONS
    GameInfo.character_screen.player_info = Kill_Button(GameInfo.character_screen.player_info)
    GameInfo.character_screen.buttons = Kill_Button(GameInfo.character_screen.buttons)

    TitleText.text = ""
    GameInfo.pause_main = false
    --CheckActionPos(false)

    if (finalise_button ~= nil) then
        finalise_button.text.text = finalise_button.default_text
        check_FinalisationButton(GameInfo.current_player)
    end
end

function Kill_Button(buttons)
    for i=1, table.getn(buttons) do
        local button = buttons[i]
        button.icon.button_text:removeSelf()
        button.icon:removeSelf()
        --button.icon.isVisible = false
    end
    --GET RID OF THE REST OF THE BUTTON INFO
    buttons = {}

    return buttons;
end


function Show_CharacterScreen()
    GameInfo.screen_elements.image.isVisible  = true

    for i=1, table.getn(GameInfo.character_screen.player_info) do
        local button = GameInfo.character_screen.player_info[i]
        button.icon.isVisible = true
    end
    for i=1, table.getn(GameInfo.character_screen.buttons) do
        local button = GameInfo.character_screen.buttons[i]
        button.icon.isVisible = true
    end

    TitleText.text = "Select Character"
    --SELECTED CHARACTERS
    for i=1, 2 do

        local selected_info = {}
        local x_pos = (GameInfo.width / 2)
        local y_pos = 300 + ((i-1) * 125)
        Add_Screen_Button(selected_info,x_pos,y_pos,300,100,"white","",1);

        --selected_info.icon:addEventListener( "touch", CharacterButton_Presses )
        GameInfo.character_screen.player_info[table.getn(GameInfo.character_screen.player_info) + 1] = selected_info
    end


    --THESE ARE THE CHARACTER BUTTONS

    local start_y = 550
    local characters = Get_CharacterList()
    local id = 1

    for x=1, 2 do
        for y=1, 6 do

            local button_info = {}
            local x_pos = (GameInfo.width / 2) - 175 + ((x-1) * 350)
            local y_pos = start_y + ((y-1) * 125)
            Add_Screen_Button(button_info,x_pos,y_pos,300,100, "red",characters[id],1);

            button_info.icon:addEventListener( "touch", CharacterButton_Presses )
            GameInfo.character_screen.buttons[table.getn(GameInfo.character_screen.buttons) + 1] = button_info
            id = id + 1
        end
    end


    if (finalise_button ~= nil) then
        finalise_button.isVisible = false
        finalise_button.text.isVisible = false   
    end
end


function Load_CharacterScreen()
    local group = display.newGroup()
    -- width, height, x, y
    local draw_item = {}

    draw_item.player_info = {}
    draw_item.buttons = {}

    GameInfo.character_screen = draw_item
    --Hide_VariableTable()
    --Show_CharacterScreen()
end

function Add_Screen_Button(draw_card,x,y,width,height,colour,type,type_int)

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

function CharacterButton_Presses( event )
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
            --for i = 1, table.getn(GameInfo.player_list) do
            --    local player = GameInfo.player_list[i]
            --    if (player.username == GameInfo.username) then
            --        player.character_info = CheckCharacter(t.type)
                    --run_popup(t.type .. " SELECTED")
            --        GameInfo.character_screen.player_info[i].icon.button_text.text = t.type
            --    end
            --end

            QueueMessage(
         --appWarpClient.sendUpdatePeers(
            --tostring("MSG_CODE") .. " " ..
            tostring("set_character") .. " " ..
            tostring(GameInfo.username) .. " " .. 
            tostring(t.type)) 

            local stage = display.getCurrentStage()
            stage:setFocus( nil )
            t.button_text:toFront()
        end
    end

    return true
end