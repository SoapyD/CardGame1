
local end_game = false
local winner = -1
local loser = -1

function Reset_DeathCheck()
	end_game = false
	winner = -1
	loser = -1
end

function DeathCheck(check_decks)

	if (end_game == false) then

		--CHECK TO SEE IF EITHER PLAYER HAS DIED
		for i=1, table.getn(GameInfo.player_list) do
			local player = GameInfo.player_list[i]
			if (player.health <= 0) then
				end_game = true
				loser = i
				winner = i + 1
				if (winner > 2) then
					winner = 1
				end
			end
		end

		if (end_game == true) then
			run_popup("PLAYER " .. loser .. " HAS DIED.\n" .. "PLAYER " .. winner .. " WIN!")
		end

		--TempReset()

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

			end_game = true
			winner = saved_player
			loser = saved_player + 1
			if (loser > 2) then
				loser = 1
			end
				run_popup(empty_deck .. " DECK OUT OF CARDS.\n" .. "PLAYER " .. winner .. " WIN!")
		end
	end
end