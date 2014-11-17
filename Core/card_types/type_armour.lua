function Check_ArmourCards(filename)

	local card_info = {}
	local return_info = {}
	return_info.found = true

    local CheckState = switch { 
    --//////////////////////////////////////////////////////////////////
    --/////////////////////////////////ARMOUR    
    --//////////////////////////////////////////////////////////////////    
        ["a/1.png"] = function()
                card_info.name = "occularium"
                set_stats(card_info, 3,3,2,4,1,0,0,0,"armour",5,1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("block", "", 1, 0) --BLOCK WEAPONS 
               card_info.actions[table.getn(card_info.actions) + 1] = set_action("block", "", 5, 0) --BLOCK CHEAT
               card_info.actions[table.getn(card_info.actions) + 1] = set_action("armour", "", 5, 0)
            end,
        ["a/2.png"] = function()
                card_info.name = "honour of steele"
                set_stats(card_info, 3,3,2,4,0,0,1,0,"armour",5,1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("block", "", 5, 0) --CHEAT
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("block", "", 4, 0) --SPEED
               card_info.actions[table.getn(card_info.actions) + 1] = set_action("armour", "", 5, 0)
                end,
        ["a/3.png"] = function()
                card_info.name = "trample"
                set_stats(card_info, 3,3,2,4,0,2,0,0,"armour",5,1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("health", "", -3, 1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("armour", "", 5, 0)
                end,
        ["a/4.png"] = function()
                card_info.name = "staunch"
                set_stats(card_info, 3,3,2,4,0,0,0,0,"armour",5,1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("block", "", 1, 0) --WEAPONS
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("block", "", 2, 0) --PHYSICAL
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("health", "", 10, 0)
            end,
        ["a/5.png"] = function()
                card_info.name = "shatter"
                set_stats(card_info, 3,3,2,4,0,0,0,0,"armour",5,1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("armour", "", -10, 1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("discard", "", 1, 1)
                end,
        ["a/6.png"] = function()
                card_info.name = "primal rage"
                set_stats(card_info, 3,3,2,4,0,0,1,0,"armour",5,1)
                --EXTRA LIMB NO LONGER USED
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("block", "", 1, 0) --WEAPONS
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("block", "", 3, 0) --FOCUS
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("draw", "", 1, 0)
            end,
        ["a/7.png"] = function()
                card_info.name = "fortify"
                set_stats(card_info, 3,3,2,4,0,0,0,0,"armour",5,1.5)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("draw", "", 1, 0)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("play", "", 1, 0) 
                --card_info.actions[table.getn(card_info.actions) + 1] = set_action("strat_alter", "", 6, 0)
            end,
                
        ["a/8.png"] = function()
                card_info.name = "take_cover"
                set_stats(card_info, 3,2,3,2,0,0,0,1,"armour",5,2)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("armour", "", 15, 0)
            end,
        ["a/9.png"] = function()
                card_info.name = "onslaught"
                set_stats(card_info, 3,2,3,2,0,0,0,6,"armour",5,2)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("health", "", -6, 1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("armour", "", 5, 0) 
            end,
        ["a/10.png"] = function()
                card_info.name = "can_up!"
                set_stats(card_info, 3,2,3,2,0,2,0,5,"armour",5,2)
                --IMMUNE TO PHYSICAL REMOVED
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("health", "", -3, 1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("armour", "", 10, 0) 
            end,
        ["a/11.png"] = function()
                card_info.name = "shrapnel"
                set_stats(card_info, 3,2,3,2,0,0,0,3,"armour",5,2)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("shrapnel", "", 0, 1)
            end,
        ["a/12.png"] = function()
                card_info.name = "dig-in"
                set_stats(card_info, 3,2,3,2,0,0,4,"armour",5,2.5)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("armour", "", 10, 0)
                --card_info.actions[table.getn(card_info.actions) + 1] = set_action("strat_alter", "", 10, 0)
                end,
                
        ["a/13.png"] = function()
                card_info.name = "juggernaut"
                set_stats(card_info, 3,3,3,3,0,2,0,6,"armour",5,3)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("health", "", -6, 1) 
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("armour", "", 10, 0) 
            end,
        ["a/14.png"] = function()
                card_info.name = "forge"
                set_stats(card_info, 3,3,3,3,0,2,0,4,"armour",5,3)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("discard", "armour", 1, 0)
            end,
        ["a/15.png"] = function()
                card_info.name = "brutality"
                set_stats(card_info, 3,3,3,3,1,0,0,6,"armour",5,3.5)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("prev_card", "armour", -1, 0)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("end_round", "", 0, -1)
            end,
        default = function () 
            --print( "ERROR - filename not within physical") 
            return_info.found = false
            end,
	}

	CheckState:case(filename)

	return_info.card_info = card_info
	return return_info

end