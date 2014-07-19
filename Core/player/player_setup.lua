
function AddPlayer(username)

	local player_info = {}
	player_info.username = username
	player_info.max_health = 40 - 39
	player_info.health = player_info.max_health
	player_info.armour = 0
	player_info.max_arms = 2
	player_info.arms = player_info.max_arms	
	player_info.max_legs = 2
	player_info.legs = player_info.max_legs	
	player_info.character_info = CheckCharacter("test")

	player_info.faceoff_card = ""

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


function GetPlayer()

	local current_player = {}

    for i=1, table.getn(GameInfo.player_list) do
        current_player = GameInfo.player_list[i]
    end

    return current_player

end
