function Check_CheatCards(filename)

	local card_info = {}
	local return_info = {}
	return_info.found = true

    local CheckState = switch { 
    --//////////////////////////////////////////////////////////////////
    --/////////////////////////////////CHEAT
    --//////////////////////////////////////////////////////////////////    
        ["c/1.png"] = function()
                card_info.name = "shuriken"
                set_stats(card_info, 5,3,3,3,1,0,0,0,"cheat",6,1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("health", "", -9, 1)
            end,
        ["c/2.png"] = function()
                card_info.name = "weak-spot"
                set_stats(card_info, 2,2,2,2,0,0,0,0,"cheat",6,1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("next_card", "double_damage", 0, 0)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("play", "", 0, 0)
            end,
        ["c/3.png"] = function()
                card_info.name = "taunt"
                set_stats(card_info, -1,1,1,1,0,0,0,0,"cheat",6,1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("OR_discard", "", 2, 1)
                --OR DO THE FOLLOWING ACTION
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("OR_health", "", -6, 1)
            end,
        ["c/4.png"] = function()
                card_info.name = "poke-in-the-eye"
                set_stats(card_info, 4,2,2,2,1,0,0,"cheat",6,1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("life", "", -6, 1)
                end,
        ["c/5.png"] = function()
                card_info.name = "stop-hitting-yourself"
                set_stats(card_info, 5,3,3,3,0,0,0,0,"cheat",6,1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("discard", "damage", 1, 1)
                end,                
        ["c/6.png"] = function()
                card_info.name = "stabproof-vest"
                set_stats(card_info, -1,2,2,2,0,0,0,0,"cheat",6,1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("counter", "w_or_a", 0, 0)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("half_damage", "", 0, 0)
            end,
        ["c/7.png"] = function()
                card_info.name = "stubborn-mule"
                set_stats(card_info, 12,12,12,12,0,0,0,1,"cheat",6,1.5)
            end,
        ["c/8.png"] = function()
                card_info.name = "snatch"
                set_stats(card_info, 5,5,3,3,0,0,0,8,"cheat",6,2)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("steal", "", 1, 0)
            end,
        ["c/9.png"] = function()
                card_info.name = "backstab"
                set_stats(card_info, 7,5,5,5,1,0,0,10,"cheat",6,2)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("next_card", "damage", 0, 1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("play", "", 0, 0)
            end,
        ["c/10.png"] = function()
                card_info.name = "berserk"
                set_stats(card_info, 15,15,2,2,0,0,0,12,"cheat",6,2)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("health", "", -9, 1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("health", "", 10, 0)
            end,
        ["c/11.png"] = function()
                card_info.name = "copycat"
                set_stats(card_info, -1,-1,-1,-1,0,0,0,0,"cheat",6,2)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("copycat", "", 1, 0)
            end,
        ["c/12.png"] = function()
                card_info.name = "smoke-bomb"
                set_stats(card_info, 3,0,0,0,0,0,0,7,"cheat",6,2.5)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("end_round", "", 0, 0)
            end,
        ["c/13.png"] = function()
                card_info.name = "net"
                set_stats(card_info, 7,7,1,1,0,0,0,20,"cheat",6,3)
                --EXTRA LIMB NO LONGER USED
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("discard", "", 3, 1)
            end,
        ["c/14.png"] = function()
                card_info.name = "sabotage"
                set_stats(card_info, 10,10,2,2,0,0,0,10,"cheat",6,3)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("save_card", "", 1, 0)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("end_round", "", 0, 0) 
                --ALTERNATE RULES, SELECT CARD, KEEP A COPY OF THAT CARD
            end,
        ["c/15.png"] = function()
                card_info.name = "square-in-the-rocks"
                set_stats(card_info, 5,0,0,0,0,2,0,0,"cheat",6,3)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("prev_card", "damage", 0, 1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("heath", "", -7, 0)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("end_round", "", 0, 0)
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