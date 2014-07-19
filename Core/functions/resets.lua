

local reset_state = 1

function ResetGame()

    local CheckState = switch { 
        [1] = function()
                set_MainState(1) --RESET THE STATE IN MAIN_LOOP2
                createDeck() --RESET THE DECKS

                ResetActions()
                ResetPlayers()
                ResetCards()
            end,
        [2] = function() --DEAL OUT THE HANDS, WAIT, FOR IT TO COMPLETE
                local HandsSet = SetHands()
                if (HandsSet == true) then
                  reset_state = reset_state + 1
                end
            end,
        [3] = function() --FINISH RESET/

            end,

        default = function () print( "ERROR - sub_type not within reset_state") end,
    }

    CheckState:case(reset_state)
end


function ResetActions()
    GameInfo.actions = {}
    ResetActionState()
    ResetActionInternalState()
end

function ResetPlayers()
    for i=1, table.getn(GameInfo.player_list) do
        local player = GameInfo.player_list[i]

        player = ResetPlayer(player)         
    end
end

function ResetPlayer(player)
    player.max_health = 40
    player.health = player.max_health
    player.armour = 0
    player.max_arms = 2
    player.arms = player.max_arms 
    player.max_legs = 2
    player.legs = player.max_legs 

    return player
end

function ResetCards()
    for i=1, table.getn(GameInfo.cards) do
        local card = GameInfo.cards[i]
        card:removeSelf()
    end

    GameInfo.cards = {}

    for i=1, table.getn(GameInfo.table_cards) do
        local card = GameInfo.table_cards[i]
        card:removeSelf()
        camera:remove(card)
    end

    GameInfo.table_cards = {}
    GameInfo.quads = {}

    GameInfo.current_card_int = -1
    GameInfo.previous_card_int = -1
    camera:toPoint(1750, 1750)

    Reset_SetCards_state()

    for i=1, table.getn(GameInfo.player_list) do
       	GameInfo.player_list[i].faceoff_card = ""
    end
end

function SetHands()

    local HandsSet = false

    if(GameInfo.player_list[1].username == GameInfo.username) then
        local SetupComplete = SetPlayerCards_Networked()
        if (SetupComplete == true) then
            --EndRound_state = EndRound_state + 1
            HandsSet = true
        end
    else
        if (GameInfo.switch1 == true) then
            HandsSet = true
            GameInfo.switch1 = false
            --EndRound_state = EndRound_state + 1
            SetGame()
        end
    end

    return HandsSet
end