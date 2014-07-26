

function Hide_COTable()
    GameInfo.screen_elements.image.isVisible  = false
    GameInfo.counter_screen.player1.isVisible  = false
    TitleText.text = ""
    GameInfo.pause_add = 0
    GameInfo.finalise_state = 1
    CheckActionPos(true) --NEEDS TO BE SET TO TRUE AS BOTH PLAYERS HAVE THIS TABLE LOADED

    --if (finalise_button ~= nil) then
    --    finalise_button.print_text = finalise_button.default_text
    --end
    if (finalise_button ~= nil) then
        finalise_button.text.text = finalise_button.default_text
        check_FinalisationButton(GameInfo.current_player)
    end
end

function Show_COTable()
    GameInfo.screen_elements.image.isVisible  = true
    GameInfo.counter_screen.player1.isVisible  = true
    TitleText.text = "Counter!"
    GameInfo.pause_add = 3
    GameInfo.finalise_state = 4

    --if (finalise_button ~= nil) then
    --    finalise_button.print_text = "counter"
    --end
end

function LoadCounter()
    local group = display.newGroup()
    -- width, height, x, y
    local counter_item = {}

    AddCounterZone(counter_item);
    GameInfo.counter_screen = counter_item

    Runtime:addEventListener( "enterFrame", End_Counter )

    --Show_COTable()
    Hide_COTable()
    --CURRENTLY TURNED ON IN THE NETWORKING CODE
end

function AddCounterZone(counter_item)

    counter_item.player1 = display.newRoundedRect( 
        (GameInfo.width / 2), (GameInfo.height / 2) - 100, 360,360, 1 )
            counter_item.player1:setFillColor( colorsRGB.RGB("blue") )
            counter_item.player1.strokeWidth = 6
            counter_item.player1:setStrokeColor( 200,200,200,255 )
end



function AddCounterCard(username, faceoff_card)

    if ( GameInfo.player_list ~= nil) then
        for i=1, table.getn(GameInfo.player_list) do
            if (username == GameInfo.player_list[i].username) then
                GameInfo.player_list[i].faceoff_card = faceoff_card
            end
        end
        Check_Counter_End()
    end
end

local end_counter = false
local end_state = 0

function Check_Counter_End()

    print("CHECKING COUNTER: " , GameInfo.pause_main )
    local card_count = 0 
    print("counter checked")
    if ( GameInfo.player_list ~= nil) then
        for i=1, table.getn(GameInfo.player_list) do
            if (GameInfo.player_list[i].faceoff_card ~= "") then
                card_count = card_count + 1
                print("count increased")
            end
        end

        if (card_count >= 1 and GameInfo.pause_main == true) then
            --THIS SHOULD END THINGS
            end_counter = true
            run_popup("Card Countered!")
        end

    end
end

function End_Counter()
    if (end_counter == true) then
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
                    Hide_COTable()
                    GameInfo.cards[GameInfo.faceoff_int].isVisible = false
                    end_counter = false
                    end_state = 0
                    GameInfo.pause_main = false
                    resetCounter()

                end,
            default = function () print( "ERROR - run_main_state not within counter end") end,
        }

        CheckState:case(end_state)

    end

end

function  resetCounter()
    for i=1, table.getn(GameInfo.player_list) do
        GameInfo.player_list[i].faceoff_card = ""
    end 
    GameInfo.faceoff_int = -1   
end