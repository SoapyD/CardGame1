function Check_ArmourCards(filename)

	local card_info = {}
	local return_info = {}
	return_info.found = true

    local CheckState = switch { 
    --//////////////////////////////////////////////////////////////////
    --/////////////////////////////////SPEED    
    --//////////////////////////////////////////////////////////////////    
    	["a/1.png"] = function()
    			card_info.name = "battlesuit"
    			set_stats(card_info, 10,10,10,10,0,2,0,0,"armour",5)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("armour", 10, 0)
    		end,
    	["a/2.png"] = function()
    			card_info.name = "block"
    			set_stats(card_info, 10,10,5,5,0,0,1,0,"armour",5)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("block", 2, 0) --PHYSICAL				
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("block", 4, 0) --SPEED

    		end,
     	["a/3.png"] = function()
    			card_info.name = "codpiece"
    			set_stats(card_info, 6,0,0,0,0,0,0,10,"armour",5)
				--IMMUNE TO CHEAT NO LONGER USED
				card_info.actions[table.getn(card_info.actions) + 1] = set_action("armour", 5, 0)
				card_info.actions[table.getn(card_info.actions) + 1] = set_action("draw", 1, 0)
    		end,
    	["a/4.png"] = function()
    			card_info.name = "devolve"
    			set_stats(card_info, -1,-1,-1,-1,0,0,0,0,"armour",5)
				--EXTRA LIMB NO LONGER USED
				card_info.actions[table.getn(card_info.actions) + 1] = set_action("armour", 5, 0)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("draw", 1, 0)
    		end,
    	["a/5.png"] = function()
    			card_info.name = "dig-in"
    			set_stats(card_info, -1,-1,-1,-1,0,0,0,"armour",5)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("armour", 5, 0)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("play", 1, 0)
				card_info.actions[table.getn(card_info.actions) + 1] = set_action("strat_alter", 10, 0)
				end,    		    		   		
    	["a/6.png"] = function()
    			card_info.name = "entranch"
    			set_stats(card_info, -1,-1,-1,-1,0,0,0,0,"armour",5)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("draw", 2, 0)
				card_info.actions[table.getn(card_info.actions) + 1] = set_action("play", 1, 0) 
				card_info.actions[table.getn(card_info.actions) + 1] = set_action("strat_alter", 6, 0)
    		end,
    	["a/7.png"] = function()
    			card_info.name = "forge"
    			set_stats(card_info, 3,3,3,3,0,2,0,0,"armour",5)
				card_info.actions[table.getn(card_info.actions) + 1] = set_action("armour_discard", 1, 1)
    		end,
     	["a/8.png"] = function()
    			card_info.name = "juggernaut"
    			set_stats(card_info, 8,8,8,8,0,2,0,0,"armour",5)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("health", -2, 1) 
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("armour", 3, 0) 
    		end,
    	["a/9.png"] = function()
    			card_info.name = "platemail"
    			set_stats(card_info, 5,5,5,5,0,0,0,0,"armour",5)
				--IMMUNE TO WEAPONS REMOVED
				card_info.actions[table.getn(card_info.actions) + 1] = set_action("armour", 8, 0) 
				
    		end,    		    	
    	["a/10.png"] = function()
    			card_info.name = "riot_shield"
    			set_stats(card_info, -1,-1,-1,-1,0,0,0,0,"armour",5)
				--IMMUNE TO PHYSICAL REMOVED
				card_info.actions[table.getn(card_info.actions) + 1] = set_action("draw", 2, 0)
    		end,
     	["a/11.png"] = function()
    			card_info.name = "shatter"
    			set_stats(card_info, 7,7,5,5,0,0,0,5,"armour",5)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("armour", -10, 1)
				end,    		
    	["a/12.png"] = function()
    			card_info.name = "shield_bash"
    			set_stats(card_info, 2,2,2,2,1,0,0,5,"armour",5)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("armour_prev_card", -1, 0)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("end_round", 0, 0)
    		end,
    	["a/13.png"] = function()
    			card_info.name = "shrapnel"
    			set_stats(card_info, -1,-1,-1,-1,0,0,0,5,"armour",5)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("shrapnel", 0, 1)
    		end,
    	["a/14.png"] = function()
    			card_info.name = "take_cover"
    			set_stats(card_info, -1,-1,-1,-1,0,0,0,0,"armour",5)
				card_info.actions[table.getn(card_info.actions) + 1] = set_action("armour", 15, 0)
    		end,    		    	    		
        ["a/15.png"] = function()
                card_info.name = "tower_shield"
                set_stats(card_info, 10,1,10,10,1,0,0,0,"armour",5)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("block", 1, 0) --BLOCK WEAPONS 
               card_info.actions[table.getn(card_info.actions) + 1] = set_action("block", 6, 0) --BLOCK CHEAT
               card_info.actions[table.getn(card_info.actions) + 1] = set_action("armour", 5, 0)
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