
function AddPlayer(username)

	local player_info = {}
	player_info.username = username

	local add = true
	for i=1, table.getn(GameInfo.player_list) do
		if ( GameInfo.player_list[i].username == username) then
			add = false
		end
		--print("checked username:" .. GameInfo.player_list[i].username)
	end

	if ( add == true) then
		GameInfo.player_list[table.getn(GameInfo.player_list) + 1] = player_info
		print("username added: " .. username)
	else
		print("player already on list")
	end
end