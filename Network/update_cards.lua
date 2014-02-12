
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

    if ( found == false) then
      AddCard(unique_id,filename, x, y, true)
      current_card = GameInfo.table_cards[table.getn(GameInfo.table_cards)]
      camera:add(current_card, 7, false)
    else
      GameInfo.table_cards[saved_id].x = x
      GameInfo.table_cards[saved_id].y = y
    end 

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