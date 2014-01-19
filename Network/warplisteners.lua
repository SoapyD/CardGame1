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
  -- extract the sent values which are space delimited
  --local id = tostring(func())
  --local x = func()
  --local y = func()
  local filename = tostring(func())
  local x = tonumber(func())
  local y = tonumber(func())

  --if (table.getn(GameInfo.table_cards) < tonumber(id)) then
  --  print("not on table")
  --end
  found = false
  saved_id = -1
  for i = 1, table.getn(GameInfo.table_cards) do    
      temp_filename = GameInfo.table_cards[i].filename
      print("table_card: " .. temp_filename)
      if ( temp_filename == filename) then
        found = true
        saved_id = i
      end
  end

  if ( found == false) then
    print(filename, " not on table")
    AddCard(filename, x, y)
  else
    GameInfo.table_cards[saved_id].x = x
    GameInfo.table_cards[saved_id].y = y
  end
  --local button = GameInfo.myButtons[id]
  --button.x = tonumber(x)
  --button.y = tonumber(y)
  --print("someone moved button id ".. id)
end

appWarpClient.addRequestListener("onConnectDone", onConnectDone)
appWarpClient.addRequestListener("onJoinRoomDone", onJoinRoomDone)
appWarpClient.addRequestListener("onSubscribeRoomDone", onSubscribeRoomDone)
appWarpClient.addNotificationListener("onUpdatePeersReceived", onUpdatePeersReceived)