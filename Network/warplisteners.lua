require("Network.update_cards")

function onJoinRoomDone(resultCode)
  if(resultCode == WarpResponseResultCode.SUCCESS) then
    appWarpClient.subscribeRoom(STATIC_ROOM_ID)
    --statusText.text = "Subscribing to room.."
    print("Subscribing to room..")
  else
    --statusText.text = "Room Join Failed"
    print("Room Join Failed")
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

function onConnectDone(resultCode)
  if(resultCode == WarpResponseResultCode.SUCCESS) then
    --statusText.text = "Joining Room.."
    print("Joining Room..")
    appWarpClient.joinRoom(STATIC_ROOM_ID)
  elseif(resultCode == WarpResponseResultCode.AUTH_ERROR) then
    --statusText.text = "Incorrect app keys"
    print("Incorrect app keys")
  else
    --statusText.text = "Connect Failed. Restart"
    print("Connect Failed. Restart")
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
  if (update_type == "position") then
    local unique_id = tostring(func())
    local filename = tostring(func())
    local x = tonumber(func())
    local y = tonumber(func())

    --print("id_to_use" .. filename)
    Update_Pos(unique_id, filename, x, y)
  end

  if (update_type == "rotation") then
    local unique_id = tostring(func())
    local username = tostring(func()) 
    local angle = tonumber(func())

    Update_Rotation(unique_id, username, angle)
  end
end


appWarpClient.addRequestListener("onConnectDone", onConnectDone)
appWarpClient.addRequestListener("onJoinRoomDone", onJoinRoomDone)
appWarpClient.addRequestListener("onSubscribeRoomDone", onSubscribeRoomDone)
appWarpClient.addNotificationListener("onUpdatePeersReceived", onUpdatePeersReceived)