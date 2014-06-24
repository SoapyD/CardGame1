local sub_action = ""
local sets_player = false

function Hide_FOTable()
    GameInfo.screen_elements.image.isVisible  = false
    GameInfo.faceoff_screen.player1.isVisible  = false
    GameInfo.faceoff_screen.player2.isVisible  = false
    TitleText.text = ""
    GameInfo.pause_add = 0
    GameInfo.finalise_state = 1
    
    sets_player = false

    CheckActionPos(true) --NEEDS TO BE SET TO TRUE AS BOTH PLAYERS HAVE THIS TABLE LOADED

    if (finalise_button ~= nil) then
        finalise_button.text.text = finalise_button.default_text
        check_FinalisationButton(GameInfo.current_player)
    end
end

function Show_FOTable(temp_sub_action, checks_player)
    GameInfo.screen_elements.image.isVisible  = true
    GameInfo.faceoff_screen.player1.isVisible  = true
    GameInfo.faceoff_screen.player2.isVisible  = true
    TitleText.text = "Face-Off!"
    sub_action = temp_sub_action
    GameInfo.pause_add = 2
    GameInfo.finalise_state = 2
    
    sets_player = checks_player

    --print(sub_action)
    if (finalise_button ~= nil) then
        finalise_button.text.text = "set faceoff"
        finalise_button.isVisible = true
        finalise_button.text.isVisible = true
    end
end

function LoadFaceOff()
    local group = display.newGroup()
    -- width, height, x, y
    local faceoff_item = {}

    AddPlayerZone(faceoff_item);
    GameInfo.faceoff_screen = faceoff_item

    Runtime:addEventListener( "enterFrame", End_FaceOff )

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
        --local current_player = GetPlayer()
        --current_player.faceoff_card = faceoff_card
        Check_FaceOff_End()
    end
end

local end_faceoff = false
local end_state = 0

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
                --HIGHEST STRAT WINS FACEOFF
                for n=1, table.getn(card_info.strat_scores) do
                    if ( saved_score < card_info.strat_scores[n]) then
                        saved_score = card_info.strat_scores[n]
                    end 
                end

                --CHECK TO SEE IF IT JUST WINS FACEOFF REGARDLESS
                if ( table.getn(card_info.actions) > 0) then
                    for i=1, table.getn(card_info.actions) do
                        local action = card_info.actions[i]

                        if (action.name == "win_faceoff") then
                            saved_score = 99
                            print("ALWAYS WIN FACEOFF")
                        end
                    end
                end

                --HIGHEST POWER WINS FACEOFF
                --saved_score = card_info.power
                --print("card power: " .. card_info.power)

                if (i == 1) then
                    p1_score = saved_score
                else
                    p2_score = saved_score
                end
            end
        end

        print("player1_score: " .. p1_score .. " player2_score: " .. p2_score)

        if (card_count == 2 and GameInfo.pause_main == true) then
            local end_process = false
            local winner = -1
            if (p1_score > p2_score) then
                end_process = true
                --MsgText.text = "P1 wins faceoff"
                --MsgBox.fade = 2
                run_popup("P1 wins faceoff")
                winner = 1
            end
            if (p2_score > p1_score) then
                end_process = true
                --MsgText.text = "P2 wins faceoff"
                --MsgBox.fade = 2
                run_popup("P2 wins faceoff")
                winner = 2
            end

            if (sets_player == false) then
                --THIS IS USED FOR FACEOFF ACTIONS THAT HAVE "WIN ACTIONS" ASSOCIATED WITH THEM
                if (winner == GameInfo.current_player) then

                else
                    --IF THE FACEOFF FAILS, REMOVE ALL "WIN ACTIONS" AND PASS THE TURN
                    GameInfo.actions = {}
                    ResetActionState()
                    ResetActionInternalState()
                    --THIS IS TAKEN FROM THE END TURN FUNCTION
                    local temp_mods = {}
                    temp_mods.type = "pass_turn"
                    temp_mods.sub_action = ""
                    temp_mods.applied_to = -1
                    temp_mods.value = 0

                    local arr_pos = table.getn(GameInfo.actions) + 1
                    GameInfo.actions[arr_pos] = {}
                    GameInfo.actions[arr_pos] = temp_mods
                end
            end

            local reset_faceoff = false

            if (end_process == true) then
                end_faceoff = true
                if (sets_player == true) then
                    GameInfo.current_player = winner
                    check_FinalisationButton(GameInfo.current_player)
                    print("current player is!!!: " .. GameInfo.current_player)
                    sets_player = false
                end
            end

            if (p1_score == p2_score) then
                --MsgText.text = "faceoff drawn, place down another card"
                --MsgBox.fade = 2
                run_popup("faceoff drawn, place down another card")

                GameInfo.cards[GameInfo.faceoff_int].isVisible = false
                resetFaceoff()
                GameInfo.pause_main = false
            end        
        end

    end
end

function End_FaceOff()
    if (end_faceoff == true) then
        local CheckState = switch { 
            [0] = function()
                    end_state = 1
                end,
            [1] = function()
                    if (MsgBox.msg_fade == 0 and MsgBox.fade == 0) then
                        end_state = 2
                    end
                end,
            [2] = function() 
                    Hide_FOTable()
                    GameInfo.cards[GameInfo.faceoff_int].isVisible = false
                    end_faceoff = false
                    end_state = 0
                    GameInfo.pause_main = false
                    resetFaceoff()

                end,
            default = function () print( "ERROR - run_main_state not within face_off end") end,
        }

        CheckState:case(end_state)

    end

end

function  resetFaceoff()
    for i=1, table.getn(GameInfo.player_list) do
        --GameInfo.player_list[i].faceoff_card = ""
    end
    GameInfo.faceoff_int = -1   
end