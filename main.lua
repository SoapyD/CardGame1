--THIS IS A TEST TO SEE IF THE SYNC WORKS

require("Core.INC_Class")
require("Core.class")
require("Core.statements")
require("Core.core_functions")
require("main_setup")
require("main_loop")
require("Core.button_setup")
require("Core.button_loop")
require("Core.card_functions")
require("Core.card_setup")
require("Core.card_loop")
require("Core.colors-rgb")
require("Network.networking")

GameInfo = cGameInfo:new(0)

require("Core.camera_controls") --REQUIRES THE ZOOM VALUE FROM GAMEINFO
require("Core.table_setup")
require("Core.faceoff_setup")

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
    	[1] = loadGame,--SET ANYTHING THAT ONLY NEEDS LOADING ONCE 
    	[2] = function()
    			run_main_loop()
    		end,
	    --[3] = function () 
	    		--run_main_loop()
	    --	end,
	   	default = function () print( "ERROR - gamestate not within switch") end,
	}

	CheckState:case(GameInfo.gamestate)


end


-- assign the above function as an "enterFrame" listener
Runtime:addEventListener( "enterFrame", GameLoop )


