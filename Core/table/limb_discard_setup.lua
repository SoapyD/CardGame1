local discard_max = 0
local sub_action = ""

function Hide_LimbDiscardTable()
    Hide_GameTypeScreen();

    TitleText.text = ""
    GameInfo.pause_add = 0

    CheckActionPos(false)
    GameInfo.finalise_state = 1

    if (finalise_button ~= nil) then
        finalise_button.text.text = finalise_button.default_text
        check_FinalisationButton(GameInfo.current_player)
    end
end

function Show_LimbDiscardTable()
    LoadLimbDiscardCard();
    Show_GameTypeButtons();

    TitleText.text = "Discard Card to Heal Limb"
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

    local current_user = {};
    for i=1, table.getn(GameInfo.player_list) do
        if (GameInfo.username == GameInfo.player_list[i].username) then
            current_user = GameInfo.player_list[i]
        end
    end

    --HEAL ARM BUTTONS
    local colour = "red"
    if (current_user.arms == 2) then
        colour = "gray"
    end
 
    Add_GameType_Button(draw_item.card1,1,
        GameInfo.width / 2 - 250, GameInfo.height / 2 - 150,
        200,400,colour,"heal arm","discard to heal",1)

    --HEAL LEG BUTTONS
    colour = "red"
    if (current_user.legs == 2) then
        colour = "gray"
    end

    Add_GameType_Button(draw_item.card2,2,
        GameInfo.width / 2 + 250, GameInfo.height / 2 - 150,
        200,400,"red","heal leg","discard to heal",2)

    GameInfo.limb_discard_screen = draw_item
end
