local function set_stats(card_info, top, bottom, left, right, arms, legs, either_limb, damage)
	card_info.top = top
	card_info.bottom = bottom
	card_info.left = left
	card_info.right = right
	card_info.arms = arms
	card_info.legs = legs
	card_info.either_limb = either_limb
	card_info.damage = damage					

	card_info.actions = {}

end 

function set_action(action_name, value)
	local action_info = {}
	action_info.name = action_name
	action_info.value = value

	return action_info
end

function retrieve_card(filename)

	local card_info = {}
	

    CheckState = switch { 
    --//////////////////////////////////////////////////////////////////
    --/////////////////////////////////WEAPONS    
    --//////////////////////////////////////////////////////////////////    
    	["w/1.png"] = function()
    			card_info.name = "backslash"
    			set_stats(card_info, 9,1,9,9,1,0,0,10)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("defender health", -1)
    		end,
    	["w/2.png"] = function()
    			card_info.name = "cleave"
    			set_stats(card_info, 0,1,9,9,2,0,0,20)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("defender health", -2)
    		end,
     	["w/3.png"] = function()
    			card_info.name = "crush"
    			set_stats(card_info, 7,3,7,7,2,0,0,10)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("defender armour", -5)
    		end,
    	["w/4.png"] = function()
    			card_info.name = "dismember"
    			set_stats(card_info, 3,1,3,1,1,0,0,10)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("defender cripple arm", 2)
    		end,
    	["w/5.png"] = function()
    			card_info.name = "morningstar"
    			set_stats(card_info, 7,4,7,7,1,0,0,15)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("defender cripple arm", 1)
       			card_info.actions[table.getn(card_info.actions) + 1] = set_action("attacker cripple leg", 1) 			
    		end,    		    		   		
    	["w/6.png"] = function()
    			card_info.name = "parry"
    			set_stats(card_info, 15,1,4,4,1,0,0,5)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("draw card", 1)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("play card", 1)
    		end,
    	["w/7.png"] = function()
    			card_info.name = "skewer"
    			set_stats(card_info, 7,2,4,4,1,0,0,20)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("defender discard", 1)
    		end,
     	["w/8.png"] = function()
    			card_info.name = "slash"
    			set_stats(card_info, 10,1,4,4,1,0,0,10)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("defender health", -1)
    		end,
    	["w/9.png"] = function()
    			card_info.name = "slice"
    			set_stats(card_info, 6,6,6,6,2,0,0,15)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("defender health", -1)
    		end,
    	["w/10.png"] = function()
    			card_info.name = "stab"
    			set_stats(card_info, 15,1,1,1,1,0,0,20)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("defender health", -2)
    		end,    		    	
    	["w/11.png"] = function()
    			card_info.name = "stiletto-knife"
    			set_stats(card_info, 3,13,3,3,0,1,0,10)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("defender health", -1)
    		end,
     	["w/12.png"] = function()
    			card_info.name = "wall-of-knives"
    			set_stats(card_info, 3,3,3,3,2,0,0,5)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("defender health", -3)
    		end,    		
    	["w/13.png"] = function()
    			card_info.name = "wall-of-blades"
    			set_stats(card_info, 5,5,5,5,2,0,0,10)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("defender health", -5)
    		end,
    	["w/14.png"] = function()
    			card_info.name = "wall-of-swords"
    			set_stats(card_info, 7,7,7,7,2,0,0,10)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("defender health", -7)
    		end,
    	["w/15.png"] = function()
    			card_info.name = "wrench"
    			set_stats(card_info, 8,1,8,1,1,0,0,10)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("defender health", -1)
    			card_info.actions[table.getn(card_info.actions) + 1] = set_action("defender armour", -5)
    		end,    		    	    		

	   	default = function () print( "ERROR - filename not within switch") end,
	}

	CheckState:case(filename)

	return card_info

end
