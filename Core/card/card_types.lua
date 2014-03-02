
function retrieve_card(filename)

	local card_info = {}

    CheckState = switch { 
    --//////////////////////////////////////////////////////////////////
    --/////////////////////////////////WEAPONS    
    --//////////////////////////////////////////////////////////////////    
    	["w/1.png"] = function()
    			card_info.name = "backslash"
    		end,
    	["w/2.png"] = function()
    			card_info.name = "cleave"
    		end,
     	["w/3.png"] = function()
    			card_info.name = "crush"
    		end,
    	["w/4.png"] = function()
    			card_info.name = "dismember"
    		end,
    	["w/5.png"] = function()
    			card_info.name = "morningstar"
    		end,    		    		   		
    	["w/6.png"] = function()
    			card_info.name = "parry"
    		end,
    	["w/7.png"] = function()
    			card_info.name = "skewer"
    		end,
     	["w/8.png"] = function()
    			card_info.name = "slash"
    		end,
    	["w/9.png"] = function()
    			card_info.name = "slice"
    		end,
    	["w/10.png"] = function()
    			card_info.name = "stab"
    		end,    		    	
    	["w/11.png"] = function()
    			card_info.name = "stiletto-knife"
    		end,
    	["w/12.png"] = function()
    			card_info.name = "wall-of-blades"
    		end,
     	["w/13.png"] = function()
    			card_info.name = "wall-of-knives"
    		end,
    	["w/14.png"] = function()
    			card_info.name = "wall-of-swords"
    		end,
    	["w/15.png"] = function()
    			card_info.name = "wrench"
    		end,    		    	    		

	   	default = function () print( "ERROR - filename not within switch") end,
	}

	CheckState:case(filename)

	return card_info

end

