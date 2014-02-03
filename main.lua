--THIS IS A TEST TO SEE IF THE SYNC WORKS

require("Core.INC_Class")
require("Core.class")
require("Core.statements")
require("Core.core_functions")
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
	boundX2 = -camera.scrollX + (display.contentWidth / camera.xScale)
	boundY1 = -camera.scrollY
	boundY2 = -camera.scrollY + (display.contentHeight / camera.yScale)


    --CREATE TOOLS TO KEEP THE CARD AND SCROLL IT UP AND DOWN THE SCREEN
 	run_button_loop()
 	run_card_loop()
 	CheckZoom()



 	--SOME TEMPORARY DRAWN BUTTONS I'M USING TO TEST THE CAMERA AND IT'S SPACING
	button1.x = -camera.scrollX
	button1.y = -camera.scrollY
	button2.x = -camera.scrollX + (display.contentWidth / camera.xScale)
	button2.y = -camera.scrollY
	button3.x = -camera.scrollX 
	button3.y = -camera.scrollY + (display.contentHeight / camera.yScale)
	button4.x = -camera.scrollX + (display.contentWidth / camera.xScale)
	button4.y = -camera.scrollY + (display.contentHeight / camera.yScale)

	if ( table.getn(GameInfo.touches) >= 1) then
		--local parent = GameInfo.touches[1].parent
		--parent:insert( GameInfo.touches[1] )
		--button1.isFocus = true
		button1.x = (GameInfo.touches[1].x  / camera.xScale) - camera.scrollX
		button1.y = (GameInfo.touches[1].y  / camera.yScale) - camera.scrollY
		
	end 
	if ( table.getn(GameInfo.touches) >= 2) then
		--local parent = GameInfo.touches[2].parent
		--parent:insert( GameInfo.touches[2] )
		--button2.isFocus = true		
		button2.x = (GameInfo.touches[2].x  / camera.xScale) - camera.scrollX
		button2.y = (GameInfo.touches[2].y  / camera.yScale) - camera.scrollY
	end 

	print_string = "CameraX:" .. math.round(camera.scrollX)
	print_string = print_string .. "\nCameraY:" .. math.round(camera.scrollY)
	print_string = print_string .. "\nTouches:" .. table.getn(GameInfo.touches)
	print_string = print_string .. "\nZoom:" .. GameInfo.zoom_dis
	print_string = print_string .. "\nTable:" .. GameInfo.table_item.x .. "," .. GameInfo.table_item.y
	--print_string = print_string .. "\nTouches:" .. CountDictionary(GameInfo.touches)

	GameInfo.touches = {}	

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

	LoadTable( "table2" .. ".jpg",0,0);
	EndBounds();
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
	button1 = display.newRoundedRect( 0, 0, 150, 150, 1 )
			button1:setFillColor( colorsRGB.RGB("green") )
			button1.strokeWidth = 6
			button1:setStrokeColor( 200,200,200,255 )

    camera:add(button1, 1, true)

	button2 = display.newRoundedRect( 0, 0, 150, 150, 1 )
			button2:setFillColor( colorsRGB.RGB("green") )
			button2.strokeWidth = 6
			button2:setStrokeColor( 200,200,200,255 )

    camera:add(button2, 1, true)

	button3 = display.newRoundedRect( 0, 0, 150, 150, 1 )
			button3:setFillColor( colorsRGB.RGB("green"))
			button3.strokeWidth = 6
			button3:setStrokeColor( 200,200,200,255 )

    camera:add(button3, 1, true)

	button4 = display.newRoundedRect( 0, 0, 150, 150, 1 )
			button4:setFillColor( colorsRGB.RGB("green") )
			button4.strokeWidth = 6
			button4:setStrokeColor( 200,200,200,255 )

    camera:add(button4, 1, true)        

end