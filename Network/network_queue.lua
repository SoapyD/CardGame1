

local message_number = 1


function Reset_MessageNum()
	message_number = 1
end

function QueueMessage(message)

	--WriteToFile()
	--print("SENDING MESSAGE")
	local message_code = tostring(GameInfo.username .. " " .. message_number)
	message = message_code .. " " .. message

	appWarpClient.sendUpdatePeers(message)

	message_number = message_number + 1

end

function ConfirmMessage(msg_id, msg_num, update_type)

	if (msg_id ~= GameInfo.username and
		update_type:sub(1, 16) ~= "message_received") then
			--print("sending message received message")
			--QueueMessage("message_received" .. "_" .. msg_id .. "_" .. msg_num .. "_" .. update_type)

			--DON'T WANT THESE AFFECTING THE OVERALL MESSAGE COUNT
			--local message = "message_received" .. "_" .. msg_id .. "_" .. msg_num .. "_" .. update_type
			--local message_code = tostring(GameInfo.username .. " " .. 0)
			--message = message_code .. " " .. message
			--appWarpClient.sendUpdatePeers(message)

	end

end

function WriteToFile()
	local saveData = "My app state data"

	local path = system.pathForFile( "myfile.txt", system.DocumentsDirectory )
	local file = io.open( path, "w" )
	--local path = system.pathForFile( "/sdcard/myfile.txt", system.DocumentsDirectory )
	--local file = io.open(path,"w")

	if (file ~= nil) then
		--run_popup("SAVING")
		file:write( saveData )
		io.close( file )
	end
	file = nil
end