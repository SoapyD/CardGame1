
function Update_Pos(unique_id, filename, x, y)
    found = false
    saved_id = -1
    for i = 1, table.getn(GameInfo.table_cards) do    
        temp_unique_id = GameInfo.table_cards[i].unique_id

        if ( temp_unique_id == unique_id) then
          found = true
          saved_id = i
        end
    end

    if ( found == false) then
      AddCard(unique_id,filename, x, y, false)

      current_card = GameInfo.table_cards[table.getn(GameInfo.table_cards)]
      current_card.finalised = true
      camera:add(current_card, 7, true)
      camera:track()
      camera.damping = 10

      local Pos_Info = CheckBoard_Pos(current_card)
      section_num = Pos_Info[3]--Pos_Info[1] + (Pos_Info[2] * GameInfo.world_width)
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
    else
      GameInfo.table_cards[saved_id].x = x
      GameInfo.table_cards[saved_id].y = y

      current_card = GameInfo.table_cards[saved_id]
      current_card.finalised = true
      camera:add(current_card, 7, true)
      camera:track()
      camera.damping = 10
    end	

end

function Update_Pos2(unique_id, filename, x, y)
    found = false
    saved_id = -1
    for i = 1, table.getn(GameInfo.table_cards) do    
        temp_unique_id = GameInfo.table_cards[i].unique_id

        if ( temp_unique_id == unique_id) then
          found = true
          saved_id = i
        end
    end

    local current_card = {}

    if ( found == false) then
      AddCard(unique_id,filename, x, y, true)
      current_card = GameInfo.table_cards[table.getn(GameInfo.table_cards)]
      camera:add(current_card, 7, false)
    else
      current_card = GameInfo.table_cards[saved_id]
      current_card.x = x
      current_card.y = y
    end 

    local pos_info = CheckBoard_Pos(current_card)
    Check_Quad_Region(current_card, pos_info[3])    

end


function Update_Rotation(unique_id, username, angle)
    found = false
    saved_id = -1

    --FIND THE CARD TO ROTATE
    for i = 1, table.getn(GameInfo.table_cards) do    
        temp_unique_id = GameInfo.table_cards[i].unique_id

        if ( temp_unique_id == unique_id) then
          found = true
          saved_id = i
        end
    end

    --IF THE ROTATING CARD WASN'T YOUR CARD, UPDATE ITS ROTATION
    if ( found == true) then
      t = GameInfo.table_cards[saved_id]

      if ( username ~= GameInfo.username) then
        transition.to(t, {time=250, 
          rotation= angle, onComplete=UpdatenetRotation(t)})
      end
    end
end

function UpdatenetRotation(t)
end