--THIS IS A TEST TO SEE IF THE SYNC WORKS

require("Core.INC_Class")
require("Core.class")
require("Core.statements")
require("Core.core_functions")
--require("Core.perspective")
require("Core.camera_controls")
require("Network.networking")

GameInfo = cGameInfo:new(0)
local hand;

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

		hand.x = bar.x
		hand.y = bar.y + (bar.height / 2) + (hand.height / 2) 


    --KEEP THE CARD ALONG THE HAND BAR IF THEY'RE NOT BEING CARRIED
	for i = 1, table.getn(GameInfo.cards) do
		if(GameInfo.cards[i].touched == false) then
	    	GameInfo.cards[i].x = hand.x - (hand.width / 2) + (GameInfo.cards[i].width / 2)
	    	GameInfo.cards[i].x = GameInfo.cards[i].x + (GameInfo.cards[i].width * (i -1))
	     	GameInfo.cards[i].x = GameInfo.cards[i].x + (10 * (i -1))   	
	    	GameInfo.cards[i].y = hand.y
    	end    
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
     	for j=1, 32 do
    	    local tempCard = j;
    	    table.insert(decks[i],tempCard);
    	    --cardtext = cardtext .. tempCard .. ",";
     	end
     	--print(cardtext)
    end
end

function SetupButtons()
	PlayerHand()
	ScrollBar()

	DrawCard(2)
	DrawCard(2)
	DrawCard(2)
	DrawCard(2)

	--Portrait()				
end


function DrawCard(deck_index)
	tempCard = CheckDeck(deck_index)
	if ( tempCard > 18) then
		tempCard = tempCard - 18
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

	boxwidth = 1000
	boxheight = 382

	hand = display.newRoundedRect(
		250 + boxwidth / 2,
		GameInfo.height - boxheight / 2,
		boxwidth,boxheight, 0 )
	hand:setFillColor( 255, 0, 128 )
	hand.strokeWidth = 6
	hand:setStrokeColor( 200,200,200,255 )
	hand.width = boxwidth
	hand.height = boxheight
end

function ScrollBar()
	print("height: ", display.contentHeight)

	boxwidth = 1000
	boxheight = 100

	bar = display.newRoundedRect(
		250 + boxwidth / 2,
		GameInfo.height - hand.height - boxheight / 2,
		boxwidth,boxheight, 0 )
	bar:setFillColor( 255, 128, 0 )
	bar.strokeWidth = 6
	bar:setStrokeColor( 200,200,200,255 )
		-- Make the button instance respond to touch events
	bar:addEventListener( "touch", onStrafe )
	bar.width = boxwidth
	bar.height = boxheight	
	
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