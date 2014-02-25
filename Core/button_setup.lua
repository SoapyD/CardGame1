
function SetupButtons()
	PlayerHand()
	ScrollBar()
	Tab()
	Finalise_button()

	DrawCard(1)
	DrawCard(1)
	DrawCard(1)
	DrawCard(1)

	--Portrait()				
end


function PlayerHand()
	print("height: ", display.contentHeight)

	boxwidth = 1800
	boxheight = 360

	GameInfo.hand = display.newRoundedRect(
		GameInfo.portrait_start + boxwidth / 2,
		GameInfo.height - boxheight / 2,
		boxwidth,boxheight, 0 )
	GameInfo.hand:setFillColor( 255, 0, 128 )
	GameInfo.hand.strokeWidth = 6
	GameInfo.hand:setStrokeColor( 200,200,200,255 )
	GameInfo.hand.width = boxwidth
	GameInfo.hand.height = boxheight
	GameInfo.hand.hide = false
	GameInfo.hand.show = false
end

function ScrollBar()
	print("height: ", display.contentHeight)

	boxwidth = 1800
	boxheight = 100

	bar = display.newRoundedRect(
		GameInfo.portrait_start + boxwidth / 2,
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
	tab.hide_once = true
end

function Finalise_button()
	boxwidth = 300
	boxheight = 100

	rotate_button = display.newRoundedRect(
		GameInfo.portrait_start + boxwidth / 2,
		GameInfo.height - GameInfo.hand.height - bar.height - boxheight / 2,
		boxwidth,boxheight, 0 )
	rotate_button:setFillColor( 1, 1, 1 )
	rotate_button.strokeWidth = 6
	rotate_button:setStrokeColor( 200,200,200,225 )
		-- Make the button instance respond to touch events
	rotate_button.width = boxwidth
	rotate_button.height = boxheight	
	rotate_button:addEventListener( "touch", finishCard )
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
			tab.hide_once = true
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

function finishCard( event )
	local t = event.target
	local phase = event.phase

	if "began" == phase then
		
		local parent = t.parent
		parent:insert( t )
		display.getCurrentStage():setFocus( t )	
		t.isFocus = true

	elseif t.isFocus then
		if "ended" == phase then
			display.getCurrentStage():setFocus( nil )
			t.isFocus = false
			id = GameInfo.current_card_int
			if(id ~= -1) then
				--current_card = GameInfo.table_cards[id]

				--current_card.finalised = true
				--camera:add(current_card, 1, true)
				--camera:setFocus(current_card)
				--camera:track()
				camera.damping = 10

				local current_card = GameInfo.table_cards[GameInfo.current_card_int]

				appWarpClient.sendUpdatePeers(
					tostring("position") .. " " ..
					tostring(current_card.unique_id) .. " " ..
					tostring(current_card.filename) .. " " .. 
					tostring(current_card.x).." ".. 
					tostring(current_card.y))

				appWarpClient.sendUpdatePeers(
					tostring("rotation") .. " " ..
					tostring(current_card.unique_id) .. " " .. 
					tostring(GameInfo.username) .. " " ..		
					tostring(current_card.rotation))
												
			end
		end
	end

	return true
end