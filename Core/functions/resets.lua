

local reset_state = 1
local reset_counter = 0

function ResetGame()

    --print("RESET STATE: " .. reset_state)

    local CheckState = switch { 
        --[0] = function()
        --    end,

        [1] = function()
                ResetAllTables()
                Show_EndTable()
                reset_state = reset_state + 1
            end,
        [2] = function()
                --print("RESETTING GAME")
                --clear_popup()
                set_MainState(1) --RESET THE STATE IN MAIN_LOOP2
                createDeck() --RESET THE DECKS

                ResetActions()
                ResetPlayers()
                ResetCards()
                Reset_MessageNum() --LOCATED IN NETWORK_QUEUE
                reset_state = reset_state + 1
            end,
        [3] = function() --DEAL OUT THE HANDS, WAIT, FOR IT TO COMPLETE
                --print("BEING USED")
                local HandsSet = SetHands()
                if (HandsSet == true) then
                    --print("HAND RESET FINISHED")
                    run_card_loop()
                    reset_state = reset_state + 1
                end
            end,
        [4] = function() --SET TIMER
                reset_counter = 3 * 60
                reset_state = reset_state + 1
            end,
        [5] = function() --SET TIMER
                reset_counter = reset_counter - 1

                if (reset_counter <= 0) then
                    reset_state = reset_state + 1
                end
            end,
        [6] = function() --FINISH RESET/
            --print("resetting finish")
            Reset_DeathCheck()
            Hide_EndTable()
            reset_state = 1
            end,

        default = function () print( "ERROR - sub_type not within reset_state") end,
    }

    CheckState:case(reset_state)
end

function Reset_DeathCheck()
    GameInfo.end_game = false
    GameInfo.winner = -1
    GameInfo.loser = -1
end

function ResetAllTables()
    Hide_COTable()
    Hide_DiscardTable()
    Hide_DrawTable()
    Hide_FOTable()
    Hide_LimbTable()
    Hide_VariableTable()
end


function ResetActions()
    GameInfo.actions = {}
    ResetActionState()
    ResetActionInternalState()
end

function ResetPlayers()
    for i=1, table.getn(GameInfo.player_list) do
        local player = GameInfo.player_list[i]

        player = ResetPlayer(player, player.username)
        player.character_info = CheckCharacter(GameInfo.selected_character)
        --print("player: " .. player.username .. " life: " .. player.health)       
    end
end

function ResetPlayer(player, username)
    player.username = username
    player.character_name = ""
    player.character_info = CheckCharacter("test")
    player.faceoff_card = ""

    player.max_health = 40
    player.health = player.max_health
    player.armour = 30
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

    --print("current player: " .. GameInfo.player_list[GameInfo.current_player].username
    --    .. " first pos: " .. GameInfo.player_list[1].username)

    --if(GameInfo.player_list[1].username == GameInfo.username) then
    if(GameInfo.player_list[GameInfo.current_player].username == GameInfo.username) then
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

function  resetFaceoff()
    for i=1, table.getn(GameInfo.player_list) do
        GameInfo.player_list[i].faceoff_card = ""
    end
    GameInfo.faceoff_int = -1   
end