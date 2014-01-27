

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
	LoadCard( suits[deck_index] .. "/" .. tempCard .. ".jpg",0,150);
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