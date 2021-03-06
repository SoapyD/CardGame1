function Check_SpeedCards(filename)

	local card_info = {}
	local return_info = {}
	return_info.found = true

    local CheckState = switch { 
    --//////////////////////////////////////////////////////////////////
    --/////////////////////////////////SPEED    
    --//////////////////////////////////////////////////////////////////    
        ["s/1.png"] = function()
                card_info.name = "flurry"
                set_stats(card_info, 4,4,2,1,0,0,0,0,"speed",4,1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("discard", "flurry", -3, 0) 
            end,
        ["s/2.png"] = function()
                card_info.name = "dash"
                set_stats(card_info, 4,4,2,1,0,2,0,0,"speed",4,1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("draw", "", 2, 0)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("play", "", 1, 0) 
            end,
        ["s/3.png"] = function()
                card_info.name = "sidestep"
                set_stats(card_info, 4,4,2,1,0,2,0,0,"speed",4,1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("counter", "", 1, 0)
            end,
        ["s/4.png"] = function()
                card_info.name = "adrenaline-rush"
                set_stats(card_info, 4,4,2,1,0,0,0,0,"speed",4,1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("arm", "", 2, 0)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("leg", "", 2, 0)  
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("draw", "", 1, 0)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("play", "", 1, 0) 
            end,
        ["s/5.png"] = function()
                card_info.name = "trip"
                set_stats(card_info, 4,4,2,1,0,0,1,0,"speed",4,1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("health", "", -3, 1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("armour", "", -10, 1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("discard", "", 1, 1)
            end,
        ["s/6.png"] = function()
                card_info.name = "flying-leap"
                set_stats(card_info, 4,4,2,1,0,2,0,0,"speed",4,1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("discard", "damage", 1, 0) 
            end,
        ["s/7.png"] = function()
                card_info.name = "dodge"
                set_stats(card_info, 4,4,2,1,0,0,0,0,"speed",4,1.5)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("steal", "", 1, 1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("play", "", 1, 0) 
            end,
        ["s/8.png"] = function()
                card_info.name = "feint"
                set_stats(card_info, 4,2,4,2,0,0,1,3,"speed",4,2)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("discard", "", 1, 1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("draw", "", 2, 0)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("play", "", 1, 0) 
            end,
        ["s/9.png"] = function()
                card_info.name = "accelerate"
                set_stats(card_info, 4,2,4,2,0,2,0,1,"speed",4,2)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("draw", "", 4, 0)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("discard", "", 3, 0)
            end,
        ["s/10.png"] = function()
                card_info.name = "stamp"
                set_stats(card_info, 4,2,4,2,0,1,0,5,"speed",4,2)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("draw", "", 1, 0)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("limb", "", -1, 0)
                end,            
        ["s/11.png"] = function()
                card_info.name = "vanish"
                set_stats(card_info, 4,2,4,2,0,1,0,0,"speed",4,2)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("next_round", "draw", 0, -1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("end_round", "", 0, -1)
                end,
        ["s/12.png"] = function()
                card_info.name = "stun"
                set_stats(card_info, 4,2,4,2,0,0,1,6,"speed",4,2.5)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("next_round", "discard", 1, -1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("end_round", "", 0, -1)
            end,
        ["s/13.png"] = function()
                card_info.name = "disarm"
                set_stats(card_info, 4,4,4,4,2,0,0,19,"speed",4,3)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("steal", "", 1, 1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("discard", "", 1, 1)
                end,                                
        ["s/14.png"] = function()
                card_info.name = "opportunity-attack"
                set_stats(card_info, 4,4,4,4,0,0,1,21,"speed",4,3)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("win_faceoff", "", 0, 0)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("no_counter", "", 0, 0)
            end,
        ["s/15.png"] = function()
                card_info.name = "ace-in-the-hole"
                set_stats(card_info, 4,4,4,4,0,0,0,5,"speed",4,3)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("armour", "", 5, 0)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("draw", "", 3, 0)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("play", "", 1, 0) 
            end,

        default = function () 
            --print( "ERROR - filename not within speed") 
            return_info.found = false
            end,
	}

	CheckState:case(filename)

	return_info.card_info = card_info
	return return_info

end