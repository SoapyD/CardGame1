require("Network.update_cards")

function onConnectDone(resultCode)
  if(resultCode == WarpResponseResultCode.SUCCESS) then
    --statusText.text = "Joining Room.."
    print("Joining Room..")
    --appWarpClient.joinRoom(STATIC_ROOM_ID)
    appWarpClient.joinRoomInRange (1, 1, false)
    --appWarpClient.deleteRoom ( 1402891999 )
  elseif(resultCode == WarpResponseResultCode.AUTH_ERROR) then
    --statusText.text = "Incorrect app keys"
    print("Incorrect app keys")
  else
    --statusText.text = "Connect Failed. Restart"
    print("Connect Failed. Restart")
  end  
end

function onCreateRoomDone(resultCode, roomId, roomName)
  print("room id is: " .. roomId)
  if(resultCode == WarpResponseResultCode.SUCCESS) then
    isNewRoomCreated = true;
    appWarpClient.joinRoom(roomId)
     print("joining to: "  .. roomId .. " " .. roomName)

    print("room created!!!")
    --var = appWarpClient.getLiveRoomInfo(roomId);
     
  else
    --statusText.text = "Room Join Failed"
    print("Room Create Failed")
  end  
end

function onDeleteRoomDone (resultCode , roomId , name )  

  if(resultCode == WarpResponseResultCode.SUCCESS) then
    print("room deleted: " .. roomId)
  else
    --statusText.text = "Room Join Failed"
    print("Room Could be Deleted")
  end  
end

local join_state = 0

--function onJoinRoomDone(resultCode)
function onJoinRoomDone(resultCode, roomId)  
  if(resultCode == WarpResponseResultCode.SUCCESS) then
    --appWarpClient.subscribeRoom(STATIC_ROOM_ID)
    appWarpClient.subscribeRoom(roomId)
    print("Subscribing to room.." .. roomId)
    appWarpClient.getAllRooms();

  elseif(resultCode == WarpResponseResultCode.RESOURCE_NOT_FOUND) then
    -- no room found with one user creating new room
    if (join_state == 0) then
      appWarpClient.joinRoomInRange (0, 0, false)
      join_state = 1
    else
      print("creating room")
      local roomPropertiesTable = {}
      roomPropertiesTable["result"] = ""
      appWarpClient.createRoom ( "testroom1" ,GameInfo.username ,2 ,nil ) 
    end
    --appWarpClient.getAllRooms();
  else
    print("Room Join Failed")
  end  
end

function onGetAllRoomsDone(resultCode , roomsTable )  

  if(resultCode == WarpResponseResultCode.SUCCESS) then
    print("room table: " .. table.getn(roomsTable))

    for i=1, table.getn(roomsTable) do
      print("pos" .. i .. ": " .. roomsTable[i])
      --appWarpClient.deleteRoom ( roomsTable[i] )  
    end
    --appWarpClient.getLiveRoomInfo(roomsTable[1]) 
  else
    --statusText.text = "Room Join Failed"
    print("Get All Rooms Failed")
  end  
end

function onGetLiveRoomInfoDone (resultCode , roomTable )  

  if(resultCode == WarpResponseResultCode.SUCCESS) then
    --print("room ID: " .. roomId) -- .. " room_name: " roomTable.name)

    print(roomTable.name)
    --for i=1, table.getn(roomsTable) do
    --  print("pos" .. i .. ": " .. roomsTable[i])
    --end
  else
    --statusText.text = "Room Join Failed"
    print("No Room Info Available")
  end  

end


function onSubscribeRoomDone(resultCode)
  if(resultCode == WarpResponseResultCode.SUCCESS) then    
    --statusText.text = "Started!"
    print("Started!")
  else
    --statusText.text = "Room Subscribe Failed"
    print("Room Subscribe Failed")
  end  
end


