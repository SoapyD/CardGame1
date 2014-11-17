local discard_max = 0
local sub_action = ""

function Hide_LimbDiscardTable()
    GameInfo.screen_elements.image.isVisible  = false
    GameInfo.limb_discard_screen.card1.icon.isVisible  = false
    GameInfo.limb_discard_screen.card2.icon.isVisible  = false
    TitleText.text = ""
    GameInfo.pause_add = 0
    --print("HIDING TABLE!!!!!!")
    CheckActionPos(false)
    GameInfo.finalise_state = 1

    if (finalise_button ~= nil) then
        finalise_button.text.text = finalise_button.default_text
        check_FinalisationButton(GameInfo.current_player)
    end
end

function Show_LimbDiscardTable()
    GameInfo.screen_elements.image.isVisible  = true
    GameInfo.limb_discard_screen.card1.icon.isVisible  = true
    GameInfo.limb_discard_screen.card2.icon.isVisible  = true
    TitleText.text = "Limb Discard Card"
    GameInfo.pause_add = 4

    finalise_button.text.text = "end discard\nto heal"
    finalise_button.isVisible = true
    finalise_button.text.isVisible = true
    GameInfo.finalise_state = 8

end

function CheckLimbDiscard(current_card, heal_type)

    --ADD A LIMB TO THE CURRENT USER THEN HIDE THE TABLE
    local against = 1 --DONATES THE OTHER PLAYER

    if (GameInfo.player_list[GameInfo.current_player].username == 
        GameInfo.username) then
        against = 0 --DIRECT AT THE CURRENT PLAYER
    end

    QueueMessage(
    --appWarpClient.sendUpdatePeers(
    --tostring("MSG_CODE") .. " " ..
    tostring("limb_discard") .. " " .. 
    tostring(GameInfo.username) .. " " ..
    tostring(1) .. " " ..
    tostring(heal_type) .. " " .. 
    tostring(against))
end


function LoadLimbDiscardCard()
    local group = display.newGroup()
    -- width, height, x, y
    local draw_item = {}
    draw_item.card1 = {}
    draw_item.card2 = {}

    AddDiscardZone(draw_item.card1,GameInfo.width / 2 - 250,GameInfo.height / 2 - 150,
        200,400,"red","discard",1);

    AddDiscardZone(draw_item.card2,GameInfo.width / 2 + 250,GameInfo.height / 2 - 150,
        200,400,"red","discard",1);

    GameInfo.limb_discard_screen = draw_item
    Hide_LimbDiscardTable()
    --Show_LimbDiscardTable()
end
