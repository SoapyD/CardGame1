

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

function onTouch( event )
		local t = event.target
		local phase = event.phase

		if (t.finalised == false) then
			if "began" == phase then
				-- Make target the top-most object
				local parent = t.parent
				parent:insert( t )
				display.getCurrentStage():setFocus( t )
				t.isFocus = true
				-- Store initial position
				t.x0 = event.x - t.x
				t.y0 = event.y - t.y
				t.moved = true
				t.touched = true

				GameInfo.hand.hide = true
				print("touched")
			elseif t.isFocus then
				if "moved" == phase then
					-- Make object move (we subtract t.x0,t.y0 so that moves are
					-- relative to initial grab point, rather than object "snapping").
					t.x = event.x - t.x0
					t.y = event.y - t.y0
				elseif "ended" == phase or "cancelled" == phase then
					display.getCurrentStage():setFocus( nil )
					t.isFocus = false
		      		print("moved button id ".. tostring(t.id))
		      		-- send the update to others in the game room. space delimit the values and parse accordingly
		      		-- in onUpdatePeersReceived notification
		      		--appWarpClient.sendUpdatePeers(tostring(t.id) .. " " .. tostring(t.x).." ".. tostring(t.y))
					appWarpClient.sendUpdatePeers(tostring(t.filename) .. " " .. tostring(t.x).." ".. tostring(t.y))

					if (t.drawn == false) then
						t.isVisible = false	
						print("now non visible: ".. tostring(t.filename))
					end
					t.moved = false
				end
			end
		end
		return true
end

function LoadCard(filename,x,y)
	local group = display.newGroup()
    -- width, height, x, y
    local icon = display.newImage(group, "Images/" .. filename, 
        x, y)

    icon:addEventListener( "touch", onTouch )
    --icon:addEventListener( "touch", onPress )
    --icon:scale( 0.35, 0.35 )

    id = table.getn(GameInfo.cards)+1

    GameInfo.cards[id] = icon
    GameInfo.cards[id].touched = false
    GameInfo.cards[id].id = id 
    GameInfo.cards[id].filename = filename
    GameInfo.cards[id].drawn = false
    GameInfo.cards[id].finalised = false
end


function AddCard(filename,x,y)
	local group = display.newGroup()
    -- width, height, x, y
    local icon = display.newImage(group, "Images/" .. filename, 
        (x / camera.xScale) - camera.scrollX, (y / camera.yScale) - camera.scrollY)

    icon:addEventListener( "touch", onTouch )
    icon:addEventListener( "tap" , tapRotateLeftButton )

    --icon:scale( 0.75, 0.75 )

    id = table.getn(GameInfo.table_cards)+1

    GameInfo.table_cards[id] = icon
    GameInfo.table_cards[id].touched = false
    GameInfo.table_cards[id].id = id 
    GameInfo.table_cards[id].filename = filename
    GameInfo.table_cards[id].drawn = true
    GameInfo.table_cards[id].rotation = 0
    GameInfo.table_cards[id].finalised = false

    GameInfo.current_card_int = id

    --ADD THE CARD TO THE CAMERA BUT DON'T MAKE IT THE FOCUS YET
    camera:add(GameInfo.table_cards[id], 1, false)
    --if(id - 1 > 0) then
   -- 	camera:setFocus(GameInfo.table_cards[id - 1])
    --end
end

--ALLOW THE CARDS PLACED ON THE TABLE TO BE ROTATED IF CLICKED ON
function tapRotateLeftButton( e )
    local t = e.target

    if (t.finalised == false) then
	    if ( t.rotation == 0 or t.rotation == -90 or 
	    	t.rotation == -180 or t.rotation == -270) then
	    	transition.to(t, {time=250, 
	    	rotation= t.rotation -90.0, onComplete=updaterotation(t)})
		end
	end
end

local test_int = 0

function updaterotation(t)
	--do nothing on completion
end