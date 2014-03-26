
function EndTurn(current_card)

  local pospone_play = false

  GameInfo.actions = {}
  local card_info = retrieve_card(current_card.filename)

  if ( table.getn(card_info.actions) > 0) then
    for i=1, table.getn(card_info.actions) do
      local action = card_info.actions[i]
      local temp_mods = {}
      --print("adding action" .. action.name)
      temp_mods = CheckAbility(action.name, action.applied_to, action.value)
      --print("mods" .. temp_mods[1].type)
      if (temp_mods.type ~= "") then
          if (temp_mods.type ~= "play") then
            local arr_pos = table.getn(GameInfo.actions) + 1
            GameInfo.actions[arr_pos] = {}
            GameInfo.actions[arr_pos] = temp_mods
            --print("action added" .. temp_mods.type)
            --GameInfo.actions[table.getn(GameInfo.actions)].type = temp_mods.type
          end

          if (temp_mods.type == "play") then
            pospone_play = true

          end
      end
    end
  end
  print("action num" .. table.getn(GameInfo.actions))
  --GameInfo.actions = {}
  --if (draw_cards == true) then
  --  GameInfo.actions[table.getn(GameInfo.actions) + 1] = "draw"
  --end
  --if (table.getn(GameInfo.actions) > 0) then
  --  for n=1 to table.getn(GameInfo.actions) do
  --    if (GameInfo.actions[n] = "play") then
  --      pospone_play = true
  --    end
  --  end
  --end

  local Pos_Info = CheckBoard_Pos(current_card)
  section_num = Pos_Info[3]
  local quad_info = {}
  quad_info.section_num = section_num
  quad_info.filename = current_card.filename
  quad_info.rotation = current_card.rotation
  quad_info.unique_id = current_card.unique_id
  local list_pos = Quad_Add(GameInfo.quads, quad_info)

  if (pospone_play == false) then --THIS IS USED TO POSPONE ADVANCING PLAYER NUMBER WHEN "PLAY CARD" ABILITY IS USED
    GameInfo.current_player = GameInfo.current_player + 1
    if ( GameInfo.current_player > table.getn(GameInfo.player_list)) then
      GameInfo.current_player = 1
    end               
  end

  if ( GameInfo.username ~= GameInfo.player_list[GameInfo.current_player].username) then
    finalise_button.isVisible = false
  else
    finalise_button.isVisible = true
  end
end