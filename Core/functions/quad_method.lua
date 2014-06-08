
function Quad_Add(quads, search_quad)

	quad_pos = -1

	if ( table.getn(quads) == 0 ) then --add it if there's no other quads
	   	quad_pos = 1
	   	quads[quad_pos] = search_quad
	    --print("val " .. search_quad.section_num .. " start")
	else
	    local value_added = false

		if (search_quad.section_num > quads[table.getn(quads)].section_num) then --add the card if it's larger than the list end
			quad_pos = table.getn(quads) + 1
			quads[quad_pos] = search_quad
			value_added = true
			--print("val " .. search_quad.section_num .. " added to end")
		end
		if (search_quad.section_num < quads[1].section_num) then --add the card if it's smaller than the list beginning
			quad_pos = 1
			table.insert(quads, quad_pos, search_quad)
			value_added = true
			--print("val " .. search_quad.section_num .. " inserted onto start")
		end

		if ( value_added == false) then
		    local return_info = {}
			return_info = Quad_Check(GameInfo.quads, search_quad)
			--found_bool = true, found_quad = no quad found
			if (return_info[1] == true and return_info[2] == -1) then
				quad_pos = return_info[5] + 1
				table.insert(quads, quad_pos, search_quad)
				--print("val " .. search_quad.section_num .. " sorted")
				--print("current " .. quads[return_info[5]] .. "|| next " .. quads[return_info[5]+1])
			else
                print("QUAD ALREADY EXISTS!!!!!!!!")
            end
		end
	end

	return quad_pos
end


--function Quad_Remove(quads, search_quad)
function Quad_Remove(quads, search_quad)

    for i = 1, table.getn(GameInfo.quads) do
        local quad = GameInfo.quads[i]
        --print("quad: " .. i .. " section: " .. quad.section_num .. " filename: " .. quad.filename)
    end

    local return_info = {}
    return_info = Quad_Check(GameInfo.quads, search_quad)
    if (return_info[1] == true and return_info[2] == -1) then

    else
        quad_pos = return_info[2]
        table.remove(quads, quad_pos)
        --print("quad pos!!!!!!!!:   " .. quad_pos .. " search_quad: " .. search_quad.section_num)
    end

    for i = 1, table.getn(GameInfo.quads) do
        local quad = GameInfo.quads[i]
        --print("quad: " .. i .. " section: " .. quad.section_num .. " filename: " .. quad.filename)
    end

end


function Quad_Check(quads, search_val)

local return_info = {}

	local min_height = -1
	local max_height = -1
	local found_quad = -1
	local found_bool = false
	local pos_before = -1

    local run_loop = true
    local count = 0
    list_length = table.getn(quads)
    min_height = 1
    max_height = list_length

    local band_1 = -1
    local band_2 = -1
    local band_3 = -1
    local band_4 = -1             
    local saved_min = -1
    local saved_max = -1 

    while run_loop == true do

    	--SET THE VALUES OF THE BAND NUMBERS, NOT WHATS BEING CHECKED AGAINST
    	local band_size = math.round((max_height - min_height) / 4)
    	band_1 = min_height
    	band_2 = (band_size * 2) + min_height
    	if( band_2 > max_height) then
    		band_2 = max_height
    	end
    	band_3 = (band_size * 3) + min_height
    	if( band_3 > max_height) then
    		band_3 = max_height
    	end    	
    	band_4 = max_height

    	--print("band_size: " .. band_size)
    	--print("band#1: " .. band_1 .. " || value: " .. quads[band_1].section_num)
    	--print("band#2: " .. band_2 .. " || value: " .. quads[band_2].section_num)
    	--print("band#3: " .. band_3 .. " || value: " .. quads[band_3].section_num)
    	--print("band#4: " .. band_4 .. " || value: " .. quads[band_4].section_num)    	    	    	
    	--print("--------------------------------------------") 

    	--EXACT VALUE CHECKS
    	if (search_val.section_num == quads[band_1].section_num) then
    		found_quad = band_1
    	end 
    	if (search_val.section_num == quads[band_2].section_num) then
    		found_quad = band_2
    	end 
    	if (search_val.section_num == quads[band_3].section_num) then
    		found_quad = band_3
    	end 
     	if (search_val.section_num == quads[band_4].section_num) then
    		found_quad = band_4
    	end    	    	
        --print("section_num: " .. search_val.section_num .. " || quad: " .. quads[band_4].section_num)
        --print("found: " .. found_quad)
    	--BETWEEN-THE-BANDS CHECK
    	if (search_val.section_num > quads[band_1].section_num and 
    		search_val.section_num < quads[band_2].section_num) then
    		min_height = band_1
    		max_height = band_2
    	end
    	if (search_val.section_num > quads[band_2].section_num and 
    		search_val.section_num < quads[band_3].section_num) then
    		min_height = band_2
    		max_height = band_3
    	end
    	if (search_val.section_num > quads[band_3].section_num and 
    		search_val.section_num < quads[band_4].section_num) then
    		min_height = band_3
    		max_height = band_4
    	end	


    	--if search val is lower than band1
    	--if search val is higher than band4    	

    	if ( found_quad ~= -1) then
    		--print("quad found: " .. found_quad .. " in " .. count .. " passes")
    		run_loop = false
    		found_bool = true
    	end

    	if ( found_quad == -1) then
    		--THIS REGISTERS IF THERE NEEDS TO BE A QUAD INSERTED BETWEEN TWO OTHERS
	    	if (saved_min == min_height and saved_max == max_height) then
	    		--print("quads exhausted:")
	    		--print("between: " .. min_height .. " and " .. max_height  .. " in " .. count .. " passes")
	    		for i = min_height, max_height do
	    			if (search_val.section_num == quads[i].section_num) then
	    				found_quad = i
	    			end
	    			if (search_val.section_num > quads[i].section_num) then
	    				pos_before = i
	    			end	    			
	    		end
	    		--print("found_quad:" .. found_quad)
	    		--print("pos_before:" .. pos_before)
	    		run_loop = false
	    		found_bool = true
	    	end
    	end

    	saved_min = min_height
    	saved_max = max_height

    	if (count >= 500) then
    		run_loop = false
    	end

    	if ( run_loop == false) then
    		return_info[1] = found_bool --Whether two quads where found on either side of the search pos
    		return_info[2] = found_quad --whether the search quad itself was already in the quad
    		return_info[3] = min_height --the upper bound
    		return_info[4] = max_height --the lower bound
    		return_info[5] = pos_before --the last quad, between the bounds, that was lower than the search. needed for inserts 
        end

    	count = count + 1
    end

    return return_info

end