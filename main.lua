--THIS IS A TEST TO SEE IF THE SYNC WORKS

require("Core.INC_Class")
require("Core.class")
require("Core.statements")
require("Core.core_functions")
--require("Core.perspective")
require("Core.camera_controls")
require("Network.networking")

GameInfo = cGameInfo:new(0)
--local hand;
local portrait_start = 400;

local x_space = 187.5
local y_space = 187.5
local x_land = 187.5
local y_land = 187.5
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


    --CREATE TOOLS TO KEEP THE CARD AND SCROLL IT UP AND DOWN THE SCREEN
    
    --STOCK THE TAB GOING HIGHER THAN HAND AND BAR HEIGHT OR LOWER THAN SCREEN EDGE
	if(tab.y < GameInfo.height - (tab.height / 2) - bar.height - GameInfo.hand.height ) then
		tab.y = GameInfo.height - (tab.height / 2) - bar.height - GameInfo.hand.height
	end
	if(tab.y > GameInfo.height - (tab.height / 2)) then
		tab.y = GameInfo.height - (tab.height / 2)
	end

	--MAKE THE HAND HIDE AWAY IF THE PLAYER IS CURRENTLY HOLDING A CARD
	if ( GameInfo.hand.hide == true and tab.y < GameInfo.height - (tab.height / 2)) then
		tab.y = tab.y + 50

		if(tab.y > GameInfo.height - (tab.height / 2)) then
			tab.y = GameInfo.height - (tab.height / 2)
		end
	end
	--STOP THE BAR GOING BEYOND THE PORTRAIT OR FAR RIGHT OF THE SCREEN
	if(bar.x < GameInfo.width - (bar.width / 2) ) then
		bar.x = GameInfo.width - (bar.width / 2)
	end
	if(bar.x > portrait_start + (bar.width / 2) ) then
		bar.x = portrait_start + (bar.width / 2) 
	end

	--LOCK THE BAR.Y TO THE TAB.Y ALLOWING IT BE LOWERED BELOW SCREEN
    bar.y = tab.y  + (tab.height / 2) + (bar.height / 2)
    rotate_button.y = tab.y
    --LOCK THE HAND.X TO THE SCROLL BAR.X POSITION
	GameInfo.hand.x = bar.x
	GameInfo.hand.y = bar.y + (bar.height / 2) + (GameInfo.hand.height / 2) 



    --KEEP THE CARD ALONG THE HAND BAR IF THEY'RE NOT BEING CARRIED
    hide = false
	for i = 1, table.getn(GameInfo.cards) do
		if(GameInfo.cards[i].touched == false) then
	    	GameInfo.cards[i].x = GameInfo.hand.x - (GameInfo.hand.width / 2) + (GameInfo.cards[i].width / 2)
	    	GameInfo.cards[i].x = GameInfo.cards[i].x + (GameInfo.cards[i].width * (i -1))
	     	GameInfo.cards[i].x = GameInfo.cards[i].x + (10 * (i -1))   	
	    	GameInfo.cards[i].y = GameInfo.hand.y
    	end
    	if(GameInfo.cards[i].moved == true) then
    		hide = true
    	end
	end
	if ( hide == false) then
		GameInfo.hand.hide = false
	end

	--TABLE_CARD LOOP
	for i = 1, table.getn(GameInfo.table_cards) do
		current_card = GameInfo.table_cards[i]

		if ( current_card.rotation <= -360 ) then
			current_card.rotation = 0
		end


		if ( current_card.saved_rotation == current_card.rotation) then
			if ( current_card.rotation == 0 or current_card.rotation == -180 ) then
				x_pos = current_card.x
				y_pos = current_card.y

				x_itts = x_pos / x_space
				y_itts = y_pos / y_space

				x_itts = math.round(x_itts)
				y_itts = math.round(y_itts)

				current_card.x = (x_itts * x_space) --+ (x_space / 2)
				current_card.y = (y_itts * y_space) --+ (y_space / 2)
				--print("x:", x_itts, " y:", y_itts, "|")
			else
				x_pos = current_card.x
				y_pos = current_card.y

				x_itts = (x_pos - 93.75) / x_land
				y_itts = (y_pos - 93.75) / y_land

				x_itts = math.round(x_itts)
				y_itts = math.round(y_itts)

				current_card.x = (x_itts * x_land) + 93.75 --+ (x_space / 2)
				current_card.y = (y_itts * y_land) + 93.75 --+ (y_space / 2)
				--print("x:", x_itts, " y:", y_itts, "|")
			end
		end

		current_card.saved_rotation = current_card.rotation
	end

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



local deck; -- The deck of Cards
local suits = {"w","p","f","s"}; -- weapon, physical, focus, speed
local dealBtn; -- the deal buttons

function createDeck()
	decks = {};
	for i=1, 4 do
		cardtext = ""
		decks[i] = {}
     	for j=1, 30 do
    	    local tempCard = j;
    	    table.insert(decks[i],tempCard);
    	    --cardtext = cardtext .. tempCard .. ",";
     	end
     	--print(cardtext)
    end
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

function SetupButtons()
	PlayerHand()
	ScrollBar()
	Tab()
	Rotate_button()

	DrawCard(1)
	DrawCard(1)
	DrawCard(1)
	DrawCard(1)

	--Portrait()				
