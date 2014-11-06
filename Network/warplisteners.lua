require("Network.update_cards")

local saved_room = ""

function onConnectDone(resultCode)

  if(resultCode == WarpResponseResultCode.SUCCESS) then
    print("Joining Room..")
    TitleText.text = "Joining Room.."
    appWarpClient.joinRoomInRange (1, 1, false) --go to onJoinRoomDone and resolve
  elseif(resultCode == WarpResponseResultCode.AUTH_ERROR) then
    print("Incorrect app keys")
  else
    print("Connect Failed. Restart")

    Show_EndTable()
    TitleText.text = "CONNECTION FAILED.\nRESTART"
  end  
end

function onCreateRoomDone(resultCode, roomId, roomName)
  print("room id is: " .. roomId)
  if(resultCode == WarpResponseResultCode.SUCCESS) then
    isNewRoomCreated = true;
    appWarpClient.joinRoom(roomId)
    --print("room created!!!")
    print("joining to: "  .. roomId .. " " .. roomName)
    TitleText.text = "joining to: "  .. roomId .. " " .. roomName
  else
    print("Room Create Failed")
  end  
end

function onDeleteRoomDone (resultCode , roomId , name )  

  if(resultCode == WarpResponseResultCode.SUCCESS) then
    print("room deleted: " .. roomId)
  else
    print("Room Could be Deleted")
  end  
end

local join_state = 0

function onJoinRoomDone(resultCode, roomId)  
  if(resultCode == WarpResponseResultCode.SUCCESS) then
    appWarpClient.subscribeRoom(roomId)
    print("Subscribing to room.." .. roomId)
    TitleText.text = "Subscribing to Room\n" .. roomId
    saved_room = roomId
    appWarpClient.getAllRooms();

  elseif(resultCode == WarpResponseResultCode.RESOURCE_NOT_FOUND) then
    -- no room found with one user creating new room
    if (join_state == 0) then
      appWarpClient.joinRoomInRange (0, 0, false)
      print("joining empty room")
      TitleText.text = "Joining Empty Room"
      join_state = 1
    else
      print("creating room")
      TitleText.text = "Creating Room"
      local roomPropertiesTable = {}
      roomPropertiesTable["result"] = ""
      appWarpClient.createRoom ( "testroom1" ,GameInfo.username ,2 ,nil ) 
    end
  else
    print("Room Join Failed")
  end  
end

function onGetAllRoomsDone(resultCode , roomsTable )  

  if(resultCode == WarpResponseResultCode.SUCCESS) then
    print("room table: " .. table.getn(roomsTable))

    for i=1, table.getn(roomsTable) do
      print("pos" .. i .. ": " .. roomsTable[i])
    end
  else
    print("Get All Rooms Failed")
  end  
end

function onGetLiveRoomInfoDone (resultCode , roomTable )  

  if(resultCode == WarpResponseResultCode.SUCCESS) then
    print("Room Info Available: " .. roomTable.name)
  else
    print("No Room Info Available")
  end  

end


function onSubscribeRoomDone(resultCode)
  if(resultCode == WarpResponseResultCode.SUCCESS) then    
    print("Started!")
    TitleText.text = "Subscribed to\n" .. saved_room
  else
    print("Room Subscribe Failed")
  end  
end


function onUpdatePeersReceived(update)

  Read_NetworkMessage(update)

end


appWarpClient.addRequestListener("onConnectDone", onConnectDone)
appWarpClient.addRequestListener("onCreateRoomDone", onCreateRoomDone)
appWarpClient.addRequestListener("onGetAllRoomsDone", onGetAllRoomsDone)
appWarpClient.addRequestListener("onGetLiveRoomInfoDone", onGetLiveRoomInfoDone)
appWarpClient.addRequestListener("onDeleteRoomDone", onDeleteRoomDone)
appWarpClient.addRequestListener("onJoinRoomDone", onJoinRoomDone)
appWarpClient.addRequestListener("onSubscribeRoomDone", onSubscribeRoomDone)
appWarpClient.addNotificationListener("onUpdatePeersReceived", onUpdatePeersReceived)