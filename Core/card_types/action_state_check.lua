--local run_main_state = 0
local action_state = 1
local action_internal_state = 0
local action_timer = 0

local animation_state = 1
local network_used = false
local animation_timer = 0

function ResetActionState()
    action_state = 1
end
function ResetActionInternalState()
    action_internal_state = 0
end

function AdanceActionInternalState()
    action_internal_state = action_internal_state + 1
end


function Get_ActionState()
    return action_state
end

function Get_ActionInternalState()
    return action_internal_state
end

function Get_ActionTimer()
    return action_timer
end
function Set_ActionTimer(value)
    action_timer = value
end

function CheckActionState()

    --print("a_state: " .. action_state .. " a_i_state: " .. action_internal_state)

    local Action = GameInfo.actions[action_state]


    local CheckState = switch { 
        ["save_card"] = function()    --RUN COPYCAT
                local CheckState = switch { 
                    [0] = function()    --SETUP ACTION
                        action_internal_state = 1
                        run_popup("Select a card on the table to copy.")
                        GameInfo.finalise_state = 7 --SAVE CARD FUNCTION
                        GameInfo.selected_card = {}
                        finalise_button.text.text = "Save Card"
                        end,
                    [1] = function()    --WAIT FOR THE CARD TO BE SELECTED

                        end,
                    default = function () print( "ERROR - action_internal_state not within switch") end,
                }

                CheckState:case(action_internal_state)
            end, 
        ["or_action"] = function()    --SEND HEALTH DAMAGE THAT NEEDS STACKING

                local CheckState = switch { 
                    [0] = function()    --
                        CheckVariableActions(Action.sub_action)

                        action_internal_state = action_internal_state + 1
                        end,
                    [1] = function()    --WAIT FOR A BUTTON TO BE PRESSED
                        end,
                    default = function () print("ERROR - action_internal_state not within switch") end,
                }

                CheckState:case(action_internal_state)
            end, 

        ["next_round"] = function()    --SAVE ACTIONS THAT NEEDS PLAYING NEXT TURN

                local CheckState = switch { 
                    [0] = function()    --
                        GameInfo.saved_actions[table.getn(GameInfo.saved_actions) + 1] = Action.sub_action
                        --print("action added!!!!!!!!:  " .. Action.sub_action)
                        action_internal_state = action_internal_state + 1
                        end,
                    [1] = function()    --
                        CheckActionPos(true) --BOTH PLAYERS USE THIS ACTION SO DOESNT NEED PASSING
                        end,
                    default = function () print("ERROR - action_internal_state not within switch") end,
                }

                CheckState:case(action_internal_state)
            end, 

        ["armour"] = function()    --SEND HEALTH DAMAGE THAT NEEDS STACKING

                local CheckState = switch { 
                    [0] = function()    --TURN ON THE FACEOFF SCREEN
                        --print("ARMOUR BEING MODDED " .. Action.value)
                        
                        QueueMessage(
                        --appWarpClient.sendUpdatePeers(
                            --tostring("MSG_CODE") .. " " ..
                            tostring("armour_delay") .. " " .. 
                            tostring(Action.value) .. " " ..
                            tostring(Action.applied_to) .. " " ..
                            tostring("yes"))
                        action_internal_state = 1
                        end,
                    [1] = function()    --ENDS IN WARPLISTENER, OVER THE NETWORK
                        --print("HEALTH DELAY ENDSs")
                        end,
                    default = function () print("ERROR - action_internal_state not within switch") end,
                }

                CheckState:case(action_internal_state)
            end,

        ["life"] = function()    --SEND HEALTH DAMAGE THAT NEEDS STACKING

                local CheckState = switch { 
                    [0] = function()    --TURN ON THE FACEOFF SCREEN
                        --print("LIFE DAMAGE BEING INFLICTED " .. Action.value)
                        
                        QueueMessage(
                        --appWarpClient.sendUpdatePeers(
                            --tostring("MSG_CODE") .. " " ..
                            tostring("life_delay") .. " " .. 
                            tostring(Action.value) .. " " ..
                            tostring(Action.applied_to) .. " " ..
                            tostring("yes"))
                        action_internal_state = 1
                        end,
                    [1] = function()    --ENDS IN WARPLISTENER, OVER THE NETWORK
                        --print("HEALTH DELAY ENDSs")
                        end,
                    default = function () print("ERROR - action_internal_state not within switch") end,
                }

                CheckState:case(action_internal_state)
            end,

        ["health"] = function()    --SEND HEALTH DAMAGE THAT NEEDS STACKING

                local CheckState = switch { 
                    [0] = function()    --TURN ON THE FACEOFF SCREEN
                        --print("DAMAGE BEING INFLICTED " .. Action.value)
                        
                        QueueMessage(
                        --appWarpClient.sendUpdatePeers(
                            --tostring("MSG_CODE") .. " " ..
                            tostring("health_delay") .. " " .. 
                            tostring(Action.value) .. " " ..
                            tostring(Action.applied_to) .. " " ..
                            tostring("yes").. " " ..
                            tostring("no"))
                        action_internal_state = 1
                        end,
                    [1] = function()    --ENDS IN WARPLISTENER, OVER THE NETWORK
                        --print("HEALTH DELAY ENDSs")
                        end,
                    default = function () print("ERROR - action_internal_state not within switch") end,
                }

                CheckState:case(action_internal_state)
            end, 

        ["arm"] = function()    --SEND HEALTH DAMAGE THAT NEEDS STACKING

                local CheckState = switch { 
                    [0] = function()    --TURN ON THE FACEOFF SCREEN
                        --print("ARM BEING INFLICTED " .. Action.value)
                        
                        QueueMessage(
                            tostring("arm_delay") .. " " .. 
                            tostring(Action.value) .. " " ..
                            tostring(Action.applied_to) .. " " ..
                            tostring("yes"))
                        action_internal_state = 1
                        end,
                    [1] = function()    --ENDS IN WARPLISTENER, OVER THE NETWORK
                        --print("HEALTH DELAY ENDSs")
                        end,
                    default = function () print("ERROR - action_internal_state not within switch") end,
                }

                CheckState:case(action_internal_state)
            end, 

        ["leg"] = function()    --SEND HEALTH DAMAGE THAT NEEDS STACKING

                local CheckState = switch { 
                    [0] = function()    --TURN ON THE FACEOFF SCREEN
                        --print("LEG BEING INFLICTED " .. Action.value)
                        
                        QueueMessage(
                        --appWarpClient.sendUpdatePeers(
                            --tostring("MSG_CODE") .. " " ..
                            tostring("leg_delay") .. " " .. 
                            tostring(Action.value) .. " " ..
                            tostring(Action.applied_to) .. " " ..
                            tostring("yes"))
                        action_internal_state = 1
                        end,
                    [1] = function()    --ENDS IN WARPLISTENER, OVER THE NETWORK
                        --print("HEALTH DELAY ENDSs")
                        end,
                    default = function () print("ERROR - action_internal_state not within switch") end,
                }

                CheckState:case(action_internal_state)
            end, 

        ["health_delay"] = function()    --SEND HEALTH DAMAGE THAT NEEDS STACKING

                local CheckState = switch { 
                    [0] = function()    --TURN ON THE FACEOFF SCREEN
                        --print("health value: " .. Action.value)
                        
                        QueueMessage(
                        --appWarpClient.sendUpdatePeers(
                            --tostring("MSG_CODE") .. " " ..
                            tostring("health_delay") .. " " .. 
                            tostring(Action.value) .. " " ..
                            tostring(Action.applied_to) .. " " ..
                            tostring("yes").. " " ..
                            tostring("no"))
                        action_internal_state = 1
                        end,
                    [1] = function()    --ENDS IN WARPLISTENER, OVER THE NETWORK
                        --print("HEALTH DELAY ENDSs")
                        end,
                    default = function () print("ERROR - action_internal_state not within switch") end,
                }

                CheckState:case(action_internal_state)
            end, 

        ["power_damage"] = function()    --RUN THE DRAW LOOP
                --print("internal state" .. action_internal_state)
                local CheckState = switch { 
                    [0] = function()    --TURN ON THE FACEOFF SCREEN

                        --local faceoff_card = {}

                        --if ( GameInfo.player_list ~= nil) then
                        --    for i=1, table.getn(GameInfo.player_list) do
                        --        if (GameInfo.username == GameInfo.player_list[i].username) then
                        --           faceoff_card =retrieve_card(GameInfo.player_list[i].faceoff_card)
                                   --print("card!!!!!!: " .. GameInfo.player_list[i].faceoff_card)
                        --        end
                        --    end
                        --end   

                        --print("card: " .. faceoff_card.name .. " power: " .. faceoff_card.power)
                        --if (faceoff_card ~= nil) then
                            
                            QueueMessage(
                            --appWarpClient.sendUpdatePeers(
                                --tostring("MSG_CODE") .. " " ..
                                tostring("health_delay") .. " " .. 
                                --tostring(-faceoff_card.power) .. " " ..
                                tostring(-GameInfo.power_damage) .. " " ..
                                tostring(1) .. " " ..
                                tostring("yes").. " " ..
                                tostring("no"))
                        --end

                        GameInfo.power_damage = 0
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
        ["limb_discard"] = function()    --RUN THE DISCARD LOOP
                local CheckState = switch { 
                    [0] = function()    --SETUP ACTION
                        --run_main_state = 1
                        action_internal_state = 1
                        end,
                    [1] = function()    --TURN ON THE DISCARD CARDS SCREEN
                        Show_LimbDiscardTable()
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
                        --reset_DoubleDamage()
                        action_internal_state = 1
                        RoundCheck()
                        end,
                    [1] = function()    --WAIT FOR THE ACTION TO COMPLETE
                        CheckActionPos(false) --DONE THIS WAS AS BOTH PLAYERS RUN THIS FUNCTION AT THE SAME TIME AS IT'S -1
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
                        reset_DoubleDamage()
                        RoundCheck()
                        action_internal_state = 2
                        end,
                    [2] = function()    --WAIT FOR THE ACTION TO COMPLETE
                        print("PASSING TURN")
                        CheckActionPos(true) --DONE THIS WAS AS BOTH PLAYERS RUN THIS FUNCTION AT THE SAME TIME AS IT'S -1
                        end,
                    default = function () print( "ERROR - action_internal_state not within switch") end,
                }

                CheckState:case(action_internal_state)
            end,
        ["end_round"] = function()    --RUN THE END_ROUND
                --print("end: " .. action_internal_state)
                local CheckState = switch { 
                    [0] = function()    --SETUP ACTION
                            action_timer = 60 * 3
                            run_popup("Ending Round")
                            AdanceActionInternalState()
                            Set_EndSet(0)
                        end,

                    [1] = function()    --SETUP ACTION
                            if (action_timer > 0) then
                                action_timer = action_timer - 1
                            else
                                action_timer = 0
                                AdanceActionInternalState()
                            end
                        end,

                    [2] = function()    --SETUP ACTION

                        --THIS SHOULD ACTUALLY BE A PASS IN THE END ROUND CHECK
                        
                        if (GameInfo.username == GameInfo.player_list[GameInfo.current_player].username) then
                            local last_card = GameInfo.table_cards[GameInfo.current_card_int]
                            local card_info = retrieve_card(last_card.filename)

                            QueueMessage(
                                --appWarpClient.sendUpdatePeers(
                                --tostring("MSG_CODE") .. " " ..
                                tostring("health_delay") .. " " .. 
                                tostring(-card_info.power) .. " " ..
                                tostring(1) .. " " ..
                                tostring("no").. " " ..
                                tostring("yes"))
                        end

                        AdanceActionInternalState()
                        end,
                    [3] = function()    --WAIT FOR THE HEALTH DELAY TO BE REGISTERED
                            --NEEDS TO BE A PAUSE HERE WHERE BOTH PLAYERS DON'T ADVANCE UNTIL THEY'RE BOTH ON THIS SPOT

                            local count = 0
                            for i=1, table.getn(GameInfo.player_list) do
                                if (GameInfo.player_list[i].temp_trigger == true) then  
                                    count = count + 1
                                end
                            end
                            if(count >= 2) then
                                AdanceActionInternalState()
                                for i=1, table.getn(GameInfo.player_list) do
                                    GameInfo.player_list[i].temp_trigger = false  
                                end 
                            end
                        end,
                    [4] = function()
                            action_timer = 60 * 3
                            AdanceActionInternalState()
                        end,
                    [5] = function()
                            if (action_timer > 0) then
                                action_timer = action_timer - 1
                            else
                                action_timer = 0
                                AdanceActionInternalState()
                            end
                        end,
                    [6] = function()    --TURN ON THE DISCARD CARDS SCREEN
                        --print("ENDING ROUND")
                        --THIS IS BEING TRIGGERED TO EARLY IF THERE'S A NETWORK DELAY
                        EndRound()
                        reset_DoubleDamage()
                        end,
                    [7] = function()    --WAIT FOR THE ACTION TO COMPLETE
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


    local Check_Animation = switch { 

        [1] = function (x) --CHECK THE ACTION STATE AGAINST THE ACTION LIST
                if (table.getn(GameInfo.actions) > 0 and GameInfo.end_game == false and GameInfo.end_round == false) then
                    --print("applied to" .. GameInfo.actions[action_state].applied_to)
                    if (GameInfo.actions[action_state].applied_to == 0 and
                        GameInfo.username == GameInfo.player_list[GameInfo.current_player].username) then
                       CheckState:case(GameInfo.actions[action_state].type)
                    end
                end
                if (table.getn(GameInfo.actions) > 0 and GameInfo.end_game == false and GameInfo.end_round == false) then
                    if (GameInfo.actions[action_state].applied_to == 1 and
                        GameInfo.username ~= GameInfo.player_list[GameInfo.current_player].username) then
                        CheckState:case(GameInfo.actions[action_state].type)
                    end
                end
                if (table.getn(GameInfo.actions) > 0 and GameInfo.end_game == false and GameInfo.end_round == false) then
                    if (GameInfo.actions[action_state].applied_to == -1) then
                        CheckState:case(GameInfo.actions[action_state].type)
                    end
                end
            end, 
        --[2] = function (x) --WAIT FOR THE TIMER TO RUN OUT

        --    end,
        [2] = function (x) --SET TIMER
                print("NEXT ACTION")
                animation_timer = 60 * 3
                animation_state = animation_state + 1
            end,
        [3] = function (x) --COUNT DOWN TIMER, ACTION INFO TO DISPLAY
                animation_timer = animation_timer - 1
                if (animation_timer <= 0 ) then
                    animation_timer = 0
                    animation_state = animation_state + 1
                end
            end,

        [4] = function (x) --ADVANCE ACTION
                if (GameInfo.end_game == false and GameInfo.end_round == false) then
                    CompleteAction()
                    animation_state = 1
                end
            end,

        default = function () 
                --print( "ERROR - ability not within switch") 
                end,
    }

    --print("ANIMATION STATE " .. animation_state)
    Check_Animation:case(animation_state)

    DeathCheck(false)

end

function CheckActionPos(network_used2)
    
    if (animation_timer > 0) then
        print("STILL TIME ON THE TIMER, network_used: " , network_used2)
        CompleteAction()
    end

    animation_state = 2 --advance the animation state, an artificial pause so players can see what actions are playing
    network_used = network_used2
    --CompleteAction()

    local list_size = table.getn(GameInfo.actions)

    if (list_size > 0) then

        if ( network_used == false) then --send the advance_actions message message if its not been sent over the network already
        --also isn't sent if both players run the action, so won'#t run with any -1 actions
            QueueMessage(
            tostring("advance_actions") .. " " .. 
            tostring(GameInfo.username)) 
       end
    end
    --print("advance action --- ACTION POS: " .. action_state .. " INTERNAL: " .. action_internal_state)
end

function ActivateNetwork()
    network_used = true
end

function CompleteAction()
    local list_size = table.getn(GameInfo.actions)

    if (list_size > 0) then
        if (action_state < list_size) then --advance action_state and play next action if there's one to play
            action_state = action_state + 1
        else
            ResetActions() --else, reset the action list and anything actions use
        end

        DeathCheck(false) --check to see if anyones dead before the next action has time to play

        ResetActionInternalState() --reset internal_state so it's ready to use for the next action
    end
    animation_state = 1 --reset the animation state
    print("complete action --- ACTION POS: " .. action_state .. " INTERNAL: " .. action_internal_state)
end