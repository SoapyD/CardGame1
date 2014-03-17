
function EndTurn(current_card)

        --(applied_to, value)
    local card_info = retrieve_card(current_card.filename)
    print("actions size:" .. table.getn(card_info.actions))
    if ( table.getn(card_info.actions) > 0) then
      for i=1, table.getn(card_info.actions) do
        local action = card_info.actions[i]
        CheckAbility(action.name, action.applied_to, action.value)
      end
    end

      local Pos_Info = CheckBoard_Pos(current_card)
      section_num = Pos_Info[3]
      local quad_info = {}
      quad_info.section_num = section_num
      quad_info.filename = current_card.filename
      quad_info.rotation = current_card.rotation
      quad_info.unique_id = current_card.unique_id
      local list_pos = Quad_Add(GameInfo.quads, quad_info)

      GameInfo.current_player = GameInfo.current_player + 1
      if ( GameInfo.current_player > table.getn(GameInfo.player_list)) then
        GameInfo.current_player = 1
      end               

      if ( GameInfo.username ~= GameInfo.player_list[GameInfo.current_player].username) then
        finalise_button.isVisible = false
      else
        finalise_button.isVisible = true
      end
end