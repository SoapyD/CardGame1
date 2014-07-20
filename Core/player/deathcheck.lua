
--local end_game = false
--local winner = -1
--local loser = -1

function Reset_DeathCheck()
	GameInfo.end_game = false
	GameInfo.winner = -1
	GameInfo.loser = -1
end

function DeathCheck(check_decks)

	if (GameInfo.end_game == false) then

		--CHECK TO SEE IF EITHER PLAYER HAS DIED
		for i=1, table.getn(GameInfo.player_list) do
			local player = GameInfo.player_list[i]
			if (player.health <= 0) then
				GameInfo.end_game = true
				GameInfo.loser = i
				GameInfo.winner = i + 1
				if (GameInfo.winner > 2) then
					GameInfo.winner = 1
				end
			end
		end

		if (end_game == true) then
			run_popup("PLAYER " .. GameInfo.loser .. " HAS DIED.\n" .. "PLAYER " .. GameInfo.winner .. " WIN!")
		end
	end
end


function DeckDeath()
	if (GameInfo.end_game == false) then

		--CHECK THE DECKS TO SEE IF THEY'VE RUN OUT OF CARDS
		local decks = GetDeck()
		local suit_names = Get_SuitNames()
		local empty_deck = ""
		local no_cards = false
		for i=1, 6 do
			local deck = decks[i]
			if (table.getn(deck) == 0) then
				--CHECK TO SEE WHO HAS THE MOST LIFE
				no_cards = true
				empty_deck = suit_names[i]
			end
		end

		if (no_cards == true and check_decks == true) then
			local saved_health = -1
			local saved_player = -1
			for i=1, table.getn(GameInfo.player_list) do
				local player = GameInfo.player_list[i]
				if (player.health > saved_health) then
					saved_player = i
					saved_health = player.health
				end
			end				

			GameInfo.end_game = true
			GameInfo.winner = saved_player
			GameInfo.loser = saved_player + 1
			if (GameInfo.loser > 2) then
				GameInfo.loser = 1
			end
				run_popup(empty_deck .. " DECK OUT OF CARDS.\n" .. "PLAYER " .. GameInfo.winner .. " WIN!")
		end
	end
end