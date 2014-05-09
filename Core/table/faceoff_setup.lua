local sub_action = ""

function Hide_FOTable()
    GameInfo.screen_elements.image.isVisible  = false
    GameInfo.faceoff_screen.player1.isVisible  = false
    GameInfo.faceoff_screen.player2.isVisible  = false
    TitleText.text = ""
    GameInfo.pause_add = 0
    GameInfo.finalise_state = 1
    CheckActionPos(false)

    if (finalise_button ~= nil) then
        if ( GameInfo.username ~= GameInfo.player_list[GameInfo.current_player].username) then
            finalise_button.isVisible = false
        end
    end
end

function Show_FOTable(temp_sub_action)
    GameInfo.screen_elements.image.isVisible  = true
    GameInfo.faceoff_screen.player1.isVisible  = true
    GameInfo.faceoff_screen.player2.isVisible  = true
    TitleText.text = "Face-Off!"
    sub_action = temp_sub_action
    GameInfo.pause_add = 2
    GameInfo.finalise_state = 2

    --print(sub_action)
    if (finalise_button ~= nil) then
        finalise_button.isVisible = true
    end
end

function LoadFaceOff()
    local group = display.newGroup()
    -- width, height, x, y
    local faceoff_item = {}

    AddPlayerZone(faceoff_item);
    GameInfo.faceoff_screen = faceoff_item

    --Show_FOTable()
    Hide_FOTable()
    --CURRENTLY TURNED ON IN THE NETWORKING CODE
end

function AddPlayerZone(faceoff_item)

    faceoff_item.player1 = display.newRoundedRect( 
        (GameInfo.width / 2) - 200, (GameInfo.height / 2) - 100, 360,360, 1 )
            faceoff_item.player1:setFillColor( colorsRGB.RGB("red") )
            faceoff_item.player1.strokeWidth = 6
            faceoff_item.player1:setStrokeColor( 200,200,200,255 )

    faceoff_item.player2 = display.newRoundedRect( 
        (GameInfo.width / 2) + 200, (GameInfo.height / 2) - 100, 360, 360, 1 )
            faceoff_item.player2:setFillColor( colorsRGB.RGB("blue") )
            faceoff_item.player2.strokeWidth = 6
            faceoff_item.player2:setStrokeColor( 200,200,200,255 )
end



function AddFaceOffCard(username, faceoff_card)

    if ( GameInfo.player_list ~= nil) then
        for i=1, table.getn(GameInfo.player_list) do
            if (username == GameInfo.player_list[i].username) then
                GameInfo.player_list[i].faceoff_card = faceoff_card
            end
        end
        Check_FaceOff_End()
    end
end

function Check_FaceOff_End()

    local card_count = 0 
    local p1_score = 0
    local p2_score = 0

    if ( GameInfo.player_list ~= nil) then
        for i=1, table.getn(GameInfo.player_list) do
            if (GameInfo.player_list[i].faceoff_card ~= "") then
                card_count = card_count + 1
                local card_info = retrieve_card(GameInfo.player_list[i].faceoff_card)

                local saved_score = 0
                for n=1, table.getn(card_info.strat_scores) do
                    if ( saved_score < card_info.strat_scores[n]) then
                        saved_score = card_info.strat_scores[n]
                    end 
                end

                if (i == 1) then
                    p1_score = saved_score
                else
                    p2_score = saved_score
                end
            end
        end

        print("player1_score: " .. p1_score .. " player2_score: " .. p2_score)

        if (card_count == 2) then
            local end_faceoff = false
            if (p1_score > p2_score) then
                end_faceoff = true
                print("P1 wins faceoff")
            end
            if (p2_score > p1_score) then
                end_faceoff = true
                print("P2 wins faceoff")
            end

            local reset_faceoff = false

            if (end_faceoff == true) then
                Hide_FOTable()
                GameInfo.cards[GameInfo.faceoff_int].isVisible = false
                reset_faceoff = true
            end

            if (p1_score == p2_score) then
                print("faceoff drawn, place down another card")
                GameInfo.cards[GameInfo.faceoff_int].isVisible = false
                GameInfo.pause_main = false
                reset_faceoff = true
            end        

            if (reset_faceoff == true) then
                for i=1, table.getn(GameInfo.player_list) do
                    GameInfo.player_list[i].faceoff_card = ""
                end
                GameInfo.faceoff_int = -1
            end
        end

    end
end