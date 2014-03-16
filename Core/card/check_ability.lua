

function CheckAbility()

    CheckState = switch { 
    	["health"] = ,
   		["armour"] = , 
    	["cripple arm"] = ,
    	["cripple leg"] = , 
    	["draw card"] = run_main_loop,
    	["play card"]

	   	default = function () print( "ERROR - ability not within switch") end,
	}

	CheckState:case(GameInfo.gamestate)

end


function mod_health()

end