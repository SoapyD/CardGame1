function SetGame()
    portrait:toFront()
    statusText:toFront()

    if ( GameInfo.username ~= GameInfo.player_list[1].username) then
      finalise_button.isVisible = false
    end
end

function StealCards(card_number)

	local count = 0
	print("card is being stolen")

	for i = 1, table.getn(GameInfo.cards) do
		if (GameInfo.cards[i].isVisible == true) then
			count = count + 1
		end
	end

	local offset_count = 0
	if ( count > 0) then
		for i = 1, card_number do
			local randIndex = math.random(count - offset_count)
			local card = GameInfo.cards[randIndex]
			local card_type = string.sub(card.filename,1,1)
			card.isVisible = false

			appWarpClient.sendUpdatePeers(
				tostring("steal") .. " " ..
				tostring(GameInfo.username) .. " " ..		
				tostring(card.filename))

			offset_count = offset_count + 1
		end
	end
end

function InjureEnemy()

    local apply_to = find_applied_to(0)
    local applied_player = GameInfo.player_list[apply_to]

    local shrap_val = -applied_player.armour
    applied_player.armour = 0

	appWarpClient.sendUpdatePeers(
		tostring("shrapnel") .. " " ..
		tostring(GameInfo.username) .. " " ..		
		tostring(shrap_val))

end