end


function DrawCard(deck_index)
	tempCard = CheckDeck(deck_index)
	if ( tempCard > 15) then
		tempCard = tempCard - 15
	end
	--print(tempCard)
	LoadCard( suits[deck_index] .. "/" .. tempCard .. ".jpg",0,150);
end

function CheckDeck(deck_index)

	--RANDOMLY GENERATE A NUMBER FROM THE SIZE OF THE ECK
	local randIndex = math.random(#decks[deck_index])
	--print("indexnum: ", randIndex)

	--GET THE CARD NAME SAVED AT THAT LIST INDEX POSITION
	tempCard = decks[deck_index][randIndex]
	print("card: ", tempCard)

	--REMOVE THE VALUE FROM THE LIST
	table.remove(decks[deck_index],randIndex)
	print("listSize: ", table.maxn(decks[deck_index]))

	return tempCard
end



function PlayerHand()
	print("height: ", display.contentHeight)

	boxwidth = 1100
	boxheight = 510

	GameInfo.hand = display.newRoundedRect(
		portrait_start + boxwidth / 2,
		GameInfo.height - boxheight / 2,
		boxwidth,boxheight, 0 )
	GameInfo.hand:setFillColor( 255, 0, 128 )
	GameInfo.hand.strokeWidth = 6
	GameInfo.hand:setStrokeColor( 200,200,200,255 )
	GameInfo.hand.width = boxwidth
	GameInfo.hand.height = boxheight
	GameInfo.hand.hide = false
end

function ScrollBar()
	print("height: ", display.contentHeight)

	boxwidth = 1100
	boxheight = 100

	bar = display.newRoundedRect(
		portrait_start + boxwidth / 2,
		GameInfo.height - GameInfo.hand.height - boxheight / 2,
		boxwidth,boxheight, 0 )
	bar:setFillColor( 255, 128, 0 )
	bar.strokeWidth = 6
	bar:setStrokeColor( 200,200,200,255 )
		-- Make the button instance respond to touch events
	bar:addEventListener( "touch", onStrafe )
	bar.width = boxwidth
	bar.height = boxheight	
	
end

function Tab()
	boxwidth = 100
	boxheight = 100

	tab = display.newRoundedRect(
		GameInfo.width - boxwidth / 2,
		GameInfo.height - GameInfo.hand.height - bar.height - boxheight / 2,
		boxwidth,boxheight, 0 )
	tab:setFillColor( 0, 128, 128 )
	tab.strokeWidth = 6
	tab:setStrokeColor( 200,200,200,225 )
		-- Make the button instance respond to touch events
	tab:addEventListener( "touch", onStrafe_vert )
	tab.width = boxwidth
	tab.height = boxheight	
	
end

function Rotate_button()
	boxwidth = 300
	boxheight = 100

	rotate_button = display.newRoundedRect(
		portrait_start + boxwidth / 2,
		GameInfo.height - GameInfo.hand.height - bar.height - boxheight / 2,
		boxwidth,boxheight, 0 )
	rotate_button:setFillColor( 1, 1, 1 )
	rotate_button.strokeWidth = 6
	rotate_button:setStrokeColor( 200,200,200,225 )
		-- Make the button instance respond to touch events
	rotate_button.width = boxwidth
	rotate_button.height = boxheight	

    --function tapRotateLeftButton( e )
    --    transition.to(icon, {time=500, 
    --        rotation=-180.0, onComplete=restore})
    --end
	
end


function Portrait()
	print("height: ", display.contentHeight)

	button = display.newRoundedRect( 60,display.actualContentHeight - 140,
		120,180, 10 )
	button:setFillColor( 0, 128, 128 )
	button.strokeWidth = 6
	button:setStrokeColor( 200,200,200,255 )
	
end


function onStrafe( event )
		local t = event.target
		local phase = event.phase
		if "began" == phase then
			-- Make target the top-most object
			local parent = t.parent
			--parent:insert( t )
			display.getCurrentStage():setFocus( t )
			t.isFocus = true
			-- Store initial position
			t.x0 = event.x - t.x
			--t.y0 = event.y - t.y
		elseif t.isFocus then
			if "moved" == phase then
				-- Make object move (we subtract t.x0,t.y0 so that moves are
				-- relative to initial grab point, rather than object "snapping").
				t.x = event.x - t.x0
				--t.y = event.y - t.y0
			elseif "ended" == phase or "cancelled" == phase then
				display.getCurrentStage():setFocus( nil )
				t.isFocus = false
			end
		end
		return true
end

function onStrafe_vert( event )
		local t = event.target
		local phase = event.phase
		if "began" == phase then
			-- Make target the top-most object
			local parent = t.parent
			--parent:insert( t )
			display.getCurrentStage():setFocus( t )
			t.isFocus = true
			-- Store initial position
			--t.x0 = event.x - t.x
			t.y0 = event.y - t.y
		elseif t.isFocus then
			if "moved" == phase then
				-- Make object move (we subtract t.x0,t.y0 so that moves are
				-- relative to initial grab point, rather than object "snapping").
				--t.x = event.x - t.x0
				t.y = event.y - t.y0
			elseif "ended" == phase or "cancelled" == phase then
				display.getCurrentStage():setFocus( nil )
				t.isFocus = false
			end
		end
		return true
end