--local quads = {};
function Check_Quad_Region(current_card, search_section)

	local pos_num = 1
	local current_info = retrieve_card(current_card.filename)
    local allow_placement = true

    local touch_count = 0
    local current_check = false


    if (table.getn(GameInfo.quads) > 0) then

    	for y = -1, 1 do
    		for x = -1, 1 do
    			if ( x == 0 and (y == -1 or y == 1)) or
    			( y == 0 and (x == -1 or x == 1)) then
    				local check_pos = search_section
    				check_pos = check_pos + x
    				check_pos = check_pos + (y * GameInfo.world_width)

                    local return_info = {}
                    local search_quad = {}
                    search_quad.section_num = check_pos
                    return_info = Quad_Check(GameInfo.quads, search_quad)

                    local direction = -1
                    if (x == 0 and y == -1) then
                        direction = 1
                    end
                    if (x == 0 and y == 1) then
                        direction = 3
                    end
                    if (y == 0 and x == -1) then
                        direction = 4
                    end
                    if (y == 0 and x == 1) then
                        direction = 2
                    end

                    if (return_info[2] == -1) then
                         --print("no card, " .. direction)
                    else
                    	local quad = GameInfo.quads[return_info[2]]
                        local surrounding_info = retrieve_card(quad.filename)

                        local temp_allow = compare_card_info(direction, current_card, current_info,
                            quad, surrounding_info)

                        if ( temp_allow == false) then
                            allow_placement = false
                        end

                        print("previous:" .. GameInfo.previous_card_int)
                        if (quad.unique_id ==
                            GameInfo.table_cards[GameInfo.previous_card_int].unique_id) then
                            current_check = true
                        end
                        touch_count = touch_count + 1
                    end
    				pos_num = pos_num + 1
    			end
    		end
    	end
    end

    --CHECK TO SEE THAT THE CARD IS CONNECTED TO OTHER CARDS
    if ( touch_count == 0 and table.getn(GameInfo.quads) > 0) then
            allow_placement = false
    end

    if (current_check == false and table.getn(GameInfo.quads) > 0) then
        allow_placement = false
    end


    if ( allow_placement == true) then
        finalise_button.isVisible = true
    else
        finalise_button.isVisible = false
    end

end


function compare_card_info(clash_dir, current_card, current_info, quad, surrounding_info)

    local current_add = 0

    --Get the clash location on the opposite card
    local opp_strat = 0
    if ( clash_dir == 1) then
        opp_strat = 3
    end
    if ( clash_dir == 3) then
        opp_strat = 1
    end
    if ( clash_dir == 2) then
        opp_strat = 4
    end
    if ( clash_dir == 4) then
        opp_strat = 2
    end

    --get the rotation offset of the opposite card
    if ( quad.rotation == 0) then
        current_add = 0
    end    
    if ( quad.rotation == -90) then
        current_add = 1
    end
    if ( quad.rotation == -270) then
        current_add = 3
    end
    if ( quad.rotation == -180) then
        current_add = 2
    end 

    opp_strat = opp_strat + current_add
    if ( opp_strat > 4) then
        opp_strat = opp_strat - 4
    end


    --create an offset value for the current card's rotation
    if ( current_card.rotation == 0) then
        current_add = 0
    end    
    if ( current_card.rotation == -90) then
        current_add = 1
    end
    if ( current_card.rotation == -270) then
        current_add = 3
    end
    if ( current_card.rotation == -180) then
        current_add = 2
    end    

    --get the action clashing strat of the current card
    clash_dir = clash_dir + current_add

    local current_strat = 0
    current_strat = current_strat + clash_dir
    if ( current_strat > 4) then
        current_strat = current_strat - 4
    end

    --print("current_strat:" .. current_strat .. " add" .. current_add
    --    .. " opp_strat:" .. opp_strat)

    local current_val = current_info.strat_scores[current_strat]
    local opposite_val = surrounding_info.strat_scores[opp_strat]

    local return_info = false

    if (current_val >= opposite_val) then
        print("placement available, curr:" .. current_val .. ", opp:" .. opposite_val)
        return_info = true
    --else
    --    print("CAN'T PLACE")
    end

    return return_info

end
