--local quads = {};
function Check_Quad_Region(current_card, search_section, check_positioning)

	local pos_num = 1
	local current_info = retrieve_card(current_card.filename)
    local allow_placement = true

    local touch_count = 0
    local current_check = false

    if (check_positioning == true) then
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
                             print("no card, " .. direction)
                        else
                        	local quad = GameInfo.quads[return_info[2]]
                            local surrounding_info = retrieve_card(quad.filename)

                            local temp_allow = compare_card_info(direction, current_card, current_info,
                                quad, surrounding_info)

                            if ( temp_allow == false) then
                                run_popup("Can't use card, strat points not high enough")
                                allow_placement = false
                            end

                            --print("card at x: " .. x .. " y:" .. y)
                            --print("previous:" .. GameInfo.previous_card_int)
                            print("quad id: " .. quad.unique_id)

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
            run_popup("Not touching other cards.")
        end

        if (current_check == false and table.getn(GameInfo.quads) > 0) then
            allow_placement = false
            run_popup("Not touching the last card placed. Prev: " .. GameInfo.previous_card_int)
        end
    else
        --if (table.getn(GameInfo.quads) > 0) then
        --    local prev_card = GameInfo.table_cards[GameInfo.previous_card_int]
        --    local prev_info = retrieve_card(prev_card.filename)

        --    local highest_current = 0
        --    for n=1, table.getn(current_info.strat_scores) do
        --        if ( highest_current < current_info.strat_scores[n]) then
        --            highest_current = current_info.strat_scores[n]
        --        end 
        --    end
        --    local highest_prev = 0
        --    for n=1, table.getn(prev_info.strat_scores) do
        --        if ( highest_prev < prev_info.strat_scores[n]) then
        --            highest_prev = prev_info.strat_scores[n]
        --        end 
        --    end
        --    if (highest_current >= highest_prev) then
        --        allow_placement = true
        --        run_popup("Card card be placed next to previous card")
        --    else
        --        allow_placement = false
        --    end
        --end        
    end

    --CHECK LIMBS TO MAKE SURE THE CARD CAN BE PLACED
    local current_player = GetPlayer()
    if (current_info.arms > current_player.arms) then
        run_popup("Can't use card, need " .. current_info.arms .. " arm/s.")
        allow_placement = false
    end
    if (current_info.legs > current_player.legs) then
        run_popup("Can't use card, need " .. current_info.legs .. " leg/s.")
        allow_placement = false
    end
    

    if (GameInfo.previous_card_int ~= -1) then
        --Check to see if the attacking card type is blocked
        local last_card_info = GameInfo.table_cards[GameInfo.previous_card_int]
        local last_card = retrieve_card(last_card_info.filename)
        --print("file name: " .. last_card_info.filename .. " size: " .. table.getn(last_card.actions))

        if (table.getn(last_card.actions) > 0) then
            for n=1 , table.getn(last_card.actions) do
                if (last_card.actions[n].name == "block") then
                    --print("card with block")
                    if (current_info.card_value == last_card.actions[n].value) then
                        allow_placement = false
                        --print(current_info.card_type .. " card type block")
                        run_popup("Can't use card, card type blocked.")
                    end
                end
            end
        end
    end
    print("placement: " , allow_placement)
    if ( allow_placement == true) then
        finalise_button.isVisible = true
        finalise_button.text.isVisible = true    
        clear_popup()
    else
        finalise_button.isVisible = false
        finalise_button.text.isVisible = false
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

    if (quad.passed_ability == "strat_alter") then
        --print("this value has been passed: " .. quad.passed_value)
        opposite_val = quad.passed_value
    end 

    local return_info = false

    if (current_val >= opposite_val or current_val == -1 or opposite_val == -1) then
        --print("placement available, curr:" .. current_val .. ", opp:" .. opposite_val)
        return_info = true
    --else
    --    print("CAN'T PLACE")
    end

    return return_info

end
