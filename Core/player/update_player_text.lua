function Run_PlayerText()
    if (table.getn(GameInfo.player_list) >= 2) then

		local p1_text = ""
		local p2_text = ""

    	--if(GameInfo.player_list[1].username == GameInfo.username) then
			--p1_text = p1_text .. "PLAYER1:"
			local health = "" .. GameInfo.player_list[1].health
			local armour = "" .. GameInfo.player_list[1].armour
			local arms = "" .. GameInfo.player_list[1].arms
			local legs = "" .. GameInfo.player_list[1].legs
		    --GameInfo.print_string = GameInfo.print_string .. "\nHP:" .. health .. " AR:" ..armour
		    --GameInfo.print_string = GameInfo.print_string .. "\nA:" .. arms .. " L:" .. legs  
		    p1_text = p1_text .. " HP:" .. health .. " AR:" ..armour
		    p1_text = p1_text .. " A:" .. arms .. " L:" .. legs

		--else

			--p2_text = p2_text .. "PLAYER2:"
			health = "" .. GameInfo.player_list[2].health
			armour = "" .. GameInfo.player_list[2].armour
			arms = "" .. GameInfo.player_list[2].arms
			legs = "" .. GameInfo.player_list[2].legs
		    --GameInfo.print_string = GameInfo.print_string .. "\nHP:" .. health .. " AR:" ..armour
		    --GameInfo.print_string = GameInfo.print_string .. "\nA:" .. arms .. " L:" .. legs  
		    p2_text = p2_text .. " HP:" .. health .. " AR:" ..armour
		    p2_text = p2_text .. " A:" .. arms .. " L:" .. legs		
		--end

		if(GameInfo.player_list[1].username == GameInfo.username) then
			GameInfo.print_string = "You: " .. p1_text
			GameInfo.print_string2 = "Enemy: " .. p2_text
		else
			GameInfo.print_string = "You: " .. p2_text
			GameInfo.print_string2 = "Enemy: " .. p1_text
		end
	end
end