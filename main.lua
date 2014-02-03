--THIS IS A TEST TO SEE IF THE SYNC WORKS

require("Core.INC_Class")
require("Core.class")
require("Core.statements")
require("Core.core_functions")
require("main_loop")
require("Core.button_setup")
require("Core.button_loop")
require("Core.card_setup")
require("Core.card_loop")
require("Core.colors-rgb")
require("Network.networking")

GameInfo = cGameInfo:new(0)

require("Core.camera_controls") --REQUIRES THE ZOOM VALUE FROM GAMEINFO
require("Core.table_setup")

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
    			--LoadTable( "table2" .. ".jpg",0,0) 
    			--GameInfo.gamestate = GameInfo.gamestate + 1
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


function loadGame()
	--HERE'S WHERE WE CAN LOAD ANYTHING THAT ONLY NEEDS INITIALISING
	print( "LOAD INFO")
	
	networkSetup();
	networkConnection(); 
	--BOXES TO TEST THE NETWORK CONNECTION
	LoadTable( "table2" .. ".jpg",0,0);
	setBoards();


	EndBounds();
	createDeck();
	SetupButtons();
	run_main_loop()
	--ADVANCE THE GAMESTATE
	GameInfo.gamestate = GameInfo.gamestate + 1
end


function setBoards()
	board = {};
	for i=-14, 16 do
		--cardtext = ""
		board[i] = {}
     	for j=-14, 16 do
     		local tempSpace;
    	    table.insert(board[i],tempSpace);
    	    --cardtext = cardtext .. i .. "," .. j .. "||";
    	    board[i] =display.newRoundedRect( 
    	    	((j - 1) * 125), 
    	    	((i - 1) * 125), 
    	    	50, 50, 1 )
    	    board[i]:setFillColor( colorsRGB.RGB("blue") )
    	    camera:add(board[i], 1, false)
     	end
     	--print(cardtext)
    end

    	    --item1 =display.newRoundedRect( 
    	    --	0, 
    	    --	0, 
    	    --	150, 150, 1 )
    	    --item1:setFillColor( colorsRGB.RGB("blue") )
    	    --camera:add(item1, 1, false)

    	    --item2 =display.newRoundedRect( 
    	    --	GameInfo.table_item.x, 
    	    --	GameInfo.table_item.y, 
    	    --	150, 150, 1 )
    	    --item2:setFillColor( colorsRGB.RGB("red") )
    	    --camera:add(item2, 1, false)

end


function EndBounds()
	button1 = display.newRoundedRect( 0, 0, 150, 150, 1 )
			button1:setFillColor( colorsRGB.RGB("green") )
			button1.strokeWidth = 6
			button1:setStrokeColor( 200,200,200,255 )

    camera:add(button1, 1, false)

	button2 = display.newRoundedRect( 0, 0, 150, 150, 1 )
			button2:setFillColor( colorsRGB.RGB("green") )
			button2.strokeWidth = 6
			button2:setStrokeColor( 200,200,200,255 )

    camera:add(button2, 1, false)

	button3 = display.newRoundedRect( 0, 0, 150, 150, 1 )
			button3:setFillColor( colorsRGB.RGB("green"))
			button3.strokeWidth = 6
			button3:setStrokeColor( 200,200,200,255 )

    camera:add(button3, 1, false)

	button4 = display.newRoundedRect( 0, 0, 150, 150, 1 )
			button4:setFillColor( colorsRGB.RGB("green") )
			button4.strokeWidth = 6
			button4:setStrokeColor( 200,200,200,255 )

    camera:add(button4, 1, false)        

end