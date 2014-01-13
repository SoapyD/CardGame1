--THIS IS A TEST TO SEE IF THE SYNC WORKS

require("Core.INC_Class")
require("Core.class")
require("Core.statements")
require("Core.core_functions")
--require("Core.perspective")
require("Core.camera_controls")
require("Network.networking")

GameInfo = cGameInfo:new(0)

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
	--Test();
	--LoadImage("Icon.png",0,150);
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
    	    --local tempCard = suits[i]..j;
    	    local tempCard = j;
    	    table.insert(decks[i],tempCard);
    	    --cardtext = cardtext .. tempCard .. ",";
     	end

     	--print(cardtext)
    end
end

function SetupButtons()
	dealBtn = display.newImage("Images/" .. "deal_btn.png",250,460);

	DrawCard(2)
	--DrawCard(2)
	--DrawCard(2)				
end


function DrawCard(deck_index)
	tempCard = CheckDeck(deck_index)
	if ( tempCard > 18) then
		tempCard = tempCard - 18
	end
	--print(tempCard)
	LoadImage( suits[deck_index] .. "/" .. tempCard .. ".jpg",0,150);
end

function CheckDeck(deck_index)

	--RANDOMLY GENERATE A NUMBER FROM THE SIZE OF THE ECK
	local randIndex = math.random(#decks[deck_index])
	print("indexnum: ", randIndex)

	--GET THE CARD NAME SAVED AT THAT LIST INDEX POSITION
	tempCard = decks[deck_index][randIndex]
	print("card: ", tempCard)

	--REMOVE THE VALUE FROM THE LIST
	table.remove(decks[deck_index],randIndex)
	print("listSize: ", table.maxn(decks[deck_index]))

	return tempCard
end