

local deck; -- The deck of Cards
local suits = {"w","p","f","s"}; -- weapon, physical, focus, speed
local dealBtn; -- the deal buttons

--CREATE 4 DECKS CONTAINING 30 CARDS EACH. EACH DECK CONTAINS 2 OF THE EACH CARD (15 SETS)
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

--DRAW A CARD BY AMENDING THE DECK CHOSEN AND LOADING THE CARD AS AN OBJECT
function DrawCard(deck_index)
	tempCard = CheckDeck(deck_index)
	if ( tempCard > 15) then
		tempCard = tempCard - 15
	end
	--print(tempCard)
	LoadCard( suits[deck_index] .. "/" .. tempCard .. ".png",0,150);
end

function CheckDeck(deck_index)

	--RANDOMLY GENERATE A NUMBER FROM THE SIZE OF THE DECK
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


function LoadCard(filename,x,y)
	local group = display.newGroup()
    -- width, height, x, y
    local icon = display.newImage(group, "Images/" .. filename, 
        x, y)

    icon:addEventListener( "touch", onTouch )
    id = table.getn(GameInfo.cards)+1

    GameInfo.cards[id] = icon
    GameInfo.cards[id].touched = false
    GameInfo.cards[id].id = id
    GameInfo.cards[id].unique_id = GameInfo.username .. "_" .. filename .. "_" .. id
    GameInfo.cards[id].filename = filename
    GameInfo.cards[id].drawn = false
    GameInfo.cards[id].finalised = false
end


function AddCard(unique_id,filename,x,y,scale)
	local group = display.newGroup()
    -- width, height, x, y
    --it's this that's causing the misalignment of cards being laid down over the network
    local icon;

    if (scale == true) then
	    icon = display.newImage(group, "Images/" .. filename, 
	        (x / camera.xScale) - camera.scrollX, (y / camera.yScale) - camera.scrollY)
	else
	    icon = display.newImage(group, "Images/" .. filename, 
	        x, y)
	end
    icon:addEventListener( "tap" , tapRotateLeftButton )
    icon:addEventListener( "touch", onTouch )

    if ( GameInfo.current_card_int ~= -1) then
        if (GameInfo.table_cards[GameInfo.current_card_int].finalised == false) then
            Restore_HandCard()
            Remove_CurrentCard()
            tab.hide_once = true
        end

        GameInfo.previous_card_int = GameInfo.current_card_int
    end
    --print("card added")

    id = table.getn(GameInfo.table_cards)+1
    GameInfo.table_cards[id] = icon
    GameInfo.table_cards[id].touched = false
    GameInfo.table_cards[id].id = id 
    GameInfo.table_cards[id].unique_id = unique_id
    GameInfo.table_cards[id].filename = filename
    GameInfo.table_cards[id].drawn = true
    GameInfo.table_cards[id].rotation = 0
    GameInfo.table_cards[id].finalised = false

    
    GameInfo.current_card_int = id
end