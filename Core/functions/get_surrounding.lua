cAllSurrounding_Info=setclass("AllSurrounding_Info")

function cAllSurrounding_Info.methods:init() 
    self.section = -1
    self.card_found = false
    self.quad = {}
    self.card = {}
end

--local AllSurrounding_Info = cAllSurrounding_Info:new()

function GetSurrounding_Sections(search_section)

	local AllSurrounding_Info = {}

	local pos = 1
	--print(search_section .. " quads " .. table.getn(GameInfo.quads))

    if (table.getn(GameInfo.quads) > 0) then

        for y = -1, 1 do
        	for x = -1, 1 do
        		if ( x == 0 and (y == -1 or y == 1)) or
        		( y == 0 and (x == -1 or x == 1)) then

        			local Temp_Surrounding = cAllSurrounding_Info:new()

        			local check_pos = search_section
        			check_pos = check_pos + x
        			check_pos = check_pos + (y * GameInfo.world_width)
        			--print(check_pos)

        			--SET ALL THE INFO TO BE PASSED BACK
        			Temp_Surrounding.section = check_pos
                    Temp_Surrounding.card_found = false
        			Temp_Surrounding.quad = {}
        			Temp_Surrounding.card = {}

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

		    			Temp_Surrounding.quad = quad
		    			Temp_Surrounding.card = surrounding_info
                        Temp_Surrounding.card_found = true
                    end

                    AllSurrounding_Info[pos] = Temp_Surrounding

                    add = "true"
                    if (Temp_Surrounding.card_found == false) then
                        add = "false"
                    end
                    --print_string = "section: " .. Temp_Surrounding.section
                    --print_string = print_string .. "found: " .. add
                    --print_string = print_string .. "quad: " .. Temp_Surrounding.quad.filename
                    --print_string = print_string .. "card: " .. Temp_Surrounding.card
                    --print(print_string)

                    pos = pos + 1
                end
            end
        end
    end

    --print(table.getn(AllSurrounding_Info))
    return AllSurrounding_Info
    --1 = SECTION_NUM
    --2 = QUAD
    --3 = CARD

end