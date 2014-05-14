
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
      --THIS IS THE OPPONENTS VIEW OF THE TABLE
      AddCard(unique_id,filename, x, y, false)

      current_card = GameInfo.table_cards[table.getn(GameInfo.table_cards)]
      current_card.finalised = true
      camera:add(current_card, 7, true)
      camera:track()
      camera.damping = 10

      --EndTurn(current_card)
      advance_cardPausestate()
    else
      --THIS IS THE CARD OF THE CURRENT PLAYER
      GameInfo.table_cards[saved_id].x = x
      GameInfo.table_cards[saved_id].y = y

      current_card = GameInfo.table_cards[saved_id]
      current_card.finalised = true
      camera:add(current_card, 7, true)
      camera:track()
      camera.damping = 10
      --print("ending turn")
      --EndTurn(current_card)
    end	

end

--THIS IS USED TO ADD A CARD WITHOUT ADDING TO THE TABLE
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
    local found = false
    local saved_id = -1

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

--function UpdateDeck(username, remove_pos)
--  if ( username ~= GameInfo.username) then
--    RemoveDeckCard(deck_index, remove_pos)
--  end
--end

function UpdateLimbs(username, action_var, cripple_type)

  local apply_to = find_applied_to(1) --apply this to the defender
  local applied_player = GameInfo.player_list[apply_to]
  --print("limb passed: " .. cripple_type .. " " .. action_var)
  if (cripple_type == "cripple_arm") then
    applied_player.arms = applied_player.arms + action_var
  end
  if (cripple_type == "cripple_leg") then
    applied_player.legs = applied_player.legs + action_var
  end

  if (applied_player.arms < 0 ) then
    applied_player.arms = 0
  end
  if (applied_player.arms > 2) then
    applied_player.arms = 2
  end
  if (applied_player.legs < 0 ) then
    applied_player.legs = 0
  end
  if (applied_player.legs > 2) then
    applied_player.legs = 2
  end

  if (username == GameInfo.username) then
    CheckLimbs()
  end
end
