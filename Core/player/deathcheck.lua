
--local end_game = false
--local winner = -1
--local loser = -1

function RoundCheck()

	local any_allowed = false

	--if (GameInfo.end_game == false) then

		if (GameInfo.username == GameInfo.player_list[GameInfo.current_player].username and
			GameInfo.current_card_int ~= -1 and
			GameInfo.end_game == false) then
			--GameInfo.previous_card_int ~= -1) then
			--local card_count = 0
			--print("CURRENT: " .. GameInfo.current_card_int)
			--print("PREVIOUS: " .. GameInfo.previous_card_int)

			--needs to be the last card on the table
			local last_card = GameInfo.table_cards[GameInfo.current_card_int]
			--local last_card = GameInfo.table_cards[GameInfo.previous_card_int]
			--print("card:  " .. last_card.filename)
			local pos_info = CheckBoard_Pos(last_card)
			local surrounding_info = GetSurrounding_Sections(pos_info[3])

			--print(table.getn(surrounding_info))

			for i = 1, table.getn(GameInfo.cards) do
				local hand_card = GameInfo.cards[i]
				if (hand_card.isVisible == true) then
					--print("checking: " .. )
					for n = 1, table.getn(surrounding_info) do
						--NEED TO LOOP THROUGH AVAILABLE POSITIONS ON THE BOARD AROUND
						--THE CURRENT CARD
						--ALSO NEEDS TO BE DONE IN ALL ROTATIONS

						--local pos_info = CheckBoard_Pos(surrounding_info[n].section)
						
						for rotation=0,-360,-90 do
							--print(rotation)
							hand_card.rotation = rotation
							local allow_placement = false
							if (surrounding_info[n].card_found == false) then
								--print("card found: " , surrounding_info[n].card_found)
								allow_placement = Check_Quad_Region(hand_card, surrounding_info[n].section, false)
								--print("SINGLE CHECK: " , allow_placement)
							end
							
							if (allow_placement == true) then
								any_allowed = true
							end
						end
						--card_count = card_count + 1
					end
				end
			end

			--print("CAN YOU PLAY A CARD?: " , any_allowed)

			if (any_allowed == false) then
				
				winner = GameInfo.current_player + 1
				if (winner > 2) then
					winner = 1
				end

				local card_info = retrieve_card(last_card.filename)

				run_popup("PLAYER " .. winner .. " WINS ROUND\nINFLICTS " .. card_info.power .. " DAMAGE")
				--GameInfo.player_list[GameInfo.current_player]
				--print("PLAYER " .. winner .. " WINS ROUND\nINFLICTS " .. card_info.power .. " DAMAGE")


				QueueMessage(
				--appWarpClient.sendUpdatePeers(
                	--tostring("MSG_CODE") .. " " ..
                    tostring("health_delay") .. " " .. 
                    tostring(-card_info.power) .. " " ..
                    tostring(0) .. " " ..
                    tostring("no") .. " " ..
                    tostring("no"))
				--GameInfo.round_damage = -card_info.power

				QueueMessage(
				--appWarpClient.sendUpdatePeers(
                	--tostring("MSG_CODE") .. " " ..
                    tostring("end_round"))
				--EndRound()
			end

		end 
	--end
	return any_allowed
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
		--print("winner: " .. GameInfo.winner)
		--print("loser: " .. GameInfo.loser)

		if (end_game == true) then
			run_popup("PLAYER " .. GameInfo.loser .. " HAS DIED.\n" .. "PLAYER " .. GameInfo.winner .. " WIN!")
		end
	end
end


function DrawDeath()


	local end_bool = false
	print("CHECKING CARDS FOR DRAW DEATH")

	if (GameInfo.end_game == false) then

	    local deck_info = GetDeck(); 
	    local suit_names = Get_SuitNames()
	    local empty_deck = ""
	    local draw_numbers = {}
		for i=1, 6 do	    
			draw_numbers[i] = 0
		end


	    for i=1, table.getn(GameInfo.player_list) do --CHECK BOTH PLAYERS

	        local user_info = GameInfo.player_list[i] --RETRIEVE THEIR CARD STATS

	        for stat=1, table.getn(user_info.character_info) do --CHECK EACH SAT

	            local card_num = user_info.character_info[stat] --GET THE NUMBER OF CARDS IT'LL DRAW

	            draw_numbers[stat] = draw_numbers[stat] + card_num --KEEP A RECORD OR THAT TOTAL CARDS WE NEED TO DRAW FROM THAT DECK

			end
		end

		for i=1, table.getn(draw_numbers) do
			print ("deck checked: " .. table.getn(deck_info[i]) .. " cards needed: " .. draw_numbers[i])
			if (table.getn(deck_info[i]) - draw_numbers[i] < 0) then --IF THAT DECK CONTAINS NO CARDS, END THE GAME
				end_bool = true;
				empty_deck = suit_names[i]
			end
		end


		if (end_bool == true) then
			Winner_Check_Lifes(empty_deck)
		end

	end

	return end_bool
end


--function DeckDeath()
--	if (GameInfo.end_game == false) then

		--CHECK THE DECKS TO SEE IF THEY'VE RUN OUT OF CARDS
--		local decks = GetDeck()
--		local suit_names = Get_SuitNames()
--		local empty_deck = ""
--		local no_cards = false
--		for i=1, 6 do
--			local deck = decks[i]
--			if (table.getn(deck) == 0) then
				--CHECK TO SEE WHO HAS THE MOST LIFE
--				no_cards = true
--				empty_deck = suit_names[i]
--			end
--		end

--		if (no_cards == true and check_decks == true) then
--			Winner_Check_Lifes(empty_deck);
--		end
--	end
--end


function Winner_Check_Lifes(empty_deck)
	local saved_health = -1
	local saved_player = -1

	for i=1, table.getn(GameInfo.player_list) do --HIGHEST LIFE WINS
		local player = GameInfo.player_list[i]
		
		if (player.health > saved_health) then
			saved_player = i
			saved_health = player.health
		elseif (player.health ~= 0 and player.health == saved_health) then --IF LIFE TOTALS ARE DRAWN
			saved_player = -1 --RESET THE WINNING PLAYER AS HEALTH SCORES ARE TIED
		end
	end				

	GameInfo.end_game = true

	if (saved_player ~= -1) then
		GameInfo.winner = saved_player
		GameInfo.loser = saved_player + 1
		if (GameInfo.loser > 2) then
			GameInfo.loser = 1
		end
		run_popup(empty_deck .. " DECK OUT OF CARDS.\n" .. "PLAYER " .. GameInfo.winner .. " WIN!")
	else
		run_popup(empty_deck .. " DECK OUT OF CARDS.\n" .. "EQUAL LIFE, GAME DRAWN")
	end

end