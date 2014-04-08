--THIS IS A TEST TO SEE IF THE SYNC WORKS

require("Core.functions.INC_Class")
require("Core.functions.statements")
require("Core.functions.core_functions")
require("Core.functions.quad_method")
require("Core.functions.colors-rgb")
require("Core.functions.end_turn_functions")

require("Core.class")

GameInfo = cGameInfo:new(0)

require("Core.player.character_classes")
require("Core.player.player_setup")
require("main_setup")
require("main_loop")
require("Core.button.button_functions")
require("Core.button.button_setup")
require("Core.button.button_loop")
require("Core.card.action_functions")
require("Core.card.card_functions")
require("Core.card.check_quad")
require("Core.card.check_ability")
require("Core.card.card_types")
require("Core.card.type_weapons")
require("Core.card.type_physical")
require("Core.card.type_focus")
require("Core.card.type_speed")
require("Core.card.type_armour")
require("Core.card.type_cheat")
require("Core.card.card_setup")
require("Core.card.card_loop")
require("Network.networking")

require("Core.functions.camera_controls") --REQUIRES THE ZOOM VALUE FROM GAMEINFO
require("Core.table.screen_elements")
require("Core.table.table_setup")
require("Core.table.faceoff_setup")
require("Core.table.limb_setup")
require("Core.table.draw_setup")
require("Core.table.discard_setup")

--local hand;
local board = {}

system.activate( "multitouch" )

-- listener function
local function GameLoop( event )

	--THIS IS WHERE THE MAIN GAMELOOP RUNS   

	--THE GAMESTATE SWITCH. GIVES ACCESS TO ALL THE MAIN GAME METHODS
    CheckState = switch { 
    	[0] = function()	--GIVE THE CAMERA TIME TO READJUST
    		GameInfo.gamestate = GameInfo.gamestate + 1
    		end,
   		[1] = LoadConnection,--SET ANYTHING THAT ONLY NEEDS LOADING ONCE 
    	--[2] = player_check, --REGISTER BOTH PLAYERS
    	--[3] = loadGame,--SET ANYTHING THAT ONLY NEEDS LOADING ONCE 
        [2] = loadGame,--SET ANYTHING THAT ONLY NEEDS LOADING ONCE 
        [3] = player_check, --REGISTER BOTH PLAYERS
    	[4] = run_main_loop,

	   	default = function () print( "ERROR - gamestate not within switch") end,
	}

	CheckState:case(GameInfo.gamestate)
end


-- assign the above function as an "enterFrame" listener
Runtime:addEventListener( "enterFrame", GameLoop )