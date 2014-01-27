--THIS IS A TEST TO SEE IF THE SYNC WORKS

require("Core.INC_Class")
require("Core.class")
require("Core.statements")
require("Core.core_functions")
require("Core.camera_controls")
require("Core.button_setup")
require("Core.button_loop")
require("Core.card_setup")
require("Core.card_loop")
require("Network.networking")

GameInfo = cGameInfo:new(0)
--local hand;

local board = {}

-- listener function
local function GameLoop( event )

	--THIS IS WHERE THE MAIN GAMELOOP RUNS   

	--THE GAMESTATE SWITCH. GIVES ACCESS TO ALL THE MAIN GAME METHODS
    CheckState = switch { 	
    	[0] = loadGame,--SET ANYTHING THAT ONLY NEEDS LOADING ONCE 
    	[1] = function() end,
	    [2] = function () print( "Frame Num: ", GameInfo.frame_num) end,
	   	default = function () print( "ERROR - gamestate not within switch") end,
	}

	CheckState:case(GameInfo.gamestate)

	GameInfo.frame_num= GameInfo.frame_num + 1;
    if (GameInfo.frame_num > 60) then
    	GameInfo.frame_num = 0
    end

    --BOUNDS NEEDED TO KEEP THE SYNCING OF SCREEN AND GAME SPACES TOGETHER
	boundX1 = -camera.scrollX
	boundX2 = -camera.scrollX + display.contentWidth
	boundY1 = -camera.scrollY
	boundY2 = -camera.scrollY + display.contentHeight


    --CREATE TOOLS TO KEEP THE CARD AND SCROLL IT UP AND DOWN THE SCREEN
 	run_button_loop()
 	run_card_loop()


 	--SOME TEMPORARY DRAWN BUTTONS I'M USING TO TEST THE CAMERA AND IT'S SPACING
	button1.x = -camera.scrollX
	button1.y = -camera.scrollY
	button2.x = -camera.scrollX + display.contentWidth
	button2.y = -camera.scrollY
	button3.x = -camera.scrollX 
	button3.y = -camera.scrollY + display.contentHeight
	button4.x = -camera.scrollX + display.contentWidth
	button4.y = -camera.scrollY + display.contentHeight


	print_string = "CameraX:" .. math.round(camera.scrollX)
	print_string = print_string .. "\nCameraY:" .. math.round(camera.scrollY)

	statusText.text = print_string
	statusText.x = statusText.width / 2
	statusText.y = display.contentHeight - statusText.height / 2
	--print("cameraX1:",camera.scrollX)

    --CHECK THE NETWORK CONNECTION
    appWarpClient.Loop()
end


-- assign the above function as an "enterFrame" listener
Runtime:addEventListener( "enterFrame", GameLoop )


function loadGame()
	--HERE'S WHERE WE CAN LOAD ANYTHING THAT ONLY NEEDS INITIALISING
	print( "LOAD INFO")
	
	networkSetup();
	networkConnection(); 
	--BOXES TO TEST THE NETWORK CONNECTION
	setBoards();
	createDeck();
	SetupButtons();
	--ADVANCE THE GAMESTATE
	GameInfo.gamestate = GameInfo.gamestate + 1
end


function setBoards()
	board = {};
	for i=1, 20 do
		--cardtext = ""
		board[i] = {}
     	for j=1, 20 do
     		local tempSpace;
    	    table.insert(board[i],tempSpace);
    	    --cardtext = cardtext .. i .. "," .. j .. "||";
     	end
     	--print(cardtext)
    end
end


function EndBounds()
	button1 = display.newRoundedRect( 0, 0, 50, 50, 1 )
			button1:setFillColor( 0, 0, 0 )
			button1.strokeWidth = 6
			button1:setStrokeColor( 200,200,200,255 )

    camera:add(button1, 4, true)

	button2 = display.newRoundedRect( 0, 0, 50, 50, 1 )
			button2:setFillColor( 0, 0, 0 )
			button2.strokeWidth = 6
			button2:setStrokeColor( 200,200,200,255 )

    camera:add(button2, 4, true)

	button3 = display.newRoundedRect( 0, 0, 50, 50, 1 )
			button3:setFillColor( 0, 0, 0 )
			button3.strokeWidth = 6
			button3:setStrokeColor( 200,200,200,255 )

    camera:add(button3, 4, true)

	button4 = display.newRoundedRect( 0, 0, 50, 50, 1 )
			button4:setFillColor( 0, 0, 0 )
			button4.strokeWidth = 6
			button4:setStrokeColor( 200,200,200,255 )

    camera:add(button4, 4, true)        

end