function onUpdatePeersReceived(update)
  local func = string.gmatch(update, "%S+")

  local update_type = tostring(func())

  --//////////////////////////////////////////////////////////////////////////
  --////////////////////NETWORKING SOLUTIONS
  --//////////////////////////////////////////////////////////////////////////
  if (update_type == "check_player") then
    local username = tostring(func())
    --AddPlayer(username)

    if (username == GameInfo.username) then
      GameInfo.attacker_ready = true
    end
    if (username ~= GameInfo.username) then
      GameInfo.opponent_ready = true
    end
  end
  if (update_type == "add_player") then
    local username = tostring(func())
    AddPlayer(username)
  end
  if (update_type == "set_player_1") then
    local username = tostring(func())
    
    if (GameInfo.player_1_id == "") then
      GameInfo.player_1_id = username
      print("player 1 is: " .. username)
    end 
  end

  --//////////////////////////////////////////////////////////////////////////
  --////////////////////GAME SOLUTIONS
  --//////////////////////////////////////////////////////////////////////////

  if (update_type == "remove_card") then
    local username = tostring(func())
    local deck_index = tonumber(func())
    local remove_pos = tonumber(func())

    if (username ~= GameInfo.username) then
      RemoveDeckCard(deck_index, remove_pos)
    end
  end

  if (update_type == "finish_draw") then --REGISTER THAT THE RECEIVER HAS RECEIVED A MESSAGE
    local username = tostring(func())
    print("FINISHING DRAW")
    if (username ~= GameInfo.username) then
         appWarpClient.sendUpdatePeers(
            tostring("complete_action") .. " " .. 
            tostring(username)) 

      if (table.getn(GameInfo.cards) == 0) then
        DrawCharacterCards()

        appWarpClient.sendUpdatePeers(
          tostring("finish_draw") .. " " ..
          tostring(GameInfo.username))    
      end
    end
  end

  if (update_type == "complete_action") then --TURN A SWITCH IN GAMEINFO
    local username = tostring(func())

    if (username == GameInfo.username) then
      GameInfo.switch1 = true
    end
  end

  if (update_type == "position") then
    local unique_id = tostring(func())
    local filename = tostring(func())
    local sheet = tostring(func())
    local sprite = tostring(func())
    local x = tonumber(func())
    local y = tonumber(func())

    --print("id_to_use" .. filename)
    Update_Pos(unique_id, filename, sheet, sprite, x, y)
  end

  if (update_type == "rotation") then
    local unique_id = tostring(func())
    local username = tostring(func()) 
    local angle = tonumber(func())

    Update_Rotation(unique_id, username, angle)
  end

  --//////////////////////////////////////////////////////////////////////////
  --////////////////////CARD PLACEMENT PAUSE ACTIONS
  --//////////////////////////////////////////////////////////////////////////
  if (update_type == "finish_placement_pause") then
    local username = tostring(func())

    if (username ~= GameInfo.username) then
      advance_cardPausestate()
    end
  end

  --//////////////////////////////////////////////////////////////////////////
  --////////////////////FACEOFF ACTIONS
  --//////////////////////////////////////////////////////////////////////////
  if (update_type == "pass_faceoff") then
    local username = tostring(func())

    if (username ~= GameInfo.username) then
      --CheckActionPos(true)
      local faceoff_card = tostring(func())
      --print("faceoff passed! " .. faceoff_card .. " added.")
      AddFaceOffCard(username, faceoff_card)
    end
  end

  if (update_type == "health_delay") then
    local health_modifier = tonumber(func())
    local applied_to = tonumber(func())
    --print("health mod " .. health_modifier)
    --mod_health(1,health_modifier)
    mod_health(applied_to,health_modifier)
    CheckActionPos(true)
  end

  --//////////////////////////////////////////////////////////////////////////
  --////////////////////COUNTER ACTIONS
  --//////////////////////////////////////////////////////////////////////////
  if (update_type == "counter") then
    local username = tostring(func())
    local filename = tostring(func())
    local sheet = tostring(func())
    local sprite = tostring(func())
    local unique_id = tostring(func())

    id = GameInfo.current_card_int
    if(id ~= -1) then
      local current_card = GameInfo.table_cards[id]
      current_card.isVisible = false
      GameInfo.actions = {}
      ResetActionState()
      ResetActionInternalState()

      Update_Pos(unique_id, filename, sheet, sprite, current_card.x, current_card.y)
      if (username == GameInfo.username) then
        set_cardPausestate(5)
      end
    end 

  end

  --//////////////////////////////////////////////////////////////////////////
  --////////////////////COOPYCAT ACTIONS
  --//////////////////////////////////////////////////////////////////////////
  if (update_type == "hide_current") then
    id = GameInfo.current_card_int

    --HIDE THE CURRENT CARD AND RESET THE ACTIONS
    if(id ~= -1) then
      local current_card = GameInfo.table_cards[id]
      current_card.isVisible = false
      GameInfo.actions = {}
      ResetActionState()
      ResetActionInternalState()
      local Pos_Info = CheckBoard_Pos(current_card)
      local quad_info = {}
      quad_info.section_num = Pos_Info[3]

      Quad_Remove(GameInfo.quads, quad_info)


      local username = tostring(func())
      local unique_id = tostring(func())
      local filename = tostring(func())
      local sheet = tostring(func())
      local sprite = tostring(func())
      local x = tonumber(func())
      local y = tonumber(func())

      if (GameInfo.username == username) then
                Update_Pos3(unique_id, 
                  filename, sheet, sprite, x, y)
      end

    end
  end

  --//////////////////////////////////////////////////////////////////////////
  --////////////////////CARD ACTIONS
  --//////////////////////////////////////////////////////////////////////////

  if (update_type == "advance_actions") then
    local username = tostring(func())
    --print("advancing networked player actions")
    if (username ~= GameInfo.username) then
      CheckActionPos(true)
    end
  end

  if (update_type == "cripple_limb") then
    local username = tostring(func())
    local action_var = tonumber(func())
    local damage_type = tostring(func())
    local applied_to = tonumber(func())
    --print("action var netted: " .. action_var)
    UpdateLimbs(username, action_var, damage_type, applied_to)

    if (username == GameInfo.username) then
      CheckLimbs()
    end
  end

  if (update_type == "limb_discard") then
    local username = tostring(func())
    local action_var = tonumber(func())
    local damage_type = tostring(func())
    local applied_to = tonumber(func())
    --print("action var netted: " .. action_var)
    UpdateLimbs(username, action_var, damage_type, applied_to)

    if (username == GameInfo.username) then
      Hide_LimbDiscardTable()
    end
  end

  if (update_type == "health_mod") then
    local health_modifier = tonumber(func())
    --print("health mod " .. health_modifier)
    mod_health(1,health_modifier)
  end

  if (update_type == "armour_mod") then
    local armour_modifier = tonumber(func())
    --print("health mod " .. health_modifier)
    mod_armour(0,armour_modifier)
  end

  if (update_type == "steal") then
    local username = tostring(func())
    local filename = tostring(func())
    local sheet = tostring(func())
    local sprite = tostring(func())

    if (username ~= GameInfo.username) then
      --print("network stealing card")
      LoadCard2(filename,sheet,sprite,0,150);
      SetGame()
    end
  end

  if (update_type == "shrapnel") then
    local username = tostring(func())
    local damage = tonumber(func())

    if (username ~= GameInfo.username) then
      --print("inflicting damage: " .. damage)
      mod_health(1,damage)
    end
  end

  if (update_type == "hide_discard") then
    local username = tostring(func())
    if (username == GameInfo.username) then
      Hide_DiscardTable(false)
    end
  end

  if (update_type == "add_variable_action") then
    local username = tostring(func())
    local action_type = tostring(func())

    Add_VariableAction(username, action_type)

  end

  if (update_type == "add_action") then
    local action_name = tostring(func())
    local subaction_name = tostring(func())
    local action_val = tonumber(func())
    local action_against = tonumber(func())

    arr_pos = table.getn(GameInfo.actions) + 1
    GameInfo.actions[arr_pos] = set_action(action_name, subaction_name, action_val, action_against)
    GameInfo.actions[arr_pos].type = action_name
  end

  if (update_type == "end_round") then
    --EndRound()
    GameInfo.end_round = true
  end

end


appWarpClient.addRequestListener("onConnectDone", onConnectDone)
appWarpClient.addRequestListener("onCreateRoomDone", onCreateRoomDone)
appWarpClient.addRequestListener("onGetAllRoomsDone", onGetAllRoomsDone)
appWarpClient.addRequestListener("onGetLiveRoomInfoDone", onGetLiveRoomInfoDone)
appWarpClient.addRequestListener("onDeleteRoomDone", onDeleteRoomDone)
appWarpClient.addRequestListener("onJoinRoomDone", onJoinRoomDone)
appWarpClient.addRequestListener("onSubscribeRoomDone", onSubscribeRoomDone)
appWarpClient.addNotificationListener("onUpdatePeersReceived", onUpdatePeersReceived)