

local message_number = 1


function Reset_MessageNum()
	message_number = 1
end

function QueueMessage(message)

	--print("SENDING MESSAGE")
	local message_code = tostring(GameInfo.username .. "_" .. message_number)
	message = message_code .. " " .. message

	appWarpClient.sendUpdatePeers(message)

	message_number = message_number + 1

end