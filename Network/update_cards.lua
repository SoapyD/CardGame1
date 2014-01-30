
function Update_Pos(unique_id, filename, x, y)
    found = false
    saved_id = -1
    for i = 1, table.getn(GameInfo.table_cards) do    
        --temp_filename = GameInfo.table_cards[i].filename
        temp_unique_id = GameInfo.table_cards[i].unique_id

       -- print("table_card: " .. temp_unique_id)
        if ( temp_unique_id == unique_id) then
          found = true
          saved_id = i
        end
    end

    if ( found == false) then
      --print("adding card:", unique_id)

      AddCard(unique_id,filename, x, y, false)

      current_card = GameInfo.table_cards[table.getn(GameInfo.table_cards)]
      current_card.finalised = true
      camera:add(current_card, 1, true)
      camera:setFocus(current_card)
      camera:track()

    else
      GameInfo.table_cards[saved_id].x = x
      GameInfo.table_cards[saved_id].y = y

      current_card = GameInfo.table_cards[saved_id]
      current_card.finalised = true
      camera:add(current_card, 1, true)
      camera:setFocus(current_card)
      camera:track()

    end	

end

function Update_Pos2(unique_id, filename, x, y)
    found = false
    saved_id = -1
    for i = 1, table.getn(GameInfo.table_cards) do    
        --temp_filename = GameInfo.table_cards[i].filename
        temp_unique_id = GameInfo.table_cards[i].unique_id

       -- print("table_card: " .. temp_unique_id)
        if ( temp_unique_id == unique_id) then
          found = true
          saved_id = i
        end
    end

    if ( found == false) then
      --print("adding card:", unique_id)
      AddCard(unique_id,filename, x, y, true)
    else
      GameInfo.table_cards[saved_id].x = x
      GameInfo.table_cards[saved_id].y = y
    end 

end


function Update_Rotation(unique_id, username, angle)
    found = false
    saved_id = -1
    for i = 1, table.getn(GameInfo.table_cards) do    
        temp_unique_id = GameInfo.table_cards[i].unique_id

        if ( temp_unique_id == unique_id) then
          found = true
          saved_id = i
        end
    end

    if ( found == true) then
      t = GameInfo.table_cards[saved_id]

      if ( username ~= GameInfo.username) then
        transition.to(t, {time=250, 
          rotation= angle, onComplete=UpdatenetRotation(t)})
      end
    end
end