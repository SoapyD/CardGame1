--local run_main_state = 0
local action_state = 1
local action_internal_state = 0


function ResetActionState()
    action_state = 1
end
function ResetActionInternalState()
    action_internal_state = 0
end

function CheckActionState()

    --print("a_state: " .. action_state .. " a_i_state: " .. action_internal_state)

    local Action = GameInfo.actions[action_state]


    local CheckState = switch { 
        ["health_delay"] = function()    --SEND HEALTH DAMAGE THAT NEEDS STACKING

                local CheckState = switch { 
                    [0] = function()    --TURN ON THE FACEOFF SCREEN
                        appWarpClient.sendUpdatePeers(
                            tostring("health_faceoff") .. " " .. 
                            tostring(Action.value))
                        action_internal_state = 1

                        --CheckActionPos(false)
                        end,
                    [1] = function()    --
                        end,
                    default = function () print("ERROR - action_internal_state not within switch") end,
                }

                CheckState:case(action_internal_state)
            end, 

        ["power_damage"] = function()    --RUN THE DRAW LOOP
                --print("internal state" .. action_internal_state)
                local CheckState = switch { 
                    [0] = function()    --TURN ON THE FACEOFF SCREEN

                        local faceoff_card = {}

                        if ( GameInfo.player_list ~= nil) then
                            for i=1, table.getn(GameInfo.player_list) do
                                if (GameInfo.username == GameInfo.player_list[i].username) then
                                   faceoff_card =retrieve_card(GameInfo.player_list[i].faceoff_card)
                                   --print("card!!!!!!: " .. GameInfo.player_list[i].faceoff_card)
                                end
                            end
                        end   

                        --print("card: " .. faceoff_card.name .. " power: " .. faceoff_card.power)
                        if (faceoff_card ~= nil) then
                            appWarpClient.sendUpdatePeers(
                                tostring("health_faceoff") .. " " .. 
                                tostring(-faceoff_card.power))
                        end
                        action_internal_state = 1
                        end,
                    [1] = function()    --
                        end,

                    default = function () print("ERROR - action_internal_state not within switch") end,
                }

                CheckState:case(action_internal_state)
            end, 

        ["faceoff"] = function()    --RUN THE DRAW LOOP
                --print("internal state" .. action_internal_state)
                local CheckState = switch { 
                    [0] = function()    --TURN ON THE FACEOFF SCREEN
                        Show_FOTable("", false)
                        action_internal_state = 1
                        end,
                    [1] = function()    --WAIT FOR THE ACTION TO COMPLETE
                        --print( "ERROR - action_internal_state not within switch")
                        end,
                    default = function ()print("ERROR - action_internal_state not within switch")  end,
                }

                CheckState:case(action_internal_state)
            end,    
        ["draw"] = function()    --RUN THE DRAW LOOP

                local CheckState = switch { 
                    [0] = function()    --SETUP ACTION
                        --run_main_state = 1
                        action_internal_state = 1
                        SetDrawMax(Action.value)
                        end,
                    [1] = function()    --TURN ON THE DRAW CARDS SCREEN
                        Show_DrawTable()
                        action_internal_state = 2
                        end,
                    [2] = function()    --WAIT FOR THE ACTION TO COMPLETE
                        end,
                    default = function () print( "ERROR - action_internal_state not within switch") end,
                }

                CheckState:case(action_internal_state)
            end,
        ["discard"] = function()    --RUN THE DISCARD LOOP
                local CheckState = switch { 
                    [0] = function()    --SETUP ACTION
                        --run_main_state = 1
                        action_internal_state = 1
                        SetDiscardMax(Action.value)
                        end,
                    [1] = function()    --TURN ON THE DISCARD CARDS SCREEN
                        Show_DiscardTable(Action.sub_action)
                        action_internal_state = 2
                        end,
                    [2] = function()    --WAIT FOR THE ACTION TO COMPLETE
                        end,
                    default = function () print( "ERROR - action_internal_state not within switch") end,
                }

                --print("discard")
                CheckState:case(action_internal_state)

            end,
        ["limb"] = function()    --RUN THE LIMB LOOP
                local CheckState = switch { 
                    [0] = function()    --SETUP ACTION
                        --run_main_state = 1
                        action_internal_state = 1
                        SetCrippleMax(Action.value)
                        end,
                    [1] = function()    --TURN ON THE LIMB SCREEN
                        Show_LimbTable(Action.value)
                        action_internal_state = 2
                        end,
                    [2] = function()    --WAIT FOR THE ACTION TO COMPLETE
                        end,
                    default = function () print( "ERROR - action_internal_state not within switch") end,
                }

                CheckState:case(action_internal_state)

            end,
        ["steal"] = function()    --RUN THE STEAL FUNCTION
                local CheckState = switch { 
                    [0] = function()    --SETUP ACTION
                        action_internal_state = 1
                        StealCards(Action.value)
                        end,
                    [1] = function()    --TURN ON THE LIMB SCREEN
                        CheckActionPos(false)
                        end,
                    default = function () print( "ERROR - action_internal_state not within switch") end,
                }

                CheckState:case(action_internal_state)
            end,
        ["copycat"] = function()    --RUN COPYCAT
                local CheckState = switch { 
                    [0] = function()    --SETUP ACTION
                        action_internal_state = 1
                        run_popup("Select a card on the table to copy.")
                        GameInfo.finalise_state = 5 --COPYCAT FUNCTION
                        GameInfo.selected_card = {}
                        finalise_button.text.text = "Copy Card"
                        end,
                    [1] = function()    --WAIT FOR THE CARD TO BE SELECTED

                        end,
                    default = function () print( "ERROR - action_internal_state not within switch") end,
                }

                CheckState:case(action_internal_state)
            end,            
        ["shrapnel"] = function()    --RUN THE SHRAPNEL FUNCTION
                if (action_internal_state == 0) then
                    run_main_state = 0
                    action_internal_state = 1
                    InjureEnemy()
                end
            end,
        ["play"] = function()    --RUN THE PASS_TURN
                local CheckState = switch { 
                    [0] = function()    --SETUP ACTION
                        run_popup("Play Another Card.")
                        action_internal_state = 1
                        end,
                    [1] = function()    --WAIT FOR THE ACTION TO COMPLETE
                        CheckActionPos(true) --DONE THIS WAS AS BOTH PLAYERS RUN THIS FUNCTION AT THE SAME TIME AS IT'S -1
                        end,
                    default = function () print( "ERROR - action_internal_state not within switch") end,
                }

                CheckState:case(action_internal_state)
            end,
        ["pass_turn"] = function()    --RUN THE PASS_TURN
                local CheckState = switch { 
                    [0] = function()    --SETUP ACTION
                        action_internal_state = 1
                        end,
                    [1] = function()    --PASS THE TURN
                        PassTurn()
                        action_internal_state = 2
                        end,
                    [2] = function()    --WAIT FOR THE ACTION TO COMPLETE
                        CheckActionPos(true) --DONE THIS WAS AS BOTH PLAYERS RUN THIS FUNCTION AT THE SAME TIME AS IT'S -1
                        end,
                    default = function () print( "ERROR - action_internal_state not within switch") end,
                }

                CheckState:case(action_internal_state)
            end,
        ["end_round"] = function()    --RUN THE END_ROUND

                local CheckState = switch { 
                    [0] = function()    --SETUP ACTION
                        action_internal_state = 1
                        end,
                    [1] = function()    --TURN ON THE DISCARD CARDS SCREEN
                        EndRound()
                        end,
                    [2] = function()    --WAIT FOR THE ACTION TO COMPLETE
                        end,
                    default = function () print( "ERROR - action_internal_state not within switch") end,
                }
                CheckState:case(action_internal_state)                
            end,

        ["strat_alter"] = function()    --STRAT_ALTER
                --print("strat altered action is running")
                CheckActionPos(false)
            end,            
        default = function () print( "ERROR - GameInfo Action not within switch") end,
    }

    if (table.getn(GameInfo.actions) > 0 ) then
        --print("applied to" .. GameInfo.actions[action_state].applied_to)
    	if (GameInfo.actions[action_state].applied_to == 0 and
            GameInfo.username == GameInfo.player_list[GameInfo.current_player].username) then
    	   CheckState:case(GameInfo.actions[action_state].type)
        end
    end
    if (table.getn(GameInfo.actions) > 0 ) then
        if (GameInfo.actions[action_state].applied_to == 1 and
            GameInfo.username ~= GameInfo.player_list[GameInfo.current_player].username) then
            CheckState:case(GameInfo.actions[action_state].type)
        end
    end
    if (table.getn(GameInfo.actions) > 0 ) then
        if (GameInfo.actions[action_state].applied_to == -1) then
            --print("-1 used")
           CheckState:case(GameInfo.actions[action_state].type)
        end
	end
end

function CheckActionPos(network_used)
    local list_size = table.getn(GameInfo.actions)

    if (list_size > 0) then
        --print("action list size:" .. list_size .. " action_state:" .. action_state)
        if (action_state < list_size) then
            action_state = action_state + 1
        else
            GameInfo.actions = {}
            ResetActionState()
            ResetActionInternalState()
        end

        --print("action list size:" .. list_size .. " action_state:" .. action_state .. " action_internal_state: " .. action_internal_state)

        if ( network_used == false) then
            appWarpClient.sendUpdatePeers(
            tostring("advance_actions") .. " " .. 
            tostring(GameInfo.username)) 
        end

        ResetActionInternalState()
        --check_FinalisationButton(GameInfo.current_player)
    end
    --print("NEW ACTION POS: " .. action_state)
end