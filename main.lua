--THIS IS A TEST TO SEE IF THE SYNC WORKS
--THIS IS TO SEE IF I CAN MAKE CHANGES ON 2 COMPUTERS

require("Core.functions.INC_Class")
require("Core.functions.statements")
require("Core.functions.core_functions")
require("Core.functions.quad_method")
require("Core.functions.colors-rgb")
require("Core.functions.resets")
require("Core.functions.end_turn_functions")
require("Core.functions.popup")
require("Core.functions.get_surrounding")

require("Core.class")

GameInfo = cGameInfo:new(0)

require("Core.player.character_classes")
require("Core.player.player_setup")
require("Core.player.deathcheck")
require("Core.player.update_player_text")

require("main_setup")
--require("main_loop")
require("main_loop2")
require("Core.button.button_functions")
require("Core.button.button_setup")
require("Core.button.button_loop")
require("Core.card.card_functions")
require("Core.card.check_quad")
require("Core.card.card_setup")
require("Core.card.card_loop")
require("Core.card_types.action_state_check")
require("Core.card_types.action_functions")
require("Core.card_types.check_ability")
require("Core.card_types.card_types")
require("Core.card_types.type_weapons")
require("Core.card_types.type_physical")
require("Core.card_types.type_focus")
require("Core.card_types.type_speed")
require("Core.card_types.type_armour")
require("Core.card_types.type_cheat")
require("Network.networking")

require("Core.functions.camera_controls") --REQUIRES THE ZOOM VALUE FROM GAMEINFO
require("Core.table.screen_elements")
require("Core.table.table_setup")
require("Core.table.faceoff_setup")
require("Core.table.counter_setup")
require("Core.table.limb_setup")
require("Core.table.draw_setup")
require("Core.table.discard_setup")
require("Core.table.or_setup")
require("Core.table.endgame_table")

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