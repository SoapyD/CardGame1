function Check_PhysicalCards(filename)

	local card_info = {}
	local return_info = {}
	return_info.found = true

    local CheckState = switch { 
    --//////////////////////////////////////////////////////////////////
    --/////////////////////////////////WEAPONS    
    --//////////////////////////////////////////////////////////////////    
    	["p/1.png"] = function()
    			card_info.name = "bash"
    			set_stats(card_info, 8,4,5,5,1,0,0,10,"physical")
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("limb", -1, 1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("block_focus", 0, 1)
    		end,
    	["p/2.png"] = function()
    			card_info.name = "batter"
    			set_stats(card_info, 5,2,3,3,1,0,0,5,"physical")
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("discard", 2, 1)
    		end,
     	["p/3.png"] = function()
    			card_info.name = "body-slam"
    			set_stats(card_info, 4,4,4,4,2,2,0,10,"physical")
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("end round", 0, 1)
    		end,
    	["p/4.png"] = function()
    			card_info.name = "deadly-punch"
    			set_stats(card_info, 10,1,7,7,1,0,0,15,"physical")
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("limb", -1, 1)
    		end,
    	["p/5.png"] = function()
    			card_info.name = "dive"
    			set_stats(card_info, 8,8,1,1,0,1,0,5,"physical")
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("draw", 1, 1)
       			card_info.actions[table.getn(card_info.actions) + 1] = set_action("play", 1, 0) 			
    		end,    		    		   		
    	["p/6.png"] = function()
    			card_info.name = "double-kick"
    			set_stats(card_info, 2,16,6,6,0,2,0,15,"physical")
    		end,
    	["p/7.png"] = function()
    			card_info.name = "double-punch"
    			set_stats(card_info, 12,5,5,5,2,0,0,15,"physical")
    		end,
     	["p/8.png"] = function()
    			card_info.name = "headbutt"
    			set_stats(card_info, 20,2,2,2,0,0,0,20,"physical")
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("block_physical", 0, 1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("block_focus", 0, 1)
    		end,
    	["p/9.png"] = function()
    			card_info.name = "hold"
    			set_stats(card_info, 5,3,5,5,2,0,0,10,"physical")
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("block_speed", 0, 1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("block_focus", 0, 1)
    		end,
    	["p/10.png"] = function()
    			card_info.name = "kick"
    			set_stats(card_info, 2,10,10,10,0,1,0,10,"physical")
    		end,    		    	
    	["p/11.png"] = function()
    			card_info.name = "punch"
    			set_stats(card_info, 8,8,8,8,1,0,0,10,"physical")
    		end,
     	["p/12.png"] = function()
    			card_info.name = "roundhouse-ick"
    			set_stats(card_info, 5,15,5,5,0,2,0,15,"physical")
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("discard", 1, 1)
    		end,    		
    	["p/13.png"] = function()
    			card_info.name = "suplex"
    			set_stats(card_info, 8,8,8,8,2,2,0,15,"physical")
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("armour", -5, 1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("block_physical", 0, 1)
                card_info.actions[table.getn(card_info.actions) + 1] = set_action("block_weapons", 0, 1)    
    		end,
    	["p/14.png"] = function()
    			card_info.name = "sweep"
    			set_stats(card_info, 3,7,5,5,0,1,0,10,"physical")
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("discard", 1, 1)
    		end,
    	["p/15.png"] = function()
    			card_info.name = "throw"
    			set_stats(card_info, 5,3,5,5,2,0,0,13,"physical")
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("draw", 1, 1)
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