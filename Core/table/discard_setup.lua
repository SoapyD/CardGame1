local discard_max = 0
local sub_action = ""

function Hide_DiscardTable()
    GameInfo.screen_elements.image.isVisible  = false
    GameInfo.discard_screen.card1.icon.isVisible  = false
    TitleText.text = ""
    GameInfo.pause_add = 0
    CheckActionPos(false)
    GameInfo.finalise_state = 1

    if (finalise_button ~= nil) then
        finalise_button.text.text = finalise_button.default_text
        check_FinalisationButton(GameInfo.current_player)
    end
end

function Show_DiscardTable(temp_sub_action)
    GameInfo.screen_elements.image.isVisible  = true
    GameInfo.discard_screen.card1.icon.isVisible  = true
    TitleText.text = "Discard Card"
    GameInfo.pause_add = 1
    sub_action = temp_sub_action
    --print(sub_action)

    if (temp_sub_action == "flurry" or 
        temp_sub_action == "heal_limb") then
        if (finalise_button ~= nil) then
            finalise_button.text.text = "end discard"
            finalise_button.isVisible = true
            finalise_button.text.isVisible = true
            GameInfo.finalise_state = 6
        end
    else
        if (discard_max ~= 0) then       
            run_popup("Discard: " .. discard_max)
        end
    end

    --if (discard_max == 0) then
        local hide = true
        for i = 1, table.getn(GameInfo.cards) do
            local hand_card = GameInfo.cards[i]
            if (hand_card.isVisible == true) then
                hide = false
            end
        end

        if (hide == true) then
            QueueMessage(
            --appWarpClient.sendUpdatePeers(
                --tostring("MSG_CODE") .. " " ..
                tostring("hide_discard") .. " " .. 
                tostring(GameInfo.username)) 
        end
   -- end
end

function CheckDiscard(current_card)

    local card_info = retrieve_card(current_card.filename)
    local discard_state = 1

    local CheckState = switch { 
        ["damage"] = function()    --DAMAGE ENEMY USING CARDS MAIN VALUE
            QueueMessage(
            --appWarpClient.sendUpdatePeers(
                --tostring("MSG_CODE") .. " " ..
                tostring("health_mod") .. " " .. 
                tostring(-card_info.power)) 
            end,
        ["armour"] = function()    --ADD ARMOUR USING CARDS MAIN VALUE
            QueueMessage(
            --appWarpClient.sendUpdatePeers(
                --tostring("MSG_CODE") .. " " ..
                tostring("armour_mod") .. " " .. 
                tostring(card_info.power)) 
            end,
        ["flurry"] = function()    --FLURRY DISCARD DAMAGE
            QueueMessage(
            --appWarpClient.sendUpdatePeers(
                --tostring("MSG_CODE") .. " " ..
                tostring("health_mod") .. " " .. 
                tostring(discard_max)) 

            run_popup(discard_max .. " Flurry Damage")
            discard_state = 2
            end,

        default = function () print( "ERROR - sub_type not within discard subtypes") end,
    }

    CheckState:case(sub_action)

    local card_available = false
    for i = 1, table.getn(GameInfo.cards) do
        local hand_card = GameInfo.cards[i]
        if (hand_card.isVisible == true) then
            card_available = true
        end
    end

    if (discard_state == 1) then
        if (discard_max <= 1 or card_available == false) then
        --    Hide_DiscardTable(false)
            QueueMessage(
            --appWarpClient.sendUpdatePeers(
                --tostring("MSG_CODE") .. " " ..
                tostring("hide_discard") .. " " .. 
                tostring(GameInfo.username)) 
        end
        discard_max = discard_max - 1
        if (discard_max ~= 0) then  
            run_popup("Discard: " .. discard_max)
        end
    end

end

function SetDiscardMax(discard_value)
    discard_max = discard_value
    --print("draw value" .. draw_max)
end

function LoadDiscardCard()
    local group = display.newGroup()
    -- width, height, x, y
    local draw_item = {}
    draw_item.card1 = {}

    AddDiscardZone(draw_item.card1,GameInfo.width / 2,GameInfo.height / 2 - 150,
        400,400,"red","discard",1);


    GameInfo.discard_screen = draw_item
    Hide_DiscardTable()
    --Show_DiscardTable()
end

function AddDiscardZone(draw_card,x,y,width,height,colour,type, type_int)

    local icon = display.newRoundedRect( 
        x, y, width, height, 1 )
            icon:setFillColor( colorsRGB.RGB(colour) )
            icon.strokeWidth = 6
            icon:setStrokeColor( 200,200,200,255 )
            
    --icon:addEventListener( "touch", DrawTempCard )
    icon.item_loaded = false
    icon.card_type = type
    icon.type_int = type_int
    icon.bbox_min_x = x - (width / 2)
    icon.bbox_max_x = x + (width / 2)
    icon.bbox_min_y = y - (height / 2)
    icon.bbox_max_y = y + (height / 2)
    draw_card.icon = icon
end