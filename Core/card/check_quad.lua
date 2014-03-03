--local quads = {};
function Check_Quad_Region(current_card, search_section)

	local pos_num = 1
	local current_info = retrieve_card(current_card.filename)

    if (table.getn(GameInfo.quads) > 0) then

    	for y = -1, 1 do
    		for x = -1, 1 do
    			if ( x == 0 and (y == -1 or y == 1)) or
    			( y == 0 and (x == -1 or x == 1)) then
    				local check_pos = search_section
    				check_pos = check_pos + x
    				check_pos = check_pos + (y * GameInfo.world_width)
    				--print("check pos" .. pos_num .. ":" .. check_pos)

                    local return_info = {}
                    local search_quad = {}
                    search_quad.section_num = check_pos
                    return_info = Quad_Check(GameInfo.quads, search_quad)

                    local direction = -1
                    if (x == 0 and y == -1) then
                        --direction = "top"
                        direction = 1
                    end
                    if (x == 0 and y == 1) then
                        --direction = "bottom"
                        direction = 4
                    end
                    if (y == 0 and x == -1) then
                        --direction = "left"
                        direction = 2
                    end
                    if (y == 0 and x == 1) then
                        --direction = "right"
                        direction = 3
                    end

                    if (return_info[2] == -1) then
                         --print("no card, " .. direction)
                    else
                    	local quad = GameInfo.quads[return_info[2]]
                        local surrounding_info = retrieve_card(quad.filename)
                        --print(direction .. ", card:" .. card_info.name)
                        --print("current rotation:" .. current_card.rotation 
                        --	.. " quad card rotation" .. quad.rotation)

                        compare_card_info(direction, current_card, current_info,
                            quad, surrounding_info)
                    end
    				pos_num = pos_num + 1
    			end
    		end
    	end
    end

end


function compare_card_info(clash_dir, current_card, current_info, quad, surrounding_info)

    local current_strat = 0
    current_strat = current_strat + clash_dir
    if ( current_strat > 4) then
        current_strat = current_strat - 4
    end

    local current_add = 0
    if ( current_card.rotation == 0) then
        current_add = 1
    end    
    if ( current_card.rotation == -90) then
        current_add = 2
    end
    if ( current_card.rotation == -270) then
        current_add = 3
    end
    if ( current_card.rotation == -180) then
        current_add = 4
    end    

    local opp_strat = 5 - clash_dir

    --print("current rotation:" .. current_card.rotation)
    print("current_strat:" .. current_strat .. " add" .. current_add
        .. " opp_strat:" .. opp_strat)

end
