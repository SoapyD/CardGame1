
function EndTurn(current_card)

  local pospone_play = false

  GameInfo.actions = {}
  local card_info = retrieve_card(current_card.filename)

  if ( table.getn(card_info.actions) > 0) then
    for i=1, table.getn(card_info.actions) do
      local action = card_info.actions[i]

      local temp_mods = {}
      --temp_mods = CheckAbility(action.name, action.applied_to, action.value)
      temp_mods = CheckAbility(action)
      if (temp_mods.type ~= "") then
          if (temp_mods.type ~= "play") then
            local arr_pos = table.getn(GameInfo.actions) + 1
            GameInfo.actions[arr_pos] = {}
            GameInfo.actions[arr_pos] = temp_mods
          end

          if (temp_mods.type == "play") then
            pospone_play = true
          end
      end
    end
  end

  --ADD "PASS TURN" ACTION IF THE PLAY ACTION WASN'T DETECTED
  if (pospone_play == false) then

    local temp_mods = {}
    temp_mods.type = "pass_turn"
    temp_mods.sub_action = ""
    temp_mods.applied_to = -1
    temp_mods.value = 0

    local arr_pos = table.getn(GameInfo.actions) + 1
    GameInfo.actions[arr_pos] = {}
    GameInfo.actions[arr_pos] = temp_mods
  end

  for i=1, table.getn(GameInfo.actions) do
    print(GameInfo.actions[i].type)
  end

  local Pos_Info = CheckBoard_Pos(current_card)
  section_num = Pos_Info[3]
  local quad_info = {}
  quad_info.section_num = section_num
  quad_info.filename = current_card.filename
  quad_info.rotation = current_card.rotation
  quad_info.unique_id = current_card.unique_id

  quad_info.passed_ability = ""
  quad_info.passed_value = 0

  if (GameInfo.previous_card_int ~= -1) then
    --Check to see if the attacking card type is blocked
    local last_card_info = GameInfo.table_cards[GameInfo.previous_card_int]
    local last_card = retrieve_card(last_card_info.filename)

    --CHECK THE LAST CARD PUT DOWN TO SEE IF ANY ADDITIONAL RULES NEED APPLYING
    if ( table.getn(last_card.actions) > 0) then
      for i=1, table.getn(last_card.actions) do
        local action = last_card.actions[i]
        --print("action checked: " .. action.name)
        if( action.name == "strat_alter") then
          --print("strat found")
          quad_info.passed_ability = action.name
          quad_info.passed_value = action.value
        end 
      end
    end

  end

  local list_pos = Quad_Add(GameInfo.quads, quad_info)

end

function PassTurn()
  GameInfo.current_player = GameInfo.current_player + 1
  if ( GameInfo.current_player > table.getn(GameInfo.player_list)) then
    GameInfo.current_player = 1
  end               
  print("current player is:" .. GameInfo.current_player)

  check_FinalisationButton()
end


local EndRound_state = 1

function EndRound()

  --print("round ended")
    local reset_state = false


    local CheckState = switch { 
        [1] = function()    --RESET THE CARDS ON THE BOARD

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
              --ResetActionState()

              GameInfo.current_card_int = -1
              GameInfo.previous_card_int = -1
              camera:toPoint(1750, 1750)

              Reset_SetCards_state()
              GameInfo.current_player = 1

              if ( GameInfo.username ~= GameInfo.player_list[GameInfo.current_player].username) then
                finalise_button.isVisible = false
              else
                finalise_button.isVisible = true
              end

              EndRound_state = EndRound_state + 1

            end,
        [2] = function()    --DRAW CARDS ON BOTH SIDES

                if(GameInfo.player_list[1].username == GameInfo.username) then
                    local SetupComplete = SetPlayerCards_Networked()
                    if (SetupComplete == true) then
                        EndRound_state = EndRound_state + 1
                    end
                else
                    if (GameInfo.switch1 == true) then
                        GameInfo.switch1 = false
                        EndRound_state = EndRound_state + 1
                        SetGame()
                    end
                end

              end,
        [3] = function()    --END
              GameInfo.actions = {}
              ResetActionState()
              ResetActionInternalState()
              Show_FOTable("", true)
              reset_state = true
            end,
        default = function () print( "ERROR - EndRound_state not within switch") end,
    }

    CheckState:case(EndRound_state)

    if (reset_state == true) then
      EndRound_state = 1
    end

end