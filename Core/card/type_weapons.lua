function Check_WeaponCards(filename)

	local card_info = {}
	local return_info = {}
	return_info.found = true

    local CheckState = switch { 
    --//////////////////////////////////////////////////////////////////
    --/////////////////////////////////WEAPONS    
    --//////////////////////////////////////////////////////////////////    
    	["w/1.png"] = function()
    			card_info.name = "backslash"
    			set_stats(card_info, 9,1,9,9,1,0,0,10,"weapon",1)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("health", -1, 1)
    		end,
    	["w/2.png"] = function()
    			card_info.name = "cleave"
    			set_stats(card_info, 9,2,9,9,1,0,0,20,"weapon",1)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("health", -2, 1)
    		end,
     	["w/3.png"] = function()
    			card_info.name = "crush"
    			set_stats(card_info, 7,3,7,7,2,0,0,10,"weapon",1)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("armour", -5, 1)
    		end,
    	["w/4.png"] = function()
    			card_info.name = "dismember"
    			set_stats(card_info, 3,1,3,1,1,0,0,10,"weapon",1)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("arm", -2, 1)
    		end,
    	["w/5.png"] = function()
    			card_info.name = "morningstar"
    			set_stats(card_info, 7,4,7,7,1,0,0,15,"weapon",1)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("arm", -1, 1)
       			card_info.actions[table.getn(card_info.actions) + 1] = set_action("leg", -1, 0) 			
    		end,    		    		   		
    	["w/6.png"] = function()
    			card_info.name = "parry"
    			set_stats(card_info, 15,1,4,4,1,0,0,5,"weapon",1)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("draw", 1, 1)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("play", 1, 0)
    		end,
    	["w/7.png"] = function()
    			card_info.name = "skewer"
    			set_stats(card_info, 7,2,4,4,1,0,0,20,"weapon",1)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("discard", 1, 1)
    		end,
     	["w/8.png"] = function()
    			card_info.name = "slash"
    			set_stats(card_info, 10,1,4,4,1,0,0,10,"weapon",1)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("health", -1, 1)
    		end,
    	["w/9.png"] = function()
    			card_info.name = "slice"
    			set_stats(card_info, 6,6,6,6,2,0,0,15,"weapon",1)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("health", -1, 1)
    		end,
    	["w/10.png"] = function()
    			card_info.name = "stab"
    			set_stats(card_info, 15,1,1,1,1,0,0,20,"weapon",1)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("health", -2, 1)
    		end,    		    	
    	["w/11.png"] = function()
    			card_info.name = "stiletto-knife"
    			set_stats(card_info, 3,13,3,3,0,1,0,10,"weapon",1)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("health", -1, 1)
    		end,
     	["w/12.png"] = function()
    			card_info.name = "wall-of-knives"
    			set_stats(card_info, 3,3,3,3,2,0,0,5,"weapon",1)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("health", -3, 1)
    		end,    		
    	["w/13.png"] = function()
    			card_info.name = "wall-of-blades"
    			set_stats(card_info, 5,5,5,5,2,0,0,10,"weapon",1)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("health", -5, 1)
    		end,
    	["w/14.png"] = function()
    			card_info.name = "wall-of-swords"
    			set_stats(card_info, 7,7,7,7,2,0,0,10,"weapon",1)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("health", -7, 1)
    		end,
    	["w/15.png"] = function()
    			card_info.name = "wrench"
    			set_stats(card_info, 8,1,8,1,1,0,0,10,"weapon",1)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("health", -1, 1)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("armour", -5, 1)
    		end,    		    	    		

	   	default = function () 
	   		--print( "ERROR - filename not within weapons") 
	   		return_info.found = false
	   		end,
	}

	CheckState:case(filename)

	return_info.card_info = card_info
	return return_info

end